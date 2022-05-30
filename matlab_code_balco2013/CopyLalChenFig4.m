% This code duplicates part of Figure 4 of Lal and Chen, 2005 (EPSL, v. 
% 236, p. 797), which describes variations in cosmogenic-nuclide production
% within a spherical boulder. 
%
% It then does the same calculation using the Monte Carlo shielding model 
% as a validation exercise. 
%
% This generates Figure 4 of an accompanying paper, 'Simple computer code
% for estimating cosmic-ray shielding by oddly shaped objects.'
%
% Note that the functions integrated here (that execute Equations 5 and 6
% of Lal and Chen) have been modified to have the same true particle atten-
% uation length as is used in the Monte Carlo code, i.e., 208 g/cm2. It
% appears that Lal and Chen used a value of 160 g/cm2. 
%
% Greg Balco
% Berkeley Geochronology Center
% November, 2011
%

%% clean up

clear all; close all;

%% Analytical solutions and plotting

% Define radius of boulder
R = 1.5; % meters

% Create vector of positions at which to compute shielding
a = linspace(0,R,40); % meters

sfTop = zeros(size(a));
sfSide = sfTop;

% Compute analytical solutions (actually by numerical integration, for 
% simplicity, which is not quite fair)

for b = 1:length(a);
    sfTop(b) = dblquad(@(theta,phi) LalChenSphereVert(theta,phi,a(b),R),0,pi/2,0,2*pi);
    sfSide(b) = dblquad(@(theta,phi) LalChenSphereSide(theta,phi,a(b),R),0,pi/2,0,2*pi);
end;

% Plot results

figure(1);

% Normalize to production rate at top of boulder; this gives shielding
% factor
normTo = max(sfTop);

plot(R-a,sfTop./normTo,'g',R-a,sfSide./normTo,'r');
%set(gca,'yscale','log')
%axis([0 5 1e-4 5]);
grid on;
title(['R = ' sprintf('%0.1f',R) ' m']);
xlabel('Distance from center of sphere (m)');
ylabel('Shielding factor');
hold on;
axis([0 R 0 1]);
drawnow;

%% Next, use the Monte Carlo integration scheme to do the same thing. 

% Load shape file

% Now load the faceted unit hemisphere and scale it to whatever R is. 
% Note: this file should have been generated with create_upper_hemisphere.m
% if not, run it

if exist('upperHemisphere.mat','file');
    % do nothing
else;
    create_upper_hemisphere;
end;


load upperHemisphere
facetsRaw = facetsRaw*R;
save upperHemisphereScaled facetsRaw;

%% First, do numerical calculations for points on horizontal radius
% Define points along a horizontal radius

z = 0;
y = 0;
x = linspace(0,R.*0.97,8);

sfSideNumerical = zeros(size(x));

for c = 1:length(x);
    disp(['starting ' int2str(c)]);
    % Run generate_cosmic_rays
    horizFlag = 0;
    numits = 1000;
    d.plotFlag = 0;
    
    in.rays = generate_cosmic_rays(numits,d);
    
    % Assemble other data 
    
    in.fname = 'upperHemisphereScaled.mat';
    in.thispoint = [x(c) y z];
    
    in.plotFlag = 0;
    in.finalPlotFlag = 0;
    in.rho = 2.65;
    in.tpal = 208;


    % run shielding_loop
    sfSideNumerical(c) = shielding_loop(in);
    % plot
    figure(1);
    plot(x(c),sfSideNumerical(c),'ko','markerfacecolor','r');drawnow;
end;



%% Second, do numerical calculations for points on vertical radius
% Define points along a vertical radius

x = 0;
y = 0;
z = linspace(0,R.*0.97,8);

sfVertNumerical = zeros(size(z));

for c = 1:length(z);
    disp(['starting ' int2str(c)]);
    % Run generate_cosmic_rays
    horizFlag = 0;
    numits = 1000;
    d.plotFlag = 0;
    
    in.rays = generate_cosmic_rays(numits,d);
    
    % Assemble other data 
    
    in.fname = 'upperHemisphereScaled.mat';
    in.thispoint = [x y z(c)];
    
    in.plotFlag = 0;
    in.finalPlotFlag = 0;
    in.rho = 2.65;
    in.tpal = 208;


    % run shielding_loop
    sfVertNumerical(c) = shielding_loop(in);
    % plot
    figure(1);
    plot(z(c),sfVertNumerical(c),'ko','markerfacecolor','g');drawnow;
end;



