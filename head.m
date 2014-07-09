function X = head( X0, N )
%HEAD Top N rows of a matrix.
    if(~exist('N','var'))
        N = 10;
    end
    X = X0(1:N,:);

end
