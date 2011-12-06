function display_cycle(name, cycle, table, N);

% Displays the end result.
% Name is the PGM filename (without extension), cycle is the answer
% given by the main_loop and table is the table of acrs returned
% by the preprocesssing.

%N = size(mpoints,1)*2;

I = imread(strcat(name,'.pgm'));
%I = 255 - I;
figure('Visible', 'off');
imagesc(I);
colormap(gray)
axis off
axis equal
hold on
brighten(0.6);

for i=1:size(cycle,1)
    if (cycle(i,5) == 0)
        j = 1;
        while ( (cycle(i,1) ~= table(j,1)) | (cycle(i,2) ~= table(j,2)) )
            j = j + 1;
        end
        p = plot([table(j,3), table(j,5), table(j,7), table(j,9), table(j,11)],[table(j,4), table(j,6), table(j,8), table(j,10), table(j,12)],'r-');
        set(p,'LineWidth',5);

        %mark used corners
%         if ( (table(j,7) ~= (table(j,5)+table(j,9))/2) | (table(j,8) ~= (table(j,6)+table(j,10))/2) )
%             p = plot(table(j,7), table(j,8), 'b.');
%             set(p,'MarkerSize', 20);
%         end

        % uncomment this to print detected and gap-filling in different colors.
%                     p = plot([table(j,3), table(j,5)],[table(j,4), table(j,6)],'r-');
%                     set(p,'LineWidth',5);
%                     p = plot([table(j,5), table(j,7), table(j,9)],[table(j,6), table(j,8), table(j,10)],'b-');
%                     set(p,'LineWidth',5);
%                     p = plot([table(j,9), table(j,11)],[table(j,10), table(j,12)],'r-');
%                     set(p,'LineWidth',5);
    end
end


print('-djpeg',strcat(name,'-RC-', int2str(N)));
print('-depsc2',strcat(name,'-RC-', int2str(N)));
close;

return;
