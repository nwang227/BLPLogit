# BLPLogit
This Julia package is created to estimate mixed logit set-ups following the Berry, Levinohn, and Pakes’ (1995) framework. We prepared functions for mixed logit estimation and generate simulation data for a mixed logit discrete choice model.

[![Build Status](https://github.com/nwang227/BLPLogit.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/nwang227/BLPLogit.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/nwang227/BLPLogit.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/nwang227/BLPLogit.jl)

## Model Discriptions
* Consumer $i$ in market $m$ at time $t$ makes a discrete choice between $J$ different products and one outside option. 

* Consumers' utility can be divided into three parts: a mean utility $\delta_{jt}$, a individual utility $\mu_{ijt}$ and an error term $\epsilon_{ijt}$.
$$u_{ijt} = \delta_{jt} + \mu_{ijt} + \epsilon_{ijt}$$


* Mean utility $\delta$ is the same for all the consumers for the same product. 
$$\delta_{jt} = \alpha p_{jt} + x_{jt}' \beta + \xi_{jt} $$


* Consumers' can have individual preference $\nu_{ik}$ on any product characteristics including price. The individual utility $\mu_{ijt}$ can be written as: $$\mu_{ijt} = \sigma_1 \nu_{i1} p_{jt} + \sum_{k = 1}^K \sigma_{k+1} \nu_{i{k+1}} x_{jk}$$  



* Metricians observe the price $p_{jt}$, charatertics of the product $char_{jt}$ where $char_{jt} \equiv [char1_{jt},...,chark_{jt}]'$ is a $k$-element vector and $charn_{jt}$ demotes the $n$ th charateristic of the product. 



* $\epsilon_{ijt}$ is Type I Extreme Value Distributed.



## Estimation Method

1. Have a guess on $\sigma$
2. Following BLP(1995), use contraction mapping find $\delta^* (\sigma)$ for all $j$ and $t$ such that $$s_{jt} = s_{jt}(\delta^* (\sigma), x_{jt}, p_{jt})$$
3. Estimate $(\alpha, \beta)$ using a GMM estimator with cost shifters as instruments.
4. Evaluate GMM objective function.
5. Repeat step 1-4 until gobal minimum is found.


## Simulation

Our simulation function allows user to generate mixed logit discrete data with costomized parameters. Our test is based on this simulation function, in which we generate a simulation data and check whether the estimation resutls are close to our pre-set parameters.


## User Guideline

### 1. Data Preperation

To estimate mixed logit parameters, the user will need to first standardize their data set for estimation function. This process can be done by `blpdata`


