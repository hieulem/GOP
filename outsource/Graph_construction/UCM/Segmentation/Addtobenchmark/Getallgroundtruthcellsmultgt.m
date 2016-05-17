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
        allgroundtruth{f}{mid}.Segmentation=Uintconv(labelledgtvideo{mid,f});  %touse: Uintconv

        %Level=1;
        %labels2 = bwlabel(gtucm2{f} < Level);
        %labels = labels2(2:2:end, 2:2:end);
        %allgroundtruth{f}{1}.Segmentation=labels;

        %Thin boundaries
        bmap=logical(gtucm2{mid,f}(3:2:end, 3:2:end));
        allgroundtruth{f}{mid}.Boundaries=logical(  bwmorph( bmap , 'thin', Inf)  );
%         
        %Backup previous code (thick boundaries)
%         allgroundtruth{f}{mid}.Boundaries=logical(gtucm2{mid,f}(3:2:end, 3:2:end));
        
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



% function Test_this_function()
% 
% FSSscripthalf('airplane','testmanifoldclustering','0','clustaddname','Bvdscfallucm30poptnrmrwhein10f','newsegname','Bvdssegmfallucm30poptnrmrwhein10f','ucm2level','30',...
%     'faffinityv','10','uselevelfrw','1','ucm2levelfrw','1','newmethodfrw','0','proplabels','1','proplabelsdir','Bvdsplrwheinucm30hpov10inc1init0ncm1000mrgmult1seed1km3newtmp',...
%     'plwhmaxframe','30',...
%     'pltwwidth','200','ploverlap','190','plincrement','1','plusehorder','0','pliterations','100','plalpha','0.95','plmethod','2','plncincrease','-1000',...
%     'pluseoverhp','1','plmergelabequiv','1','plinitframesall','0','plrwusenewmethod','0','manifoldclustermethod','km3new','plmultiplicity','1','plseed','1','stpcas','paperoptnrm');

