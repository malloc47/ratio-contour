function display_mpoints(fname, mp);

I = imread(fname);
imagesc(I);
colormap(gray);
axis off
axis equal
hold on
brighten(1);

for i=1:size(mp,1)
    %plot(mp(i,1), mp(i,2), 'b.');
    plot([mp(i,1),mp(i,1)+mp(i,4)*cos(mp(i,3))], [mp(i,2),mp(i,2)+mp(i,4)*sin(mp(i,3))], 'r-');
    plot([mp(i,1),mp(i,1)-mp(i,4)*cos(mp(i,3))], [mp(i,2),mp(i,2)-mp(i,4)*sin(mp(i,3))], 'r-');
end

return;
