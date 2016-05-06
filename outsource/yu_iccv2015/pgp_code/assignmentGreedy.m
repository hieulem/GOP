%assignmentGreedy.m
%
%assign the temporal matching using a greedy approach

function corrMatrix = assignmentGreedy(offSet1, offSet2, corrMatrix, tAffinity, sNeighbors, sNeighbors2)

%Sort by size, then location, then shape, then intensity, then color, then
%orientation.

regionInd = 1:size(tAffinity,1);

[minVals, forward] = min(tAffinity, [], 2);


pairs(:,1) = regionInd;
pairs(:,2) = forward;
pairs(:,3) = minVals;

regionInd2 = 1:size(tAffinity,2);
extraRegions = setdiff(regionInd2, unique(forward));

%if this is the last frame
% if isLast == 1

    [minVals, backward] = min(tAffinity(:, extraRegions), [], 1);

    pairs = [pairs; backward', extraRegions', minVals'];
% end

%find the threshold for the bad matches
% q3 = prctile(pairs(:,3), 75);
% badMatchT = q3 + 1.5*iqr(pairs(:,3));
% pairs(pairs(:,3) >= badMatchT, :) = [];

% %forward check
% pairs = sortrows(pairs, [1, 3]);
% [B, I, J] = unique(pairs(:,1), 'first');
% t = diff(I);
% 
% multiR = find(t > 1);
% 
% newPairs = pairs(I(t == 1),:);
% 
% %for each multi-region merging into a single region 
% for i = 1:length(multiR)
%     
%     regions = pairs(I(multiR(i)):I(multiR(i))+t(multiR(i))-1, 2);
%     
%     %check to see if they are originally disjoint
%     totalNeighbors = unique(cell2mat(sNeighbors2(regions,1)));
%     disjoints = ismember(regions, totalNeighbors);
%     
%     %the first disjoints is definitely connected.
%     disjoints(1) = 1;
%     %newPairs(end+1,:) = pairs(I(multiR(i)),:);
%     
%     %ind = find(disjoints == 0);
%     for j = 1:length(disjoints)
%         
%         toNode = regions(j);
%         
%         if disjoints(j) == 0
%             
%             %for the originally disjoint regions, assign to other match
%             temp = sortrows([(1:size(tAffinity,1))', tAffinity(:,toNode)], 2);
%             temp(1,:) = [];
%             temp(temp(:,2) >= badMatchT,:) = [];
%             
%             %match to the first remaining one
%             if ~isempty(temp)
%                 
%                 %place connection only if the new ones are neighbors
%                 for k = 1:size(temp,1)
%                     ind2 = find(pairs(:,1) == temp(k,1), 1);
%                     
%                     if isempty(ind2) || ismember(toNode, sNeighbors2{pairs(ind2,2)})
%                         newPairs(end+1,:) = [temp(k,1), toNode, temp(k,2)];
%                         break;
%                     end
%                     
%                 end
%                 
%             end
%             
%         else
%             newPairs(end+1,:) = pairs(I(multiR(i))+j-1,:);
%         end
%     end
% end
% 
% newPairs = sortrows(newPairs, [1,3]);
% 
% %backward check
% pairs = sortrows(newPairs, [2, 3]);
% [B, I, J] = unique(pairs(:,2), 'first');
% t = diff(I);
% 
% multiR = find(t > 1);
% 
% newPairs2 = pairs(I(t == 1),:);
% 
% %for each multi-region merging into a single region 
% for i = 1:length(multiR)
%     
%     regions = pairs(I(multiR(i)):I(multiR(i))+t(multiR(i))-1, 1);
%     
%     %check to see if they are originally disjoint
%     totalNeighbors = unique(cell2mat(sNeighbors(regions,1)));
%     disjoints = ismember(regions, totalNeighbors);
%     
%     %the first disjoints is definitely connected.
%     disjoints(1) = 1;
%     %newPairs(end+1,:) = pairs(I(multiR(i)),:);
%     
%     %ind = find(disjoints == 0);
%     for j = 1:length(disjoints)
%     
%         fromNode = regions(j);
%         
%         if disjoints(j) == 0
%             
%             %for the originally disjoint regions, assign to other match
%             temp = sortrows([(1:size(tAffinity,2))', tAffinity(fromNode,:)'], 2);
%             temp(1,:) = [];
%             temp(temp(:,2) >= badMatchT,:) = [];
%             
%             %match to the first remaining one
%             if ~isempty(temp)
%                   
%                 %place connection only if the new ones are neighbors
%                 for k = 1:size(temp,1)
%                     ind2 = find(pairs(:,2) == temp(k,1), 1);
%                     
%                     if isempty(ind2) || ismember(fromNode, sNeighbors{pairs(ind2,1)})
%                         newPairs2(end+1,:) = [fromNode, temp(1,1), temp(1,2)];
%                         break;
%                     end
%                     
%                 end
%                
%             end
%             
%         else
%             newPairs2(end+1,:) = pairs(I(multiR(i))+j-1,:);
%         end
%     end
% end
%     
% newPairs = sortrows(newPairs2, [2,3]);

%update the correct from/to indices with the provided off set values
newPairs = pairs;
newPairs(:,1) = newPairs(:,1) + offSet1;
newPairs(:,2) = newPairs(:,2) + offSet2;

ind = sub2ind(size(corrMatrix), newPairs(:,1), newPairs(:,2)); %from->to
ind2 = sub2ind(size(corrMatrix), newPairs(:,2), newPairs(:,1)); %to->from

%update the correspondence matrix
corrMatrix(ind) = newPairs(:,3);
corrMatrix(ind2) = newPairs(:,3);



