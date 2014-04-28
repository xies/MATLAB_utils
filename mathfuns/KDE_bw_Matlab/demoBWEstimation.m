function demoBWEstimation()
% This is a demo code for the multivariate bandwidth estimation. The demo
% generates a grid of data-points and calculates the bandwidths using three
% different approaches:
% * An unconstrained bandwidth from [1],
% * A constrained bandwidth (diagonal) derived from [1],
% * A standard Silverman bandwidth.
% The code then diplays the estimated KDEs as tabulated distributions as
% well as mixture models. 
%
% The demo uses the "drawTools" from Matej Kristan for visualization only.
% If you only want a multivariate bandwidth estimator, then you will only
% need the file/function "getBandwidth.m".
%
% If you are using this bandwidth in your work, please cite the paper [1].
%
% [1] M. Kristan, A. Leonardis, D. Skoèaj, "Multivariate online Kernel Density
% Estimation", Pattern Recognition, 2011.
% 
% Author: Matej Kristan (matej.kristan@fri.uni-lj.si) 2012

% add path to draw tools (for visualization only)
pth = [pwd, '/drawTools' ] ; rmpath(pth) ; addpath(pth) ;
 
% generate data
% N = 100 ; d = 2 ;  data = randn(d,N) ;  %  data = rand(d,N) ; 
[x,y] = meshgrid(1:2:10,1:2:10) ; data = [x(:)';y(:)'] ;
w = ones(1,size(data,2)); w = w / sum(w) ;

% calculate Silverman bandwidth
H_s = getBandwidth('data', data, 'weights', w, 'type_estimator', 'Silverman') ;
 
% calculate Kristan bandwidth (unconstrained)
H_k = getBandwidth('data', data, 'weights', w, 'type_estimator', 'Kristan') ;
 
% calculate Kristan 2D bandwidth (diagonal)
H_k2d = getBandwidth('data', data, 'weights', w, 'type_estimator', ...
                     'Kristan', 'kernel_type', 'bivariate_diagonal') ;
 
% construct the kdes using the calculated bandwidths
kde_s = constructKDE(data, w, H_s) ;
kde_k = constructKDE(data, w, H_k) ;
kde_k2d = constructKDE(data, w, H_k2d) ;

figure(1); clf ; 
% plot the kdes as tabulated distributions
subplot(2,3,1) ; I_k = visualizeKDE('kde', kde_k, 'tabulated', 1) ; 
imagesc(I_k); title('Tabulated pdf: Kristan -- general') ; axis equal ; axis tight ; colormap gray ;
subplot(2,3,2) ; I_k2 = visualizeKDE('kde', kde_k, 'tabulated', 1) ; 
imagesc(I_k2); title('Tabulated pdf: Kristan -- bivariate diagonal') ; axis equal ; axis tight ; colormap gray ;
subplot(2,3,3) ; I_s = visualizeKDE('kde', kde_s, 'tabulated', 1) ; 
imagesc(I_s); title('Tabulated pdf: Silverman'); axis equal ; axis tight ; colormap gray ;

% plot the kde as a mixture model
subplot(2,3,4) ; visualizeKDE('kde', kde_k, 'tabulated', 0) ; title('Mixture model: Kristan -- general') ;
hold on ; plot(data(1,:),data(2,:),'b.', 'MarkerSize',20) ;
axis equal ; axis tight ;
subplot(2,3,5) ; visualizeKDE('kde', kde_k2d, 'tabulated', 0) ; title('Mixture model: Kristan -- bivariate diagonal') ;
hold on ; plot(data(1,:),data(2,:),'b.', 'MarkerSize',20) ;
axis equal ; axis tight ;
subplot(2,3,6) ; visualizeKDE('kde', kde_s, 'tabulated', 0) ; title('Mixture model: Silverman') ;
hold on ; plot(data(1,:),data(2,:),'b.', 'MarkerSize',20) ;
axis equal ; axis tight ;

% ------------------------------------------------------------------ %
function kde_out = constructKDE(data, weights, H)
% constructs the kde as a Gaussian mixture model 
if isempty(weights) 
    weights = ones(1,size(data,2))/size(data,2) ;
end

pdf.Mu = data ;
pdf.w = weights ;
C = {} ;
for i = 1 : size(data,2)
    C = horzcat(C, H) ;
end
pdf.Cov = C ;
kde_out.pdf = pdf ;


