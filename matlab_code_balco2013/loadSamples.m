function out = loadSamples(fname);

% This function loads a sample data file (in .csv form) and creates a 
% window with sample information. It is part of the graphical user
% interface to the Monte Carlo integration shielding calculation. 
%
% Syntax: out = loadSamples(fname);
%
% fname is a string with the name of the sample data file. 
% 
% The sample data file is a csv text file containing a line with x,y,z
% coordinates for each sample.
%
% The output argument is not used. 
%
% Greg Balco
% Berkeley Geochronology Center
% February, 2012
%
% This file is for use in the course of reviewing an accompanying paper
% ('Simple computer code for estimating cosmic-ray shielding by oddly
% shaped objects', submitted to Quaternary Geochronology). It is not
% licensed for use for any other purpose. 


% Load file
d = csvread(fname);

% How many samples?       
ns = size(d,1);


% Check for existing figure
if ~isempty(findobj('tag','samples_window'));
    close(findobj('tag','samples_window'));
end;

% New figure

f = figure;
set(f,'tag','samples_window');
bgc = get(f,'color');
rht = 25;
fht = (ns*rht)+20+25; % one extra line for 'save' button
set(f,'pos',[400 400 640 fht]);

col1 = zeros(ns,1);
inputX = zeros(ns,1);
inputY = inputX;
inputZ = inputX;
colX = inputX;
colY = inputY;
colZ = inputZ;
buttons = inputZ;

mstring = '';

set(f,'name',fname);

% Fill figure with stuff
for a = 1:ns;
    col1(a) = uicontrol('style','text','pos',[10 fht-5-rht*a 100 20],...
        'fontsize',10,'string',['Sample ' int2str(a) ':'],...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag',['sample_text_' int2str(a)]);
    
    colX(a) = uicontrol('style','text','pos',[115 fht-5-rht*a 20 20],...
        'fontsize',10,'string','X:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag',['X_text_' int2str(a)]);    
    
    colY(a) = uicontrol('style','text','pos',[255 fht-5-rht*a 20 20],...
        'fontsize',10,'string','Y:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag',['Y_text_' int2str(a)]);
    
	colZ(a) = uicontrol('style','text','pos',[395 fht-5-rht*a 20 20],...
        'fontsize',10,'string','Z:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag',['Z_text_' int2str(a)]);
    
    inputX(a) = uicontrol('style','edit','pos',[135 fht-2-rht*a 100 25],...
        'string',sprintf('%0.3f',d(a,1)),...
        'backgroundcolor',bgc,...
        'tag',['X_input_' int2str(a)]);
    
    inputY(a) = uicontrol('style','edit','pos',[275 fht-2-rht*a 100 25],...
        'string',sprintf('%0.3f',d(a,2)),...
        'backgroundcolor',bgc,...
        'tag',['Y_input_' int2str(a)]);
    
    inputZ(a) = uicontrol('style','edit','pos',[415 fht-2-rht*a 100 25],...
        'string',sprintf('%0.3f',d(a,3)),...
        'backgroundcolor',bgc,...
        'tag',['Z_input_' int2str(a)]);
    
    buttons(a) = uicontrol('style','pushbutton','pos',[525 fht-2-rht*a 100 25],...
        'string','Check position',...
        'backgroundcolor',bgc,...
        'callback',['check_position(' int2str(a) ');']);
    
    mstring = [mstring ' sample ' int2str(a) ' |'];
    
end;

saveButton = uicontrol('style','pushbutton','pos',[220 10 200 25],...
        'string','Save to new file',...
        'backgroundcolor',bgc,...
        'callback','shielding_control_window(''new_sample_file'')');
    
set(findobj('parent',gcf),'units','normalized');
    
mstring = mstring(1:(end-1));
set(findobj('tag','sample_menu_run_one'),'string',mstring);
set(findobj('tag','sample_menu_run_many'),'string',mstring);
    
    


  