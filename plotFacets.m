function out = plotFacets(facetsRaw);

% This code plots facets derived from a .stl file into a 3D plot window. 
%
% Syntax: out = plotFacets(facetsRaw);
%
% Input argument facetsRaw is a matrix containing information about the 
% facets, in the form output by readstl.m.
%
% Output argument is not used currently.
%
% This is set up for use with the graphical user interface front end to 
% the Monte Carlo integration routine -- it checks to see if the appropriate window
% exists, and if so, plots into it. This may require modification if used
% alone. 
%
% Greg Balco -- Berkeley Geochronology Center -- October, 2011
%
% This file is for use in the course of reviewing an accompanying paper
% ('Simple computer code for estimating cosmic-ray shielding by oddly
% shaped objects', submitted to Quaternary Geochronology). It is not
% licensed for use for any other purpose. 

% Setup

% Look for figure
if isempty(findobj('tag','3D_plot_window'));
   f = figure;
   set(f,'tag','3D_plot_window');
else;
   f = findobj('tag','3D_plot_window');
   figure(f);
   clf;
end;

% Number of facets
nf = size(facetsRaw,1);

hold on;

% Plot the rock 
for a = 1:nf;
    xx = facetsRaw(a,[1 4 7 1]);
    yy = facetsRaw(a,[2 5 8 2]);
    zz = facetsRaw(a,[3 6 9 3]);
    p = patch(xx,yy,zz,'r','tag','p'); 
end;

axis('equal');
xlabel('X'); ylabel('Y'); zlabel('Z');
light;
view(45,30);
grid on;

set(gca,'xcolor',[0.5 0.5 0.5],'zcolor',[0.5 0.5 0.5],'ycolor',[0.5 0.5 0.5])
set(gca,'gridlinestyle','-');
