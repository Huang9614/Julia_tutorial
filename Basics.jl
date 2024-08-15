""" ------ 3 Basic Variabal Types ------ """
# no need to specify the type of variable
a = 1+1
b = "hello"
typeof(a)
typeof(b)

# --- Numerical variables ---

## convert integers to float
Float64(2)
## convert float into integers
floor(Int64, 5.4)
ceil(Int64, 5.4)
round(Int64, 5.4)
## dividing two integers returns a float, except using div() or ÷
a = 1/2             
@assert div(10,3) == ÷(10,3)           
@assert rem(10,3) == 10%3


# --- Boolean Variables ---
## !x, x&&y, `x(||)

## property of &&: first check a > 0, if it's not satisfied, then the second condition won't be checked, since false && ANY = false
if a > 0 && expensive_computation(b) > 0
    do_something()
end

## property of ||: since 3>2 is satisfied, no need to check the second condition, since true || ANY = true
if 3 > 2 || expensive_computation(b) > 0
    do_something()
end

## Bool is subtype of Integer, true = 1 and false = 0
true + true 


# --- string concatenation and formatting ---

## string vs char
string = "String"
char = 'H'

## concatenate string
"Hello " * "wor" * "ld"


## convert number to string


## concatenate a number to a string

### string interpolation
"In ancient Babylon they approximated pi to 25/8, which is $(25/8)"

rmse = 1.5; mse = 1.1; R2 = 0.94
"Our model has a R^2 of $(R2), rmse of $(rmse), and mse of $(mse)"


""" ------ 4 for loops ------ """

# simple for loop

x=0
for k in 1:100000
    x = x + (1/k)^2
end


# nested for loop

for i in 1:3
    for j in 1:3
        println("i=", i, " j=", j, "\n")
    end
end

## for a better reading 
for i in 1:3, j in 1:3
    print("i=", i, " j=", j, "\n")
end

## resort to even nicer
for i ∈ 1:3, j ∈ 1:3
    print("i=", i, " j=", j, "\n")
end


# break statement: quit loop when a certain condition is satisfied

x=0
for k in 1:100000
    term = (1/k)^2
    x = x + term
    println(x)
    if (abs(term) < 1e-10) break end
end


# continue statement: exit the current iteration of for loop and continue with the next iteration immediately
# useful when we have multiple conditions, by which we need to skip the loop iteration
numbers = randn(100)
sum = 0
for k in numbers
    if (k==0) continue end
    sum = sum + 1/k
end



""" ------ 5 functions ------ """

# define a function
function sum_zeta(s,nterms)
    x = 0
    for n in 1:nterms
        x = x + (1/n)^s
    end
    return x
end
sum_zeta(2,1000)

# we can also define a function with a single line of code
sum_zeta(s,nterms) = sum(1/n^s for n=1:nterms)
sum_zeta(2,1000)


# function with optional and keyword arguments

## when we set nterms as optional, then we need to assign a default value for it
sum_zeta(s,nterms=10000) = sum(1/n^s for n=1:nterms)
sum_zeta(2)

## keyword arguments: a function can accept arguments which are identified by name instead of position
sum_zeta(s; nterms=10000) = sum(1/n^s for n=1:nterms) # they are placed after a semicolon in the function definition
sum_zeta(2)
sum_zeta(2, 10)

## function with multiple outputs
function circle(r)
    area = π * r^2
    circumference = 2π * r
    return area, circumference
end

## the output is a tuple, which is then destructed into two variables
a, c = circle(1.5)

## since the output is a tuple, therefore, we can deal with them in another way
shape = circle(1.5)
shape[1]
shape[2]

## shape is tuple, which is immutable; but the lower a and c are mutable
a,c = shape


# function can also change the value of its input

## only the mutable input can be changed by function
function add_one!(x)
    x .= x .+ 1
end

x = [1,2,3]
add_one!(x)    


# anonymous functions: sometimes no need to assign a name to a function
# For example, when we need to quickly define a function, to pass it as an argument to another function.

## the argument f here is a function argument
function secant(f,a,b,rtol,maxIters)
    iter = 0
    while abs(b-a) > rtol*abs(b) && iter < maxIters
        c,a = a,b
        b = b + (b-c)/(f(c)/f(b)-1)
        iter = iter + 1
    end
    return b
end

## x -> x^2 - x - 1 is the anonymous function arguments
φ = secant( x-> x^2 - x - 1, 1, 2, 1e-15, 10 )


# storing and calling functions in a separate file

include("Basics_utils.jl")
x = sum_series(10)



""" ------ 6 arrays, vectors and matrices ------ """

# --- initializ arrays and matrices --- #

## direct input
A = [1 2 3; 1 2 4; 2 2 2]     

b1 = [4.0, 5, 6]                # 3-element Vector{Float64}
b2 = [4.0; 5; 6]                # 3-element Vector{Float64}
m1 = [4.0 5 6]                  # 1×3 Matrix{Float64}

A = ["Hello", 1, 2, 3]


## array comprehension

v = [1/n^2 for n=1:100000]
x = sum(v)

### when using parenthsis, a generator will be returned, the underlying array isn't allcated in memory in advance, the generator could thus have better performance

gen = (1/n^2 for n=1:100000)
x = sum(gen)

## undefined arrays：initialize an array just with type and size, without specific values; 
## we will then fill them later, e.g. with the use of a for loop
## To defined such arrayzs, we need to emply keywords Vector{T}. Matrix{T}, where T is the type

n = 5
A1 = Array{Float64}(undef,n,n)          # 5×5 Matrix{Float64}
A2 = Matrix{Float64}(undef,n,n)         # 5×5 Matrix{Float64}

V1 = Array{Float64}(undef,n)            # 5-element Vector{Float64}
V2 = Vector{Float64}(undef,n)           # 5-element Vector{Float64}

A = Array{String}(undef,n)
A = Array{Any}(undef,n)


## empty arrays: useful when we don't even know the size of array

v1 = Array{Float64}(undef,0)
v2 = Float64[]
@assert v1==v2


## initialize special kind of arrays

A = zeros(8,9)
B = ones(8,9)
C = rand(6,6)

### In the case of the identity matrix, placing an integer right before a letter ‘I’ will do the job, 
### but this requires the LinearAlgebra package
using LinearAlgebra
M = 5I + rand(2,2)


# --- arrays functions and dot operator --- #

# instead for loop, we use dot operator after the function's name to apply a function element-wise to an array

f(x) = 3x^3/(1+x^2)
x = [2π/n for n=1:30]
y = f.(x)

## dot operator also works for built-in function
z = sin.(x)

## in case of multiple usage of dot, we can resort to boradcasting the dot 

y_redundant = 2x.^2 + 3x.^5 - 2x.^8

y_better = @. 2x^2 + 3x^5 - 2x^8


# --- array indexing and slicing --- #

# by default, the first element of the array in indexed as 1
# but we can override this default behavior, TODO: HOW?

## using the keyword: begin and end to access the first and last element of an array
A = rand(6)
A[begin]
A[end]

## array slicing

A = rand(6,6)                   # 6×6 Matrix{Float64}
### extract the odd indices in both dimensions from a 6x6 matrix
B = A[begin:2:end,begin:2:end]  
C = A[1:2:5,1:2:5]              # Same as B

## logical indexing: select array elements by boradcasting boolean operation
A = rand(6,6)
A[ A .< 0.5 ] .= 0


## iterate over an array

A = rand(6)
for i ∈ eachindex(A)
    println(string("i=$(i) A[i]=$(A[i])"))
    # println(string("try: i = $(i)"))
end

### over a multidimentsional arrays by using axes function

A = rand(6,6)
for i ∈ axes(A,1), j ∈ axes(A,2) # nice nested for loop, check part4
    println(string("i=$(i) j=$(j) A[i,j]=$(A[i,j])"))
end


# --- array operations --- #

## matri x matrix/vector
A * B
A * v


## element-wise multiplication by using dot operator
A .* B

## dot production, e.g. [2,3] * [1,2]^T = 8 
v = [2,3]
w = [1,2]
z = dot(v,w)
z_alternative = v'w

## Attention to backslash operator: 1xN matrices are not the same as N-element vectors
A = rand(3,3)
b1 = [4.0, 5, 6]                # 3-element Vector{Float64}
b2 = [4.0; 5; 6]                # 3-element Vector{Float64}
m1 = [4.0 5 6]                  # 1×3 Matrix{Float64}

x=A\b1                          # Solves A*x=b
x=A\b2                          # Solves A*x=b  
x=A\m1                          # Error!!
x=A\m1'                         # Correct!!


# --- resize and concatenate arrays --- #
# by default, arrays are dynamic( growable, resizable)

## resize 1d arrays with push and pop
A = Float64[]       # Equivalent to A=Array{Float64}(undef,0)
push!(A, 4)         # Adds the number 4 at the end of the array
push!(A, 3)         # Adds the number 3 at the end of the array
push!(A, 2)
v = pop!(A)         # Returns the last element and removes it from A
splice!(A,1)        # returns the element at the given position
deleteat!(A,1)      # returns A after deleting the first element

## multi-dim array concatenate
## hcat, vcat, and cat functions, to concatenate in the horizontal, vertical, or along any given dimension.

A = [4 5 6] 
B = [6 7 8] 

M1 = vcat(A, B)
M2 = hcat(A, B)
M1 = cat(A, B, dims=1)
M2 = cat(A, B, dims=2)
M3 = cat(A, B, dims=3)


## concatenate 2d matrices: using brackets and spaces and semicolons as alternatives to hcat and vcat, respectively.
M1 = [A;B]
M2 = [A B]


## concatenate vectors

a = [1, 2, 3] 
b = [4, 5, 6] 

## vector -> vector
vcat(a,b)
[a; b]

## vector -> matrix
hcat(a,b)
[a b]

## vector -> vector[vectors]
[a,b]   # returns a vector of vectors

## vector -> matrix
stack([a,b], dims=1)    # stack a vector of vectors along a specified dimension


""" ------ 7 data structures------ """
# besides arrays, there are several other built-in basic data sturctures: Tuples, Named Tuple and Dictionary

# --- Tuple --- #

t = (3.14, 2.72)    # difference between tuple and array is () and []
t = 3.14, 2.72
t[1]

## tuple is immutable, but we still can operate it indirectly
t = (2*t[1], t[2])
t = t .* 2

## convert tuple into arrays

a = (1, 2, 3)

t1 = collect(a)     
t2 = [x for x in a]
t3 = [a...]    # splat notation


## destructure Tuples: cast the elements of a tuple as different variables. See application case in part5
pi_approx, e_approx = t
typeof(pi_approx)


# --- Named Tuple --- #
# we can assign names to the different elements of a tuple
p = ( x = 1.1, y = 2.4)
@assert p.x == p[1]

K = keys(p)
V = values(p)

# merge this key/value pairs into a named tuple again with the zip function:
p_new = (; zip(K,V)...)


# merge named tuple
TemporalParams = ( 
    Δt = 0.1, 
    T = 2
)

SpatialParams = ( 
    Δx = 0.05, 
    a = 0,
    b = 100
)

TotalParams = merge(TemporalParams, SpatialParams)


# destructure named tuple

## parameters can be destructured regardless of their order.
(; a,b,Δt ) = TotalParams


# --- Dictionary --- #

# initialize a Dictionary

D = Dict("a" => 1, "b" => 2, 1 => "a")

## alternatively, we can initialize using key/valule pairs
D = Dict([("a", 1), ("b", 2), (1, "a")])

# accesssing elements: using key, similar to array

D["a"]
D[1]

## Dict is also an iterable object

for e in D
    println(e)
end

### unstructure the pair into two variables
for (k,v) in D
    println(k, " => ", v)
end


# modify the Dict

D["c"] = 3           # Adding a new key
D["c"] = "Hello"     # Updating existing key
D = delete!(D, "c")  # Deleting an existing key


# --- structure --- #

# except define as mutable struct, by default, a struct object is immutable

# create a LOcation type
struct Location
    name::String
    lat::Float64
    lon::Float64
end

# initialize with values

loc1 = Location("Los Angeles", 34.0522,-118.2437)

# access the struct fields with dot notation
loc1.name
loc1.lon


# by defining the location type, we can create a vector of Locations and dynamically fill it with Location elements
sites = Location[]
sites_alter = Array{Location}[] ## similar to Float64[], check part6
@assert sites == sites_alter

push!(sites, Location("Los Angeles", 34.0522,-118.2437))
push!(sites, Location("Las Vegas", 36.1699,-115.1398))


# mutable struct

mutable struct mLocation
    name::String
    lat::Float32
    lon::Float32
end

loc1 = mLocation("Los Angeles", 34.0522,-118.2437)
loc1.name = "LA"


# defaults values in structs and keyword-based constructors

@kwdef mutable struct Param
    Δt :: Float64 = 0.1
    n :: Int64
    m :: Int64
end

P = Param(m=50, n=35)


# destructure a struct
# get any field of P that matches what we write on the left-hand side and turn it into a variable. 
# Note that the order of the variables doesn’t matter, and that we don’t need to destructure all the fields.

(; n,Δt ) = P

## we can also access the fields by 
P.n


""" ------ 9 organizing julia code ------ """

# --- include the file into the script file ---#


# --- Organize a project: environment, projects, packages --- #


# --- creating a new project --- #

# after create module MyProject

## ATTENTION: we have to switch to the MyProject environment(this script liegt in Julia_tutorial ), otherwise, using MyProject will raises Error
using MyProject
using Revise    # force the recompilation of your project’s files every time you call using MyProject 

MyProject.greet()
greet()     # only if we add export greet in module MyProject


# --- TODO: writing and running tests --- #


# --- TODO: automated documenntation --- #


# --- TODO: developing local packages --- #

# develop projects with local packages




# ---  collaborating on existing packages --- #

"""
    Introduce Transformers.jl into the current project: Julia_tutorial 
    1. Pkg.develop(url="address of your fork repo") # git clone and activate the environment
    2. changes to Transformers.jl in ~/.julia/dev/Transformers.jl, and git push
    3. ] dev somePackage    # using the development version of Transformers
    4. ] free somePackage   # using the registered version
    

    clone the Transformers.jl into local and play around
    1. shell> git clone git@github.com:Huang9614/Transformers.jl.git && cd Transformers
    2. pkg> activate .
    3. pkg> instantiate
"""



# --- TODO: compiling a custom sysimage --- #


""" ------ 10 multiple dispatch ------ """

# The realization of polymorphism; Compared with OVERLOAD in C++ and abstract Class in Python


# Extending the definition of an existing function for A new type


# Defining A new method for an existing type


# Dispatch on any finite number of arguments



""" ------ 11 coding tips ------ """




