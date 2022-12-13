# BLPLogit
This Julia package is created to estimate mixed logit set-ups following the Berry, Levinohn, and Pakes’ (1995) framework.  
[![Build Status](https://github.com/nwang227/BLPLogit.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/nwang227/BLPLogit.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/nwang227/BLPLogit.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/nwang227/BLPLogit.jl)

## Model Discriptions
* Consumer $i$ facing with $J$ different produce choices and one outside option at period $t$. 
* Consumer $i$ has unobserved consumer demographics $\nu_i \equiv [\nu_{1i},...,\nu_{hi}]' $ is an $h$-element vector and $\nu_{ni}$ denotes the $n$ th demographics of consumer $i$.
* For product $j$ at time $t$, econometricians observe the price $p_{jt}$, charatertics of the product $char_{jt}$ where $char_{jt} \equiv [char1_{jt},...,chark_{jt}]'$ is a $k$-element vector and $charn_{jt}$ demotes the $n$ th charateristic of the product. 
* Consumer $i$ has the following utility function: $$u_{ijt} = \delta_{jt}-\sigma_1\nu_{1i}p_{jt} + \sigma_2\nu_{2i}char1_{jt} +...+ \sigma_{q}\nu_{2i}charq_{jt} + \epsilon_{ijt}.$$ where $$\delta_{jt}= -\alpha p_{jt} + \beta_1char1_{jt} +...+ \beta_k chark_{jt}  + \xi_{jt}.$$
