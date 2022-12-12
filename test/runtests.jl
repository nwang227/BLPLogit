using BLPLogit
using Test
using LinearAlgebra, Distributions, Random,UnPack
@testset "BLPLogit.jl" begin
    # Write your tests here.
end

struct BLPparameters
    ρ::Float64
    T::Int64
    J::Int64
    I::Int64
    σ1::Float64
    σ2::Float64
    α::Float64
    β1::Float64
    β2::Float64
end



function simlate_utility(pa::BLPparameters)
    @unpack ρ,T,J,I,σ1,σ2,α,β1,β2 = pa
    ϵ= reshape(rand(Logistic(),J*I),J,I)
    char1 = reshape(rand(Normal(0,1),J*I),J,I)
    char2 = reshape(rand(Normal(0,1),J*I),J,I)
    p = reshape(rand(Normal(0,1),J*I),J,I)
    ξ = reshape(rand(Normal(0,1),J*I),J,I)
    δ = -α .*p + β1 .* char1 + β2 .* char2 + ξ
    ν1 = rand(Normal(0, 1),I)
    ν2 = rand(Normal(0, 1),I)
    
    U = zeros(T,J,I)

    for i in 1:T
        for j in 1:J
            for t in 1:I
                 U[i,j,t]= δ[j,t] - σ1*ν1[i]*p[j,t] + σ2*ν2[i]*char1[j,t] + ϵ[j,t]
            end
        end
    end

    return (p, char1, char2, U) = (p, char1, char2, U)
end

simlate_utility(pa::BLPparameters)

function simulate_BLP(pa::BLPparameters)
    A = simlate_utility(pa::BLPparameters)
    U = A[4]
    @unpack T,I = pa
    c = zeros(I,T)
    for i in 1:I
        for t in 1:T
        c[i,t] = findmax(U[i,:,t])[2]
        end 
    end 
    return (p= A[1],char1=A[2],char2=A[3] ,c=c)
end

pa = BLPparameters(3,10,10,10,1,1,1,1,1)
simulate_BLP(pa)



