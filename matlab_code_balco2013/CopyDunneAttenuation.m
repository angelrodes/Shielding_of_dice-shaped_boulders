% This code uses the Monte Carlo integration routine for cosmic-ray shielding
% to estimate the attenuation length for cosmic-ray production beneath a
% surface whose horizon is obstructed. Basically, obstructions on the
% horizon make the cosmic-ray flux more vertically collimated, so the
% effective attenuation length for production lengthens. 
% 
% Compares results with similar integration (using various analytical 
% schemes) from Dunne, Elmore, and Muzikar, 1999 (Geomorphology v. 27, p. 
% 3. 
%
% This generates Figure 5 of an accompanying paper, 'Simple computer code 
% for estimating cosmic-ray shielding by oddly shaped objects'.
%
% Greg Balco
% Berkeley Geochronology Center
% February, 2012
%
%

% Clean up

clear all; close all;

% First, we need to make a dummy shape to load...the MCI code requires some sort
% of a solid object to evaluate. Thus, create a very small one to simulate an
% unobstructed location. 

% Start with coords of a tetrahedron. 

initFacets = [0 1 0 1 0 0 0 0 1
    0 -1 0 1 0 0 0 0 1
    -1 0 0 0 -1 0 0 0 1
    -1 0 0 0 1 0 0 0 1];

% Make it small:

facetsRaw = initFacets.*0.01;

% That's a 1-cm-high pyramid. Save it for use by shielding_loop.

save smallPyramid facetsRaw


%% 

clear d;

% Define number of rays to be evaluated in MCI
numits = 2000;

% Define horizon

% Example: single 180-deg "rectangular" obstruction that is 
% 50 degrees "high."

d.az = [89.9 90 270 270.1];
d.el = [0 50 50 0];

% Enter predicted results for example obstruction from Dunne et al. here 
% for comparison. These values have to be manually picked off Figures 1
% and 2 of Dunne. 

predL = 160.*1.06; % Effective attenuation length from Dunne, Fig 2
predS = 0.79; % Shielding factor at surface from Dunne, Fig 1

% Make sure generate_cosmic_rays works with horizon -- get plots
d.plotFlag = 1;
generate_cosmic_rays(numits,d);

% Now turn plotting off
d.plotFlag = 0; 

% Define input args for shielding_loop
in.fname = 'smallPyramid.mat';
in.thispoint = [0 0 0];
in.plotFlag = 0;
in.finalPlotFlag = 0;
in.rho = 2.65;
in.tpal = 208;

% Vector of depths
selvs = 0:0.1:1; % in meters

% Allocate
sfs = zeros(size(selvs));

% Start plot
figure;
px = 0:1:100; % linear
pxd = px.*in.rho;

% Plot predicted depth profile
py = predS*exp(-pxd./predL);
plot(pxd,py,'g'); hold on;

% Calculate Monte Carlo depth profile and plot
for c = 1:length(selvs);
    in.rays = generate_cosmic_rays(numits,d);
    disp(['starting ' int2str(c)]);
    in.selv = selvs(c);
    % Calculate
    sfs(c) = shielding_loop(in);
    % plot
    plot(selvs(c).*100.*in.rho,sfs(c),'ko','markerfacecolor','r');drawnow;
end;

axis([0 100*rho 0 1]);