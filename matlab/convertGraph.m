function convertGraph(filename)
    fid = fopen([filename '.graph'],'r');
    if (fid == -1)
        display(['Could not open file ' filename '.']);
        return;
    end
    n = fscanf(fid, '%d',1);
    disp(['Number of vertices: ' int2str(n)]);
    vertices = (fscanf(fid,'%d',[2,n]))';
    vertices = [vertices -1*ones(size(vertices,1),1)];
    edges = (fscanf(fid,'%d %d %f %f %d'));
    edges = reshape(edges,[],length(edges)/5)';
    fclose(fid);

    solid = edges(find(edges(:,5) == 1),:);
    dashed = edges(find(edges(:,5) == 0),:);

    RCGraph = [];
    
    % Create solid edges first
    for i = 1:size(solid,1)
        edge_frag = solid(i,:);
        
            n1 = edge_frag(1);
            n2 = edge_frag(2);

            vertices(edge_frag(1)+1,3) = i;
            vertices(edge_frag(2)+1,3) = i;
%            RCGraph = [RCGraph; 2*n1 2*n2 abs(edge_frag(4)) abs(edge_frag(3)) 1; 2*n1+1 2*n2+1 -1*abs(edge_frag(4)) abs(edge_frag(3)) 1 ];
            RCGraph = [RCGraph; 2*n1 2*n2 0 0 1; 2*n1+1 2*n2+1 0 0 1 ];

    end

    % Now create dashed edges
    for i = 1:size(dashed,1)
        
        edge_frag = dashed(i,:);
        
        w1 = abs(edge_frag(3));
        w2 = abs(edge_frag(4));
        
        e1 = (vertices(edge_frag(1)+1,3)-1);
        e2 = (vertices(edge_frag(2)+1,3)-1);
        
        ABw1 = abs(solid(e1+1,3));
        ABw2 = abs(solid(e1+1,4));
        CDw1 = abs(solid(e2+1,3));
        CDw2 = abs(solid(e2+1,4));
        
        n1 = edge_frag(1);
        n2 = edge_frag(2);
        
        if(n1 == n2)
            disp('Nonunique solid edges!');
            return;
        end
        
        if(e1 == e2)
            disp('Nonunique vertices!');
            continue;
        end

        p1 = vertices(n1+1,1:2);
        p2 = vertices(n2+1,1:2);
        
        back1 = vertices(setdiff(solid(e1+1,1:2),n1)+1,1:2);
        back2 = vertices(setdiff(solid(e2+1,1:2),n2)+1,1:2);
        
        if(isequal(p1,back1) || isequal(p2,back2) || isequal(p1,back2) || isequal(p2,back1))
            disp('Endpoint overlap');
            continue;
        end
        
        flagAB = false;
        
        if(p1(1) > back1(1))
           flagAB = true;
        elseif(p1(1) == back1(1))
           if(p1(2) > back1(2))
               flagAB = true;
           end
        end
        
        flagCD = false;
        
        if(p2(1) > back2(1))
           flagCD = true;
        elseif(p2(1) == back2(1))
           if(p2(2) > back2(2))
               flagCD = true;
           end
        end
        
        if(p1(1) > p2(1))
            w2 = -1*w2;
        end

         if(flagAB)
             w2 = w2 + ABw2/2;
         else
             w2 = w2 - ABw2/2;
         end
        
         if(flagCD)
             w2 = w2 - CDw2/2;
         else
             w2 = w2 + CDw2/2;
         end
         
%         w1 = w1 + ABw1/2 + CDw1/2;
                
        if(flagAB) % A->B is positive
            if(flagCD) % C->D is negative
                RCGraph = [RCGraph; 2*n1 2*n2+1 w2 w1 edge_frag(5); ...
                    2*n1+1 2*n2 -1*w2 w1 edge_frag(5)];
            else % C->D is positive
                RCGraph = [RCGraph; 2*n1 2*n2 w2 w1 edge_frag(5); ...
                    2*n1+1 2*n2+1 -1*w2 w1 edge_frag(5)];
            end
        else % A->B is negative
            if(flagCD) % C->D is negative
                RCGraph = [RCGraph; 2*n1+1 2*n2+1 w2 w1 edge_frag(5); ...
                    2*n1 2*n2 -1*w2 w1 edge_frag(5)];
            else % C->D is positive
                RCGraph = [RCGraph; 2*n1+1 2*n2 w2 w1 edge_frag(5); ...
                    2*n1 2*n2+1 -1*w2 w1 edge_frag(5)];
            end
        end
        
%         if(p1(1) > back1(1)) % A->B is positive
%             if(p2(1) > back2(1)) % C->D is negative
%                 RCGraph = [RCGraph; 2*n1 2*n2+1 w2 w1 edge_frag(5); ...
%                     2*n1+1 2*n2 -1*w2 w1 edge_frag(5)];
%             else % C->D is positive
%                 RCGraph = [RCGraph; 2*n1 2*n2 w2 w1 edge_frag(5); ...
%                     2*n1+1 2*n2+1 -1*w2 w1 edge_frag(5)];
%             end
%         else % A->B is negative
%             if(p2(1) > back2(1)) % C->D is negative
%                 RCGraph = [RCGraph; 2*n1+1 2*n2+1 w2 w1 edge_frag(5); ...
%                     2*n1 2*n2 -1*w2 w1 edge_frag(5)];
%             else % C->D is positive
%                 RCGraph = [RCGraph; 2*n1+1 2*n2 w2 w1 edge_frag(5); ...
%                     2*n1 2*n2+1 -1*w2 w1 edge_frag(5)];
%             end
%         end
    end

    maxw1 = max(abs(RCGraph(:,4)))
    maxw2 = max(abs(RCGraph(:,3)))
    
    for i = 1:size(RCGraph,1)
       RCGraph(i,3) = (RCGraph(i,3)*600)/maxw2;
       RCGraph(i,4) = (RCGraph(i,4)*600)/maxw1;
    end
    
    RCGraph = int16(RCGraph);
    
    largestsolididx = max(max(RCGraph(find(RCGraph(:,5)==1),1:2)))+1;
    
    fid = fopen([filename '.w'],'w');
    fprintf(fid,'%d\t%d\n',largestsolididx,size(RCGraph,1));
    fprintf(fid, '%d %d %d %d %d\n', RCGraph');
    fclose(fid);
end

