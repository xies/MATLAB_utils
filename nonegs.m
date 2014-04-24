function x = nonegs(x)
% Returns non-negative elements of input vector x

x = x(x => 0);