function displaySolidedge_new(filename)

% D = dir([dirname '/*.w']);

%filename = '/home/zhangz/vlfeat-0.9.4.1/vlfeat/toolbox/get_datafortrain_cluster/VOC2006/ImageSets/';

% 
% [id,flag] = textread([filename '.txt'], '%s %f');
% 
% for i=1:size(id,1)
%     
%     
%     fid_in = fopen()
% 
% 
%     if(flag(i) ==1)
%  %   fname = [dirname '/' D(i).name];
%  %   [fname,s] = strtok(fname,'-');
%     %fname = fname(1,1:size(fname,2)-4); % remove extension
%     displayResults([dirname id{i} '_gpb_hys'], N);
%     close;
%     end
% end

%  fid = fopen([filename '.w'],'r');
%     if (fid == -1)
%         display(['Could not open file ' filename '.']);
%         return;
%     end
%     n_edges = fscanf(fid, '%d',[1,2]);
%     %disp(['Number of vertices: ' int2str(n)]);
%  %   vertices = (fscanf(fid,'%d',[2,n]))';
%     edges = (fscanf(fid,'%d %d %f %f %d'));
%     edges = reshape(edges,[],length(edges)/5)';
%     fclose(fid);
    
    
    fid = fopen([filename '.graph'],'r');
    if (fid == -1)
        display(['Could not open file ' filename '.']);
        return;
    end
    n = fscanf(fid, '%d',1);
    
    
    disp(['Number of vertices: ' int2str(n)]);
    position = (fscanf(fid,'%d',[2,n]))';
%     edges = (fscanf(fid,'%d %d %f %f %d'));
%     edges = reshape(edges,[],length(edges)/5)';



% fid_in = fopen(filename);
% 
% num_line = fgetl(fid_in);
% 
% for i = 1: str2num(num_line)
%     
%     str_p = fgetl(fid_in);
%     [x, t] = strtok (str_p, ' ');
%     
%     position(i,1) = str2num(x);
%     position(i,2) = str2num(t);
% end


edges = (fscanf(fid,'%d %d %f %f %d'));
    edges = reshape(edges,[],length(edges)/5)';

fclose(fid);
    
    
 solid = edges(find(edges(:,5) == 1),:);
 dashed = edges(find(edges(:,5) == 0),:);
  
figure;
imshow(imread([filename '.pgm']));
hold on;

for i=1: size(solid,1)
    
plot([position(solid(i,1)+1, 1)+1; position(solid(i,2)+1,1)+1], [position(solid(i,1)+1,2)+1; position(solid(i,2)+1,2)+1],'r-');

end

return;

figure;
imshow(imread([filename '.pgm']));
hold on;

for i=1: size(solid,1)
    
plot([position(solid(i,1)+1, 1)+1; position(solid(i,2)+1,1)+1], [position(solid(i,1)+1,2)+1; position(solid(i,2)+1,2)+1],'r-');

end

for i=1: size(dashed,1)
    
plot([position(dashed(i,1)+1, 1)+1; position(dashed(i,2)+1,1)+1], [position(dashed(i,1)+1,2)+1; position(dashed(i,2)+1,2)+1],'g-');



end


% [x,y,w1,w2,f] = textread('dashedge.w','%d %d %f %f %d');
% 
% 
% for i=1: size(x,1)
%     
% plot([position(x(i)+1, 1), position(y(i)+1,1)], [position(x(i)+1,2),position(y(i)+1,2)],'g-');
% 
% 
% 
% end
