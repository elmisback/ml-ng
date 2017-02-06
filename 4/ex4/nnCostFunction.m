function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices.
%
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

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

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial
%         derivatives of the cost function with respect to Theta1 and Theta2 in
%         Theta1_grad and Theta2_grad, respectively. After implementing Part 2,
%         you can check that your implementation is correct by running
%         checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


%for i=1:m
%  x = X(i,:);
%  a1 = [1 x];
%  a2 = [1 sigmoid(a1 * Theta1.')];
%  a3 = sigmoid(a2 * Theta2.');
%  h = a3;
%  y_i = y(i);
%  J += sum(-y_i.' * log(h) - (1 - y_i.') * log(1 - h));
%end
% size(Y): m x num_labels
Y = zeros(m, num_labels);
for i=1:num_labels;
  Y(:, i) = (y == i);
end
%J = 1/m * J;
% size(y): m x 1
% size(X): m x (n + 1)
% size(Theta1): hidden_layer_size x (n + 1)
a1 = [ones(m, 1) X];
% size(a2): m x hidden_layer_size
a2 = [ones(m, 1) sigmoid(a1 * Theta1.')];
% size(Theta2): num_labels x (hidden_layer_size + 1)
% size(a3): m x num_labels
a3 = sigmoid(a2 * Theta2.');
h = a3;

reg_params = [Theta1(:, 2:end)(:); Theta2(:, 2:end)(:)];
reg_term = lambda/(2 * m) * sum(reg_params .^ 2);

J = 1/m * sum(sum(-Y .* log(h) - (1 - Y) .* log(1 - h))) + reg_term ;

bigdelta2 = 0;
bigdelta1 = 0;
%for t = 1:m
%  a1 = X(t, :)(:);
%  a1 = [1; a1];
%  z2 = Theta1 * a1;
%  a2 = sigmoid(z2);
%  a2 = [1; a2];
%  z3 = Theta2 * a2;
%  a3 = sigmoid(z3);
%
%  T = zeros(num_labels, 1);
%  T(y(t)) = 1;
%
%  d3 = a3 - T;
%  d2 = (Theta2(:, 2:end).' * d3) .* sigmoidGradient(z2);
%  bigdelta2 = bigdelta2 + d3 * (a2.');
%  bigdelta1 = bigdelta1 + d2 * (a1.');
%end

% Vectorized
a1 = X;
a1 = [ones(m, 1) X];
z2 = a1 * (Theta1.');
a2 = sigmoid(z2);
a2 = [ones(m, 1) a2];
z3 = a2 * (Theta2.');
a3 = sigmoid(z3);

d3 = a3 - Y;

d2 = (d3 * Theta2(:, 2:end)) .* sigmoidGradient(z2);
bigdelta2 = d3.' * a2;
bigdelta1 = d2.' * a1;

% Add regularization.
temp1 = Theta1;
temp1(:, 1) = 0;
temp2 = Theta2;
temp2(:, 1) = 0;

Theta1_grad = bigdelta1/m + lambda/m * temp1;
Theta2_grad = bigdelta2/m + lambda/m * temp2;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
