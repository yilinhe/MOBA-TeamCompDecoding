function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)


% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));


% Feedforward the neural network

for i=1:m
    for k=1:num_labels
        yk = y(i)==k;
        temp=[1,X(i,:)];
        a2 = sigmoid(Theta1*temp');
        a22 = [1;a2];
        h = sigmoid(Theta2*a22);
        J = J + (-yk*log(h(k))-(1-yk)*log(1-h(k)));
    end
end
J=J/m;

temp = Theta1;
temp1 = Theta2;
temp(:,1)=0;
temp1(:,1)=0;
J = J + lambda/(2*m)*(sum(sum(temp.^2))+sum(sum(temp1.^2)));

% Implement the backpropagation algorithm 

for t=1:m
    a_1 = [1,X(t,:)]';
    z_2 = Theta1 * a_1;
    a_2 = sigmoid(z_2);
    a_2 = [1;a_2];
    z_3 = Theta2 * a_2;
    a_3 = sigmoid(z_3);
    yk = zeros(size(a_3,1),1);
    yk(y(t))=1;
    delta_3 = a_3-yk;
    delta_2 = Theta2'*delta_3;
    delta_2 = delta_2(2:end);
    delta_2 = delta_2.*sigmoidGradient(z_2);
    Theta1_grad = Theta1_grad + delta_2*(a_1)';
    Theta2_grad = Theta2_grad + delta_3*(a_2)';
end

Theta1_grad = Theta1_grad/m;
Theta2_grad = Theta2_grad/m;
    
% Regularization

temp = Theta1;
temp1 = Theta2;
temp(:,1)=0;
temp1(:,1)=0;

Theta1_grad = Theta1_grad + lambda/m*temp;

Theta2_grad = Theta2_grad + lambda/m*temp1;

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
