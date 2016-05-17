function allgroundtruth=Getallgroundtruthcells(gtucm2,labelledgtvideo,printonscreen)

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

noFrames=numel(gtucm2);

allgroundtruth=cell(1,noFrames);

%Prepare output format by reducing the gtucm2 size to the image size
%keeping boundaries and segmentation
animage=zeros(size(labelledgtvideo,1),size(labelledgtvideo,2));
for f=1:noFrames
    %The size is reduced to the image size and the edges and segmentations kept
    %This format is suitable to compute the benchmark with the Berkeley software
    
    allgroundtruth{f}=cell(1);
    
    animage=labelledgtvideo(:,:,f);
    %Remove the empty labels
% % %     [tmp1,tmp2,newlabels]=unique(animage(:));
% % %     animage(:)=newlabels(:);
    %output to the designed structure
    allgroundtruth{f}{1}.Segmentation=Uintconv(animage);  %touse: Uintconv

%     Level=1;
%     labels2 = bwlabel(gtucm2{f} < Level);
%     labels = labels2(2:2:end, 2:2:end);
%     allgroundtruth{f}{1}.Segmentation=labels;
    
    allgroundtruth{f}{1}.Boundaries=logical(gtucm2{f}(3:2:end, 3:2:end));
end
%Just boundaries
% for f=1:noFrames
%     gtucm2{f}=gtucm2{f}(3:2:end, 3:2:end);
% end

if (printonscreen)
    Init_figure_no(10)
    Init_figure_no(11)
    for f=1:noFrames
        figure(10), imagesc(allgroundtruth{f}{1}.Boundaries)
        figure(11), imagesc(allgroundtruth{f}{1}.Segmentation)
        fprintf('Frame %d max label %d\n',f,max(allgroundtruth{f}{1}.Segmentation(:)));
        pause(0.1)
    end
end
