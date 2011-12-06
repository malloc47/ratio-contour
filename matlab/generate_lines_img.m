function generate_lines(folder)

list = dir(strcat(folder,'*.pgm'));

for i=1:size(list,1)
    img = imread([folder list(i).name]);
    bw = edge(img,'canny');    
    name = list(i).name(1:(size(list(i).name,2)-4));
    imwrite(255*(~bw),[folder name '-canny.pgm']);
    data = load([folder name '.lines'],'-ASCII');

%     axis ij;
%     axis off;
%     axis([1 size(img,2) 1 size(img,1)])
%     axis equal;
    imshow(255+0*img)
    brighten(1);
    hold on;
    for i=1:size(data,1)
        plot([data(i,1),data(i,3)],[data(i,2),data(i,4)],'k-');
    end

    print('-depsc2', [folder name '-lines']);
    print('-djpeg', [folder name '-lines']);
    close;
end