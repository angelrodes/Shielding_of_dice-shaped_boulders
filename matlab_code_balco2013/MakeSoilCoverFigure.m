% This script makes Figure 7 in 'Simple computer code for estimating
% cosmic-ray shielding by irregularly shaped objects.' 

clear all; close all; 

% preprocess input .stl file for better speed
facetsRaw = readstl('gv01_everything.stl');
save gv01_everything.mat facetsRaw;

% Set up input structure

% Define input args for shielding_loop
in.fname = 'gv01_everything.mat';
in.thispoint = [-5.125 -3.467 -0.322];
in.plotFlag = 0;
in.finalPlotFlag = 0;
in.rho = 2.65;

% Create vector of soil z-coordinates
% sample is 1.69 m below PBR top, so we want to calculate shielding 
% factors over a range of soil elevations from 0 to 1.69 m above the 
% sample elevation. 

selvs = linspace(in.thispoint(3),in.thispoint(3)+1.69,10); % sample is 1.69 m below PBR top

% Allocate
sfs = zeros(size(selvs));

% Start plot
figure;
px = linspace(0,169,100); % in cm
pxd = px.*in.rho;

% Plot standard depth profile for no shielding, 160 g/cm2
ps = exp(-pxd./160);
plot(px,ps,'r'); hold on;

axis([0 180 0 1]);
xlabel('Soil thickness above sample (cm)');
ylabel('Shielding factor'); drawnow;

% How many iterations
numits=1000;

% Use Monte Carlo integration code to compute shielding factors for
% successively increasing soil thicknesses; plot them

for c = 1:length(selvs);
    % Generate random sample of cosmic ray incidence directions
    in.rays = generate_cosmic_rays(numits);
    disp(['starting ' int2str(c)]);
    % Set soil surface elevation
    in.selv = selvs(c);
    % Calculate shielding factor
    sfs(c) = shielding_loop(in);
    % plot soil thickness (not z-coord) vs. shielding factor
    plot((selvs(c)-in.thispoint(3)).*100,sfs(c),'ko','markerfacecolor','r');drawnow;
end;

% Now fit exponential profile to calculated shielding factors and plot

fitx = (selvs-in.thispoint(3)).*100.*in.rho; % g cm-2
fity = log(sfs);

p1 = polyfit(fitx,fity,1);
S0 = exp(p1(2));
L = -1/p1(1);

ps2 = S0.*exp(-pxd./L);
plot(px,ps2,'r');

% Report parameters of exponential fit
title(['S0 = ' sprintf('%0.2f',S0) '; L = ' sprintf('%0.1f',L) ' g/cm2']);




