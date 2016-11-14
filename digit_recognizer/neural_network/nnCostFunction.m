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
% Activation 1
X = [ones(m, 1) X];
A1 = sigmoid(X * Theta1');

% Hypotheis value
A1 = [ones(size(A1, 1), 1) A1];
h = sigmoid(A1 * Theta2');

% Enlarge y to 5000 * 10
Y = zeros(size(h));
for i = 1:size(y, 1)
    Y(i, y(i)) = 1;
end

% J
j = -Y .* log(h) - (1 - Y) .* log(1 - h);
J = sum(sum(j, 2)) / m;

% Bias
theta1 = Theta1(:, 2:size(Theta1, 2));    % 25 * 400
theta2 = Theta2(:, 2:size(Theta2, 2));    % 10 * 25
bias1 = sum(sum(theta1 .^ 2, 2));
bias2 = sum(sum(theta2 .^ 2, 2));
bias = (bias1 + bias2) * lambda / (2 * m);

% Add bias
J = J + bias;

% -------------------------------------------------------------
for t = 1:m
    a1 = X(t, :)';

    z2 = Theta1 * a1;
    a2 = [1; sigmoid(z2)];

    z3 = Theta2 * a2;
    a3 = sigmoid(z3);

    o3 = a3 - Y(t, :)';
    o2 = (Theta2(:, 2:end)' * o3) .* sigmoidGradient(z2);

    Theta2_grad = Theta2_grad + o3 * a2';
    Theta1_grad = Theta1_grad + o2 * a1';
end

Theta2_grad = Theta2_grad / m;
Theta1_grad = Theta1_grad / m;

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end