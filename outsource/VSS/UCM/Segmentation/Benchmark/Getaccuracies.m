function [matchesj,confcountssized,segareas,gtareas] = Getaccuracies(confcounts,maxgtlabelsngt,metricstocompute)
% Compute a matrix of segmentation coverings and a matrix of confusion
% counts, resized to the labels in use. confcounts contains in fact an
% extra label for the zeros.
% Zero values are considered, -1 values are neglected. A pixel with -1 is
% not counted at all (neither for precision, nor for recall nor for SC)
% A pixel with value 0 is counted as not matched
%
% Input:
%       confcounts = confidence counts including zero label
%                       (nsegs+1) x (total_gt+ngts)
%       maxgtlabelsngt = maximum number of labels per GT
%                       1 x (ngts)
%       metricstocompute = bool to indicate which output to compute
%                           [jaccard indexes, conf counts sized, areas]
% Output:
%       matchesj = nsegs x total_gt
%                   total_gt x nsegs in this function
%       confcountssized = nsegs x total_gt
%                   total_gt x nsegs in this function
%       segareas,gtareas = ground truth areas to consider when computing,
%                           respectively, precision and recall. The first
%                           does not zonsider zero values of machine
%                           segmentation, the second those of GT
%
% based on PASCAL evaluation code:
% http://pascallin.ecs.soton.ac.uk/challenges/VOC/voc2010/index.html#devkit
% and Arbelaez et al. CVPR 2009
%
% modified by Fabio Galasso
% September 2012

if ( (~exist('metricstocompute','var')) || (isempty(metricstocompute)) )
    metricstocompute=true(1,3);
end

ngts=numel(maxgtlabelsngt);
nsegs=size(confcounts,1)-1;

total_gt = size(confcounts,2) - ngts; %sum(maxgtlabelsngt)
if (total_gt ~= sum(maxgtlabelsngt))
    fprintf('Total gt and gt label count\n');
    matchesj=[]; confcountssized=[];
    return;
end

cnt = 0;
cntsized=0;
matchesj = zeros(total_gt, nsegs);
confcountssized = zeros(total_gt, nsegs);
%The statistics are used as denominators for the precision-recall region metrics
segareas = zeros(1,ngts); %area of machine segments corresponding to each GT (this could potentially be different because of -1 values in GT)
    %0 values of segmentations are not counted here, this is a sum of all classified points
    %used for precision
gtareas = zeros(1,ngts); %area of GT segments corresponding to each machine segment (-1 excluded)
    %0 values in GT are not counted, as this is the area of what the segmentation should recall
    %used for recall
for s = 1 : ngts

    num1 = maxgtlabelsngt(s) + 1; 
    num2 = nsegs + 1;
    
    aconfcounts = confcounts(: , cnt+1:cnt+maxgtlabelsngt(s)+1)';
    %aconfcounts = (maxgtlabelsngt(s)+1) x (nsegs+1)

    if (metricstocompute(1)||metricstocompute(3))
        gtjsum=sum(aconfcounts,2);
        segisum=sum(aconfcounts,1);
    end
    
    if (~isempty(aconfcounts(2:end, 2:end))) %This may happen in cases of empty GT for some human annotations or empty machine segmentations (-1)
        %intersections between gt and segmentation computed for the labels (>0)
        if (metricstocompute(2))
            confcountssized(cntsized+1:cntsized+maxgtlabelsngt(s), :) = aconfcounts(2:end, 2:end);
        end

        %segmentaion coverings between machine segments and GTs (Jaccard indexes)
        if (metricstocompute(1))
            matchesj(cntsized+1:cntsized+maxgtlabelsngt(s), :) = aconfcounts(2:end, 2:end) ./ ( repmat(gtjsum(2:end),1,num2-1) + repmat(segisum(2:end),num1-1,1) - aconfcounts(2:end, 2:end) );
        end
    end
    
    if (metricstocompute(3))
        gtareas(s) = sum(gtjsum(2:end)); %sum(sum( aconfcounts(2:end, :) ));
        segareas(s) = sum(segisum(2:end)); %sum(sum( aconfcounts(:, 2:end) ));
    end
    
    cntsized = cntsized + maxgtlabelsngt(s);
    cnt = cnt + maxgtlabelsngt(s) + 1 ;
end

confcountssized = confcountssized';
matchesj = matchesj';




% confcounts = Getconfcounts(seg, groundTruth, maxgtlabelsngt);
