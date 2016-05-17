function [newucm2,relabelledvideo,labelstorelabels]=Getucmfromlabelledvideo(level,labelledvideo,newucm2)
%Getsimpleucmfromlabelledvideo performs the same task, using mex and just
%creating a new ucm2 with Level 1

dimIi=size(labelledvideo,1);
dimIj=size(labelledvideo,2);
noFrames=size(labelledvideo,3);



for i=1:dimIi
    ui=min(dimIi,i+1);
    for j=1:dimIj
        uj=min(dimIj,j+1);
        for f=1:noFrames
            if (labelledvideo(i,j,f)~=labelledvideo(ui,j,f))
                newucm2{f}(2*i+1,2*j-1:2*j+1)=level;
            end
            if (labelledvideo(i,j,f)~=labelledvideo(i,uj,f))
                newucm2{f}(2*i-1:2*i+1,2*j+1)=level;
            end
        end
    end
end

relabelledvideo=zeros(size(labelledvideo));
for f=1:noFrames
    labels2 = bwlabel(newucm2{f} < level);
    labels = labels2(2:2:end, 2:2:end);
    relabelledvideo(:,:,f)=labels;
%     Init_figure_no(5), imagesc(labels2)
%     Init_figure_no(6), imagesc(newucm2{f} < level)
end


labelstorelabels=zeros(max(labelledvideo(:)),noFrames);
for thelabel=unique(labelledvideo)'
    for f=1:noFrames
        labels2 = bwlabel(newucm2{f} < level);
        labels = labels2(2:2:end, 2:2:end);
        
        [r,c]=find(labelledvideo(:,:,f)==thelabel,1,'first');
        if (~isempty(r))
            labelstorelabels(thelabel,f)=labels(r,c);
        end
    end
end

if (0)
    for f=1:noFrames
        Init_figure_no(1), imagesc(newucm2{f})
        Init_figure_no(2), imagesc(labelledvideo(:,:,f))
        Init_figure_no(3), imagesc(relabelledvideo(:,:,f))
        pause(1);
    end
end
