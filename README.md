# BLPLogit
This Julia package is created to estimate mixed logit set-ups following the Berry, Levinohn, and Pakes’ (1995) framework.  
[![Build Status](https://github.com/nwang227/BLPLogit.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/nwang227/BLPLogit.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/nwang227/BLPLogit.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/nwang227/BLPLogit.jl)

## Model Discriptions
* Consumer $i$ facing with $J$ different produce choices and one outside option at period $t$. 
* For product $j$ at time $t$, econometricians observe the price $p_{jt}$, charatertics of the product $char_{jt}$ where $char_{jt} \equiv [char1_{jt},...,chark_{jt}]$ is a $k$-element vector and $charn_{jt}$ demotes the $n$th charateristic of the product for $n \in \{1,...,k\}$. 
* Consumer $i$ has the following utility function: $$u_{ijt} = \delta_{jt}-\sigma_1\nu_{1i}p_{jt} + \sigma_2\nu_{2i}char1_{jt} +...+ \sigma_{k+1}\nu_{2i}chark_{jt} + \epsilon_{jt}$$ 
