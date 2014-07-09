function [ X ] = mape( ACTUAL, PREDICT )
%MAPE Mean Absolute Percentage Error.
%   Has problems with divide by zero, should use SMAPE in that case.
numA0 = sum(~isnan(ACTUAL));
X = 100/numA0*nansum(abs(ACTUAL - PREDICT) ./ ACTUAL);

end

