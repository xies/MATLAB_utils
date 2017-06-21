function H = getBandwidth(varargin)
% Example of usage:
% H = getBandwidth('data', data, 'weights', weights) ;
%
% Description of inputs:
% data ... dxN matrix of N d-dimensional datapoints
% weights ... weight of each datapoint. if all weights are equal, then
%             you can skip this parameter, eg.,
%             H = getBandwidth('data', data ) ;
%
% type_estimator = {'Silverman', 'Kristan'} -- default 'Kristan'
% kernel_type = {'unconstrained', 'bivariate_diagonal'} -- default 'general'
%               ... 'unconstrained' implies a multivariate unconstrained Gaussian kernel 
%               ... 'bivariate_diagonal' implies a 2D diagonal Gaussian
%                   kernel (only diagonal elements of covariance matrix are
%                   nonzero).
%
% Comments:
% The "Kristan" bandwidth is derived from a more general bandwidth
% estimation method from the paper [1]. That method allows that
% each data-point may be a general multivariate Gaussian, however, here we
% provide a code for a more widely-used applications in which we have 
% access to each data point and do not require online estimation.
%
% If you are using this bandwidth in your work, please cite the paper [1].
%
% [1] M. Kristan, A. Leonardis, D. Skoèaj, "Multivariate online Kernel Density
% Estimation", Pattern Recognition, 2011.
% 
% Author: 
% Matej Kristan (matej.kristan@fri.uni-lj.si) 2012

data = [] ;
weights = [] ;
type_estimator = 'Kristan' ; % default
kernel_type = 'unconstrained' ; % {'unconstrained', 'bivariate_diagonal'}
args = varargin;
nargs = length(args);
for i = 1:2:nargs
    switch args{i}        
        case 'data', data = args{i+1} ;
        case 'weights', weights = args{i+1} ;
        case 'type_estimator', type_estimator = args{i+1} ;
        case 'kernel_type', kernel_type = args{i+1} ;
    end
end

% select the estimator 
switch type_estimator
    case 'Silverman'
        scale = 1 ;
        H = getSilvermanBandwidth(data, weights, scale) ;
    case 'Kristan'        
 
        switch kernel_type
            case 'unconstrained'
                H =  innerKristanKernel_xd(data, weights)   ;
            case 'bivariate_diagonal'
                 inflate_factor = 1 ; % 1.2^2
                 H = innerKristanKernel2D_decorrelated(data, weights, inflate_factor); %*1.5^2  ;
            otherwise
                error(['Unknown kernel_type: ', kernel_type, ' !']) ;
        end    
end

% ---------------------------------------------------------------------- %
function H = innerKristanKernel2D_decorrelated(tdata, weights, inflate_factor)
% Assumes 2D data with decorrelated axes
% The kernel matrix is therefore diagonal with zero nondiagonal elements.
% 
% tdata ... [2xN] matrix of data, one datapoint per column
% weights ... [1xN] matrix of weights for the datapoints (weights should sum to one)
%

len = size(tdata,2) ;
d = size(tdata,1) ;
if d > 2
    error('Functions were written only for d=2!') ;
end

if ~isempty(weights)
    weights = weights / sum(weights) ;
    N_eff = sum( weights.^2 )^(-1) ;
else
    N_eff = size(tdata,2) ;
    weights = ones(1,size(tdata,2))* 1/len ;
end

C_smp = std(tdata,[],2).^2 ;
d=2 ; r = 4 ;
G = C_smp*(4/(d+2*r+2))^(2/(d+2*r+4)) *N_eff^(-2/(d+2*r+4)) * inflate_factor;  
dG = G(1)*G(2) ;
ig = 1./G ;
r = 0 ;
for i = 1 : len
    for j = i : len
        dm = (tdata(:,i)-tdata(:,j)) ;
        m_ij = sum((dm.^2) .* ig) ;
        % determine the weight of the term current
        if ( i == j )
            eta = 1 ;
        else
            eta = 2 ;
        end
        c = 4*m_ij^2 - 16*m_ij + 8 ;
        r = r + weights(i)*weights(j)*eta*exp(-0.5*m_ij) *c ;
    end
end
bet = (4*N_eff*r)^(-1/6) ;
H = diag(G) * bet^2 ;

% ---------------------------------------------------------------------- %
function H = innerKristanKernel_xd(tdata, weights)
% A general kernel -- does not assume any constraints on the bandwidth
% 
% tdata ... [dxN] matrix of data, one datapoint per column
% weights ... [1xN] matrix of weights for the datapoints (weights should sum to one)
%
len = size(tdata,2) ;
d = size(tdata,1) ;

if ~isempty(weights)
    weights = weights / sum(weights) ;
    N_eff = sum( weights.^2 )^(-1) ;
else
    N_eff = size(tdata,2) ;
    weights = ones(1,size(tdata,2))* 1/len ;
end
C_smp =  cov(tdata') ; % covestimate(tdata, weights) ; %
r = 4 ;
G = C_smp*(4/(d+2*r+2))^(2/(d+2*r+4)) *N_eff^(-2/(d+2*r+4)) ;
iG = inv( G ) ;
r = 0 ;
for i = 1 : len
    for j = i : len
        dm = (tdata(:,i)-tdata(:,j)) ;
        m_ij = dm' * iG * dm ;
        % determine the weight of the term current
        if ( i == j )
            eta = 1 ;
        else
            eta = 2 ;
        end
        c = 2*d*(1-2*m_ij) + d^2*(1-m_ij)^2 ;
        r = r + weights(i)*weights(j)*eta*exp(-0.5*m_ij) *c ;
    end
end
R = r/( (2*pi)^(d/2) ) ;
bet = ( d*(4*pi)^(d/2) * N_eff * R )^(-1/(d+4)) ;
H = G * bet^2 ;

% ---------------------------------------------------------------------- %
function H = getSilvermanBandwidth(data, ww, scale)
% Assumes 2D data with decorrelated axes
% The kernel matrix is therefore diagonal with zero nondiagonal elements.
% 
% tdata ... [2xN] matrix of data, one datapoint per column
% weights ... [1xN] matrix of weights for the datapoints (weights should sum to one)
% scale ... a scalar value by which the Silverman kernel is rescaled
% 

len = size(data,1) ;
d = size(data,2) ;
if ~isempty(ww)
    ww = ww / sum(ww) ;
    N_eff = sum( ww.^2 )^(-1) ;    
else
    N_eff = len ;
end
C = covestimate(data, ww) ;

l1 = round(0.25*size(data,2)) ;
l2 = round(0.75*size(data,2)) ;
ic = zeros(1,size(data,1)) ;
for i = 1:size(data,1)
    dd = sort(data(i,:)) ;
    ic(i) = dd(l2)-dd(l1) ;    
end
ic = (ic/1.34).^2 ;

cc = min([diag(C), ic']')' ; 
C = diag(cc) ;
 
H = C * N_eff^(-2/(d+4)) * scale^2 ; 

% ---------------------------------------------------------------------- %
function C = covestimate(data, w)

if isempty(w)
    C = cov(data') ;
else    
    m = sum(bsxfun(@times,data,w),2) ;     
    delt = bsxfun(@minus,data,m) ;    
    delt = bsxfun(@times,delt,sqrt(w))  ;         
    C = delt*delt' ;
end

