function get_canny(dirname);

DIR = dir([dirname '*.pgm']);

for i=1:size(DIR,1)
    fname = DIR(i).name;
    I = imread([dirname fname]);
    bw = edge(I,'canny');
    imwrite(255*bw, [dirname fname '-canny.pgm']);
end
