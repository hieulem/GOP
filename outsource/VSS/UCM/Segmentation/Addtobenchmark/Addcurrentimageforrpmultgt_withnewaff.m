function Addcurrentimageforrpmultgt_withnewaff(cim,ucm2,filename_sequence_basename_frames_or_video,videocorrectionparameters,filenames,additionalmasname,printonscreen,allthesegmentations,neglectgt)
%The function saves the images, cum2 and gt files for further evaluation
%The input is either ucm2 or allthesegmentations (default).
%ucm2 is for image segmentation, allthesegmentations is for video segmentation

if ( (~exist('neglectgt','var')) || (isempty(neglectgt)) )
    neglectgt=[];
end
if ( (~exist('allthesegmentations','var')) || (isempty(allthesegmentations)) )
    allthesegmentations=[];
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('additionalmasname','var')) || (isempty(additionalmasname)) )
    additionalmasname='Ucm';
end

%Prepare parameters
noFrames=numel(cim);



[sbenchmarkdir,imgDir,gtDir,inDir] = Benchmarkcreatedirsimvid(filenames, additionalmasname); %#ok<ASGLU>
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output



saveallsegmentations=true;
if ( (saveallsegmentations) && (~isempty(allthesegmentations)) )
    save([inDir,'new_allsegs',filenames.casedirname,'.mat'],'allthesegmentations','-v7.3');
%     Savethenonemptyindices([inDir,'allindices',filenames.casedirname,'.txt'],nonemptyindex)
end

    
    
ntoreadmgt=Inf; %1, 2, .. Inf number of gts to read
maxgtframes=Inf; %Limit max frame for gt (impose same test set)
[labelledgtvideo,nonemptygt]=Getmultgtlabvideo(noFrames,filename_sequence_basename_frames_or_video,videocorrectionparameters,ntoreadmgt,maxgtframes,printonscreen); %,numberofobjects,numbernonempty
%labelledgtvideo{ which gt annotation , which frame } = dimIi x dimIj double (the labels, 0 others, -1 neglect)
if (isempty(labelledgtvideo))
    fprintf('GT Images missing, required benchmark not created\n');
    return;
end
if (~isempty(neglectgt))
    labelledgtvideo(neglectgt,:)=[];
    nonemptygt(neglectgt,:)=[];
    if (isempty(labelledgtvideo))
        error('Remaining GT is empty');
    end
end
if (printonscreen)
    for mid=1:size(labelledgtvideo,1)
        Printthevideoonscreen(labelledgtvideo(mid,:), printonscreen, 10, false, true,[],[]);
    end
end

%Compute gtucm2 according to the boundaries in labelledgtvideo
[firstnonemptymid,firstnonemptyfid]=find(nonemptygt,1,'first');
dimi=size(labelledgtvideo{firstnonemptymid,firstnonemptyfid},1);
dimj=size(labelledgtvideo{firstnonemptymid,firstnonemptyfid},2);
ucm2size=[dimi*2+1,dimj*2+1];
gtucm2=cell(size(labelledgtvideo,1),size(labelledgtvideo,2));
% ucm2size=size(ucm2{1});
for mid=1:size(labelledgtvideo,1)
    for f=1:size(labelledgtvideo,2)
        if (~nonemptygt(mid,f)) %(isempty(multgts{mid}{f}))
            continue;
        end
        gtucm2(mid,f)=Getsimpleucmfromlabelledvideo(labelledgtvideo{mid,f},ucm2size,printonscreen);
    end
end
for mid=1:size(labelledgtvideo,1)
    Printthevideoonscreen(gtucm2(mid,:), printonscreen, 10, false, true,[],[]);
end

allgroundtruth=Getallgroundtruthcellsmultgt(gtucm2,labelledgtvideo,nonemptygt,printonscreen);

%Variables to generate: allgroundtruth, nonemptygt



%Write images, ground truth and ucm2 to appropriate directories
Writetobenchmarkmultgt(allgroundtruth, cim, ucm2, nonemptygt, filenames, imgDir, gtDir, inDir, allthesegmentations);



%     rmdir(sbenchmarkdir,'s')
%     rmdir(outDir,'s')








function Othercode(ucm2) %#ok<DEFNU>

%%% Procedure to label the video with the ground truth according to the ucm2 superpixels

%Prepare parameters
noFrames=numel(cim);

Level=1;
labelledvideo=Labellevelframes(ucm2,Level,noFrames,printonscreen);
Printthevideoonscreen(labelledvideo, printonscreen, 11, true);

[mapped]=Mappedfromlabels(labelledvideo,printonscreen); %,framebelong,noalllabels,maxnolabels

labelsgt=Labelsfromgt(filename_sequence_basename_frames_or_video,mapped,ucm2,...
    videocorrectionparameters,printonscreen);

labelledvideo=Labelclusteredvideointerestframes(mapped,labelsgt,ucm2,Level,[],printonscreen);
% Printthevideoonscreen(labelledvideo, true, 6, true);



%%%Procedure to determine a new cell array gtimages
newgtimages=cell(1,numel(gtimages));
for f=1:noFrames
    newgtimages{f}=[];
end
count=0;
for f=find(nonemptygt)
    startpos=numberofpixels*count+1;
    endpos=startpos-1+numberofpixels;
    count=count+1;
    
    animage=zeros(dimi,dimj);
    animage(:)=thenewrow(startpos:endpos);
    newgtimages{f}=animage;
end
%Visualization of newgtimages
Init_figure_no(10)
for f=1:numel(newgtimages)
    agtimage=newgtimages{f};
    if (~isempty(agtimage))
        agtimage(1,1)=1;
        agtimage(1,2)=numberofcolors;
        imagesc(agtimage);
    end
    title(['frame ',num2str(f)]);
    pause(0.1);
end



%%%Procedure to get ucm2 variables from the labelledvideo
%Initialisation
gtucm2=cell(1,noFrames);
for f=1:noFrames
    gtucm2{f}=uint8(zeros(size(ucm2{1})));
end
gtucm2=Addtoucm2wmex(1:noFrames,labelledvideo,gtucm2,size(labelledvideo,1),size(labelledvideo,2),noFrames);
% for ff=1:noFrames
%     gtucm2=Addtoucm2wmex(ff,labelledvideo,gtucm2,size(labelledvideo,1),size(labelledvideo,2),1);
% end

Init_figure_no(10)
for f=1:noFrames
    imagesc(gtucm2{f})
    pause(0.1)
end

%Prepare output format
for f=1:noFrames
    %The size is reduced to the image size and the edges kept
    gtucm2{f}=gtucm2{f}(3:2:end, 3:2:end);
end

Init_figure_no(10)
for f=1:noFrames
    imagesc(gtucm2{f})
    pause(0.1)
end
