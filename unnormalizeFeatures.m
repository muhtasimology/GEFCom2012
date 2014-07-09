function  [ X ] = unnormalizeFeatures( X0, MU, SIGMA )
%UNNORMALIZEFEATURES Undo the normalization that was imposed on the data.
    X = bsxfun(@times,X0,SIGMA);
    X = bsxfun(@plus,X,  MU);
end

