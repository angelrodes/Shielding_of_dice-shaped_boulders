function shielding_control_window(action)

% This script provides the graphical user interface for Monte Carlo
% integration shielding calculations. 
%
% Greg Balco
% Berkeley Geochronology Center
% 2011-2012
%
% This version checked Feb 2012.
%
% This file is for use in the course of reviewing an accompanying paper
% ('Simple computer code for estimating cosmic-ray shielding by oddly
% shaped objects', submitted to Quaternary Geochronology). It is not
% licensed for use for any other purpose. 

if nargin < 1;
        
    % Case create a new figure

    close all; % wipe out existing figures
    
    % create figure; set global appearance params
    f = figure;
    bgc = [0.8 0.8 0.8];
    fc = [0.6 0.6 0.8];
    set(f,'color',fc);
    set(f,'tag','main');

    set(f,'pos',[ 350   490   640   530]);
    set(f,'name','Geometric shielding - Monte Carlo integration');
    
    % -------- HEADER - TITLE AND RESET BUTTON -----
    
    text0 = uicontrol('style','text','pos',[20 495 400 25],...
        'string','Geometric shielding -- Monte Carlo integration',...
        'fontsize',14,'backgroundcolor',fc,...
        'horizontalalignment','left');
    
    button0 = uicontrol('style','pushbutton','pos',[520 500 100 25],...
        'string','1. Reset','callback','shielding_control_window(''reset'')',...
        'backgroundcolor',fc);
    
    
    % ----- TOP ROW - SHAPE FILE OPEN -----------
    
    box12 = uicontrol('style','frame','pos',[5 430 630 65],...
        'backgroundcolor',bgc);

    text11 = uicontrol('style','text','pos',[15 460 75 20],...
        'fontsize',10,'string','2. Shape file:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    text12 = uicontrol('style','text','pos',[95 440 410 40],...
        'fontsize',10,'string','--',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag','text_fname');
    
    button1 = uicontrol('style','pushbutton','pos',[520 463 100 25],...
        'string','Choose file','callback','shielding_control_window(''file_open'')',...
        'backgroundcolor',bgc);
    
    % -------------------------------------------
    
    % ----- ROW 2 -- PLOT FILE BUTTON -----------
    
    button2 = uicontrol('style','pushbutton','pos',[520 433 100 25],...
        'string','3D plot','callback','shielding_control_window(''shape_plot'')',...
        'backgroundcolor',bgc);
    
    % -------------------------------------------
    
    % ------ ROW 3 - LOAD SAMPLE LOCATIONS ------
    
    box34 = uicontrol('style','frame','pos',[5 360 630 65],...
        'backgroundcolor',bgc);
    
    text31 = uicontrol('style','text','pos',[15 395 85 20],...
        'fontsize',10,'string','3. Samples file:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    text32 = uicontrol('style','text','pos',[105 375 420 40],...
        'fontsize',10,'string','--',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag','text_samples_fname');
    
    button3 = uicontrol('style','pushbutton','pos',[520 393 100 25],...
        'string','Choose file','callback','shielding_control_window(''sample_file_open'')',...
        'backgroundcolor',bgc);
    
    % ------------------------------------------
    
    % ------ ROW 4 - PLOT SAMPLE LOCATIONS ------
    
    button4 = uicontrol('style','pushbutton','pos',[520 363 100 25],...
        'string','Plot','callback','shielding_control_window(''sample_plot'')',...
        'backgroundcolor',bgc);    
   
    % ------------------------------------------
    
    % ------ ROW 5 -- RUN ONCE INFO --------------
    
    box56 = uicontrol('style','frame','pos',[5 290 630 65],...
        'backgroundcolor',bgc);
    
    text51 = uicontrol('style','text','pos',[15 320 205 20],...
        'fontsize',10,'string','4. Run one shielding calculation  for',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    menu5 = uicontrol('style','popupmenu','pos',[220 320 120 25],...
       'string','-- | --','backgroundcolor',bgc,...
       'tag','sample_menu_run_one');
   
   check51 = uicontrol('style','checkbox','pos',[360 325 20 20],...
       'tag','soil_check_run_one','backgroundcolor',bgc);
   
   text52 = uicontrol('style','text','pos',[385 320 130 20],...
       'backgroundcolor',bgc,...
       'horizontalalignment','left','string','Soil? Enter Z coord:');
   
   input51 = uicontrol('style','edit','pos',[520 325 100 25],...
       'backgroundcolor',bgc,'tag','soil_Z_input_run_one',...
       'string','0');
   
   % ----------------------------------------
   
   % ------------- ROW 6 - RUN ONCE BUTTON ----
   
   button6 = uicontrol('style','pushbutton','pos',[520 298 100 25],...
        'string','Run once','callback','shielding_control_window(''run_once'')',...
        'backgroundcolor',bgc);
   
   % ----------------------------------------
   
   % ------ ROW 7 -- RUN MANY INFO --------------
    
    box78 = uicontrol('style','frame','pos',[5 220 630 65],...
        'backgroundcolor',bgc);
    
    text71 = uicontrol('style','text','pos',[15 250 205 20],...
        'fontsize',10,'string','5. Run a series of soil depths for',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    menu7 = uicontrol('style','popupmenu','pos',[220 250 120 25],...
       'string','-- | --','backgroundcolor',bgc,...
       'tag','sample_menu_run_many');
   
   text72 = uicontrol('style','text','pos',[385 250 130 20],...
       'backgroundcolor',bgc,...
       'horizontalalignment','left','string','Max soil Z coord (m):');
   
   input71 = uicontrol('style','edit','pos',[520 255 100 25],...
       'backgroundcolor',bgc,'tag','soil_Z_input_run_many',...
       'string','0');
   
   % ----------------------------------------
   
   % ------------- ROW 8 - RUN MANY BUTTON ----
   
   button8 = uicontrol('style','pushbutton','pos',[520 228 100 25],...
        'string','Run','callback','shielding_control_window(''run_many'')',...
        'backgroundcolor',bgc);
   
   % ----------------------------------------
   
   % ------------- ROW 9 - CONTROL STUFF ----
   
   box9 = uicontrol('style','frame','pos',[5 5 630 210],...
        'backgroundcolor',bgc);
   
   text91 = uicontrol('style','text','pos',[20 182 300 20],...
       'fontsize',10,'string','6. Monte Carlo routine control parameters:',...
       'backgroundcolor',bgc,'horizontalalignment','left');
   
   % ---------------------------------------
   
   % ------------- ROW 10 - NUMITS ---------
   
   text101 = uicontrol('style','text','pos',[50 160 300 20],...
       'fontsize',10,'string','6.1. Number of iterations:',...
       'backgroundcolor',bgc,'horizontalalignment','left');
   
   input101 = uicontrol('style','edit','pos',[520 165 100 25],...
       'backgroundcolor',bgc,'tag','numits_input',...
       'string','1000');
   
    % ---------------------------------------
     
    % ------------- ROW 11 - DENSITY ---------
   
    text111 = uicontrol('style','text','pos',[50 135 300 20],...
       'fontsize',10,'string','6.2. Density (g/cm3):',...
       'backgroundcolor',bgc,'horizontalalignment','left');
   
    input111 = uicontrol('style','edit','pos',[520 140 100 25],...
       'backgroundcolor',bgc,'tag','rho_input',...
       'string','2.65');
   
    % ---------------------------------------
    
    % ------------- ROW 12 - T.P.A.L. ---------
   
    text121 = uicontrol('style','text','pos',[50 110 300 20],...
       'fontsize',10,'string','6.3. Particle attenuation length (g/cm2):',...
       'backgroundcolor',bgc,'horizontalalignment','left');
   
    input121 = uicontrol('style','edit','pos',[520 115 100 25],...
       'backgroundcolor',bgc,'tag','tpal_input',...
       'string','208');
   
    % ---------------------------------------
    
    % ------------- ROWS 13-15 - CHECKBOXES ---------
   
    text131 = uicontrol('style','text','pos',[80 85 200 20],...
       'fontsize',10,'string','6.4. Continuous plotting',...
       'backgroundcolor',bgc,'horizontalalignment','left');
   
    check131 = uicontrol('style','checkbox','pos',[50 90 20 20],...
       'backgroundcolor',bgc,'tag','check_plotFlag');
   
    text132 = uicontrol('style','text','pos',[350 85 200 20],...
       'fontsize',10,'string','6.5. Final plotting',...
       'backgroundcolor',bgc,'horizontalalignment','left');
   
    check132 = uicontrol('style','checkbox','pos',[320 90 20 20],...
       'backgroundcolor',bgc,'tag','check_finalPlotFlag','value',1);
   
    text141 = uicontrol('style','text','pos',[80 60 400 20],...
       'fontsize',10,'string','6.6. Diagnostic plots for incidence direction sample',...
       'backgroundcolor',bgc,'horizontalalignment','left');
   
    check141 = uicontrol('style','checkbox','pos',[50 65 20 20],...
       'backgroundcolor',bgc,'tag','check_rays_plotFlag',...
       'value',0);
   
    text151 = uicontrol('style','text','pos',[80 35 400 20],...
       'fontsize',10,'string','6.7. Warning on even number of intersections',...
       'backgroundcolor',bgc,'horizontalalignment','left');
   
    check151 = uicontrol('style','checkbox','pos',[50 40 20 20],...
       'backgroundcolor',bgc,'tag','check_evenMessage',...
       'value',1);
   
    % ---------------------------------------
    
    % --- ROW 16 -- SHIELDING FILE ----------
    
    check161 = uicontrol('style','checkbox','pos',[20 15 20 20],...
       'backgroundcolor',bgc,'tag','check_horizon_file',...
       'value',0);
    
    text161 = uicontrol('style','text','pos',[45 10 90 20],...
        'fontsize',10,'string','6.8. Horizon file:',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left');
    
    text162 = uicontrol('style','text','pos',[140 10 380 20],...
        'fontsize',10,'string','--',...
        'backgroundcolor',bgc,...
        'horizontalalignment','left','tag','text_farfield_fname');
    
    button16 = uicontrol('style','pushbutton','pos',[520 12 100 25],...
        'string','Choose file','callback','shielding_control_window(''farfield_file_open'')',...
        'backgroundcolor',bgc);
    
    % ------------------------------------
    
    % -------- SET TO RELATIVE UNITS -----
    
    set(findobj('parent',gcf),'units','normalized');
    
    
    % ----------- BEGIN CALLBACKS ----------
    
    
elseif strcmp(action,'file_open');
    % Choose shape file and put file name in appropriate place
    [fname,pname] = uigetfile('*.mat;*.stl');
    fullname = [pname fname];
    set(findobj('tag','text_fname'),'string',fullname);
    
elseif strcmp(action,'farfield_file_open');
    % Choose shape file and put file name in appropriate place
    [fname,pname] = uigetfile('*.*');
    fullname = [pname fname];
    set(findobj('tag','text_farfield_fname'),'string',fullname);
    
elseif strcmp(action,'shape_plot');
    % Plot the shape file
    % First check to see if there is a file
    fname = get(findobj('tag','text_fname'),'string')
    if exist(fname,'file');
        % Read in shape
        if strcmp(fname((end-3):end),'.mat');
            disp('Reading .mat-file');
            eval(['load ' fname]);
%             facetsRaw = poligons;
        elseif strcmp(fname((end-3):end),'.stl');
            disp('Reading .stl file');
            facetsRaw = readstl(fname);
        end;
        % Plot 
        plotFacets(facetsRaw);
        set(findobj('tag','3D_plot_window'),'name',fname);
        
    else
        set(findobj('tag','text_fname'),'string','No file found. Choose again.');
    end;
           
elseif strcmp(action,'sample_file_open');
    % Choose sample file and put file name in appropriate place
    [fname,pname] = uigetfile('*.dat;*.txt;*.csv');
    fullname = [pname fname];
    set(findobj('tag','text_samples_fname'),'string',fullname);
    
    % Also load sample file into window
    loadSamples(fullname);
    
elseif strcmp(action,'sample_plot');
    % Plot samples on 3d figure
    % Check for figure
    if isempty(findobj('tag','3D_plot_window'));
        % No window, create
        shielding_control_window('shape_plot');
        figure(findobj('tag','3D_plot_window'));
    end;
    plotSamples;
    
elseif strcmp(action,'new_sample_file');
    % Read data from sample window and save to a new file
    a = 1;
    data = [];
    while 1;
        % Read x,y,z
        if isempty(findobj('tag',['X_input_' int2str(a)]));
            break;
        else
            data(a,1) = str2num(get(findobj('tag',['X_input_' int2str(a)]),'string'));
            data(a,2) = str2num(get(findobj('tag',['Y_input_' int2str(a)]),'string'));
            data(a,3) = str2num(get(findobj('tag',['Z_input_' int2str(a)]),'string'));
        end;
        a = a+1;
    end;
    [fname,pname] = uiputfile('*.*');
    csvwrite([pname fname],data);
        
        
    
elseif strcmp(action,'run_once');
    % Do one shielding calculation
    
    % Run generate_cosmic_rays
    horizFlag = get(findobj('tag','check_horizon_file'),'value');
    if horizFlag;
        hfname = get(findobj('tag','text_farfield_fname'),'string');
        d = unpackHorizonFile(hfname);
    end;
    numits = str2num(get(findobj('tag','numits_input'),'string'));
    d.plotFlag = get(findobj('tag','check_rays_plotFlag'),'value');
    
    in.rays = generate_cosmic_rays(numits,d);
    
    % Assemble other data 
    
    in.fname = get(findobj('tag','text_fname'),'string');
    snum = get(findobj('tag','sample_menu_run_one'),'value');
    x = str2num(get(findobj('tag',['X_input_' int2str(snum)]),'string'));
    y = str2num(get(findobj('tag',['Y_input_' int2str(snum)]),'string'));
    z = str2num(get(findobj('tag',['Z_input_' int2str(snum)]),'string'));
    in.thispoint = [x y z];
    
    in.plotFlag = get(findobj('tag','check_plotFlag'),'value');
    in.finalPlotFlag = get(findobj('tag','check_finalPlotFlag'),'value');
    in.rho = str2num(get(findobj('tag','rho_input'),'string'));
    in.tpal = str2num(get(findobj('tag','tpal_input'),'string'));
    in.evenMessage = get(findobj('tag','check_evenMessage'),'value');
    
    soilFlag = 0;
    if get(findobj('tag','soil_check_run_one'),'value');
        soilFlag = 1;
        in.selv = str2num(get(findobj('tag','soil_Z_input_run_one'),'string'));
    end;

    % run shielding_loop
    
    out = shielding_loop(in);
   
    % report to command window
    if soilFlag;
        s1 = ['Sample ' int2str(snum) '; soil elevation ' sprintf('%0.2f',in.selv) ': ' sprintf('%0.4f',out')];
    else;
        s1 = ['Sample ' int2str(snum) ': ' sprintf('%0.4f',out)];
    end;
    disp(s1);
    
    
elseif strcmp(action,'run_many');
    % Run a series of shielding calcs at multiple depths
    % Remember to check plot flags inside loop so can be turned off during
    % run; however everything else checks in at start of loop.
    
    % Assemble static data 
    
    % Shape file
    in.fname = get(findobj('tag','text_fname'),'string');
    
    % Sample position
    snum = get(findobj('tag','sample_menu_run_many'),'value');
    x = str2num(get(findobj('tag',['X_input_' int2str(snum)]),'string'));
    y = str2num(get(findobj('tag',['Y_input_' int2str(snum)]),'string'));
    z = str2num(get(findobj('tag',['Z_input_' int2str(snum)]),'string'));
    in.thispoint = [x y z];
    
    % Static parameters
    in.rho = str2num(get(findobj('tag','rho_input'),'string'));
    in.tpal = str2num(get(findobj('tag','tpal_input'),'string'));
    
    % decide on soil depths 
    maxz = str2num(get(findobj('tag','soil_Z_input_run_many'),'string'));
    
    % Number of intermediate depths to compute
    np = ceil((maxz-z)./0.1); % About every 10 cm
    if np < 5; np = 5; end; % Not less than 5
   
    % Soil depths
    ss = linspace(z,maxz,np);
    
    % begin loop
    
    nr = length(ss);
    sfs = zeros(1,nr);
    
    disp('Starting');
    
    for a = 1:nr;
        % Assign plot flags; checked inside loop so you can turn them off
        in.plotFlag = get(findobj('tag','check_plotFlag'),'value');
        in.finalPlotFlag = get(findobj('tag','check_finalPlotFlag'),'value');
        in.evenMessage = get(findobj('tag','check_evenMessage'),'value');
        
        % Run generate_cosmic_rays
        horizFlag = get(findobj('tag','check_horizon_file'),'value');
        if horizFlag;
            hfname = get(findobj('tag','text_farfield_fname'),'string');
            d = unpackHorizonFile(hfname);
        end;
        numits = str2num(get(findobj('tag','numits_input'),'string'));
        d.plotFlag = get(findobj('tag','check_rays_plotFlag'),'value');
        in.rays = generate_cosmic_rays(numits,d);
        
        % Set soil depth
        if a == 1;
            % Make sure no soil first step
            in.selv = z-0.1;
        else;
            in.selv = ss(a);
        end;
        
        % Run shielding calculation
        sfs(a) = shielding_loop(in);
        % Write to command window
        disp(['Soil z: ' sprintf('%0.2f',ss(a)) '; shielding factor: ' sprintf('%0.4f',sfs(a))]);
           
    end;
    
    % Do exponential fit
    
    xx = (ss-z).*100.*in.rho; % Depth in g/cm2
    yy = log(sfs); % Log of shielding factor
    p = polyfit(xx,yy,1);
    S0i = exp(p(2));
    Li = -1./p(1);
    
    % Report
    
    disp(' ----------------- ');
    rstr = ['Sample ' int2str(snum) ': '];
    rstr = [rstr 'S_0_i = ' sprintf('%0.3f',S0i) ' '];
    rstr = [rstr 'L_i = ' sprintf('%0.1f',Li) ' g cm-2'];
    disp(rstr);
    disp(' ----------------- ');
    disp('SoilThickness(m) SoilThickness(g/cm2) ShieldingFactor');
    for a = 1:length(xx);
        rrstr = [sprintf('%0.2f',(ss(a)-z)) ' ' sprintf('%0.2f',xx(a)) ' ' sprintf('%0.4f',sfs(a))];
        disp(rrstr);
    end;
    disp(' ----------------- ');
    
    % Plot results
    
    figure; plot(xx,sfs,'go');
    hold on; plot(xx,S0i.*exp(-xx./Li),'r');
    xlabel('Mass thickness of soil above sample elevation (g cm^{-2})');
    ylabel('Shielding factor');
    title(rstr);
    
    % also plot standard attenuation from one
    plot(xx,exp(-xx./160),'b:');
    set(gca,'ylim',[0 1]);
    
    
elseif strcmp(action,'reset');
    
    % Clear all windows and file names, reset defaults
    ws = get(0,'children');
    for a = 1:length(ws);
        if strcmp(get(ws(a),'tag'),'main');
            % do nothing
        else
            close(ws(a));
        end;
    end;
    
    set(findobj('tag','text_fname'),'string','--');
    set(findobj('tag','text_samples_fname'),'string','--');
    set(findobj('tag','sample_menu_run_one'),'string','-- | --','value',1);
    set(findobj('tag','sample_menu_run_many'),'string','-- | --','value',1);
    set(findobj('tag','soil_Z_input_run_one'),'string','0');
    set(findobj('tag','soil_Z_input_run_many'),'string','0');
    set(findobj('tag','soil_check_run_one'),'value',0);
    set(findobj('tag','numits_input'),'string','1000');
    set(findobj('tag','rho_input'),'string','2.65');
    set(findobj('tag','tpal_input'),'string','208');
    set(findobj('tag','check_plotFlag'),'value',0);
    set(findobj('tag','check_finalPlotFlag'),'value',1);
    set(findobj('tag','check_rays_plotFlag'),'value',0);
    set(findobj('tag','check_evenMessage'),'value',1);
    set(findobj('tag','check_horizon_file'),'value',0);
    set(findobj('tag','text_farfield_fname'),'string','--');       
    
end;
