%checkDisjoint.m
%
%check to see if the final proto-objects have disjoint spatial componenets
%at all. If so, split them by greedily removing the highest weighted edge
%until satisfying the non-disjoint spatial component criteria

function output = checkDisjoint( inTree, labelsList, numPO, spC, spList, blankImg, labels, labelCentroids1, searchMode )

%for each spatio-temporal proto-object, check to see if ALL frames have
%just one contiguous area.
for i = 1:numPO
    
    [i numPO];
    
    poMembers = find(spC == i);
    
    %re-construct this sub-tree
    tempTree = spalloc(size(inTree,1), size(inTree,2), 2*length(poMembers));
    tempTree(poMembers, poMembers) = inTree(poMembers, poMembers);
    
    %     tempTree(poMembers,:) = inTree(poMembers,:);
    %     tempTree(:,poMembers) = inTree(:,poMembers);
    tempTreeSym = tempTree + tempTree';
    
    okSubTree = [];
    count = 1;
    while count < 100
        
        [~, C2] = graphconncomp(tempTree, 'WEAK', true);
        thisGroups = C2(poMembers);
        
        groupID = unique(thisGroups);
        
        
        for z = 1:length(groupID)
            if ismember(find(thisGroups == groupID(z),1), okSubTree)
                groupID(z) = 0;
            end
        end
        
        groupID(groupID == 0) = [];
        
        if isempty(groupID)
            
            %update the Tree
            inTree(poMembers,:) = tempTree(poMembers,:);
            inTree(:,poMembers) = tempTree(:,poMembers);
            
            break;
        end
        
        %search from the largest branch
        groupID2 = groupID';
        for z = 1:length(groupID)
            groupID2(z,2) = length(find(thisGroups == groupID(z)));
        end
        
        groupID2 = sortrows(groupID2, -2);
        groupID = groupID2(:,1)';
        
        %check every sub tree, make sure they're all single branch
        %         allCheck = 1;
        %shuffle the groups
        %groupID = groupID(randsample(1:length(groupID), length(groupID)));
        for k = 1:length(groupID)
            
            poMembers2 =  find(C2 == groupID(k));
            
            %check every frame
            firstSP = 1;
            notSingle = 0;
            for j = 1:length(labelsList)
                %for j = 1:size(labels,3)
                
                sp = poMembers2(poMembers2 >= firstSP & poMembers2 <= labelsList(j));
                
                %check to see if they are all spatial neighbors
                if length(sp) > 1
                    
                    tempImg = blankImg;
                    t = cell2mat(spList(sp));
                    tempImg(t) = 1;
                    [L, num] = bwlabel(tempImg);
                    
                    if num > 1
                        
                        %find the largest two components
                        tempL = zeros(num,2);
                        tempL(:,1) = 1:num;
                        tempCount = hist(L(:), 0:num);
                        tempCount(1) = [];
                        tempL(:,2) = tempCount';
                        tempL = sortrows(tempL, -2);
                        
                        t2 = labels(:,:,j);
                        %                         group1 = nonzeros(unique(labels(:,:,j).*(L == 1)));
                        %                         group2 = nonzeros(unique(labels(:,:,j).*(L == 2)));
                        
                        %                         %keep group1 as the smaller group
                        %                         if length(group2) < length(group1)
                        %                             groupT = group1;
                        %                             group1 = group2;
                        %                             group2 = groupT;
                        %                         end
                        
                        if strcmp(searchMode, 'rand') == 1
                            
                            lonelySP = t2(randsample(find(L == tempL(1,1)),1));
                            neighborSP = t2(randsample(find(L == tempL(2,1)),1));
                            %
                        else
                            
                            sp1 = unique(t2(L == tempL(1,1)));
                            sp2 = unique(t2(L == tempL(2,1)));
                            
                            if strcmp(searchMode, 'mid') == 1
                                sp1c = labelCentroids1(sp1,:);
                                sp2c = labelCentroids1(sp2,:);

                                sp1m = mean(sp1c);
                                if size(sp1c,1) == 1
                                    sp1m = sp1c;
                                end
                                sp2m = mean(sp2c);
                                if size(sp2c,1) == 1
                                    sp2m = sp2c;
                                end
                                
                                dM1 = pdist2(sp1m, sp1c);
                                dM2 = pdist2(sp2m, sp2c);
                                
                                [~, r] = min(dM1);
                                [~, c] = min(dM2);
                            else
                                
                                d = pdist2(labelCentroids1(sp1,:), labelCentroids1(sp2,:));
                                
                                if strcmp(searchMode, 'max') == 1
                                    
                                    dM= max(max(d));
                                    
                                elseif strcmp(searchMode, 'min') == 1
                                    dM= min(min(d));
                                else
                                    tMean = mean(mean(d));
                                    d2 = d(:);
                                    dM0 = pdist2(tMean, d2);
                                    [~, dInd] = min(dM0);
                                    dM = d2(dInd);
                                end
                                
                                [r, c] = ind2sub(size(d), find(d == dM));
                            end
                            
                            lonelySP = sp1(r);
                            neighborSP = sp2(c);
                        end
                        
                        notSingle = 1;
                    end
                    
                    %                     allN = ismember(sp, unique(cell2mat(spNeighbor(sp))));
                    %
                    %                     if length(unique(allN)) ~= 1
                    %                         notSingle = 1;
                    %                     end
                    
                end
                
                if notSingle == 1
                    break;
                end
                
                firstSP = labelsList(j)+1;
            end
            
            %if this is not a single entity, keep break its "heaviest" edge until
            %it is a single spatio-temporal tube
            if notSingle == 1
                
                %                 %find the cut edge for all group1 nodes
                %                 pathList = zeros(length(group1), 3);
                %                 for j = 1:length(group1)
                %                     [sDist, sPath, ~] = graphshortestpath(tempTree', group1(j), group2, 'directed', false', 'method', 'Acyclic');
                %
                %                     %find the furtherst path with the heaviest edge
                %                     [~, maxInd] = max(sDist);
                %
                %                     if iscell(sPath) == 0
                %                         sPath = sPath';
                %                     else
                %                         sPath = sPath{maxInd}';
                %                     end
                %                     sPath(:,2) = [sPath(2:end); 0];
                %                     sPath(end,:) = [];
                %                     sPath(:,3) = tempTreeSym(sub2ind(size(tempTreeSym), sPath(:,1), sPath(:,2)));
                %                     [~, maxInd] = max(sPath(:,3));
                %
                %                     pathList(j,:) = sPath(maxInd,:);
                %                 end
                %                 pathList = sortrows(pathList, -3);
                
                %try
                [~, sPath, ~] = graphshortestpath(tempTree', lonelySP(1), neighborSP(1), 'directed', false', 'method', 'Acyclic');
                %catch err
                %    keyboard
                %end
                sPath = sPath';
                sPath(:,2) = [sPath(2:end); 0];
                sPath(end,:) = [];
                
                sPath(:,3) = tempTreeSym(sub2ind(size(tempTreeSym), sPath(:,1), sPath(:,2)));
                [~, maxInd] = max(sPath(:,3));
                
                
                
                tempTree(sPath(maxInd,1),sPath(maxInd,2)) = 0;  %set the highest value to 0
                tempTree(sPath(maxInd,2),sPath(maxInd,1)) = 0;
            else
                okSubTree = [okSubTree, find(thisGroups == groupID(k),1)];
            end
            
        end %for
        
        %         if allCheck == 1
        %
        %             %update the Tree
        %             inTree(poMembers,:) = tempTree(poMembers,:);
        %             inTree(:,poMembers) = tempTree(:,poMembers);
        %
        %             break;
        %         end
        count = count + 1;
        
    end %while
    
end

output = inTree;








