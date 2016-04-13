function Addcurrentimageforrp_withnewaff(cim,ucm2,filename_sequence_basename_frames_or_video,videocorrectionparameters,filenames,additionalmasname,printonscreen,allthesegmentations)
%The function saves the images, cum2 and gt files for further evaluation
%The input is either ucm2 or allthesegmentations (default).
%ucm2 is for image segmentation, allthesegmentations is for video segmentation

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



[labelledgtvideo,nonemptyindex,numbernonempty,numberofobjects]=...
    Getgtvideo(noFrames,filename_sequence_basename_frames_or_video,videocorrectionparameters,printonscreen);
Printthevideoonscreen(labelledgtvideo, printonscreen, 6, false);

%Compute gtucm2 according to the boundaries in labelledgtvideo
ucm2size=[size(labelledgtvideo,1)*2+1,size(labelledgtvideo,2)*2+1];
% ucm2size=size(ucm2{1});
gtucm2=Getsimpleucmfromlabelledvideo(labelledgtvideo,ucm2size,printonscreen);

allgroundtruth=Getallgroundtruthcells(gtucm2,labelledgtvideo,printonscreen);

%Variables to return: allgroundtruth, nonemptyindex, numbernonempty



[sbenchmarkdir,imgDir,gtDir,inDir] = Benchmarkcreatedirsimvid(filenames, additionalmasname);
% [sbenchmarkdir,imgDir,gtDir,inDir] = Benchmarkcreatedirs(filenames, additionalmasname);
%imgDir images (for name listing), gtDir ground truth, inDir ucm2, outDir output



%Write images, ground truth and ucm2 to appropriate directories
Writeforbenchmark(allgroundtruth, cim, ucm2, nonemptyindex, filenames, imgDir, gtDir, inDir, allthesegmentations);



saveallsegmentations=true;
if ( (saveallsegmentations) && (~isempty(allthesegmentations)) )
    save([inDir,'new_allsegs',filenames.casedirname,'.mat'],'allthesegmentations','-v7.3');
    Savethenonemptyindices([inDir,'allindices',filenames.casedirname,'.txt'],nonemptyindex)
end

    
    
%     rmdir(sbenchmarkdir,'s')
%     rmdir(outDir,'s')


% % Videodatasetbench
% USEVIDEOBENCH=true;
% if (USEVIDEOBENCH)
%     
% %     noFrames=numel(cim);
% %     ucm2size=size(ucm2{1});
% %     [labelledgtvideo,nonemptyindex,numbernonempty,numberofobjects]=...
% %         Getgtvideo(noFrames,filename_sequence_basename_frames_or_video,videocorrectionparameters,printonscreen);
% %     gtucm2=Getsimpleucmfromlabelledvideo(labelledgtvideo,ucm2size,printonscreen);
% %     allgroundtruth=Getallgroundtruthcells(gtucm2,labelledgtvideo,printonscreen);
%     allgroundtruthvideobench=Getallgroundtruthcellsvideo(allgroundtruth, printonscreen);
%     bigcim=Createbigimage(cim,nonemptyindex,numbernonempty,printonscreen);
% %     bigucm=Createbigucm(ucm2,nonemptyindex,numbernonempty,printonscreen);
%     bigsegs=Createbigsegs(allthesegmentations, nonemptyindex, numbernonempty, printonscreen);
%     
%     [vidbenchmarkdir,imgviddir,gtviddir,inviddir] = Benchmarkcreatedirsvideobench(filenames, additionalmasname);
%     %imgviddir images (for name listing), gtviddir ground truth, inviddir ucm2, outviddir output
% 
%     %Write images, ground truth and ucm2 to appropriate directories
%     Writeforbenchmarkvideobench(allgroundtruthvideobench, bigcim, bigsegs, filenames, imgviddir, gtviddir, inviddir, numbernonempty);
% end



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
