function [ X ] = smape( ACTUAL, PREDICT )
%SMAPE Symmetric Mean Absolute Percentage Error

numA0 = sum(~isnan(ACTUAL));
X = 100/numA0*nansum(abs(ACTUAL - PREDICT) ./ (ACTUAL+PREDICT));

end

