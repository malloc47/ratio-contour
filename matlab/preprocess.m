function preprocess(fname)

% Creates three data files for the input pgm file. This files are
% used by the RRC method. They are:
% fname.lines   (detected line segments)
% fname.corners (detected corners)
% fname.grad    (gradient map of the image)
%
% Joachim Stahl (05/11/2006)

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

return;

%% The following code is for work in currently progress

% 2 % Obtain detected corners
% [cim, r, c] = harris(double(img), 2, 1000, 2);
% cim = harris(double(img), 2);
% corners = findMaxCorners(cim, r, c, 100);
% if (~isempty(corners))
%     corners(:,1:2) = [corners(:,2) corners(:,1)];
% end
% 
% save([fname '.corners'],'corners','-ASCII');
% 
% % 3 % Obtain gradient map
% h = [1 0 -1; 2 0 -2; 1 0 -1]; % Sobel operators
% v = h';
% x = imfilter(double(img),h,'replicate','conv');
% y = imfilter(double(img),v,'replicate','conv');
% g = sqrt(x.^2 + y.^2); %gradient magnitude
% g = 1./(g+1);
% 
% fid = fopen([fname '.grad'],'w');
% fprintf(fid, '%g %g \n', size(img,2), size(img,1));
% for i=1:size(img,1)
%     for j=1:size(img,2)
%         fprintf(fid,'%g ', g(i,j));
%     end
%     fprintf(fid,'\n');
% end
% fclose(fid);
% 
% return;
