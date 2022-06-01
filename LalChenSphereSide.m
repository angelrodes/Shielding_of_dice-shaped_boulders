function out = LalChenSphereSide(theta,phi,a,R);

% This function is for use in duplicating Figure 4 in Lal and Chen, 2005
% (EPSL v. 236 p. 797), which describes variations in cosmogenic-nuclide
% production rates within a spherical boulder. This function evaluates
% Equation (6) of this paper and is for use in numerically integrating that
% function. 
%
% Syntax: out = LalChenSphereSide(theta,phi,a,R);
% 
% where theta is horizon angle (radians)
% phi is azimuth (radians)
% a is distance from outside of sphere (meters)
% R is radius of sphere (meters)
%
% Greg Balco
% Berkeley Geochronology Center
% November, 2011

rho = 2.65;
L = 208; % This is given as 160 in Lal and Chen. 

% compute path length

rv = (R-a).*cos(phi).*sin(theta) + sqrt( (R.^2) - ((R-a).^2).*(1-(cos(phi)^2).*(sin(theta.^2))) ); % meters
rv2 = rv.*rho.*100; % g cm-2

% return

out = (cos(theta).^2.3).*sin(theta).*exp(-rv2./L);







