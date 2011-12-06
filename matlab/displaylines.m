function convertGraph(filename)
    fid = fopen([filename '.graph'],'r');
    if (fid == -1)
        display(['Could not open file ' filename '.']);
        return;
    end
    n = fscanf(fid, '%d',1);
    disp(['Number of vertices: ' int2str(n)]);
    vertices = (fscanf(fid,'%d',[2,n]))';
    edges = (fscanf(fid,'%d %d %f %f %d'));
    edges = reshape(edges,[],length(edges)/5)';
    fclose(fid);

    solid = edges(find(edges(:,5) == 1),:);
    dashed = edges(find(edges(:,5) == 0),:);
    
    fid = fopen([filename '-0.cycle'],'r');
    n = fscanf(fid, '%d',1);
    cycle = (fscanf(fid,'%d',[6,n]))';
    fclose(fid);

    figure; imshow(imread([filename '.pgm'])); hold on;
    
    for i = 1:size(cycle,1)
        points = [];
        points = [points; vertices(uint16(floor(cycle(i,1)/2))+1,:)+1];
        points = [points; vertices(uint16(floor(cycle(i,2)/2))+1,:)+1];
        plot(points(:,1),points(:,2),'-r');
    end
    
end
