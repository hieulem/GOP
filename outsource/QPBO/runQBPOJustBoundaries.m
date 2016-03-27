function [resStats,optimLabels] = runQBPOJustBoundaries(allUnaryLabels,allUnaryConfs,allAreas,allSameLabels,allSameConfs,...
    allDiffLabels,allDiffConfs,allAreasPairs,allAdjacentPairs,segmentationDir,pointsPerImage,pairsPerImage,allBoundaryLabels,...
    allBoundaryConfs,allBDInfo,bdsPerImage,doWeights,wUnary,wSAME,wDIFF,wBound,doDiffEncNeg,doBoundaryExclusive)
%doDiffEncNeg,doBoundaryExclusive
homeDir = pwd;
%qpbodir
qpboPath = 'E:\fromDown\imrender_v2.4\vgg';
% qpboPath = 'E:\fromDown\Newimrender_v2.4\vgg';
minboundLength = 17;
optimLabels = [];
resStats = [];
%loop on segmentationDir
dirDP = dir([segmentationDir,'*.mat']);
    for cur=1:numel(dirDP)
        %chop up info
        unaryLabels = allUnaryLabels(pointsPerImage==cur);
        unaryConfs = allUnaryConfs(pointsPerImage==cur,:);
        %
        sameLabels = allSameLabels(pairsPerImage==cur);
        sameConfs = allSameConfs(pairsPerImage==cur,:);
        diffLabels = allDiffLabels(pairsPerImage==cur);
        diffConfs = allDiffConfs(pairsPerImage==cur,:);
        %aa
        adjacentPairs = allAdjacentPairs(pairsPerImage==cur,:);
        %from boundaries
        boundLabels = allBoundaryLabels(bdsPerImage==cur);
        boundConfs = allBoundaryConfs(bdsPerImage==cur,:);
        %bd struct
        bdInfo = allBDInfo(bdsPerImage==cur,:);
        %
        if doWeights > 0
            areas = allAreas(pointsPerImage==cur); 
            areasPairs = allAreasPairs(pairsPerImage==cur,3);
            areasBounds = bdInfo(:,2); %divide by 2
        else
            areas = ones(size(unaryLabels))';
            areasPairs = ones(size(diffLabels));
            areasBounds = ones(size(boundLabels));
        end
        %transpose
        areas = areas';
        %
         %% Unary potentials
         UnaryPotentials = zeros(size(unaryLabels));
         %
         %labelled  (non,sh) (1,2)
         %for labelled neg, (-conf, -conf)
         if sum(unaryLabels==0) > 0
            fprintf('some unary labels are 0, bad check inside runQBPO\n');
         end
         UnaryPotentials(unaryLabels<0,1) = -1.0 * areas(unaryLabels<0) .* unaryConfs(unaryLabels<0,1) * wUnary;
         UnaryPotentials(unaryLabels<0,2) = -1.0 * areas(unaryLabels<0) .* unaryConfs(unaryLabels<0,2) * wUnary;
         %
         UnaryPotentials(unaryLabels>0,1) = -1.0 * areas(unaryLabels>0) .* unaryConfs(unaryLabels>0,1) * wUnary;
         UnaryPotentials(unaryLabels>0,2) = -1.0 * areas(unaryLabels>0) .* unaryConfs(unaryLabels>0,2) * wUnary;
         %
         %% Setup edge structure
         %active edges for pos predicted same and diff
         sameLabels = zeros(size(sameLabels));
         diffLabels = zeros(size(diffLabels));
         posSame = sameLabels>0;
         posDiff = diffLabels>0;
    
         %
%          Edges = adjacentPairs(posPairs,:);
         Edges = adjacentPairs;
         
         %% Pairwise Potentials
         PairwisePotentials = zeros(size(Edges,1),4);
%          fprintf('edges, same: %g, diff: %g \n',sum(posSame),sum(posDiff));
%          
         if sum(posSame) > 0
%              fprintf('sameEdges: %g\n',sum(posSame(:)));
             %same: penalize different labelling with +conf 
             %columns 1)00  2)01  3)10  4)11
             PairwisePotentials(posSame,1) = 0;
             PairwisePotentials(posSame,4) = 0;
             PairwisePotentials(posSame,2) = areasPairs(posSame) .* sameConfs(posSame,2) * wSAME;
             PairwisePotentials(posSame,3) = areasPairs(posSame) .* sameConfs(posSame,2) * wSAME;
         end
         if sum(posDiff) > 0
%              fprintf('%g) count Diff edges: %g \n',cur,sum(posDiff));
%              fprintf('diffEdges: %g\n',sum(posDiff(:)));
             %diff: good lab -conf, bad lab +conf (good firsNon(0) second
             %shadow(1), E01(#2
             if doDiffEncNeg > 0
                PairwisePotentials(posDiff,2) = PairwisePotentials(posDiff,2) + (-1.0) * areasPairs(posDiff) .* diffConfs(posDiff,2) * wDIFF;
             else
                PairwisePotentials(posDiff,2) = PairwisePotentials(posDiff,2) + 0;
             end
             %penalties
             PairwisePotentials(posDiff,1) = PairwisePotentials(posDiff,1) + areasPairs(posDiff) .* diffConfs(posDiff,2) * wDIFF;
             PairwisePotentials(posDiff,3) = PairwisePotentials(posDiff,3) + areasPairs(posDiff) .* diffConfs(posDiff,2) * wDIFF;
             PairwisePotentials(posDiff,4) = PairwisePotentials(posDiff,4) + areasPairs(posDiff) .* diffConfs(posDiff,2) * wDIFF;
         end
         %reparameterize for posDiff to avoid breaking symmetry,
         %for posDiff
%          if sum(posDiff) > 0
%             save ([homeDir,'\tempOp1.mat']);
%             cd(homeDir);
%             pause
%          end
         posDiffInds = find(posDiff==1);
         for pi=1:numel(posDiffInds)
            %edge index
            edge_Index = posDiffInds(pi);
            node1 = Edges(edge_Index,1);
            node2 = Edges(edge_Index,2);
            %retrieve all potentials
            E00 = PairwisePotentials(edge_Index,1);
            E01 = PairwisePotentials(edge_Index,2);
            E10 = PairwisePotentials(edge_Index,3);
            E11 = PairwisePotentials(edge_Index,4);
            %
            %if E01 is encouraged with a negative pot add that to the others
            if E01 < 0
                E00 = E00 - E01;
                E10 = E10 - E01;
                E11 = E11 - E01;
                %set E01 to 0
                E01 = 0;
            end
            %Remove assymetric potential E10
            %add it to proper E1,and E0
            %node1, penalty added to E1, E1 is UP(node1,2)
            UnaryPotentials(node1,2) = UnaryPotentials(node1,2) + E10;
            %node2 penalty added to E0, E0 is UP(node2,1)
            UnaryPotentials(node2,1) = UnaryPotentials(node2,1) + E10;
            %set E10 to zero breaking asymmetry
            E10 = 0;
            %Resave pairwise potentials
            PairwisePotentials(edge_Index,1) = E00;
            PairwisePotentials(edge_Index,2) = E01;
            PairwisePotentials(edge_Index,3) = E10;
            PairwisePotentials(edge_Index,4) = E11;
         end
         %set up boundary potentials
         %bdinfo, 1)bd, 2)weightLength, 3)length 4)pair1, 5)pair2
         %capp too short boundaries
         tooLowBounds = bdInfo(:,3) <= minboundLength;
         boundLabels(tooLowBounds) = -1;
         %cap same reg boundaries
         toCapSamRegBd = bdInfo(:,4) == bdInfo(:,5);
         boundLabels(toCapSamRegBd) = -1;
         %
         if doBoundaryExclusive > 0
            %only boundary potentials for pairs which no diff or same has been set already
            pairwiseOnUse = posSame | posDiff;
            paiwiseOnUseIndices = find(pairwiseOnUse>0);
            %from pairs 1,
            usedPair1 = intersect(paiwiseOnUseIndices,bdInfo(:,4));
            usedPair2 = intersect(paiwiseOnUseIndices,bdInfo(:,5));
            boundLabels(usedPair1) = -1;
            boundLabels(usedPair2) = -1;
         end
         posBounds = boundLabels > 0;
         posBoundsAde = zeros(size(posDiff));
         if sum(posBounds) > 0
            %covnert from boundary indices to aapairs/edges 
             posBoundInds = [bdInfo(posBounds,4);bdInfo(posBounds,5)];
             posTranslatedBds = [bdInfo(posBounds,1);bdInfo(posBounds,1)];
             posBoundsAde(posBoundInds) = 1;
%              save tempAB
             %penalize same labelling, 1 and 4  columns 1)00  2)01  3)10  4)11
             PairwisePotentials(posBoundInds,1) = PairwisePotentials(posBoundInds,1) + areasBounds(posTranslatedBds) .* boundConfs(posTranslatedBds,2) * wBound;
             PairwisePotentials(posBoundInds,2) = PairwisePotentials(posBoundInds,2) +  0; %areasBounds(posTranslatedBds) .* boundConfs(posTranslatedBds,2) * wBound;
             PairwisePotentials(posBoundInds,3) = PairwisePotentials(posBoundInds,3) + 0; %areasBounds(posTranslatedBds) .* boundConfs(posTranslatedBds,2) * wBound;
             PairwisePotentials(posBoundInds,4) = PairwisePotentials(posBoundInds,4) + areasBounds(posTranslatedBds) .* boundConfs(posTranslatedBds,2) * wBound;
           
         end
         
         
         %remove empty edges and potentials
         posPairs = posSame | posDiff | (posBoundsAde>0);
         negPairs = ~(posPairs);
         %will have to add boundary pos, check intersection between
         %posSame, posDiff, posBound
%          cd (homeDir);
%          save tempE
%          cd (qpboPath);
         if sum(negPairs>0) >= size(Edges,1)
            %no edges set up one bogus
            clear Edges PairwisePotentials
            Edges(1,1) = 1;
            Edges(1,2) = 2;
            Edges(1,3) = 1;
            PairwisePotentials(1,1) = 0;
            PairwisePotentials(1,2) = 0;
            PairwisePotentials(1,3) = 0;
            PairwisePotentials(1,4) = 0;
            
         else
             Edges(negPairs,:) = [];
             Edges(:,3) = 1:size(Edges,1);
             PairwisePotentials(negPairs,:) = [];
         end
             %
         %% Prepare structures for QBPO
         PE = int32(PairwisePotentials');
         UE = int32(UnaryPotentials');
         PI = uint32(Edges');
         %% Run QBPO
%          tic
         cd (qpboPath);
         
         [L stats] = vgg_qpbo(UE, PI, PE);
%          toc
         %convert labels
         if sum(L<0) > 0
            optionsP = int32([size(UnaryPotentials,1),0,20,0]);
            [L stats] = vgg_qpbo(UE, PI, PE,optionsP);
            pUnlabelled = sum(L<0);
            if pUnlabelled>0
                optionsI = int32([size(UnaryPotentials,1),1,0,0]);
                [Li statsi] = vgg_qpbo(UE, PI, PE,optionsI);
                if sum(Li<0) < pUlabelled
                    L = Li;
                end
            end
         end
% %          if sum(L<0) > 0
% %            
% %                 optionsI = int32([size(UnaryPotentials,1),1,0,0]);
% %                 [Li statsi] = vgg_qpbo(UE, PI, PE,optionsI);
% % %                 if sum(Li<0) < pUlabelled
% %                     L = Li;
% % %                 end
% % %             end
% %          end
         finalLabels = zeros(size(L));
         finalLabels(L==0) = -1;
         finalLabels(L==1) = 1;
         optimLabels = [optimLabels; finalLabels];
         %
%          if sum(finalLabels==0) > 0
% %             fprintf('%g) missingLabels: %g \n',cur,sum(finalLabels==0));
%          end
        
         %treat missing labels if necessary
    end
    cd (homeDir);
  
    

end

