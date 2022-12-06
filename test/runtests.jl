using BLPLogit
using Test
using LinearAlgebra, Distributions, Random
@testset "BLPLogit.jl" begin
    # Write your tests here.
end


function simlate_utility(ρ,T,J,I,σ1,σ2,α,β1,β2)
    mvnormal = MvNormal(zeros(T), Array( Diagonal(ones(T)) .* ρ))
    ϵ= rand(mvnormal, T*J*I)
    char1 = rand(mvnormal, T*J*I)
    char2 = rand(mvnormal, T*J*I)
    p = rand(mvnormal, T*J*I)
    ξ = rand(mvnormal, T*J*I)
    δ = -α .*p + β1 .* char1 + β2 .* char2 + ξ
    ν1 = rand(Normal(0.0, 1),I)
    ν2 = rand(Normal(0.0, 1),I)
    
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

simlate_utility(1,10,10,10,1,1,1,1,1)