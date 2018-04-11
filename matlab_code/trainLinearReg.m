function [theta] = trainLinearReg(X, y, lambda)
%   [theta] = TRAINLINEARREG (X, y, lambda) trains linear regression using
%   the dataset (X, y) and regularization parameter lambda. Returns the
%   trained parameters theta.

% Initialize Theta
%initial_theta = zeros(size(X, 2), 1); 
initial_theta = zeros(size(X, 2), size(y,2)); 
size(initial_theta);

% Create "short hand" for the cost function to be minimized
costFunction = @(t) linearRegCostFunction(X, y, t, lambda);

% Now, costFunction is a function that takes in only one argument
options = optimset('MaxIter', 200, 'GradObj', 'on');

% Minimize using fmincg
initial_theta = initial_theta(:);
theta = fmincg(costFunction, initial_theta, options);

end
