using .BLPLogit
using Test

@testset "BLPLogit.jl" begin
    pa = Main.BLPLogit.BLPparameters(10,10,10000,5,[1,.5,4,.2],.1,[.5,.3,.1])
    DM = BLPLogit.create_data_matrix(pa::Main.BLPLogit.BLPparameters)
        
        df = DataFrame(DM, ["Shares","Prices","charteristics1","charteristics2", "charteristics3","product id", "time" ,"market"])


        a = "Prices"
        b = "Shares"
        c = ["charteristics1", "charteristics2", "charteristics3"]
        d = "time"
        e = "market"
        e = "Prices"
        p,s,ch,c = BLPLogit.blpdata(df,a,b,c,d,e)


        NS = 1000
        ini = [1.,1.,1.,1.]
        tol = 10e-8

        θ1= BLPLogit.est_mixed(p, s,ch, c, NS, ini, tol)[1]
        θ2= BLPLogit.est_mixed(p, s,ch, c, NS, ini, tol)[2]
        @unpack α, β, σ = pa
  @test isapprox(θ1, vcat(α,β)) #test if the estimation is close to the true value
  @test isapprox(θ2, σ)
end

