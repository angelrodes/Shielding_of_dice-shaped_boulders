% This code generates a unit upper hemisphere made up of triangular facets
% and saves it to a .mat file called "upperHemisphere.mat." The facets are
% defined in the same way as the output of readstl.m; see the documentation
% for that file. 
%
% The method of generating a sphere is the "surface refinement" method from
% here:
% 
% http://paulbourke.net/geometry/circlesphere/
%
% This method is iterative, so this code plots the results of the
% calculation at each iteration. Uses plotfacets.m to do this.
%
% Greg Balco
% Berkeley Geochronology Center
% February, 2012
%
%

% Start with coords of a tetrahedron. 

initFacets = [0 1 0 1 0 0 0 0 1
    0 -1 0 1 0 0 0 0 1
    -1 0 0 0 -1 0 0 0 1
    -1 0 0 0 1 0 0 0 1];

% Plot starting condition
plotFacets(initFacets);

numits = 3; % Define number of times to divide facets
newFacets = initFacets;

% Split each facet into 4 and push vertices out to the unit sphere

for iter = 1:numits; % outer loop - iterations to densify entire sphere
    oldFacets = newFacets;
    newFacets = zeros(size(oldFacets,1).*4,9);
    for a = 1:size(oldFacets,1);
        % Inner loop - step through each facet and split into four
        newStartIndex = 1+((a-1)*4);
        p1 = oldFacets(a,1:3);
        p2 = oldFacets(a,4:6);
        p3 = oldFacets(a,7:9);
        % Define midpoints of edges
        mp12 = (p1+p2)./2;
        mp23 = (p2+p3)./2;
        mp13 = (p1+p3)./2;
        % Normalize to unit circle
        mp12 = mp12./norm(mp12);
        mp23 = mp23./norm(mp23);
        mp13 = mp13./norm(mp13);
        % Assemble new facets
        newFacets(newStartIndex,:) = [p1 mp12 mp13];
        newFacets(newStartIndex+1,:) = [p2 mp12 mp23];
        newFacets(newStartIndex+2,:) = [p3 mp13 mp23];
        newFacets(newStartIndex+3,:) = [mp12 mp23 mp13];
        
    end;
    pause(1); % increase viewer satisfaction
    plotFacets(newFacets); drawnow;
end;

facetsRaw = newFacets;
save upperHemisphere facetsRaw