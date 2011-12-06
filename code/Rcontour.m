function CRR(filename, LAMBDA);

% runs the whole method on PGM image 'filename' (given without extension)
% and displays the result over the image. Uses:
% preprocess, main_loop and display_cycle.
filename = filename(1:size(filename,2)-4);

%I = imread(strcat(filename,'.pgm'));
if (nargin == 1)
    LAMBDA = 10;
end


preprocess(filename, LAMBDA);

load([filename '-tableRC.mat']);
load([filename '-mpointsRC.mat']);

cycle = main_loop5(table, mpoints, LAMBDA);

for i=1:5
    %[cycle2 table2] = find_simple_boundary(cycle, table, mpoints, LAMBDA);
    %overlap_cycle(filename,cycle2,table2,i);
    display_cycle(filename, cycle{i}, table, i);
end

save(strcat(filename,'-cycle'), 'cycle');

return;
