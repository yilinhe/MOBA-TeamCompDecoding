function g = sigmoidGradient(z)

g = zeros(size(z));

g = sigmoid(z);
g = g.*(1-g);


end
