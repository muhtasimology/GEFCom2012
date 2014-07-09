function [ X ] = predict(X0, T0 , LAYER )
%PREDICT Predicts the next value.

% Unroll thetas
numThetas = length(LAYER)-1;
thetas = rollWeights(T0,LAYER);
% Predict
% Hidden layers use tanh activation
a = X0;
a = [ones(size(a,1),1), a]; % Add the bias
for i = 1:(numThetas - 1)
    z = a*thetas{i}';
    a = 1.7159*tanh(2/3.*z); % SHOULD REPLACE THIS WITH A FUNCTION
    a = [ones(size(a,1),1), a]; % Add the bias
end

% Output layer uses linear activation
h = a*thetas{numThetas}';
X = h;

end

