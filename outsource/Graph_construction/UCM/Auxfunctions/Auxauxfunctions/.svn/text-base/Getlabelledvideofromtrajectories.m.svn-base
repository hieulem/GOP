function [labelledvideo,trajectories,map]=Getlabelledvideofromtrajectories(ucm2,allregionpaths,allregionsframes,trajectories,selectedtreetrajectories,printonscreen)
%The trajectories being converted do not contain holes

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

noTrajectories=numel(trajectories);

if ( (~exist('selectedtreetrajectories','var')) || (isempty(selectedtreetrajectories)) )
    selectedtreetrajectories=true(1,noTrajectories);
end

map=Scramble(noTrajectories);
% map=1:noTrajectories;
backmap=Mapitback(map);
% backmap=zeros(1,noTrajectories);
% for i=1:noTrajectories
%     backmap(i)=find(map==i,1,'first');
% end

dim=size(ucm2{1}(2:2:end, 2:2:end));
dimIi=dim(1);
dimIj=dim(2);

noFrames=numel(ucm2);

labelledvideo=zeros(dimIi,dimIj,noFrames); %the assined labels are the trajectory numbers
    %This also maps labelled pixels to trajectories
for t=1:noTrajectories
    
    if (~selectedtreetrajectories(t))
        continue;
    end
    
    nopath=trajectories{t}.nopath;
    
    for f=trajectories{t}.startFrame:trajectories{t}.endFrame
        

        fregion=Lookupregioninallregionpaths(allregionpaths,f,nopath);
        level=allregionsframes{f}{fregion}.ll(1,1);
        label=allregionsframes{f}{fregion}.ll(1,2);
        mask=Getthemask(ucm2{f},level,label);
      
        labelsatframe=labelledvideo(:,:,f);
        labelsatmask=labelsatframe(mask);
        
        currentlabels=unique(labelsatmask)';
        
        for cl=currentlabels
            
            if (cl==0)
                %no ambiguity
                assignnewlabel=true;
            else
                %resolve ambiguity
                if ( trajectories{t}.totalLength > trajectories{backmap(cl)}.totalLength ) %This should not make any difference for Getquantitativemeasurement
                    assignnewlabel=true; %or false
                else
                    assignnewlabel=false;
                end
            end

            if (assignnewlabel)
                labelsatmask(labelsatmask==cl)=map(t);
            end
        end
        
        labelsatframe(mask)=labelsatmask;
        labelledvideo(:,:,f)=labelsatframe;
    end
    
end

for t=1:noTrajectories
    trajectories{t}.label=map(t);
end


if (printonscreen)
    Printthevideoonscreen(labelledvideo, printonscreen, 1);
end


% region=Lookupregioninallregionpaths(allregionpaths,frame,nopath);
% level=allregionsframes{frame}{region}.ll(1,1);
% label=allregionsframes{frame}{region}.ll(1,2);
% mappednopath=correspondentPath{frame}{level}(label);
% 
% region=lookUpRegioninAllregionsframes(allregionsframes,f,l,nl);
% nopath=allregionpaths.nopath{f}(region);
% notrajectory=mapPathToTrajectory(nopath);
