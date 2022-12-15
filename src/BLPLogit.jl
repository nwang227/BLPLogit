module BLPLogit

# Write your package code here.
using CSV, DataFrames, Optim, Random, LinearAlgebra
export cshare, cdelta, delta_full, obj



#Function for constructing desired data set

function blpdata(df::DataFrame, p::Symbol, s::Symbol, char::Vector{Symbol},id::Symbol, cost::Vector{Symbol})
    price = select(df,[p,id])
    share = select(df, [s,id])
    character = select(df, char)
    c = select(df, c)
    id = select(df,id)
    ch = hcat(character, id)
    return (price = price, share = share, ch = ch, c = c)
end


#Function for conjectured share for one market
function cshare(delta::Vector, p::Vector, char::Matrix, v::Matrix, σ)
    ns,k1 = length(v1)
    k = length(p)
    share = zeros(k)
    σ1 = σ[1]
    σ2 = σ[2:end]
    v1 = v[:,1]
    v2 = v[:,2:end]
    for g in 1:ns
        num = exp.(delta - σ1 * v1[g] * p + char * (σ2 .* v2[g,:]) )
        den = 1 + sum(num)
        prob = num./den
        share += 1/ns * prob
    end
    return share 
end


#Function for estimating delta for one market
function cdelta(p,char,share,v, σ,tol)
    k = length(p)
    delta0 = ones(k)
    delta1 = ones(k)
    error = 1

    while error > tol
        delta0 = delta1
        j = cshare(delta0, p, char, v, σ)
        delta1 = delta0 + log.(share) - log.(j)
        error = (delta1 - delta0)' * (delta1 - delta0)
    end

    return delta1 = delta1
end


#Estimate delta for all the markets
function delta_full(p,ch,s,v, tol)
    m = maximum(p[:,2])
    n,k = size(ch)
    δ = [ ]

    for j in 1:m
        p = p[p[:,2] == j, 1] 
        char = ch[ch[:,k] == j, 1:k-1]
        share = s[s[:,2] == j, 1]
        δ_new = cdelta(p,char,share,v, σ,tol)
        vcat(δ, δ_new)
    end
    return δ
end

#Objective function, spit out both GMM error and β
function obj(σ ,p,ch,s,v,c,tol)
    n,k = size(ch)
    δ = delta_full(p,ch,s,v,tol)
    p = p[:,1]
    char = Matrix(ch[:, 1:k-1])
    share = s[: , 1]
    z1 = Matrix(c)
    x = hcat(ones(1800), p, char)
    z = hcat(ones(1800), char, z1)
    w = inv(z' * z)
    beta = (x'* z * w * z' * x)^-1  * (x'* z * w * z' * δ)
    u = δ - x * beta
    res = u' * z * w * z' * u
    return (res = res, beta = beta[2:4])
end


function est_mixed(p, s,char, c, NS, ini, tol)
    n,k = size(char)
    v = randn(NS, k+1)

    result1 = optimize(sig -> obj(sig, p, ch,s,c,v,tol)[1], ini)

    θ2 = Optim.minimizer(result1)
    println("θ1 =", round.(obj(θ2 ,p, ch,s,c,v, tol)[2], digits = 3))
    println("θ2 =",  round.(θ2, digits = 3))
end
