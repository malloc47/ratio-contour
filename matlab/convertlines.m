function convertlines(filename)

lines = dlmread([filename '.lines']);

vertices = [];
solid = [];
dashed = [];
vidx = 0;

for i = 1:size(lines,1)
    line = lines(i,:);
    vertices = [vertices; line(1) line(2); line(3) line(4)];
%    solid = [solid; vidx vidx+1 0 (abs(line(3)-line(1))*(line(2)+line(4)))/2 1];
    solid = [solid; vidx vidx+1 0 area(line(1),line(2),line(3),line(4)) 1];
    vidx = vidx + 2;
end

for i = 1:size(vertices,1)-1
    for j = i+1:size(vertices,1)

        p1 = vertices(i,:);
        p2 = vertices(j,:);
        
%         dist = abs(p1(1)-p2(1))+abs(p1(2)-p2(2));
        dist = sqrt((p2-p1)*(p2-p1)');
        
        if(dist > 50)
		continue;
        end

%        dashed = [dashed; i-1 j-1 dist (abs(p2(1)-p1(1))*(p1(2)+p2(2)))/2 0 ];
        dashed = [dashed; i-1 j-1 dist area(p1(1),p1(2),p2(1),p2(2)) 0 ];
        
    end
end

fid = fopen([filename '.graph'],'w');
fprintf(fid,'%d\n',size(vertices,1));
fprintf(fid, '%d %d\n', vertices');
fprintf(fid, '%d %d %f %f %d\n', solid');
fprintf(fid, '%d %d %f %f %d\n', dashed');
fclose(fid);

end

function a = area(P1x,P1y,P2x,P2y)
if(P1y>P2y)
a = abs(P1x-P2x)*(P1y - abs(P1y-P2y)/2);
else
a = abs(P1x-P2x)*(P2y - abs(P1y-P2y)/2);
end
end
