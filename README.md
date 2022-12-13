# BLPLogit
This Julia package is created to estimate mixed logit set-ups following the Berry, Levinohn, and Pakes’ (1995) framework.  
[![Build Status](https://github.com/nwang227/BLPLogit.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/nwang227/BLPLogit.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/nwang227/BLPLogit.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/nwang227/BLPLogit.jl)

## Model Discriptions
* Consumer $i$ facing with $J$ different produce choices and one outside option at period $t$. 
* For product $j$ at time $t$, Econometrics observe the price $p_{jt}$, charatertics of the product $char_{jt}$ where $char_{jt} \equiv [char1_{jt},...,chark_{jt}]$ is a $k$-element vector and $chark_{jt}$ demotes the $k$th charateristic of the product. 
