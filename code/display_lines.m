function display_lines(fname, lines);
%
% FUNCTION display_lines(filename, write)
%
%
% Joachim Stahl
% October 1st, 2004
%

% if (nargin == 1)
%     write == 0;
% end

%I = imread(strcat(fname, '.pgm'));
imagesc(fname);
colormap(gray);
axis off;
axis equal;
hold on;
brighten(1);

%data = load(strcat(fname, '.lin'));
data = lines;
color = 'r-';
for i=1:size(data,1)
    p = plot([data(i,1),data(i,3)],[data(i,2),data(i,4)],color);
    set(p,'LineWidth',3);
%     if (color == 'r-')
%         color = 'b-';
%     else
%         color = 'r-';
%     end
end

% if (write == 1)
% print('-dpsc', strcat(fname,'-lines'));
% end

return;
