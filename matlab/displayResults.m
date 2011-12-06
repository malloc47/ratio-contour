function displayResults(fname, N)

if (nargin == 1)
    N = 1;
end

fid = fopen([fname '.data']);
if (fid == -1)
    corners = [];
else
    fclose(fid);
    corners = load([fname '.data']);
end
lines = load([fname '.lines']);
img = imread([fname '.pgm']);
%bmp = 0*img;

%imshow(img);
%brighten(0.6);
%hold on;

for i=1:N
    fid = fopen([fname '-' int2str(i-1) '.cycle'],'r');
    if (fid == -1)
        display(['Could not open file ' fname '-' int2str(i-1) '.cycle']);
        break
    end
    num = fscanf(fid, '%d',1);
    cycle = (fscanf(fid,'%d',[6,num]))';
    fclose(fid);
    if (size(cycle,1) == 0)
        break;
    end

    % display over image
%     figure; hold on; axis equal; axis ij; axis off; axis([1 96 1 96])
%     display_lines(img, lines);
    imshow(img);
    %brighten(0.7);
    hold on;
    M = max(size(img));
    if (M > 512)
        scale = M/512;
    else
        scale = 1;
    end
    %bmp = bmp + 
    display_cycle(cycle, lines, corners, img, scale);
    print('-r0','-dpng', [fname '-cycleRRC-' int2str(i-1)]);
    print('-depsc2', [fname '-cycleRRC-' int2str(i-1)]);
    close;

    %display detected lines
    %     display_lines(img, lines);
    %     print('-r0','-dpng', [fname '-lines-' int2str(i-1)]);
    %     print('-depsc2', [fname '-lines-' int2str(i-1)]);
    %     close;
    
end

% bmp = (bmp > 0)*255;
% imwrite(bmp,[fname '-boundaryRRC5.bmp']);
% bmp2(:,:,1) = img + uint8(bmp);
% bmp2(:,:,2) = img;
% bmp2(:,:,3) = img;
% imwrite(bmp2,[fname '-cycleRRC3.bmp']);

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bmp=display_cycle(cycle, lines, corners, img, scale)

solid_color = 'r-';
dashed_color = 'r-';
corner_color = 'b.';

bmp = 0*img;
points = [];

for i=1:size(cycle,1)

    if (cycle(i,5) == 1) % solid
        a = floor(cycle(i,1)/4)+1;
        p = plot(scale*lines(a,[1 3]), scale*lines(a,[2 4]),solid_color);
        set(p,'LineWidth',2);
        points = [points; rasterize(lines(a,[1 2]), lines(a,[3 4]))];
    else % dashed
        is_c = 0;
        for j=1:size(corners,1)
            if ((cycle(i,1) == corners(j,1)) && (cycle(i,2) == corners(j,2)))
                is_c = 1;
                c = corners(j,3:4);
                break;
            end
        end

        a = floor(cycle(i,1)/4) + 1;
        b = floor(cycle(i,2)/4) + 1;

        % distances between endpoints
        dist(1) = norm(lines(a,1:2)-lines(b,1:2));
        dist(2) = norm(lines(a,3:4)-lines(b,1:2));
        dist(3) = norm(lines(a,1:2)-lines(b,3:4));
        dist(4) = norm(lines(a,3:4)-lines(b,3:4));

        [mindist indx] = min(dist);

        switch indx
            case 1
                if (is_c == 0)
                    p = plot(scale*[lines(a,1) lines(b,1)], scale*[lines(a,2) lines(b,2)],dashed_color);
                    set(p,'LineWidth',2);
                    points = [points; rasterize(lines(a,[1 2]), lines(b,[1 2]))];
                else
                    p = plot(scale*[lines(a,1) c(1) lines(b,1)], scale*[lines(a,2) c(2) lines(b,2)],dashed_color);
                    set(p,'LineWidth',2);
                    p = plot(scale*c(1),scale*c(2),corner_color);
                    set(p,'MarkerSize',20);
                end
            case 2
                if (is_c == 0)
                    p = plot(scale*[lines(a,3) lines(b,1)], scale*[lines(a,4) lines(b,2)],dashed_color);
                    set(p,'LineWidth',2);
                    points = [points; rasterize(lines(a,[3 4]), lines(b,[1 2]))];
                else
                    p = plot(scale*[lines(a,3) c(1) lines(b,1)], scale*[lines(a,4) c(2) lines(b,2)],dashed_color);
                    set(p,'LineWidth',2);
                    p = plot(scale*c(1),scale*c(2),corner_color);
                    set(p,'MarkerSize',20);
                end
            case 3
                if (is_c == 0)
                    p = plot(scale*[lines(a,1) lines(b,3)], scale*[lines(a,2) lines(b,4)],dashed_color);
                    set(p,'LineWidth',2);
                    points = [points; rasterize(lines(a,[1 2]), lines(b,[3 4]))];
                else
                    p = plot(scale*[lines(a,1) c(1) lines(b,3)], scale*[lines(a,2) c(2) lines(b,4)],dashed_color);
                    set(p,'LineWidth',2);
                    p = plot(scale*c(1),scale*c(2),corner_color);
                    set(p,'MarkerSize',20);
                end
            case 4
                if (is_c == 0)
                    p = plot(scale*[lines(a,3) lines(b,3)], scale*[lines(a,4) lines(b,4)],dashed_color);
                    set(p,'LineWidth',2);
                    points = [points; rasterize(lines(a,[3 4]), lines(b,[3 4]))];
                else
                    p = plot(scale*[lines(a,3) c(1) lines(b,3)], scale*[lines(a,4) c(2) lines(b,4)],dashed_color);
                    set(p,'LineWidth',2);
                    p = plot(scale*c(1),scale*c(2),corner_color);
                    set(p,'MarkerSize',20);
                end
        end
    end
end

% for i=1:size(points,1)
%     bmp(points(i,2), points(i,1)) = 1;
% end

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rasterize line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function points=rasterize(A,B)
% Given a line from A to B, return the list
% of (x,y) coordinates of the points that rasterize it.

points = [];
count = 0;

if (abs(A(1)-B(1)) > abs(A(2)-B(2))) % go along x-direction
    m = (A(2)-B(2))/(A(1)-B(1));
    b = A(2) - m*A(1);
    for i=round(min(A(1),B(1))):round(max(A(1),B(1)))
        count = count + 1;
        points(count,:) = [i round(m*i+b)];
    end
else
    if (A(1) == B(1)) % vertical line
        for i=round(min(A(2),B(2))):round(max(A(2),B(2)))
            count = count + 1;
            points(count,:) = [A(1) i];
        end
    else
        m = (A(2)-B(2))/(A(1)-B(1));
        b = A(2) - m*A(1);
        for i=round(min(A(2),B(2))):round(max(A(2),B(2)))
            count = count + 1;
            points(count,:) = [round((i-b)/m) i];
        end
    end
end

return;

function display_lines(img, data)
%
% FUNCTION display_lines(img, data)
%
% Displays the lines in data superimposed over the image img.
%
% Joachim Stahl
% January 18, 2005
%

% uncommment to draw lines over white background
img = 255 + 0*img;

imagesc(img);
colormap(gray);
axis off;
axis equal;
hold on;
brighten(1);

color = 'k-';
for i=1:size(data,1)
    plot([data(i,1),data(i,3)],[data(i,2),data(i,4)],color);
end

return;

%%% END %%%
