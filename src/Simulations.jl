

struct BLPparameters
    T::Int64
    J::Int64
    I::Int64
    M::Int64
    σ::AbstractVector
    α::Float64
    β::AbstractVector
end

pa= BLPparameters(10,10,100,5,[-1,2,1],1,[1,1,1])



function simulate_utility(pa::BLPparameters)
    @unpack T,J,I,σ,α,β = pa
    ϵ= rand(Logistic(),J*T*I)
    mvnormalchar= MvNormal(zeros(length(β)), Array(Diagonal(ones(length(β)))));
    char = rand(mvnormalchar,J*T)'
    p = rand(Exponential(1),J*T)
    ξ = rand(Normal(0,1),J*T)
    δ = reshape(-α .*p + char*β + ξ, J,T)
    mvnormalv= MvNormal(zeros(length(σ)), Array(Diagonal(ones(length(σ)))));
    v = rand(mvnormalv,I)'
    U = zeros(I,J,T)


    pchar = hcat(p, char[:,1:length(σ)-1])
    ϵm =  reshape(ϵ,I,J,T)
    for i in 1:I
        for j in 1:J
            for t in 1:T
                 U[i,j,t]= δ[j,t] + sum( σ .* v[i,:]' .* pchar[(j-1)*T + t, :]) + ϵm[i,j,t]
            end
        end
    end


    return (p = p, char=char, U=U)
end

simulate_utility(pa::BLPparameters)[1]

@unpack p, char, U = simulate_utility(pa)
function simulate_BLP(pa::BLPparameters)
    @unpack T,I,J,M = pa
    c = zeros(I,T,M)
    @unpack p, char, U = simulate_utility(pa)
    for m in 1:M 
        n = rand(DiscreteUniform(5,J))
        for i in 1:I
            for t in 1:T
            c[i,t,m] = findmax(rand(U[i,:,t],n))[2]
            end 
        end 
    end 
    return (p= p,char=char ,c=c)
end

simulate_BLP(pa)




function createrep(J,T)
    v = ones(J)
    for i in 1: T-1
    v = vcat(v,ones(J)*(i+1)) 
    end 
    return v
end 


function create_data_matrix(J,T,M)
    A = repeat([1:J;],T)
    B = createrep(J,T)
    C = hcat(p,char,A,B)
    D = repeat(C,M)
    E = createrep(J*T,M)
    s =zeros(J,T,M)
        for m in 1:M
            for j in 1:J
                for t in 1:T
                    s[j,t,m]= sum(c[:,t, m].==j)/I
                end 
            end
        end 

    a = zeros(1)
        for m in 1:M 
        a = vcat(a, reshape(s[:,:,m],J*T,1))
        end 
    
    return hcat(a[2:end],D,E) # Shares,prices,charteristics,product id, time ,market
end
@unpack p, char, c = simulate_BLP(pa)
@unpack T,J,I,M,σ,α,β = pa
DM = create_data_matrix(J,T,M) 
df = DataFrame(DM, ["Shares","Prices","charteristics1","charteristics2", "charteristics3","product id", "time" ,"market"])
