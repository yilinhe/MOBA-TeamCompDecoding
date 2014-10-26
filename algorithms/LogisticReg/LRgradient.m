function [ grad ] = LRgradient( X, y, w )
    f = size(X,2);
    grad = zeros(f,1);
    
    for n = 1:size(X,1)
        t = exp(X(n,:) * w);
        grad = grad + y(n) * X(n,:)' - t / (1+t) * X(n,:)';
    end
    
    grad = grad.*(-1);
end