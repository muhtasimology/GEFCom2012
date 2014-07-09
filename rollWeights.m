function [ T ] = rollWeights( T0, LAYER )
%ROLLWEIGHTS Layers unrolled weights.

T = cell(length(LAYER)-1,1);
offset = 1;
for i = 1:(length(LAYER) - 1)
    n = (LAYER(i) + 1)*LAYER(i+1); % add 1 for bias
    t = T0(offset:(offset + n - 1));
    offset = offset + n;
    T{i} = reshape(t,LAYER(i+1),LAYER(i)+1);
end

end

