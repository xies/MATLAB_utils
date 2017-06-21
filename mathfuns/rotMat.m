function R = rotMat(theta)
% Returns the 2D rotation matrix given an angle in radians.
%
% R = [cos(theta),  sin(theta)
%      -sin(theta), cos(theta)]
%
% xies@mit May 2015

R = [cos(theta), sin(theta); ...
    -sin(theta), cos(theta)];

end
