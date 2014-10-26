function [ logl ] = LRlogLikelihood( X, y, w )
    logl = 0;
    
    for n = 1:size(X,1)
        t = y(n) * (X(n,:) * w) - log(1 + exp(X(n,:) * w));
        logl = logl + t;
    end
    
    logl = -logl; % negtive loglikelihood
end