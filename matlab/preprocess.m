function preprocess(fname, homogeneity,  use_corners)

% Creates data files for the input pgm file. This files are
% used by the RRC method. They are:
% fname.lines   (detected line segments)
% fname.corners (detected corners)
% fname.map     (intensity or gradient magnitude map of the image)
%
% The corners are optional, activated by default, set use_corners
% to 0 to skip.
% The maps are optional, activated by default, set homogeneity to
% 0 to skip creating the intensity map, and to 2 to create gradient
% map instead.
%
% Joachim Stahl (08/14/2006)

epsilon = 50;
T = 128;

if (nargin == 1)
    homogeneity = 1;
    use_corners = 1;
elseif (nargin == 2)
    use_corners = 1;
end

display(['Preprocessing: ' fname]);
img = imread([fname '.pgm']);

% resize to < 512x512

M = max(size(img));
if (M > 512)
    t = maketform('affine',eye(3));
    img = imtransform(img,t,'Size',round(512*size(img)/M));
end

% 1 % Obtain line segment approximation
bw = edge(img, 'canny');
edgelist = edgelink(bw, 30);
lines = lineseg(edgelist, 2);

save([fname '.lines'],'lines','-ASCII');


%The following code is for work in currently progress

% 2 % Obtain detected corners (not published)
if (use_corners == 1)
    [cim, r, c] = harris(double(img), 2, 1000, 2);
    cim = harris(double(img), 2);
    corners = findMaxCorners(cim, r, c, 100);
    if (~isempty(corners))
        corners(:,1:2) = [corners(:,2) corners(:,1)];
    end

    save([fname '.corners'],'corners','-ASCII');
end

% 3 % Obtain intensity map
if (homogeneity == 1)
    % this IF implements intensity homogeneity (as in journal)

    %T = 128; % Here should go a method to auto-select T
    I = abs(double(img) - T);
    I2 = double(I > epsilon);  % foreground
    %I2 = double(I < epsilon); % background

    fid = fopen([fname '.map'],'w');
    fprintf(fid, '%g %g \n', size(img,2), size(img,1));
    for i=1:size(img,1)
        for j=1:size(img,2)
            fprintf(fid,'%g ', I2(i,j));
        end
        fprintf(fid,'\n');
    end
    fclose(fid);

elseif(homogeneity == 2)

    % this IF creates a gradient magnitude map (not published)
    h = [1 0 -1; 2 0 -2; 1 0 -1]; % Sobel operators
    v = h';
    x = imfilter(double(img),h,'replicate','conv');
    y = imfilter(double(img),v,'replicate','conv');
    g = sqrt(x.^2 + y.^2); %gradient magnitude
    g = g / max(g(:));

    fid = fopen([fname '.map'],'w');
    fprintf(fid, '%g %g \n', size(img,2), size(img,1));
    for i=1:size(img,1)
        for j=1:size(img,2)
            fprintf(fid,'%g ', g(i,j));
        end
        fprintf(fid,'\n');
    end
    fclose(fid);

end


return;
