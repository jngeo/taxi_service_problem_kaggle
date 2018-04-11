function [J, grad] = linearRegCostFunction(X, y, theta, lambda)

[my ny] = size(y);              % number of training examples
[mx nx] = size(X);              % number of training examples
m = my;

% You need to return the following variables correctly 
J = 0;
theta = reshape(theta(:),nx,ny);

[mtheta ntheta] = size(theta);

grad = zeros(mtheta, ntheta);
%zeros(size(theta));
size(grad);

%Cost Function
    J = ((1/(2*m))* ((X*theta - y)')*(X*theta-y)) + (lambda/(2*m))*(theta(2:end,:)'*theta(2:end,:));
    J = mean(mean(J));                             %2*m m*2                                  2*15  15*2
%Gradient
    h = X*theta;        %m*16 * 16*2
    grad(1,:) = ( (1/m)*( h - y )' * X(:,1))';
                        %2*m        m*1
    grad(2:end,:) = (1/m)*( ((h - y)' * X(:,2:end))' + lambda*theta(2:end,:) ) ;
                              %2*m       m*15                   15*2      


grad = grad(:);

end
