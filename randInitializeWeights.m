function T = randInitializeWeights(LAYER)
%RANDINITIALIZEWEIGHTS Randomly assigns weights.
layer = LAYER;
numTheta = sum(layer.*[0;layer(1:(end-1)) + 1]);
theta = zeros(numTheta,1);
offset = 1;
for i = 1:(length(layer)-1)
    randTheta = randWeights(layer(i),layer(i+1));
    theta(offset:(offset+(layer(i)+1)*layer(i+1)-1)) = randTheta(:);
    offset = offset + (layer(i)+1)*layer(i+1);
end

T = theta;

end
function W = randWeights(L_in, L_out)
    
%RANDINITIALIZEWEIGHTS Randomly initialize the weights of a layer with L_in
%incoming connections and L_out outgoing connections
%   W = RANDINITIALIZEWEIGHTS(L_in, L_out) randomly initializes the weights 
%   of a layer with L_in incoming connections and L_out outgoing 
%   connections. 
%
%   Note that W should be set to a matrix of size(L_out, 1 + L_in) as
%   the column row of W handles the "bias" terms
%

% You need to return the following variables correctly 
W = zeros(L_out, 1 + L_in);

eps_init = sqrt(6)/sqrt(L_in+L_out);
W = rand(L_out,1+L_in)*2*eps_init-eps_init;




end
