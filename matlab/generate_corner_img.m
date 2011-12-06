function generate_corner_img(dirname)

D = dir([dirname '*.pgm']);

for i=1:size(D,1);
    fname = D(i).name;
    I = imread([dirname fname]);
    [cim, r, c] = harris(double(I), 2, 1000, 2);
    cim = harris(double(I), 2);
    corners = findMaxCorners(cim, r, c, 100);

    imagesc(I);
    colormap(gray)
    axis off
    axis equal
    hold on
    brighten(0.6);
    p = plot(corners(:,2), corners(:,1), 'b.');
    set(p,'MarkerSize', 20);

    fname = fname(1:size(fname,2)-4);
    print('-depsc2',[dirname fname '-harris']);
    print('-djpeg',[dirname fname '-harris']);
    close;

end
