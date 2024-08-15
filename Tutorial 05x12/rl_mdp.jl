# load packages
"""
    POMDPs.jl is just an interface, therefore, we need to load several additional packages 
    in order to use it
"""

using POMDPs,QuickPOMDPs,POMDPModelTools

# load solver

"""
    The actual solver is stored in a separate packages, since there are many different solvers that
    we can use with POMDPs.jl interface;
    The selection of solver depends on the problem to be solved
"""

using DiscreteValueIteration


# define state data type

struct State
    x::Int
    y::Int
end    

# define Action data type (@enum from Julia Base.Enums)
@enum Action UP DOWN LEFT RIGHT 

#Action

# define state space

null = State(-1, -1) # terminal state

S = [
    [State(x,y) for x = 1:4, y = 1:3]..., null
]

# define action space

A = [UP, DOWN, LEFT, RIGHT]

# define transition function: map each action into a new state

const MOVEMENTS = Dict(
    UP => State(0, 1),
    DOWN => State(0, -1),
    LEFT => State(-1, 0),
    RIGHT => State(1, 0)
)

## add a new method to the plus operator so we can add a current state to 
## the MOVEMENTS in order to get the new state
Base.:+(s1::State, s2::State) = State(
    s1.x + s2.x, s1.y + s2.y
)


function T(s::State, a::Action)
    # Deterministic() from POMDPModelTools.jl
    if R(s) != 0
        return Deterministic(null) # used when a districution is required but the output is Deterministic
    end

    # initialize variables
    len_a = length(A)
    next_states = Vector{State}(undef, len_a + 1) # {State}是说明Vector中元素是State
    probabilities = zeros(len_a + 1)

    # enumerate() from Julia Base.Iterators
    for (index, a_prime) in enumerate(A)
        prob = (a_prime == a) ? 0.7 : 0.1
        dest = s + MOVEMENTS[a_prime]
        next_states[index + 1] = dest

        if dest.x == 2 && dest.y == 2
            probabilities[index + 1] = 0
        elseif  1 <= dest.x <= 4 && 1 <= dest.y <= 3
            probabilities[index + 1] += prob
        end
    end

    # handle_out-of-bounds transitions
    next_states[1] = s
    probabilities[1] = 1 - sum(probabilities) # makes the agent bounce off the border and remain in its current state

    # SparseCat from POMDPModelTools.jl
    return SparseCat(next_states, probabilities) 
    # assigns the probabilities contained in the probabilities vector to the states in the next_states
end

# define the reward function

function R(s, a = missing)
    if s == State(4,2)
        return 100
    elseif s == State(4,3)
        return 10
    end
    return 0
end

# set discount factor

gamma = 0.95

# define mdp using QuickPOMDPs.jl

termination(s::State) = s == null

abstract type GridWorld <: MDP{State, Action} end

mdp = QuickMDP(GridWorld,
    states = s,
    actions = A,
    transition = T,
    reward = R,
    discount = gamma,
    isterminal = termination 
)

# select solver from DiscreteValueIteration.jl
solver = ValueIterationSolver(max_iterations = 30)

# solve mdp
policy = solve(solver, mdp)

# view values (utility)
value_view = [S policy.util]