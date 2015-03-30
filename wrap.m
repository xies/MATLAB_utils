function x = wrap(x,n)
% WRAP For circular 1-indexing
%
% USAGE: y = wrap(x,n)
%
% xies@mit.edu March 2015

    x = (1 + mod(x-1,n) );

end