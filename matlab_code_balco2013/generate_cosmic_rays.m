function out = generate_cosmic_rays(numits,d)

% This function generates random cosmic ray incidence directions for Monte
% Carlo integration. Distributed uniformly in azimuth and zenith angle.  
%
% There is also the option to include a far-field horizon below which no
% cosmic rays will be generated. This employs skyline.m from the online
% exposure age calculators. 
%
% Syntax = out = generate_cosmic_rays_b(numits,d);
%
% numits is the number of incidence directions desired
%
% d is an optional data structure that may or may not include several things:
%   d.plotFlag -- enter 1 to make diagnostic plots (default is 0, no plot)
%   d.az, d.el -- azimuth and elevation of farfield horizon. Permits total
%   exclusion of cosmic ray flux by far-field obstacles. See skyline.m for
%   input format details.
%   d.strike, d.dip -- strike and dip of far-field dipping surface. Again
%   see skyline.m for details. 
%
% The output argument has four fields: 
%   out.xyz represents incidence directions as vectors; has columns
%       [x y z] and number of rows equal to numits.
%   out.phi is a vector of length numits that contains corresponding 
%       zenith angles.
%   out.theta is a vector of length numits that contains corresponding 
%       azimuths.
%   out.ok is a vector of length numits that contains zero if the ray is
%       obstructed by a farfield horizon (if one was entered) and one if it
%       is not obstructed. If no horizon was entered, this contains all
%       ones. 
%
% The phi output argument is so one can later apply the zenith angle 
% intensity distribution -- I = cos^(alpha)(phi) where I is the intensity 
% of the cosmic ray flux from zenith angle phi. 
%
%
% Greg Balco
% Berkeley Geochronology Center
% 2009-2012
%
% This version checked Feb 7 2012
%
% This file is for use in the course of reviewing an accompanying paper
% ('Simple computer code for estimating cosmic-ray shielding by oddly
% shaped objects', submitted to Quaternary Geochronology). It is not
% licensed for use for any other purpose. 

% 0. Unpack, set defaults

plotFlag = 0; % default

if nargin > 1;
    if isfield(d,'plotFlag');
        plotFlag = d.plotFlag;
    end;
end;

hFlag = 0;
% If horizon data entered, use skyline.m to generate a composite horizon
if nargin > 1;
    if isfield(d,'az') && isfield(d,'el');
        if isfield(d,'strike') && isfield(d,'dip');
            % case all parameters for skyline.m
            [temp_cf,horiz,ver] = skyline(d.az,d.el,d.strike,d.dip);
            hFlag = 1;
        else
            % case just azimuth and elevation
            [temp_cf,horiz,ver] = skyline(d.az,d.el);
            hFlag = 1;
        end;
    else
        if isfield(d,'strike') && isfield(d,'dip');
            % Case just strike and dip
            [temp_cf,horiz,ver] = skyline([],[],d.strike,d.dip);
            hFlag = 1;
        end;
    end;
end;
% The result of that is a 361-element vector with horiz angle in degrees at
% each increment. 
% Convert to radians
if hFlag == 1;
    hx = (0:360).*2.*pi./360;
    hy = horiz.*2.*pi./360;
end;

% 1. Generate distribution of zenith angles

% phi is zenith angle
phi = [];theta = [];


% Generate numits random numbers between 0 and pi/2
phi = rand(numits,1).*pi./2;
    
% Generate same number of azimuths
% Uniform between 0 and 2*pi
theta = rand(size(phi)).*2.*pi;
    
% If horizon data entered, screen against horizon
if hFlag == 1;
    minH = interp1(hx,hy,theta);
    hAngle = pi./2 - phi;
    ok = (hAngle >= minH);
else;
    % If no horizon data entered, all rays admitted
    ok = ones(size(theta));
end;

% 3. Convert zenith angle and elevation into x,y,z

[x y z] = sph2cart(theta,(pi/2-phi),ones(size(theta)));

% 4. Diagnostic plots

if plotFlag == 1;
    
    if 0;
        % 4.a. Plot actual and expected frequency distributions
        if isempty(findobj('tag','r_freq_window'));
            % No figure exists; create one
            figure('tag','r_freq_window');
        else;
            figure(findobj('tag','r_freq_window'));
            clf;
        end;
        % Plot frequency distribution of results
        numbins = 10;
        edges = linspace(0,pi/2,numbins+1);
        bw = edges(2)-edges(1);
        c = histc(phi,edges);
        bar(edges.*180/pi,c,'histc');
        xlabel('Zenith angle phi (degrees)');
        ylabel('Frequency');
        set(gca,'xlim',[0 90]);
        set(gcf,'name','Zenith angle frequency distribution');
    end;
    
    
    % 4.b. Upper hemisphere dot-plot
    if isempty(findobj('tag','polar_plot_window'));
        % No figure exists; create one
        figure('tag','polar_plot_window');
    else;
        figure(findobj('tag','polar_plot_window'));
        clf;
    end;
    
    % Decide which to plot how
    plotMe = find(ok);
    noPlot = find(~ok);
  
    
    
    polar(theta(noPlot), cos(pi./2-phi(noPlot)),'r.'); hold on;
    polar(theta(plotMe), cos(pi./2-phi(plotMe)),'b.'); 
    set(gcf,'name','Upper hemisphere plot of ray distribution');
    
    % 4.c. Plot rays to check vectorization
    %figure; 
    %plot3(x,y,z,'r.'); hold on;
    %for a = 1:length(x);
    %    xx = [0 x(a)];yy = [0 y(a)];zz = [0 z(a)];
    %    plot3(xx,yy,zz); 
    %end;
    %grid on;  
    %xlabel('x'); ylabel('y'); zlabel('z');
    
    % 4.d. Check for correct horizon exclusions...
    if hFlag;
        if isempty(findobj('tag','horizon_window'));
        % No figure exists; create one
        figure('tag','horizon_window');
        else;
            figure(findobj('tag','horizon_window'));
            clf;
        end;
        plot(hx,hy,'r'); hold on;
        plot(theta(plotMe),pi/2-phi(plotMe),'b.');
        plot(theta(noPlot),pi/2-phi(noPlot),'r.');
        axis([0 2*pi 0 pi/2]);
        xlabel('Azimuth (degrees)');
        set(gca,'xtick',[0 pi/2 pi 3*pi/2 2*pi],'xticklabel',['  0'
            ' 90'
            '180'
            '270'
            '360']);
        ylabel('Horizon angle (degrees)');
        set(gca,'ytick',[0 pi/6 pi/3 pi/2],'yticklabel',[' 0'
            '30'
            '60'
            '90']);
        set(gcf,'name','Horizon plot');
        
    end;
    
end;

% 5. Return;

out.xyz = [x y z];
out.phi = phi;
out.theta = theta;
out.ok = ok;

