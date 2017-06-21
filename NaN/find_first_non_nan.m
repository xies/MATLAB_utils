function x = find_first_non_nan(X)
% GET_FIRST_NONANS

[N,~] = size(X);
x = zeros(1,N);
for i = 1:N
    I = find( ~isnan(X(i,:)) , 1, 'first' );
    if ~isempty(I)
        x(i) = X(i,I);
    else
        I = NaN;
    end
end

end