function s = Sigmoid( x, w )
    s = 1./ (1 + exp(x * w));
end