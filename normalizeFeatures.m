function [ X, MU, SIGMA ] = normalizeFeatures( X0, MU, SIGMA )
%NORMALIZEFEATURES Normalize data. If MU or SIGMA are given they will be used.
    if ~exist('MU', 'var')
        MU = nanmean(X0);
    end
    X = bsxfun(@minus, X0, MU);
    if ~exist('SIGMA','var')
        SIGMA = nanstd(X);
    end
    X = bsxfun(@rdivide, X, SIGMA);
end

