clear
close all hidden
sizes=[0.1 0.2:0.2:3 3.5:0.5:6 8 10];  % m

%% generate cubes

for side=sizes
% for side=0.1
    L=side; % m
    
    front=[...
        0 0 0 L 0 0 0 0 L;
        L 0 0 0 0 L L 0 L];
    left=[...
        0 0 0 0 L 0 0 L L;
        0 0 0 0 0 L 0 L L];
    right=[...
        L 0 0 L L 0 L L L;
        L 0 0 L 0 L L L L];
    back=[...
        0 L 0 L L 0 0 L L;
        L L 0 0 L L L L L];
    top=[...
        0 0 L 0 L L L 0 L;
        0 L L L 0 L L L L];
    bottom=[...
        0 0 0 0 L 0 L 0 0;
        0 L 0 L 0 0 L L 0];
    
    polygons=[front;left;right;back;top];
    
    % samples: top, side, side, side, side, bottom (1 cm form cube surface)
    depth_sample=0.0001;
    samples=[...
        L/2 L/2 L-depth_sample;
        L/2 0+depth_sample L/2;
        0+depth_sample L/2 L/2;
        L-depth_sample L/2 L/2;
        L/2 L-depth_sample L/2;
        L/2 L/2 0+depth_sample];
    

%     Plot3D(polygons,samples)
%     xlabel('x')
%     ylabel('y')
%     zlabel('z')
    
    FileName=['Cube_side_' num2str(side*100) '_cm'];
    filestr=strcat(FileName,'.mat');
    save(filestr,'polygons', 'samples')
end

%% get shielding
% to be used with Balco's code
% warning ('off','all')

iteration=0;
cr=generate_cosmic_rays(3000);
in.rho=2.65;
in.tpal=208;

for side=sizes
    FileName=['Cube_side_' num2str(side*100) '_cm.mat'];
    load(FileName); % define polygons and samples
    for sample=1:size(samples,1)
        samplename=['Cube_side_' char(9) num2str(side*100) char(9) '_cm_sample_' char(9) num2str(sample)];
        in.fname=FileName;
        in.thispoint=samples(sample,:);
        in.rays=cr;
        out = shielding_loop(in); % calculate shielding
        disp([samplename char(9) num2str(out)])
        iteration=iteration+1;
        solution.side(iteration)=side;
        solution.sample(iteration)=sample;
        solution.shielding(iteration)=out;
    end
end

save('solution.mat','solution')

%% calculate furmalae

load('solution.mat')

scale=solution.shielding(1);

% interpret sides
sel=solution.sample>1 & solution.sample<6;
x=solution.side(sel);
y=solution.shielding(sel)/scale;
% side formula: y=0.5+0.5)*exp(-x*a)
b=0.5;
a=median(log((y-b)/(1-b))./(-x));

figure
hold on
title('side')
xlabel('size (m)')
ylabel('shielding factor')
plot(x,y,'.k')
ymodel=b+(1-b)*exp(-x*a);
plot(x,ymodel,'-r')
text(mean(x), mean(ymodel),...
    ['y=' num2str(b) '+' num2str((1-b)) '*exp(-x*' num2str(a) ')'],...
    'Color','r')
disp(['y=' num2str(b) '+' num2str((1-b)) '*exp(-x*' num2str(a) ')'])
% get attenuation multiplyer k
k=in.rho*100/in.tpal/a/2;
disp(['y=' num2str(b) '+' num2str((1-b)) '*exp(-z*' num2str(in.rho) '/(2*' num2str(in.tpal) '*' num2str(k) '))'])


% interpret bottom
sel=solution.sample==6;
x=solution.side(sel);
y=solution.shielding(sel)/scale;
% side formula: y=b+(1-b)*exp(-x*a)
b=0;
a=median(log((y-b)/(1-b))./(-x));

figure
hold on
title('bottom')
xlabel('size (m)')
ylabel('shielding factor')
plot(x,y,'.k')
ymodel=b+(1-b)*exp(-x*a);
plot(x,ymodel,'-r')
text(mean(x), mean(ymodel),...
    ['y=' num2str(b) '+' num2str((1-b)) '*exp(-x*' num2str(a) ')'],...
    'Color','r')
disp(['y=' num2str(b) '+' num2str((1-b)) '*exp(-x*' num2str(a) ')'])

% get attenuation multiplyer k
k=in.rho*100/in.tpal/a;
disp(['y=' num2str(b) '+' num2str((1-b)) '*exp(-z*' num2str(in.rho) '/(' num2str(in.tpal) '*' num2str(k) '))'])
