function I = find_first_non_nan(x)

I = find(cumsum(~isnan(x),1) > 0, 1 ,'first');

end