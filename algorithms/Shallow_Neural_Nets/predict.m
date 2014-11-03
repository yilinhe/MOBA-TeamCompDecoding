function p = predict(W1, W2, X)
%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT(W1, W2, X) outputs the predicted label of X given the
%   trained weights of a neural network (W1, W2)

% Useful values
m = size(X, 1);
num_labels = size(W2, 1);

% You need to return the following variables correctly 
p = zeros(size(X, 1), 1);

h1 = sigmoid([ones(m, 1) X] * W1');
h2 = sigmoid([ones(m, 1) h1] * W2');
[dummy, p] = max(h2, [], 2);

% =========================================================================


end
