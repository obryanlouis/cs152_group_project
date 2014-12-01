function x = laplacernd(mu,b,sz)
%LAPLACERND Generate Laplacian random variables 
% 
%  x = LAPLACERND(mu,b,sz) generates random variables from a Laplace
%  distribution having parameters mu and b. sz stands for the size of the
%  returned random variables. See [1] for Laplace distribution.
% 
%  [1] http://en.wikipedia.org/wiki/Laplace_distribution
% 
%  by Ismail Ari, 2011

if nargin < 1 % Equal to exponential distribution scaled by 1/2
    mu = 0;
end
if nargin < 2
    b = 1;
end
if nargin < 3
    sz = 1;
end

u = rand(sz) - 0.5;
x = mu - b*sign(u) .* log(1-2*abs(u));
end