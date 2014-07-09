function X = tail( X0, N )
%TAIL Bottom N rows of a matrix.
    if(~exist('N','var'))
        N = 10;
    end
    X = X0(length(X0)-N+1:end,:);

end