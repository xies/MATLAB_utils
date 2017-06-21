function X = noinfs(X)

X = X(~isinf(X));

end