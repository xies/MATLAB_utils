function [xe, ye] = poly2edge(x,y,scale)
%POLY2EDGELIST Computes list of horizontal edges from polygon.
%   [XE,YE] = POLY2EDGELIST(X,Y) rescales the polygon represented
%   by vectors X and Y by a factor of 5, and then quantizes them to
%   integer locations.  It then creates a new polygon by filling in
%   new vertices on the integer grid in between the original scaled
%   vertices.  The new polygon has only horizontal and vertical
%   edges.  Finally, it computes the locations of all horizontal
%   edges, returning the result in the vectors XE and YE.
%
%   [XE,YE] = POLY2EDGELIST(X,Y,SCALE) rescales by a factor of
%   SCALE instead of 5.  SCALE must be a positive odd integer.
%
%   See also EDGELIST2MASK, POLY2MASK, ROIPOLY.

%   Copyright 1993-2008 The MathWorks, Inc.
% BASED ON undocumented private function

if nargin < 3
    scale = 1;
end

% Scale and quantize (x,y) locations to the higher resolution grid.
x = round(scale*(x - 0.5) + 1);
y = round(scale*(y - 0.5) + 1);

num_segments = length(x);
x_segments = cell(num_segments,1);
y_segments = cell(num_segments,1);
for k = 1:num_segments - 1
    [x_segments{k},y_segments{k}] = iptui.intline(x(k),x(k+1),y(k),y(k+1));
end
[x_segments{k+1},y_segments{k+1}] = iptui.intline(x(end),x(1),y(end),y(1));

% Concatenate segment vertices.
xe = cat(1,x_segments{:})/scale;
ye = cat(1,y_segments{:})/scale;

% % Horizontal edges are located where the x-value changes.
% d = diff(x);
% edge_indices = find(d);
% xe = x(edge_indices);
% 
% % Wherever the diff is negative, the x-coordinate should be x-1 instead of
% % x.
% shift = find(d(edge_indices) < 0);
% xe(shift) = xe(shift) - 1;
% 
% % In order for the result to be the same no matter which direction we are
% % tracing the polynomial, the y-value for a diagonal transition has to be
% % biased the same way no matter what.  We'll always chooser the smaller
% % y-value associated with diagonal transitions.
% 
% ye = min(y(edge_indices), y(edge_indices+1));
% 
% 
% % Vertical edges are located where the y-value changes.
% % d = diff(y);
% % edge_indices = find(d);
% % ye = y(edge_indices);
% % 
% % shift = find(d(edge_indices) < 0);
% % ye(shift) = ye(shift) - 1;

end

