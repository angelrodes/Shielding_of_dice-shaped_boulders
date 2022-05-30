% to be used with Balco's code
clear
close all hidden
warning ('off','all')

iteration=0;
cr=generate_cosmic_rays(5000);

sizes=[0.1 0.2:0.2:3 3.5:0.5:10];  % m
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

