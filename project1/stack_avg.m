function [average] = stack_avg(fileNames,path)
%% Average Selected Bin Files
num_position = length(fileNames);

%%read in the first image for this position
filename = char(fileNames(1));

fprintf(['Reading file: ' filename ' ...']);

A = imread([path,filename]);
fprintf('Done \n');


%read in all the other images
for i = 2:num_position
     
    filename = char(fileNames(i));

    fprintf(['Reading file: ' filename ' ...']);
    B = imread([path,filename]);
    
    fprintf('Done \n');
    A = A + B;		
end


C = A/num_position;

average = C;
end


