function out = check_position(a);

% This function is part of the graphical user interface to the Monte Carlo
% integration shielding calculation. It plots a horizontal slice through a
% volume to aid in determining whether or not a sample is within a PBR. 
%
% Syntax: out = check_position(a);
%
% Input argument a is the number of the sample to plot -- this code looks
% at the 'samples' window to obtain the sample location. 
%
% Output argument out returns the handle to the figure generated. 
%
% Greg Balco
% Berkeley Geochronology Center
% February, 2012
%
% 
% This file is for use in the course of reviewing an accompanying paper
% ('Simple computer code for estimating cosmic-ray shielding by oddly
% shaped objects', submitted to Quaternary Geochronology). It is not
% licensed for use for any other purpose. 


% This is a callback from the samples window, so don't bother to check that
% it exists

% Get shape file name

shape_fname = get(findobj('tag','text_fname'),'string');

% Read it in

% Read in a shape
if strcmp(shape_fname((end-3):end),'.stl');
    % Case stl file
    disp('Reading .stl file');
    facetsRaw = readstl(shape_fname);
elseif strcmp(shape_fname((end-3):end),'.mat');
    disp('Reading .mat file');
    eval(['load ' shape_fname])
%     facetsRaw = poligons;
end;

% Get sample info

sampleX = str2num(get(findobj('tag',['X_input_' int2str(a)]),'string'));
sampleY = str2num(get(findobj('tag',['Y_input_' int2str(a)]),'string'));
sampleZ = str2num(get(findobj('tag',['Z_input_' int2str(a)]),'string'))


d.plotRock = 0;
d.plotLevel = 1;
d.tryToSort = 0;


temp = waterline(facetsRaw,sampleZ,d);

f = findobj('tag','xy_waterline_window');
figure(f);
hold on; plot(sampleX, sampleY, 'ro','markerfacecolor','r');

out = f;


