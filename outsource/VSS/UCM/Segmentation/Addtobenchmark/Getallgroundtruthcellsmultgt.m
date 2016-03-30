function allgroundtruth=Getallgroundtruthcellsmultgt(gtucm2,labelledgtvideo,nonemptygt,printonscreen)

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

noFrames=size(gtucm2,2);
numbergts=size(gtucm2,1);

allgroundtruth=cell(1,noFrames);

%Prepare output format by reducing the gtucm2 size to the image size keeping boundaries and segmentation

%[firstnonemptymid,firstnonemptyfid]=find(nonemptygt,1,'first');
%dimi=size(labelledgtvideo{firstnonemptymid,firstnonemptyfid},1);
%dimj=size(labelledgtvideo{firstnonemptymid,firstnonemptyfid},2);

%animage=zeros(dimi,dimj);
for f=1:noFrames
    %The size is reduced to the image size and the edges and segmentations kept
    %This format is suitable to compute the benchmark with the Berkeley software
    
    allgroundtruth{f}=cell(1,numbergts);
    for mid=1:numbergts
        
        if (~nonemptygt(mid,f)) %(isempty(labelledgtvideo{mid,f}))
            continue;
        end
        
        %Remove the empty labels
        %animage=labelledgtvideo(:,:,f);
        %[tmp1,tmp2,newlabels]=unique(animage(:));
        %animage(:)=newlabels(:);
        
        %Output to the designed structure
        allgroundtruth{f}{mid}.Segmentation=int16(labelledgtvideo{mid,f});  %touse: Uintconv

        %Level=1;
        %labels2 = bwlabel(gtucm2{f} < Level);
        %labels = labels2(2:2:end, 2:2:end);
        %allgroundtruth{f}{1}.Segmentation=labels;

        allgroundtruth{f}{mid}.Boundaries=logical(gtucm2{mid,f}(3:2:end, 3:2:end));
    end
end
%Just boundaries
% for f=1:noFrames
%     gtucm2{f}=gtucm2{f}(3:2:end, 3:2:end);
% end

if (printonscreen)
    Init_figure_no(10)
    Init_figure_no(11)
    for mid=1:numbergts
        for f=1:noFrames
            if (~isempty(allgroundtruth{f}{mid}))
                figure(10), imagesc(allgroundtruth{f}{mid}.Boundaries)
                figure(11), imagesc(allgroundtruth{f}{mid}.Segmentation)
                fprintf('Frame %d max label %d\n',f,max(allgroundtruth{f}{mid}.Segmentation(:)));
                pause(0.1)
            end
        end
    end
end
