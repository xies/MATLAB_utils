function [R,P] = correlate_nonzero(X,Y)

X = ensure_column(X);
Y = ensure_column(Y);

I = find( X ~= 0);
[R,P] = corrcoef(X(I),Y(I));