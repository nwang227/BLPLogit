module BLPLogit

# Write your package code here.
using CSV, DataFrames, Optim, Random, LinearAlgebra, UnPack, Distributions
export cshare, cdelta, delta_full, obj, BLPparameters, simulate_raw, simulate_BLP, createrep, create_data_matrix

include("Simulations.jl")

#Function for constructing desired data set if there exists a time-marekt id
"""""""
This blpdata function can be used to split the dataframe that the user provide. A user will need to feed the function a dataframe that contains product-level data on its price, market share, cost shifter(the instruments), characteristics, and specify the column name of each variable in the dataframe.
    
We allow each product to have several characteristics, and our function can handle it as long as the user specify all the column names. As for time and market id, we allow two methods. The user can either provide a market-time id for each unique market-time pair, or he/she can provide the time id and market id seperately.
"""""""


function blpdata(df::DataFrame, p::String, s::String, char::Vector{String},id::String, cost::String)
    price = select(df,[p,id])
    share = select(df, [s,id])
    character = select(df, char)
    c = select(df, cost)
    id = select(df,id)
    ch = hcat(character, id)
    return (price = price, share = share, ch = ch, c = c)
end

#Function for constructing data if there are only time and market id
function blpdata(df::DataFrame,p::String, s::String, char::Vector{String},t::String,m::String, cost::String)
    ids = Matrix(select(df, [t,m]))
    n,k = size(ids)
    upair = [ids[i,:] for i in i:n]
    n1 = length(upair)
    df[!,:id] .= 0
    for j in i:n1
        time = upair[j][1]
        mar = upair[j][2]
        df[(df[:,t] .== time) .& (df[:,m] .== mar), :id] .= j
    end

    BLPLogit.blpdata(df, p, s, char, id, cost)
end



"""""""""
The rest of the functions are used for estimation. cshare and cdelta funciton estimate the shares and mean utilities of all the products in a market at a time. delta_full function estimate the mean utilities for all the products in all the markets at all time. obj is the GMM objective funciton which can spit out both the GMM estimator and the residual.
"""""""""

#Function for conjectured share for one market
function cshare(delta::Vector, p::Vector, char::Matrix, v::Matrix, σ)
    ns,k1 = size(v)
    k = length(p)
    share = zeros(k)
    σ1 = σ[1]
    σ2 = σ[2:end]
    v11 = v[:,1]
    v22 = v[:,2:end]
    for g in 1:ns
        num = exp.(delta - σ1 * v11[g] * p + char * (σ2 .* v22[g,:]) )
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
        j = BLPLogit.cshare(delta0, p, char, v, σ)
        delta1 = delta0 + log.(share) - log.(j)
        error = (delta1 - delta0)' * (delta1 - delta0)
    end

    return delta1 = delta1
end


#Estimate delta for all the markets
function delta_full(σ, p,ch,s,v, tol)
    m = maximum(p[:,2])
    n,k = size(ch)
    δ = [ ]

    for j in 1:m
        price = p[p[:,2] .== j, 1] 
        char = Matrix(ch[ch[:,k] .== j, 1:k-1])
        share = s[s[:,2] .== j, 1]
        δ_new = BLPLogit.cdelta(price,char,share,v, σ,tol)
        δ = vcat(δ, δ_new)
    end
    δ = replace(δ, NaN => 1)
    return δ
end

#Objective function, spit out both GMM error and β
function obj(σ ,p,ch,s,v,c,tol)
    n,k = size(ch)
    δ = delta_full(σ, p,ch,s,v,tol)
    p = p[:,1]
    char = Matrix(ch[:, 1:k-1])
    z1 = Matrix(c)
    x = hcat(ones(n), p, char)
    z = hcat(ones(n), char, z1)
    w = inv(z' * z)
    beta = (x'* z * w * z' * x)^-1  * (x'* z * w * z' * δ)
    u = δ - x * beta
    res = u' * z * w * z' * u
    return (res = res, beta = beta[2:end])
end


function est_mixed(p, s,ch, c, NS, ini, tol)
    n,k = size(ch)
    v = randn(NS, k)

    result1 = optimize(sig -> BLPLogit.obj(sig, p, ch,s,v,c,tol)[1], ini)

    θ2 = Optim.minimizer(result1)
    θ1 = round.(BLPLogit.obj(θ2 ,p, ch,s,v,c, tol)[2], digits = 3)
    θ2 = round.(θ2, digits = 3)
    println("θ1 =", θ1)
    println("θ2 =",  θ2)
    return (θ1 = θ1, θ2 = θ2)
end

end
