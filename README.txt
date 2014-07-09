-- GEFCom2012 --

Author: Peter Kheo

External Files: datetick2.m (MATLAB exchange)

-- Data -- 

http://www.kaggle.com/c/global-energy-forecasting-competition-2012-load-forecasting
Data was taken from the GEFCom2012 competition hosted on Kaggle. It is only 
used here as a sample.

-- Description -- 

These scripts were created to implement online feed forward neural networks
 for short term load forecasting. These networks learn from each example 
before they predict the next. Where consecutive predictions are needed, it
they will do predictions using previous predictions.

MAPE and SMAPE are provided in the sample. Note that the sample will use
default values for momentum, learning rate, and regularization.

-- Usage --

[>] is used to denote user input.
---- Sample -----
> main
Pick a zone (1-20), or 0 to quit: 
> 1
Pick a type of prediction hourly (h) or daily (d): 
> h
hourlyForecast - Cost at time 39600: 0.000000
MAPE: 2.419240
SMAPE: 1.208823
---- End Sample ----

You can use the other scripts but you'll have to read through that 
documentation.