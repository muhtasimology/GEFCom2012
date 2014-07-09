function [PREDICT, T, LAYER] = dailyForecast (LOAD, T0, SKIP, MOMENTUM, LEARNINGRATE, LAMBDA)
%DAILYFORECAST Forecasts a time series day by day. Updates each day.

if ~exist('SKIP','var')
    SKIP = 0;
end
if ~exist('LAMBDA','var')
    LAMBDA = 0.0;
end
if ~exist('MOMENTUM','var')
    MOMENTUM = 0.3;
end
if ~exist('LEARNINGRATE','var')
    LEARNINGRATE = 0.001;
end

load = LOAD;

%% Create some days
numDays = 7;
days = repmat(eye(numDays),floor((size(load,1)+numDays)/numDays),1);
days = days(1:size(load,1),:);

%% Standardize 
loadFeatureLength = size(load,2);
% Previous 2 days 
% slope from last 2 days  
% week before 
% day of the week
layer = [loadFeatureLength*4+7;240;loadFeatureLength];
theta = randInitializeWeights(layer);
if exist('THETA', 'var') && isequal(size(THETA),size(theta))
    theta = T0;
end
%%
y = load;
predictedValues = nan(size(y));
failed = false;
dt = 0.0; % Required for Nesterov momentum
for i = (1+7+SKIP):(length(y));
    isPrediction = false;
    x = [y(i-1,:),y(i-2,:),y(i-1,:)-y(i-2,:),y(i-7,:),days(i,:)];%, predictedValues(i-1,:)];
    predictedValues(i,:) = predict(x,theta,layer);
    % Pretend that the actual load is the predicted one (This will only
    % happen when we are required to guess the output)
    if any(isnan(y(i,:))) == true
        y(i,:) = predictedValues(i,:);
        isPrediction = true;
    end
    % Pretend that the predicted load for the previous day is the actual
    % previous day load
    [cost, grad] = neuralNetworkCost(x,y(i,:), theta + MOMENTUM*dt, layer, LAMBDA);
    if ~isPrediction
        dt = -LEARNINGRATE*grad + MOMENTUM*dt; 
        theta = theta + dt;
    end
    fprintf('dailyForecast - Cost at time %d: %f\n', i, cost );
    % Don't want the cost to explode.
    % Don't want the cost to explode.
    if cost > 1e10 || isnan(cost)
        failed = true;
        fprintf('dailyForecast - Failed because of cost explosion.\n');
        break;
    end
end

%% Finalize outputs
if(failed) % If the loop breaks early then it has failed, return nothing.
    PREDICT = [];
    if nargout > 1
        T = [];
    end
    if nargout > 2
        LAYER = [];
    end
else
    % Reshape predicted values back to the original format
    PREDICT = predictedValues;
    if nargout > 1
        T = theta;
    end
    if nargout > 2
        LAYER = layer;
    end
end

end
