function out = waterline(facetsRaw,level,d)

% This function generates a horizontal ring (i.e., a "waterline") around a 
% faceted volume at a given elevation. Used for checking the location of 
% sample points relative to the object surface. 
%
% Syntax:
%
% out = waterline(facetsRaw,level,d);
%
% facetsRaw is a matrix defining a faceted volume. It is the output of 
% readstl.m.
%
% level is the level at which to draw the line, in the same coords as
% facetsRaw. 
%
% d is an optional structure with various fields:
%   d.plotRock -- 0 no plot, 1 plots entire rock with waterline
%   d.plotLevel -- 0 no plot, 1 plots x-y plot of volume x-section at level
%   d.tryToSort -- 0 to return unsorted line segments; 1 to attempt to sort
%       points into a single continuous line. Only set to 1 if you are
%       pretty sure you have a single closed volume at the desired
%       elevation. Otherwise you may get strange results. 
%       This part of the code could be greatly improved. 
%
% out is a structure with fields:
%   out.unsorted -- nx2 matrix with n/2 pairs of [x y] rows, each of which
%       defines a line segment. No particular order to the line segments.
%   out.sorted -- nx2 matrix with rows [x y] defining the waterline at
%       level. This field only exists if tryToSort = 1. 
%
% Greg Balco -- Berkeley Geochronology Center -- 2009-2011
% Edited and checked - October 2011
%
% This file is for use in the course of reviewing an accompanying paper
% ('Simple computer code for estimating cosmic-ray shielding by oddly
% shaped objects', submitted to Quaternary Geochronology). It is not
% licensed for use for any other purpose. 
%
% 

% Defaults
plotRock = 0;
plotLevel = 0;
tryToSort = 0;

if nargin == 3;
    if isfield(d,'plotRock');
        plotRock = d.plotRock;
    end;
    if isfield(d,'plotLevel');
        plotLevel = d.plotLevel;
    end;
    if isfield(d,'tryToSort');
        tryToSort = d.tryToSort;
    end;
end;


% Figure out which facets are relevant

isPossible = find((max(facetsRaw(:,[3 6 9])'))' > level &...
    (min(facetsRaw(:,[3 6 9])'))' < level);

% Go through each relevant facet and check each line segment

V = [];

for a = 1:length(isPossible);
    v1 = facetsRaw(isPossible(a),1:3);
    v2 = facetsRaw(isPossible(a),4:6);
    v3 = facetsRaw(isPossible(a),7:9);
    isAbove = [v1(3) v2(3) v3(3)] > level;
    isBelow = ~isAbove;
    if xor(isAbove(1),isAbove(2));
        % 1-2 line is OK, find intersection
        zpart = (v1(3)-level)./(v1(3)-v2(3));
        thisx = (v2(1)-v1(1))*zpart + v1(1);
        thisy = (v2(2)-v1(2))*zpart + v1(2);
        V(size(V,1)+1,:) = [thisx thisy];
    end;
    if xor(isAbove(2),isAbove(3));
        % 2-3 line is OK, find intersection
        zpart = (v2(3)-level)./(v2(3)-v3(3));
        thisx = (v3(1)-v2(1))*zpart + v2(1);
        thisy = (v3(2)-v2(2))*zpart + v2(2);
        V(size(V,1)+1,:) = [thisx thisy];
    end;
    if xor(isAbove(3),isAbove(1));
        % 3-1 line is OK, find intersection
        zpart = (v3(3)-level)./(v3(3)-v1(3));
        thisx = (v1(1)-v3(1))*zpart + v3(1);
        thisy = (v1(2)-v3(2))*zpart + v3(2);
        V(size(V,1)+1,:) = [thisx thisy];
    end;
end;

out.unsorted = V;

if tryToSort == 1;

    % Sort the dots

    % Scan through and find matches
    match1 = []; match2 = [];
    for a = 1:2:(size(V,1)-1);
        temp1 = find(abs((V(a,1) - V(:,1))) < 1e-14);
        match1(end+1) = temp1(find(temp1 ~= a));
        temp2 = find(abs((V(a+1,1) - V(:,1))) < 1e-14);
        match2(end+1) = temp2(find(temp2 ~= (a+1)));
    end;

    % Put in order

    last = match1(1);
    this = 1;
    sequence = this;
    thispair = ceil(this./2);
    j = 1;
    while 1;
        next = [match1(thispair) match2(thispair)];
        next = next(find(ceil(next./2) ~= ceil(last./2)));
        sequence(end+1) = next;
        last = this;
        this = next;
        thispair = ceil(this./2);
        if this == sequence(1);
            break;
        elseif j > size(V,1);
            break;
        end;
        j = j+1;
    end;

    % Create single line
    newV = V(sequence,:);
    
    % Report
    out.sorted = newV;

end;


% Plotting 

% Plot the rock 

if plotRock == 1;
    
    if isempty(findobj('tag','xyz_waterline_window'));
        % No figure exists; create one
        figure('tag','xyz_waterline_window');
    else
        figure(findobj('tag','xyz_waterline_window'));
        clf;
    end;
    nf = size(facetsRaw,1);
    plot3(facetsRaw(:,1),facetsRaw(:,2),facetsRaw(:,3) ,'b.');hold on;
    for a = 1:nf;
        xx = facetsRaw(a,[1 4 7 1]);
        yy = facetsRaw(a,[2 5 8 2]);
        zz = facetsRaw(a,[3 6 9 3]);
        plot3(xx,yy,zz,'b');
    end;
    axis('equal');
    xlabel('X'); ylabel('Y'); zlabel('Z');

    % Plot the dots
    if tryToSort == 1;
        plot3(newV(:,1),newV(:,2),zeros(size(newV,1),1)+level,'g.');
    else
        plot3(V(:,1),V(:,2),zeros(size(V,1),1)+level,'g.');
    end;

    % Plot the line segments
    
    if tryToSort == 1;
        % Use sorted data
        xx = newV(:,1);
        yy = newV(:,2);
        zz = zeros(size(newV,1),1)+level;
        plot3(xx,yy,zz,'m');
    else
        % Use unsorted data
        for a = 1:(size(V,1)./2);
            xx = V((a*2-1):(a*2),1);
            yy = V((a*2-1):(a*2),2);
            zz = [level level];
            plot3(xx,yy,zz,'g');
        end
    end;
    
    grid on;
    set(gcf,'name','Three-d waterline plot');
    title(['Level ' sprintf('%0.3f',level) ' m']);
end;

if plotLevel;
    if isempty(findobj('tag','xy_waterline_window'));
        % No figure exists; create one
        figure('tag','xy_waterline_window');
    else
        figure(findobj('tag','xy_waterline_window'));
        clf;
    end;
    
    if tryToSort == 1;
        % Use sorted data
        xx = newV(:,1);
        yy = newV(:,2);
        patch(xx,yy,[0.8 0.8 0.8]); hold on;
        plot(newV(:,1),newV(:,2),'m.');
        plot(xx,yy,'m');
    else
        % Use unsorted data
        plot(V(:,1),V(:,2),'g.');hold on;
        for a = 1:(size(V,1)./2);
            xx = V((a*2-1):(a*2),1);
            yy = V((a*2-1):(a*2),2);
            plot(xx,yy,'g');
        end
    end;
    
    xlabel('X'); ylabel('Y'); grid on;
    set(gcf,'name','Two-d waterline plot');
    title(['Level ' sprintf('%0.3f',level) ' m']);

end;
