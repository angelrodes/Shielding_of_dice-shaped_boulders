function out = shielding_loop(in)

% This function performs a Monte Carlo integration to compute shielding of the
% cosmic ray flux by a complicated obstruction. 
%
% Syntax:  out = shielding_loop(in);
%
% Where the input argument in is a structure with the following fields:
%
% Required:
%    in.fname - filename of file containing boulder geometry. This can be 
%           either an stl file (in which case it calls readstl.m) or a .mat
%           file resulting from a previous call to readstl. 
%    in.thispoint - [x y z] of sample point in same coordinate system as .stl file
%    in.rays.xyz - Matrix with orientation of cosmic rays to be evaluated, in the 
%           form returned by generate_cosmic_rays.m, which is x-y-z triples
%           on the unit sphere. See generate_cosmic_rays.m. Normally this 
%           would be a large number of randomly generated values returned 
%           by generate_cosmic_rays, but having it as a parameter allows 
%           any arbitrary test set of rays to be evaluated. 
%   in.rays.phi - Corresponding vector of zenith angles for these rays (as
%           these have already been calculated, it saves time to pass
%           rather than recalculating from xyz data). 
%           See generate_cosmic_rays.m. 
%   in.rays.ok - Corresponding vector showing which rays pass a far-field 
%           horizon. See generate_cosmic_rays.m. If there is no far-field
%           horizon, then this is just a vector of ones. 
%
% Optional to override defaults: 
%    in.plotFlag - plotting flag - default 0, set = 1 for continuous
%       plotting of each ray
%    in.finalPlotFlag - another flag - default 0, set = 1 for summary
%       diagnostic plots
%    in.rho - rock density (g/cm3); default 2.65;
%    in.selv - soil surface elevation in same coord system; default no soil
%    in.tpal - particle attenuation length (g/cm2); default 208 g/cm
%    in.evenMessage - disable/enable warning -- see discussion below
%    in.ax - angular distribution exponent (default 2.3);
%
% out is the (scalar) shielding factor averaged over all iterations 
%   (nondimensional). 
%
% Notes: 
%
% 1. All coordinates should be in meters.
%
% 2. It is expected that the sample location is inside one of the objects
%   defined in the .stl file, and that all of these objects are closed.
%   Then the ray should intersect either one facet (if it goes directly to
%   the sample) or (1 + 2n) facets (if it passes through n other objects
%   before getting there. Thus, we expect it to intersect an odd number of
%   facets. If it intersects an even number, we assume that the
%   farthest-from-the-sample facet is the side of an infinitely large
%   object, such that the sample is fully shielded from a ray with that
%   incidence direction. There is no problem setting up .stl files like
%   this if this is what you want to do, but this condition (even no. of
%   intersections) could also be caused by lots of topological errors.
%   Thus, when this occurs, this code i) sets the shielding factor for that
%   ray to 0 (completely shielded), and ii) throws a warning message to 
%   the command window. To disable these messages (i.e. if you expect even 
%   numbers of intersections and you are OK with the above) then set 
%   in.evenMessage = 0. 
% 
% 3. Soil is taken to have the same density as rock. 
%
% 4. The vector in.rays.ok that reflects far-field shielding
%   should be calculated such that the far-field horizon is referenced to
%   the same directions as the shape model. 
% 
%
% Uses intersectLinePlane.m from the 'geom3d' toolbox by David Legland,
% which is available on the MATLAB File Exchange.
%
% Greg Balco
% Berkeley Geochronology Center
% 2009 - 2012
%
% This version checked and edited Feb 7 2012. 
%
% This file is for use in the course of reviewing an accompanying paper
% ('Simple computer code for estimating cosmic-ray shielding by oddly
% shaped objects', submitted to Quaternary Geochronology). It is not
% licensed for use for any other purpose. 


%% Setup

% Flags, constants, defaults

if isfield(in,'plotFlag');
    plotFlag = in.plotFlag;
else
    plotFlag = 0;
end; 

if isfield(in,'finalPlotFlag');
    finalPlotFlag = in.finalPlotFlag;
else
    finalPlotFlag = 0;
end; 
    
if isfield(in,'rho');
    rho = in.rho;
else
    rho = 2.65;
end;

if isfield(in,'tpal');
    tpal = in.tpal;
else
    tpal = 208;
end;

if isfield(in,'ax');
    ax = in.ax;
else
    ax = 2.3;
end;

% Define point of interest
thispoint = in.thispoint;

if isfield(in,'selv');
    sdepth = in.selv - thispoint(3);
else
    sdepth = 0;
end;

if isfield(in,'evenMessage');
    % Do nothing
else
    in.evenMessage = 1; % Do throw message
end;

linpal = tpal./rho./100; % True particle attenuation length in m
numits = size(in.rays.xyz,1); % Number of iterations 

% Read in a shape and assemble facet information

% Read in a shape
if strcmp(in.fname((end-3):end),'.stl');
    % Case stl file
    disp('Reading .stl file');
    facetsRaw = readstl(in.fname);
elseif strcmp(in.fname((end-3):end),'.mat');
%     disp('Reading .mat file');
    eval(['load ' in.fname]);
    facetsRaw=polygons;
end;

% Number of facets

nf = size(facetsRaw,1);

% Transform so that 0,0,0 is at the point of interest

thispoints = [zeros(nf,1)+thispoint(1) zeros(nf,1)+thispoint(2) zeros(nf,1)+thispoint(3)];
facetsShift = facetsRaw - [thispoints thispoints thispoints];

% Use this to compute ray length for plot
lf = 1.4*abs(max(max(facetsShift)));

% Transform to plane specification usable by IntersectLinePlane;
facetsG = facetsShift;
facetsG(:,4:6) = facetsShift(:,4:6) - facetsShift(:,1:3);
facetsG(:,7:9) = facetsShift(:,7:9) - facetsShift(:,1:3);

% Evaluate soil position

if sdepth < 0; sdepth = 0; end; % Decrease confusion
splane = [0 0 sdepth 1 0 0 0 1 0]; % Define soil surface plane
isSoil = (sdepth > 0);

if plotFlag == 1;
    % Initial plotting....plot rock in "running" figure window
    if isempty(findobj('tag','running_window'));
        % Create it
        rfig = figure; set(rfig,'tag','running_window');
        figure(rfig);
    else
        % Clear existing axes
        figure(findobj('tag','running_window'));
        delete(get(gca,'children'));
    end;
    
    % Plot sample location (although this should be inside so always hidden
    % if using filled facets)
    plot3(0,0,0,'k.'); hold on; lighting phong;
    % Plot facets;
    for a = 1:nf;
        xx = facetsShift(a,[1 4 7 1]);
        yy = facetsShift(a,[2 5 8 2]);
        zz = facetsShift(a,[3 6 9 3]);
        %fill3(xx,yy,zz,[0.9 0.9 0.9]);
        plot3(xx,yy,zz);
    end;
    axis([-lf lf -lf lf 0 lf]);
    axis('equal');
    xlabel('X'); ylabel('Y'); zlabel('Z');
    grid on;
    set(findobj('tag','running_window'),'name',[in.fname ' -- running calculation']);
end;

%% Main calculation

% Read in set of cosmic ray vectors

lines1 = in.rays.xyz;

% Main loop: computes intersections and total attenuation for each cosmic ray

% Allocate memory
ints = zeros(numits,9); % This may underallocate. 
soilints = zeros(numits,3);
sLength = zeros(numits,1);
np = sLength;
soilLength = np;

% Initialize
it = 1;

while it <= numits

    if in.rays.ok(it) == 1;
        % Case ray admitted by far-field horizon -- do calculation
        % Select a line
        thisline = lines1(it,:);

        % Determine whether the line passes through each facet
        % resolve line into multiples of facet corner vectors
        res = zeros(nf,3);
        for a = 1:nf;
            res(a,:) = (reshape(facetsShift(a,:),3,3))\thisline';
        end;

        % If all multiples of facet corner vectors are positive, line passes
        % through the facet
        passesThrough = find(res(:,1) > 0 & res(:,2) > 0 & res(:,3) > 0);

        % Now find the intersections
        % intersections has 3 cols (x-y-z) and nrows = number facets
        % intersected
        clear intersections;
        intersections = intersectLinePlane([0 0 0 thisline],facetsG(passesThrough,:));

        % Find the distances from origin to the intersections, i.e. vector
        % norms
        clear lengths;
        lengths = sqrt(sum(intersections.*intersections, 2));

        % if needed, find intersection of ray with soil surface and shielding length
        if isSoil;
            soilints(it,:) = intersectLinePlane([0 0 0 thisline],splane);
            soilLength(it) = sqrt(sum(soilints(it,:).*soilints(it,:),2));
        end;
        % Otherwise, soil length is already zero. 

        if plotFlag == 1;
            % Plot facets of interest each step
            % Clean up figure
            delete(findobj('tag','thispatch'));
            delete(findobj('tag','p1'));
            delete(findobj('tag','p2'));
            % light up the facets that the ray passes through
            for a = 1:length(passesThrough);
                xx = facetsShift(passesThrough(a),[1 4 7 1]);
                yy = facetsShift(passesThrough(a),[2 5 8 2]);
                zz = facetsShift(passesThrough(a),[3 6 9 3]);
                patch(xx,yy,zz,[1 0.5 0.5],'edgecolor','k','tag','thispatch');
                % Also plot the intersections of ray with facets
                plot3(intersections(a,1),intersections(a,2),intersections(a,3),'r.','tag','p2');
            end;
            if isSoil;
                plot3(soilints(it,1),soilints(it,2),soilints(it,3),'k.','tag','p2');
            end;
        end;

        % Count intersections
        numpass = length(passesThrough);
        np(it) = numpass;

        % Store intersections
        ints(it,1:numel(intersections)) = reshape(intersections',1,numel(intersections));  

        % Determine even or odd number of facets
        if mod(np(it),2) == 0;
            % Case even number of facets
            % Throw warning message
            if in.evenMessage;
                warning(['Iteration ' int2str(it) ': even number of facet intersections. Ray never arrives.']);
            end;
            % Set shielding to inf for this ray
            sLength(it) = Inf;
            thisLength = Inf;
            % Plot ray in all blue
            if plotFlag == 1;
                xx = [0 lf*thisline(1)];
                yy = [0 lf*thisline(2)];
                zz = [0 lf*thisline(3)];
                plot3(xx,yy,zz,'b','tag','p2');
                drawnow;
            end;
        else
            % Case odd number of facets
            % Actually do calculation
            % Assemble all intersections and lengths
            % If no intersections, this ends up zero
            clear li;
            li = [lengths intersections];
            li = [li;[soilLength(it) soilints(it,:)]];
            % Sort by length
            li = sortrows(li,1);

            % Initialize state trackers
            isIn = 1; inSoil = 1;
            lastPoint = [0 0 0];
            thisLength = 0;

            % Loop to compute total shielding distance

            for a = 1:np(it)+1;
                % Loop through each length
                % Add it if we are inside or subsoil
                counting = (isIn | inSoil); 
                if a == 1;
                    % Case starting from zero
                    currentLength = li(a,1);
                else
                    % Case starting from last length
                    currentLength = li(a,1)-li(a-1,1);
                end;
                thisLength = thisLength + currentLength.*counting;

                % Plot current segment of ray
                if plotFlag == 1;
                    thisPoint = li(a,2:4);
                    if counting; col = 'r'; else col = 'g';end;
                    xx = [lastPoint(1) thisPoint(1)];
                    yy = [lastPoint(2) thisPoint(2)];
                    zz = [lastPoint(3) thisPoint(3)];
                    plot3(xx,yy,zz,col,'tag','p2');
                    lastPoint = thisPoint;
                end;

                % Switch either soil or in/out
                if li(a,1) == soilLength(it);
                    % if this point is the soil surface
                    inSoil = ~inSoil;
                else
                    isIn = ~isIn;
                end;
            end;  

            % Plot tag end of ray
            if plotFlag == 1;
                xx = [lastPoint(1) lf*thisline(1)];
                yy = [lastPoint(2) lf*thisline(2)];
                zz = [lastPoint(3) lf*thisline(3)];
                plot3(xx,yy,zz,'g','tag','p2');
                drawnow;
            end;

            % Assign length
            sLength(it) = thisLength;

        end; 

        % Check
        if isnan(thisLength);
            error('thisLength is NaN');
        end;
    elseif in.rays.ok(it) == 0;
        % Case ray not admitted by far-field horizon -- no calculation
        sLength(it) = Inf;
    else;
        error('Can''t decide if ray is admitted or not');
    end;
    % Any case, increment iteration
    it = it + 1;
end;

% Now the rest of the Monte Carlo integration formula....
% Compute Fmax for whatever the exponent is
Fmax = (pi.*2)./(ax+1);
% Compute attenuation factors, including zenith angle distribution and
% sin(phi) radial compression factor
SF = ((cos(in.rays.phi)).^ax).*sin(in.rays.phi).*exp(-sLength./linpal);
% Compute average shielding factor at each iteration...
% And include total area integrated in 2-d = (pi/2)*2*pi = pi^2;
thisF = (pi^2).*cumsum(SF)./(1:length(SF))';
% Then normalize by full-sky integral
cSF = thisF./Fmax;


% Report final average shielding factor
out = cSF(end);

%% Final plotting of cumulative SF if selected

if finalPlotFlag;
    % Plot cumulative shielding into its window
    if isempty(findobj('tag','csf_window'));
        % Create it
        figure('tag','csf_window');
    else
        % Clear existing axes
        figure(findobj('tag','csf_window'));
        delete(get(gca,'children'));
    end;
    % Plot SF results
    plot(cSF);
    xlabel('Iteration');
    ylabel('Shielding factor');
    set(gcf,'name','Cumulative average shielding factor');
    drawnow;
end;


%% Final plotting of all rays if selected

if finalPlotFlag;
    if isempty(findobj('tag','all_rays_window'));
        % Create it
        figure('tag','all_rays_window');
    else
        % Clear existing axes
        figure(findobj('tag','all_rays_window'));
        delete(get(gca,'children'));
    end;

    % Plot origin
    plot3(0,0,0,'k.'); hold on;
    % Plot faces 
    for a = 1:nf;
        xx = facetsShift(a,[1 4 7 1]);
        yy = facetsShift(a,[2 5 8 2]);
        zz = facetsShift(a,[3 6 9 3]);
        plot3(xx,yy,zz,'k');
    end;

    % Plot rays
    for a = 1:numits;
        isIn = 1;
        inSoil = 1;
        lastPoint = [0 0 0];
        li = reshape(ints(a,1:(3*np(a))),3,np(a))';
        li = [li; soilints(a,:)];
        li = sortrows(li,3);
        for b = 1:np(a)+1;
            counting = isIn | inSoil;
            thisPoint = li(b,:);
            if counting; col = 'r'; else col = 'g';end;
            xx = [lastPoint(1) thisPoint(1)];yy = [lastPoint(2) thisPoint(2)];zz = [lastPoint(3) thisPoint(3)];
            plot3(xx,yy,zz,col);
            lastPoint = thisPoint;
            if li(b,3) == soilints(a,3);
                % if this point is the soil surface
                inSoil = ~inSoil;
            else
                isIn = ~isIn;
            end;
        end;
        xx = [lastPoint(1) lf*lines1(a,1)];
        yy = [lastPoint(2) lf*lines1(a,2)];
        zz = [lastPoint(3) lf*lines1(a,3)];
        plot3(xx,yy,zz,'g');
    end;   
        
    axis('equal');
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('Red, in rock; green, in air; blue, never arrive.');
    grid on;
    set(gcf,'name',[in.fname ' -- All rays']);
    drawnow;
end;


    
    
    
    