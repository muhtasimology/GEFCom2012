function [PREDICT, T, LAYER] = hourlyForecast (LOAD, T0, SKIP, MOMENTUM, LEARNINGRATE, LAMBDA)
%HOURLYFORECASE Forecasts a time series hour by hour. Updates each hour.

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
    LEARNINGRATE = 0.003;
end

load = LOAD;
load = load';
load = load(:);
loadFeatureLength = size(load,2); % this will be the same as the output length
%% Create some hours
numHours = 24;
hours = eye(numHours);
hours = repmat(eye(numHours),floor((size(load,1)+numHours)/numHours),1);
hours = hours(1:size(load,1),:);
%% Create some days
numDays = 7;
daysId = eye(numDays);
days = [];
for i = 1:numDays
    days = [days; repmat(daysId(i,:),24,1)];
end
days = repmat(days,floor((size(load,1)+numDays)/numDays),1);
days = days(1:size(load,1),:);

% Previous hour and its slope from the previous hour, 
% previous day and its slope from the previous hour and the slope of the
% the previous week
% day of the week
% hour of the day
layer = [loadFeatureLength*5+numDays+numHours;140;loadFeatureLength];
%% Setup thetas
theta = randInitializeWeights(layer);
% Use previous thetas if provided, but not if they arent of the required
% size
if exist('THETA', 'var') && isequal(size(THETA),size(theta))
    theta = T0;
end
%% Main loop
y = load;
predictedValues = nan(size(y));
dontUpdate = isnan(y);
failed = false;
dt = 0.0; % Required to intiialize the gradient for our Nesterov momentum 
for i = (1+24*7+SKIP):(length(y));
    x = [y(i-1,:),y(i-1,:)-y(i-2,:),y(i-24,:),y(i-24,:)-y(i-25,:),y(i-24*7,:),days(i,:),hours(i,:)];%, predictedValues(i-1,:)];
    predictedValues(i,:) = predict(x,theta,layer);
    % Pretend that the actual load is the predicted one (This will only
    % happen when we are required to guess the output)
    if any(isnan(y(i,:))) == true
        y(i,:) = predictedValues(i,:);
    end
    % Pretend that the predicted load for the previous day is the actual
    % previous day load
    [cost, grad] = neuralNetworkCost(x,y(i,:), theta + MOMENTUM*dt, layer, LAMBDA);
    
    if ~dontUpdate(i) % Dont want to learn on our prediction
    % This should probably include a skip week as in the initial case
        dt = -LEARNINGRATE*grad + MOMENTUM*dt; 
        theta = theta + dt;
    end
    if mod(i,100) == 0
        fprintf('hourlyForecast - Cost at time %d: %f\n', i, cost );
    end
    % Don't want the cost to explode.
    if cost > 1e10 || isnan(cost)
        failed = true;
        fprintf('hourlyForecast - Failed because of cost explosion.\n');
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
    predictedValues = reshape(predictedValues,24,floor(size(predictedValues,1)/24));
    predictedValues = predictedValues';

    PREDICT = predictedValues;
    if nargout > 1
        T = theta;
    end
    if nargout > 2
        LAYER = layer;
    end
end
