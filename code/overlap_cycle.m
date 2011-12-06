function overlap_cycle(name, cycle, table, num);

% Displays the end result.
% Name is the PGM filename (without extension), cycle is the answer
% given by the main_loop and table is the table of acrs returned
% by the preprocesssing.

%N = size(mpoints,1)*2;

I = imread(strcat(name,'.pgm'));
J(:,:,1) = I;
J(:,:,2) = I;
J(:,:,3) = I;
% imagesc(I);
% colormap(gray)
% axis off
% axis equal
% hold on
%brighten(0.6);

for i=1:size(cycle,1)
    if (cycle(i,5) == 0)
        j = 1;
        while ( (cycle(i,1) ~= table(j,1)) | (cycle(i,2) ~= table(j,2)) )
            j = j + 1;
        end

        n = ceil( norm(table(j,3:4) - table(j,5:6)) );
        d = norm(table(j,3:4) - table(j,5:6));
        cost = abs(table(j,5) - table(j,3))/d;
        sint = abs(table(j,6) - table(j,4))/d;
        signA = sign(table(j,5) - table(j,3));
        signB = sign(table(j,6) - table(j,4));
        if (n > 0)
            for k=0:n
                X = round(table(j,3) + signA*(k*d/n)*cost);
                Y = round(table(j,4) + signB*(k*d/n)*sint);
                J(Y,X,:) = [255 0 0];
            end
        end
        J(round(table(j,4)), round(table(j,3)),:) = [255 0 0];
        J(round(table(j,6)), round(table(j,5)),:) = [255 0 0];


        n = ceil( norm(table(j,5:6) - table(j,7:8)) );
        d = norm(table(j,5:6) - table(j,7:8));
        cost = abs(table(j,7) - table(j,5))/d;
        sint = abs(table(j,8) - table(j,6))/d;
        signA = sign(table(j,7) - table(j,5));
        signB = sign(table(j,8) - table(j,6));
        if (n > 0)
            for k=0:n
                X = round(table(j,5) + signA*(k*d/n)*cost);
                Y = round(table(j,6) + signB*(k*d/n)*sint);
                J(Y,X,:) = [255 0 0];
            end
        end
        J(round(table(j,6)), round(table(j,5)),:) = [255 0 0];
        J(round(table(j,8)), round(table(j,7)),:) = [255 0 0];


        n = ceil( norm(table(j,7:8) - table(j,9:10)) );
        d = norm(table(j,7:8) - table(j,9:10));
        cost = abs(table(j,9) - table(j,7))/d;
        sint = abs(table(j,10) - table(j,8))/d;
        signA = sign(table(j,9) - table(j,7));
        signB = sign(table(j,10) - table(j,8));
        if (n > 0)
            for k=0:n
                X = round(table(j,7) + signA*(k*d/n)*cost);
                Y = round(table(j,8) + signB*(k*d/n)*sint);
                J(Y,X,:) = [255 0 0];
            end
        end
        J(round(table(j,8)), round(table(j,7)),:) = [255 0 0];
        J(round(table(j,10)), round(table(j,9)),:) = [255 0 0];


        n = ceil( norm(table(j,9:10) - table(j,11:12)) );
        d = norm(table(j,9:10) - table(j,11:12));
        cost = abs(table(j,11) - table(j,9))/d;
        sint = abs(table(j,12) - table(j,10))/d;
        signA = sign(table(j,11) - table(j,9));
        signB = sign(table(j,12) - table(j,10));
        if (n > 0)
            for k=0:n
                X = round(table(j,9) + signA*(k*d/n)*cost);
                Y = round(table(j,10) + signB*(k*d/n)*sint);
                J(Y,X,:) = [255 0 0];
            end
        end
        J(round(table(j,10)), round(table(j,9)),:) = [255 0 0];
        J(round(table(j,12)), round(table(j,11)),:) = [255 0 0];



        %mark used corners
        if ( (table(j,7) ~= (table(j,5)+table(j,9))/2) | (table(j,8) ~= (table(j,6)+table(j,10))/2) )
            J(round(table(j,8)), round(table(j,7)), :) = [0 0 255];
        end
    end
end


% print('-djpeg',strcat(name,'-RC'));
% print('-depsc2',strcat(name,'-RC'));
imwrite(J, [name '-' int2str(num) '-result.ppm']);
% close;

return;
