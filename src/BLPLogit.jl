module BLPLogit

# Write your package code here.
using CSV, DataFrames, Optim, Random, LinearAlgebra
export cshare, cdelta, delta_full, obj

#Function for conjectured share for one market
function cshare(delta::Vector, p::Vector, char::Matrix, v::Matrix, σ)
    ns,k1 = length(v1)
    k = length(p)
    share = zeros(k)
    σ1 = σ[1]
    σ2 = σ[2:end]
    v1 = v[:,1]
    v2 = v[:,2:end]
    @threads for g in 1:ns
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
function delta_full(σ, p,char,share,v)
    m = maximum(df[:,:market_id])
    δ = zeros(3*m)

    @threads for j in 1:m
        p = df[df.market_id .== j , :p]
        char1 = df[df.market_id .== j , :char1]
        share = df[df.market_id .== j , :share]
        δ_new = cdelta(p,char,share,v, σ,tol)
        δ[(j-1)*3 + 1:(j-1)*3 + 3] =  δ_new
    end
    return δ
end

#Objective function, spit out both GMM error and β
function obj(σ ,p,char,share,v)
    δ = delta_full(σ, p,char,share,v)
    p = df[:, :p]
    char1 = df[: , :char1]
    char2 = df[: , :char2]
    share = df[: , :share]
    z1 = Matrix(df[: , [:cost1, :cost2, :cost3]])
    x = [ones(1800) p  char1  char2]
    z = [ones(1800) char1 char2 z1]
    w = inv(z' * z)
    beta = (x'* z * w * z' * x)^-1  * (x'* z * w * z' * δ)
    u = δ - x * beta
    res = u' * z * w * z' * u
    return (res = res, beta = beta[2:4])
end


function est_mixed(p, char, share, z, tol, NS)
    n,k = size(char)
    v = randn(NS, k+1)
    


end
