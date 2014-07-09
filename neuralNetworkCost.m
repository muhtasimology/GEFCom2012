function [ COST, GRAD ] = neuralNetworkCost(X , Y, T0 , LAYER, LAMBDA)
%NEURALNETWORKCOST Feed forward neural network with tanh activation hidden
%   layer units and linear activation in the output units.

% Output initialization.
COST = 0;
GRAD = zeros(length(T0),1);

[m,n] = size(X);

numLayers = length(LAYER)-1;
thetas = rollWeights(T0,LAYER);

% Will need thetas without bias thetas later for backprop and
% regularization
thetaWoBias = cell(size(thetas));
for i = 1:(length(thetaWoBias))
    thetaWoBias{i} = thetas{i};
    thetaWoBias{i} = thetaWoBias{i}(:,2:end); % Get rid of bias
end

% Input layer
a = X;
a = [ones(size(a,1),1), a]; % Add the bias
% Hidden layers
for i = 1:(numLayers - 1)
    z = a*thetas{i}';
    a = hiddenLayerActivation(z);
    a = [ones(size(a,1),1), a]; % Add the bias
end
z = a*thetas{numLayers}';
% Output layer 
h = outputLayerActivation(z);

% Sum of squares cost function
COST = 0.5*sum(sum((Y - h).^2));

% Regulatize the cost
for i = 1:numLayers
    t = thetaWoBias{i}(:); 
    COST = COST + LAMBDA*0.5/m*sum(t.^2);
end 
% Check if backpropagation is needed
if nargout < 2
    return;
end

% Backpropagation
D = cell(numLayers,1);
for i = 1:numLayers
    D{i} = zeros(size(thetas{i}));
end

z = cell(numLayers,1);
a = cell(numLayers,1);
for i = 1:m
    % Input
    a{1} = X(i,:);
    a{1} = [1, a{1}];
    % Hidden layers (tanh activation)
    for j = 1:(numLayers - 1)
        z{j} = a{j}*thetas{j}';
        a{j+1} = hiddenLayerActivation(z{j});
        a{j+1} = [1, a{j+1}]; % Add the bias
    end
    % Output layer (linear activation)
    z{numLayers} = a{numLayers}*thetas{numLayers}';
    h1 = outputLayerActivation(z{numLayers});
    % Output layer derivatives (linear activation)
    delta = (h1 - Y(i,:)).*outputLayerDerivative(z{numLayers});
    de = delta'*a{numLayers};
    D{numLayers} = D{numLayers} + de;
    % Hidden layer derivatives (tanh activation)
    for j = (numLayers-1):-1:1
        delta = hiddenLayerDerivative(z{j}).*(delta*thetaWoBias{j+1});
        de = delta'*a{j};
        D{j} = D{j} + de; %accumulate the gradient
    end
end
for i = 1:numLayers
    D{i} = D{i} / m;
end

% Regularize the cost and the gradient
for i = 1:numLayers
    thetaWoBias{i} = thetaWoBias{i}(:); % Just vectorize it, dont need it any more
    COST = COST + LAMBDA*0.5/m*sum(thetaWoBias{i}.^2);
    D{i} = D{i} + LAMBDA/m*sum(thetaWoBias{i});
end

% Compute the final gradient
offset = 1;
for i = 1:numLayers
    layerSize = (LAYER(i)+1)*(LAYER(i+1));
    GRAD(offset:(offset+layerSize-1)) = D{i}(:);
    offset = offset + layerSize;
end

end

%% Tanh 
function [ Y ] = hiddenLayerActivation(Z)
    Y = 1.7159*tanh(2/3.*Z);
end
function [ Y ] = hiddenLayerDerivative(Z)
    Y = 1.14393*(1 - tanh(Z.*2/3).^2);
end

%% Linear
function [ Y ] = outputLayerActivation(Z)
    Y = Z;
end
function [ Y ] = outputLayerDerivative(Z)
    Y = 1;
end