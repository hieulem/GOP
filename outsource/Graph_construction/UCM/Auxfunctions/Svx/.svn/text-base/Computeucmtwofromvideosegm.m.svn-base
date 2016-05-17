function newucm2=Computeucmtwofromvideosegm(allthesegmentations,desireducmlevels,printonscreen)
%The function computes newucm2 by overlapping the UCM boundaries



if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end



%Parameter setup
noFrames=size(allthesegmentations{1},3);
framerange=1:noFrames; %all frames are considered altogether
framesize=[size(allthesegmentations{1},1),size(allthesegmentations{1},2)];



%Initialisation
newucm2=cell(1,numel(framerange));
for f=framerange
    newucm2{f}=uint8(zeros(framesize*2+1));
end



nsegmlevels=numel(allthesegmentations);



%Sample computed video segmentations if their number exceeds the desired ucm2 levels
if (nsegmlevels>desireducmlevels)
    whichsegmlevels=  round(  1 : ((nsegmlevels-1)/(desireducmlevels-1)) : nsegmlevels  )  ;
    fprintf('Sampling video segmentation levels (%d) to match the desired ucm2 levels (%d)\n',nsegmlevels,desireducmlevels);
else
    whichsegmlevels=1:nsegmlevels;
end



for level=whichsegmlevels
    
    for ff=framerange
        newucm2=Addtoucm2wmex(ff,Doublebackconv(allthesegmentations{level}),newucm2,framesize(1),framesize(2),numel(ff));
        % newucm2=Addtoucm2(ff,asegmentation,newucm2,printonscreeninsidefunction);
    end

    %fprintf('Level %d processed\n', level);
end



%Expand newucm2 to the desireducmlevels
newucm2=Expanddesireducm(newucm2,desireducmlevels,framerange);



% Print output
if (printonscreen)
    Init_figure_no(3);
    for f=1:noFrames
        figure(3), imagesc(newucm2{f})
        title(['New ucm2 frame ',num2str(f)]);
        pause(0.1);
    end
    f=ceil((noFrames-1)/2); %Leaves video positioned on central frame
    figure(3), imagesc(newucm2{f})
    title(['New ucm2 frame ',num2str(f)]);
end






function Printtogether(newucm2,ucm2) %#ok<DEFNU>



%Just for comparison
Init_figure_no(3);
for f=1:noFrames
    figure(3), imagesc([newucm2{f},ucm2{f}])
    title(['New ucm2 vs ucm2 at frame ',num2str(f)]);
    pause(1);
%     [max(newucm2{f}(:)),min(newucm2{f}(newucm2{f}~=0))]
end

f=ceil((noFrames-1)/2); %Leaves video positioned on central frame
figure(3), imagesc([newucm2{f},ucm2{f}])
title(['New ucm2 frame ',num2str(f)]);

pause(1);



outputimages=false;
if (outputimages) %filenames to be included among function arguments
%             Printthevideoonscreen(newucm2, true, 10);
    newucm2basename=[filenames.idxpicsandvideobasedir,'Pics',filesep,'image']; %#ok<UNRCH>
    Writepictureseries(newucm2,newucm2basename,'%03d','.bmp',0,numel(newucm2),true,true);
end



% save(filenames.newucmtwo, 'newucm2','-v7.3');

%The original ucm2 is kept, which is used for merging higher order
% clear ucm2;
% ucm2=newucm2;
% clear newucm2;


