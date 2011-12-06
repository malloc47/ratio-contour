function generate_lines_img(dirname)

D = dir([dirname '*.pgm']);

for i=1:size(D,1);
    fname = D(i).name;
    I = imread([dirname fname]);
    
    bw = edge(I,'canny');
    edgelist = edgelink(bw, 10);
    lines = lineseg(edgelist, 2);  

    display_lines((255 + 0*I), lines);

    fname = fname(1:size(fname,2)-4);
    print('-depsc2',[dirname fname '-lines']);
    close;

end
