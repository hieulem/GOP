function Getquantitativestatistics(filename_sequence_basename_frames_or_video, videocorrectionparameters, noFrames, filenames, ...
    trajectories, allregionpaths, allregionsframes, ucm2, selectedtreetrajectories,...
    allGis, Gif, Tm, agroupnumber, cim, howmanyframes, sizeL, minLength, minsizeL, ...
    framesforevaluation, printonscreen, printonscreeninsidefunction)



%This evaluation part uses variables:
%filename_sequence_basename_frames_or_video, noFrames,
%printonscreeninsidefunction, videocorrectionparameters, cim,
%howmanyframes, sizeL, minLength, minsizeL, trajectories, allregionpaths,
%allregionsframes, ucm2, filenames, selectedtreetrajectories, Tm,
%allGis,Gif, framesforevaluation, agroupnumber, printonscreen



%Read the ground truth video sequence or the frames
gtimages=Readpictureseries(filename_sequence_basename_frames_or_video.gtbasename,...
    filename_sequence_basename_frames_or_video.gtnumber_format,filename_sequence_basename_frames_or_video.gtclosure,...
    filename_sequence_basename_frames_or_video.gtstartNumber,noFrames,printonscreeninsidefunction);
gtimages=Adjustimagesize(gtimages,videocorrectionparameters,printonscreeninsidefunction,true);
if (printonscreeninsidefunction)
    close all;
end



% bgcode=[0,0,0] or 0;
% mbcode=[192,0,255;192,192,192] or [192;255];
if ( (~isfield(filename_sequence_basename_frames_or_video,'bgcode')) || (~isfield(filename_sequence_basename_frames_or_video,'mbcode')) )
    fprintf('Please define the background and moving body codes\n');
    return;
end
bgcode=filename_sequence_basename_frames_or_video.bgcode;
mbcode=filename_sequence_basename_frames_or_video.mbcode;



allcode=[bgcode;mbcode];
noallobjects=size(allcode,1);
textallobjects=cell(1,noallobjects);
textallobjects{1}='Background';
for i=2:noallobjects
    textallobjects{i}=['Object ',num2str(i-1)];
end

imagesize=size(cim{1});
imagesizetwo=imagesize(1:2);
emptymask=false(imagesizetwo);

nomaxframes=max(howmanyframes)+sizeL; %max(howmanyframes)+sizeL so we index gtmasks (and gtimages) with fc

% load('D:\temp\tmp.mat');
% noextraframes=size(svalidobjectmasks,1);

gtmasks=cell(nomaxframes,noallobjects);
validobjectmasks=false(nomaxframes,noallobjects);
% validobjectmasks=false(nomaxframes+noextraframes,noallobjects);
% validobjectmasks(nomaxframes+1:end,:)=svalidobjectmasks;
for frame=howmanyframes
    fc=frame+sizeL; %position of central frame in the sequence
    if (isempty(gtimages{fc}))
        continue;
    end
    for i=1:noallobjects
        gtmasks{fc,i}=emptymask;
        if (numel(size(gtimages{fc}))>2)
            tmpmask=cat(3,ones(imagesizetwo).*allcode(i,1),ones(imagesizetwo).*allcode(i,2),ones(imagesizetwo).*allcode(i,3));
            gtmasks{fc,i}=all(gtimages{fc}==tmpmask,3);
        else
            tmpmask=ones(imagesizetwo).*allcode(i);
            gtmasks{fc,i}=(gtimages{fc}==tmpmask);
        end
        if (any(any(gtmasks{fc,i}))) %this identifies masks where the objects occur
            validobjectmasks(fc,i)=true;
            if (printonscreen)
                Init_figure_no(1);
                imshow(gtmasks{fc,i});
                title(['Frame ',num2str(fc),' - code ',textallobjects{i}]);
                pause(0.1);
            end
        end
    end
end


if (printonscreen)
    for i=1:noallobjects
        Init_figure_no(i);
    end
end


%validobjectmasks=false(nomaxframes,noallobjects);
maxscore=zeros(nomaxframes,noallobjects); %Dice coefficient
maxprecision=zeros(nomaxframes,noallobjects); %which percentage of the clustered pixels belong to the object
maxrecall=zeros(nomaxframes,noallobjects); %which percentage of pixels from the object have been clustered
rawscore=zeros(nomaxframes,noallobjects,2); %2 stands for numerator and denominator
rawprecision=zeros(nomaxframes,noallobjects,2);
rawrecall=zeros(nomaxframes,noallobjects,2);
% maxscore=ones(nomaxframes,noallobjects)*(-1); %Dice coefficient
% maxprecision=ones(nomaxframes,noallobjects)*(-1); %which percentage of the clustered pixels belong to the object
% maxrecall=ones(nomaxframes,noallobjects)*(-1); %which percentage of pixels from the object have been clustered
% rawscore=ones(nomaxframes,noallobjects,2)*(-1); %2 stands for numerator and denominator
% rawprecision=ones(nomaxframes,noallobjects,2)*(-1);
% rawrecall=ones(nomaxframes,noallobjects,2)*(-1);

% maxscore=ones(nomaxframes+noextraframes,noallobjects)*(-1); %Dice coefficient
% maxprecision=ones(nomaxframes+noextraframes,noallobjects)*(-1); %which percentage of the clustered pixels belong to the object
% maxrecall=ones(nomaxframes+noextraframes,noallobjects)*(-1); %which percentage of pixels from the object have been clustered
% rawscore=ones(nomaxframes+noextraframes,noallobjects,2)*(-1); %2 stands for numerator and denominator
% rawprecision=ones(nomaxframes+noextraframes,noallobjects,2)*(-1);
% rawrecall=ones(nomaxframes+noextraframes,noallobjects,2)*(-1);
% maxscore(nomaxframes+1:end,:)=smaxscore;
% maxprecision(nomaxframes+1:end,:)=smaxprecision;
% maxrecall(nomaxframes+1:end,:)=smaxrecall;
% rawscore(nomaxframes+1:end,:,:)=srawscore;
% rawprecision(nomaxframes+1:end,:,:)=srawprecision;
% rawrecall(nomaxframes+1:end,:,:)=srawrecall;

saveworkfiles=false;
for frame=howmanyframes
    fc=frame+sizeL; %position of central frame in the sequence
    if (isempty(gtimages{fc}))
        continue;
    end
    
    % computation of track, mapTracToTrajectories, dist_track_mask, all_the_lengths
%     fcin=sizeL+1;
        %position of the central frame in the longest vector (trackLength long)
    %for the computation of the lowest level spanning tree (reference for region selection)
    ntrackLength=minLength;
    nframe=fc-minsizeL; %analysed frames are [nframe:nframe+ntrackLength-1]
    image=cim{nframe}; %should only be necessary if printonscreen == true
    imagefc=cim{fc};

    %The following is to be used, then allDs are computed on request
    [track,mapTracToTrajectories,dist_track_mask]=... %,all_the_lengths
        Prepareregiontracksonrequest(trajectories,nframe,ntrackLength,allregionpaths,ucm2,allregionsframes,...
        filenames,selectedtreetrajectories,saveworkfiles,printonscreeninsidefunction,image);
%     noTracks=size(track,3);
        %=size(dist_track_mask,2)


    %Represent computed clustering at frame
    labelsfc=Turntmtolabels(Tm); %labels according to the spanning tree allGis.T (as if fully connected)
    [labels,labelsv]=Getlabelsatframei(allGis,labelsfc,Gif,frame);

    th=1;
    if ( (~exist('th','var')) || (isempty(th)) || (~exist('labelsfc','var')) || (isempty(labelsfc)) || (th<=1) )
        useth=false;
    else
        useth=true;
    end

    fcdtm=round( (size(dist_track_mask,1)-1)/2 ) + 1; %central frame in dist_track_mask

    nofigure=17;

    %track = [ which frame , x or y , which trajectory ]
    % dist_track_mask{which frame,which trajectory}=mask
    %group{which group}=[tracks/dist_track_mask belonging to it]

    if (printonscreen)
        colouredimage=imagefc;
    end

    alllabels=unique(labelsv);
    for jj=1:numel(alllabels)
        thelabelmask=false(imagesizetwo);
        
        if (printonscreen)
            col=uint8(round(GiveDifferentColours(alllabels(jj))*255*2/3));
        end

        if ( (useth) && (numel(find(labelsfc==alllabels(jj)))<th) )
            continue;
        end
        for m=find(labelsv==alllabels(jj))
            if (~all(all(dist_track_mask{fcdtm,m}))) %so we exclude the whole frame
                mask=(dist_track_mask{fcdtm,m});
                thelabelmask=(thelabelmask|mask);

                if (printonscreen)
                    parttocolour=cat(3,mask,mask,mask);
                    colourtogive=cat(3,repmat(col(1),size(mask)),repmat(col(2),size(mask)),repmat(col(3),size(mask)));
                    colouredimage(parttocolour)=colourtogive(parttocolour); %subtracting only blue makes the marked regions yellow
                end
            end
        end
        
        if (~any(any(thelabelmask))) %this is a further check
            continue; %so sum(sum(thelabelmask)) is never zero
        end
        
        for i=1:noallobjects
            if (~validobjectmasks(fc,i)) %so sum(sum(gtmasks{fc,i})) is never zero
                continue;
            end
            score=2*sum(sum(gtmasks{fc,i}&thelabelmask))/( sum(sum(gtmasks{fc,i})) + sum(sum(thelabelmask)) );
            precision=sum(sum(gtmasks{fc,i}&thelabelmask))/sum(sum(thelabelmask));
            recall=sum(sum(gtmasks{fc,i}&thelabelmask))/sum(sum(gtmasks{fc,i}));
            if (score>maxscore(fc,i))
                maxscore(fc,i)=score;
                maxprecision(fc,i)=precision;
                maxrecall(fc,i)=recall;
                
                rawscore(fc,i,1)=2*sum(sum(gtmasks{fc,i}&thelabelmask));
                rawprecision(fc,i,1)=sum(sum(gtmasks{fc,i}&thelabelmask));
                rawrecall(fc,i,1)=sum(sum(gtmasks{fc,i}&thelabelmask));
                rawscore(fc,i,2)=( sum(sum(gtmasks{fc,i})) + sum(sum(thelabelmask)) );
                rawprecision(fc,i,2)=sum(sum(thelabelmask));
                rawrecall(fc,i,2)=sum(sum(gtmasks{fc,i}));

                if (printonscreen)
                    figure(i), imshow(thelabelmask);
                    title(['Frame ',num2str(fc),' - label ',num2str(alllabels(jj)),' - maxscore ',num2str(maxscore(fc,i))]);
                end
            end
        end
        
        if (printonscreeninsidefunction)
            Init_figure_no(1);
            imshow(thelabelmask);
            title(['Frame ',num2str(frame),' - label ',num2str(jj)]);
            pause;
        end
    end
    if (printonscreen)
        figure(nofigure), imshow(colouredimage+uint8(round(imagefc/3))) %the colouredimage here may have superposed colour as it does not use partnotdone
        set(gcf, 'color', 'white');
    
        for i=1:noallobjects
            if (validobjectmasks(fc,i)) %online refresh updated figures
                figure(i);
            end
        end
        pause(1);
    end
end


ovalidobjectmasks=validobjectmasks(:,2:end);
omaxscore=maxscore(:,2:end); %Dice coefficient
omaxprecision=maxprecision(:,2:end); %which percentage of the clustered pixels belong to the object
omaxrecall=maxrecall(:,2:end); %which percentage of pixels from the object have been clustered
orawscore=rawscore(:,2:end,:); %2 stands for numerator and denominator
orawprecision=rawprecision(:,2:end,:);
orawrecall=rawrecall(:,2:end,:);


% framesforevaluation=1:(size(validobjectmasks,1)-sizeL);

% pause;

%Write statistics
statisticsfilename=[filenames.idxpicsandvideobasedir,sprintf('statistics_withraw_nogroups%d.txt',agroupnumber)];
fid=fopen(statisticsfilename,'wt');
fprintf(fid,'Bkg/Obj         Dice_score Precision  Recall\n');
for frame=framesforevaluation
    fc=frame+sizeL; %position of central frame in the sequence
    if (~any(validobjectmasks(fc,:)))
        continue;
    end
    fprintf(fid,'Frame %d:\n',fc);
    for i=1:noallobjects
        fprintf(fid,'%10s(%d) = %.6f   %.6f   %.6f\n',textallobjects{i},validobjectmasks(fc,i),maxscore(fc,i),maxprecision(fc,i),maxrecall(fc,i));
    end
end


fprintf(fid,'Averages per cluster (averaged over frames):\n');
for i=1:noallobjects
    fprintf(fid,'%13s = %.6f   %.6f   %.6f\n',textallobjects{i},...
        mean(maxscore(validobjectmasks(:,i),i)),...
        mean(maxprecision(validobjectmasks(:,i),i)),...
        mean(maxrecall(validobjectmasks(:,i),i)) );
end





%This does not take into account how many frames a cluster appeared at
%This is not an average of the averages
%This averages all available scores of clusters at frames
fprintf(fid,'Global scores (averaged over frames and clusters):\n'); 
fprintf(fid,'   All objects and background = %.6f   %.6f   %.6f\n',... 
    mean(maxscore(validobjectmasks)),...
    mean(maxprecision(validobjectmasks)),...
    mean(maxrecall(validobjectmasks)) );
fprintf(fid,'   All objects                = %.6f   %.6f   %.6f\n',...
    mean(omaxscore(ovalidobjectmasks)),...
    mean(omaxprecision(ovalidobjectmasks)),...
    mean(omaxrecall(ovalidobjectmasks)) );





emptyvalid=false(size(ovalidobjectmasks));
tmpM1=zeros(size(omaxscore));
tmpM2=zeros(size(omaxscore));
tmpM1(ovalidobjectmasks)=orawscore(cat(3,ovalidobjectmasks,emptyvalid));
tmpM2(ovalidobjectmasks)=orawscore(cat(3,emptyvalid,ovalidobjectmasks));
globalscores=sum(tmpM1,1)./sum(tmpM2,1);
tmpM1=zeros(size(omaxscore));
tmpM2=zeros(size(omaxscore));
tmpM1(ovalidobjectmasks)=orawprecision(cat(3,ovalidobjectmasks,emptyvalid));
tmpM2(ovalidobjectmasks)=orawprecision(cat(3,emptyvalid,ovalidobjectmasks));
globalprecision=sum(tmpM1,1)./sum(tmpM2,1);
tmpM1=zeros(size(omaxscore));
tmpM2=zeros(size(omaxscore));
tmpM1(ovalidobjectmasks)=orawrecall(cat(3,ovalidobjectmasks,emptyvalid));
tmpM2(ovalidobjectmasks)=orawrecall(cat(3,emptyvalid,ovalidobjectmasks));
globalrecall=sum(tmpM1,1)./sum(tmpM2,1);
fprintf(fid,'Global scores per cluster:\n');
for i=2:noallobjects
    fprintf(fid,'%13s = %.6f   %.6f   %.6f\n',textallobjects{i},...
        globalscores(i-1),...
        globalprecision(i-1),...
        globalrecall(i-1) );
end
fprintf(fid,'Global averages (averaged over clusters):\n');
fprintf(fid,'   All objects                = %.6f   %.6f   %.6f\n',...
    mean(globalscores),...
    mean(globalprecision),...
    mean(globalrecall) );



fprintf(fid,'Global averages (not averaged):\n');
fprintf(fid,'   All objects                = %.6f   %.6f   %.6f\n',...
    sum(orawscore(cat(3,ovalidobjectmasks,emptyvalid)))./sum(orawscore(cat(3,emptyvalid,ovalidobjectmasks))),...
    sum(orawprecision(cat(3,ovalidobjectmasks,emptyvalid)))./sum(orawprecision(cat(3,emptyvalid,ovalidobjectmasks))),...
    sum(orawrecall(cat(3,ovalidobjectmasks,emptyvalid)))./sum(orawrecall(cat(3,emptyvalid,ovalidobjectmasks))) );



fprintf(fid,'Legend:\n');
for i=1:noallobjects
    fprintf(fid,'%13s = ',textallobjects{i});
    fprintf(fid,'%8d',allcode(i,:));
    fprintf(fid,'\n');
end



fprintf(fid,'\n\n\n');
fprintf(fid,'Density ( recall[not averaged] x 100 ) = %.2f\n',...
    100*sum(orawrecall(cat(3,ovalidobjectmasks,emptyvalid)))./sum(orawrecall(cat(3,emptyvalid,ovalidobjectmasks)))...
    );
fprintf(fid,'Overall error ( (1-precision[not averaged]) x 100 ) = %.2f\n',...
    100* ( 1 - sum(orawprecision(cat(3,ovalidobjectmasks,emptyvalid)))./sum(orawprecision(cat(3,emptyvalid,ovalidobjectmasks))) ) ...
    );
fprintf(fid,'Average error ( (1-precision[averaged]) x 100 ) = %.2f\n',...
    100* ( 1 - mean(globalprecision) ) ...
    );
fprintf(fid,'Segmentation covering ( Dice_score[not averaged] ) = %.2f\n',...
    sum(orawscore(cat(3,ovalidobjectmasks,emptyvalid)))./sum(orawscore(cat(3,emptyvalid,ovalidobjectmasks)))...
    );
fprintf(fid,'Head count ( number of objects[no background] ) = %d\n',...
    noallobjects-1 ...
    );



fclose(fid);



% svalidobjectmasks=validobjectmasks;
% smaxscore=maxscore; %Dice coefficient
% smaxprecision=maxprecision; %which percentage of the clustered pixels belong to the object
% smaxrecall=maxrecall; %which percentage of pixels from the object have been clustered
% srawscore=rawscore; %2 stands for numerator and denominator
% srawprecision=rawprecision;
% srawrecall=rawrecall;
% 
% save('D:\temp\tmp.mat','svalidobjectmasks','smaxscore','smaxprecision','s
% maxrecall','srawscore','srawprecision','srawrecall');
