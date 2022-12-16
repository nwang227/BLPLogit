# BLPLogit
This Julia package is created to estimate mixed logit set-ups following the Berry, Levinohn, and Pakes’ (1995) framework. We prepared functions for mixed logit estimation and generate simulation data for a mixed logit discrete choice model.

[![Build Status](https://github.com/nwang227/BLPLogit.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/nwang227/BLPLogit.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/nwang227/BLPLogit.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/nwang227/BLPLogit.jl)

## Model Discriptions
* Consumer $i$ in market $m$ at time $t$ makes a discrete choice between $J$ different products and one outside option. 

* Consumers' utility can be divided into three parts: a mean utility $\delta_{jt}$, a individual utility $\mu_{ijt}$ and an error term $\epsilon_{ijt}$.
$$u_{ijt} = \delta_{jt} + \mu_{ijt} + \epsilon_{ijt}$$


* Mean utility $\delta$ is the same for all the consumers for the same product. Parameters of interest are $\theta_1 = (\alpha, \beta)$. 
$$\delta_{jt} = \alpha p_{jt} + x_{jt}' \beta + \xi_{jt} $$


* Consumers' can have individual preference $\nu_{ik}$ on any product characteristics including price. The parameters of interest are $\theta_1 = [\sigma_1,..,\sigma_K]$. The individual utility $\mu_{ijt}$ can be written as: $$\mu_{ijt} = \sigma_1 \nu_{i1} p_{jt} + \sum_{k = 1}^K \sigma_{k+1} \nu_{i{k+1}} x_{jk}$$  



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

To estimate mixed logit parameters, the user will need to first standardize their data set for estimation function. This process can be done by `blpdata(df::DataFrame, p::String, s::String, char::Vector{String},id::String, cost::Vector{String)`. 

The first input of this function is user's data set in the format of `DataFrame`, which should contain information on products' `prices`, `shares`, `characteristics`, `cost shifters`(instrument variables) and `ids`. The users will also need specify the column names of each variable as the rest of the input. We allow each product to have multiple numbers of chatacteristics and cost shifters as long as all the column names are specified.

As for `ids` we allow two ways to include. First, the user can provide one vector of unique time-market id for each time-market pair so that they only have one colomn name to specify as `id`. Instead, the users can also provide one id for `time` and another for `market` and input use the dispatch ` blpdata(df::DataFrame,p::String, s::String, char::Vector{String},t::String,m::String, cost::Vector{String})`.

The output of `blpdata` are four dataframes, which can be directly used as input of the estiamtion function `est_mixed`. The four dataframes have data on `prices`, `shares`, `characteristics`, and `cost shifters` respectively with `id`.

## 2. Estimation 

The user can use `est_mixed(p::DataFrame, s::DataFrame,ch::DataFrame, c::DataFrame, NS::Int64, ini::Vector, tol::Float64)` function to estimate all the parameters of interest in the above mixed logit setting. The inputs of this function are four dataframes, which can be obtained using `blpdata`, level of integration apporximation `NS`, the initial guess of $\theta_2$ `ini`, and the tolerence in contraction mapping `tol`. With these inputs, `est_mixed` will spit out estimations for $\theta_1$ and $\theta_2$ repectively.

The rest of the functions are supporting the estimation in `est_mixed`. `cshare` and `cdelta` can be used to find $s_{jt}(\delta, x_{jt}, p_{jt})$ and $\delta^* (\sigma)$ for one market at a time. `delta_full` estimate $\delta^* (\sigma)$ for all market at all time. `obj` gives a GMM estimator and evaluates the GMM objective function.

### 3. Simulation

To simulate a data set, one should first define BLP parameters, for example 

```jl
pa = Main.BLPLogit.BLPparameters(10,10,10000,5,[1,.5,4,.2],.1,[.5,.3,.1])
```

The arguments in the BLPparameters are times periods, number of products, number of consumers, number of markets, $[\sigma_1,..,\sigma_K]$, $\alpha$, $\beta$, respectively.

Once the user have the BLPparameter, the user can simulate a datamatrix using the data creation function:

```jl
DM = BLPLogit.create_data_matrix(pa::Main.BLPLogit.BLPparameters)
```
One can convert the datamatrix to a dataframe:

```jl
df = DataFrame(DM, ["Shares","Prices","charteristics1","charteristics2", "charteristics3","product id", "time" ,"market"])
```





