function out = Plot3D(polygons,samples)
% plot 3D
figure(3)
polnumber=length(polygons);
for pol=1:polnumber
    trg=polygons(pol,:); % triangle
    plot3([trg(1) trg(4) trg(7) trg(1)],[trg(2) trg(5) trg(8) trg(2)],[trg(3) trg(6) trg(9) trg(3)],'-')
    plot3(mean([trg(1) trg(4) trg(7)]),mean([trg(2) trg(5) trg(8)]),mean([trg(3) trg(6) trg(9)]),'*k')
    hold on
end
for sample=1:size(samples,1)
    plot3(samples(sample,1),samples(sample,2),samples(sample,3),'p','MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',10)
    text(samples(sample,1),samples(sample,2),samples(sample,3),num2str(sample))
    hold on
end
axis equal
xlabel('x')
ylabel('y')
zlabel('z')