function out = plotSamples();

% This function is part of the graphical user interface for Monte Carlo 
% integration of cosmic-ray shielding calculations. It reads sample data 
% out of the "samples" window and plots it on the 3D plot window. 
%
% Has no arguments.
%
% Greg Balco
% Berkeley Geochronology Center
% Checked and edited April 2012
%
% This file is for use in the course of reviewing an accompanying paper
% ('Simple computer code for estimating cosmic-ray shielding by oddly
% shaped objects', submitted to Quaternary Geochronology). It is not
% licensed for use for any other purpose. 

% Find figure

f = findobj('tag','3D_plot_window');
figure(f);

hold on;

delete(findobj('tag','sample_point'));

% Get sample data

a = 1;
data = [];
while 1;
    % Read x,y,z
    if isempty(findobj('tag',['X_input_' int2str(a)]));
        break;
    else;
        data(a,1) = str2num(get(findobj('tag',['X_input_' int2str(a)]),'string'));
        data(a,2) = str2num(get(findobj('tag',['Y_input_' int2str(a)]),'string'));
        data(a,3) = str2num(get(findobj('tag',['Z_input_' int2str(a)]),'string'));
    end;
    a = a+1;
end;

ns = a-1;

% Now plot samples

for a = 1:ns;
    plot3(data(a,1),data(a,2),data(a,3),'r.','tag','sample_point');
    text(data(a,1)+0.05,data(a,2)+0.05,data(a,3)+0.05,int2str(a));
end;

set(findobj('tag','sample_point'),'marker','o','markerfacecolor','b','markersize',10)