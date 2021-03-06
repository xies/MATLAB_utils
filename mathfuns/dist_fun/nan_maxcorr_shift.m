function shift = nan_maxcorr_shift(A,B,wt)
%NANXCORR Uses NANCOV to calculate the cross correlation between two
%signals when NaN is present.
%
% SYNOPSIS: correlations = nanxcorr(A,B,wt)
%               By default correlate across the first dimension
%           correlations = nanxcorr(A,B,wt,dim)
%               Denote which dimension you want to correlate
%
% Modiefied from acmartin. xies@mit.edu Jan 2012.

[N,T] = size(B);
shift = nan(N,1);

for i = 1:N
    correlation = zeros(2*wt+1,1);
    for t = -wt:wt
        signal = cat(1,A(max(1,1+t):min(T,T+t)), ...
            B(i,max(1,1-t):min(T,T-t)))';
        cov_mat = nancov(signal);
        variances = diag(cov_mat);
        corr = cov_mat./sqrt(variances*variances');
        correlation(t+wt+1) = corr(1,2);
    end
    [~,idx] = nanmax(correlation);
    shift(i) = idx - wt - 1;
end


end
