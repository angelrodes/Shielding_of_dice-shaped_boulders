clear
close all hidden

load('solution.mat')

scale=solution.shielding(1);

% interpret sides
sel=solution.sample>1 & solution.sample<6;
x=solution.side(sel)/scale;
y=solution.shielding(sel);
% side formula: y=b+(1-b)*exp(-x*a)
b=mean(y(x>6));
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

% interpret bottom
sel=solution.sample==6;
x=solution.side(sel)/scale;
y=solution.shielding(sel);
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