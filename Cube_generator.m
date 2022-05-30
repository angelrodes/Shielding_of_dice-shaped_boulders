clear
close all hidden
sizes=[0.1 0.2:0.2:3 3.5:0.5:10];  % m

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
    samples=[...
        L/2 L/2 L-0.01;
        L/2 0+0.01 L/2;
        0+0.01 L/2 L/2;
        L-0.01 L/2 L/2;
        L/2 L-0.01 L/2;
        L/2 L/2 0+0.01];
    

    Plot3D(polygons,samples)
    xlabel('x')
    ylabel('y')
    zlabel('z')
    
    FileName=['Cube_side_' num2str(side*100) '_cm'];
    filestr=strcat(FileName,'.mat');
    save(filestr,'polygons', 'samples')
end
