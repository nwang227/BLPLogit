import .BLPLogit
using CSV, DataFrames

df = CSV.read("test/data.csv", DataFrame; header = ["market_id", "product_id", "share", "share_outside_option", "p", "char1", "char2", "cost1", "cost2", "cost3"])
a = "p"
b = "share"
c = ["char1", "char2"]
d = "market_id"
e = ["cost1", "cost2", "cost3"]
p,s,ch,c = BLPLogit.blpdata(df,a,b,c,d,e)

NS = 100
ini = [2.,2.,2.]
tol = 10e-5
n,k = size(ch)
v = randn(NS, k)
σ = [2.,2.,2.]


BLPLogit.est_mixed(p, s,ch, c, NS, ini, tol)