function Prepareandcomputebroxmalikerror(filename_sequence_basename_frames_or_video,filenames,noFrames,videocorrectionparameters,outputfilename,deffilename)
% Prepareandcomputebroxmalikerror(filename_sequence_basename_frames_or_video,filenames,noFrames,videocorrectionparameters)
%Evaluating without the background using the same ground truth a 1 must be
%removed from the computed results for the oversegmentation error (provided
%that all labels on the background are re-labelled to the same label)

if (~exist('outputfilename','var') || (isempty(outputfilename)) )
    outputfilename=[filenames.filename_directory,'Tracks',num2str(noFrames,'%d'),'generated.dat'];
end
if (~exist('deffilename','var') || (isempty(deffilename)) )
    if (isfield(filename_sequence_basename_frames_or_video,'def'))
        deffilename=filename_sequence_basename_frames_or_video.gtdef;
    else
        deffilename=[filenames.filename_directory,'gtimages',filesep,'cars1Def.dat'];
    end
end

%Prepare parameters
printonscreeninsidefunction=false;
framestoconsider=1:noFrames;

%Read the ground truth video sequence or the frames
gtimages=Readpictureseries(filename_sequence_basename_frames_or_video.gtbasename,...
    filename_sequence_basename_frames_or_video.gtnumber_format,filename_sequence_basename_frames_or_video.gtclosure,...
    filename_sequence_basename_frames_or_video.gtstartNumber,noFrames,printonscreeninsidefunction);
gtimages=Adjustimagesize(gtimages,videocorrectionparameters,printonscreeninsidefunction,true);
if (printonscreeninsidefunction)
    close all;
end
consideredgtimages=gtimages(framestoconsider);


%Determine image size
for i=1:noFrames
    if (isempty(consideredgtimages{i}))
        continue;
    else
        oneimage=consideredgtimages{i}(:,:,1);
        theimagesize=size(oneimage);
        break;
    end
end




%Fill in ground truth and form labelled video
labelledvideo=zeros(theimagesize(1),theimagesize(2),noFrames);

colourcode=cell(0);
nocolourcodes=0;
notraj=0;
fprintf('Forming labelledvideo, processed frames:');
for i=1:noFrames
    if isempty(consideredgtimages{i})
        labelledvideo(:,:,i)=1; %fictitious image label
        notraj=notraj+theimagesize(1)*theimagesize(2);
    else
        oneimage=consideredgtimages{i};
        for jj=1:theimagesize(2)
            for ii=1:theimagesize(1)
                theassignedlabel=Findthecolour(oneimage(ii,jj,:),colourcode);
                if (theassignedlabel==0)
                    nocolourcodes=nocolourcodes+1;
                    colourcode{nocolourcodes}=oneimage(ii,jj,:);
                    theassignedlabel=nocolourcodes;
                end
                labelledvideo(ii,jj,i)=theassignedlabel;
                notraj=notraj+1;
            end
        end
    end
    fprintf(' %d',i);
end
fprintf('\n');
fprintf('%d trajectories discovered, %d labels identified\n',notraj, numel(colourcode));


%Write labelledvideo to file using the format of BroxMalikECCV10
Writeblabelledvideo(labelledvideo,outputfilename);


if (~ispc)
    if (~isdir('UCM'))
        fprintf('Please set your directory to the main folder\n');
        return;
    else
%         system( ['UCM',filesep,'Aggregation',filesep,'Quantitative',filesep,'Broxcode',...
%             filesep,'MoSegEval ',sprintf('%s %s', deffilename, outputfilename)] );
%         supposedoutputfile=[filenames.filename_directory,'Tracks',num2str(noFrames,'%d'),'generatedNumbers.txt'];
% 
%         if (~exist(supposedoutputfile,'file'))
            system( ['chmod u+x UCM',filesep,'Aggregation',filesep,'Quantitative',filesep,'Broxcode',...
            filesep,'MoSegEval'] );
            system( ['UCM',filesep,'Aggregation',filesep,'Quantitative',filesep,'Broxcode',...
                filesep,'MoSegEval ',sprintf('%s %s', deffilename, outputfilename)] );
%         end
    end
end


function Updatenotrajectoriesprint(outputfilename,noFrames,notraj) %#ok<DEFNU>

%Need to reopen filename to update the number of trajectories
fid=fopen(outputfilename,'rt+');
fprintf(fid,'%d\n%013d\n',noFrames,notraj);
fclose(fid);


%Just to check
fprintf('First 20 lines of %s file\n',outputfilename);
fid=fopen(outputfilename,'rt');
for i=1:20
    tline = fgetl(fid);
    fprintf('%s\n',tline);
end
fclose(fid);


function Comparethefiles() %#ok<DEFNU>

outputfilename=[filenames.filename_directory,'Tracks',num2str(noFrames,'%d'),'generated.dat'];
outputfilename2=[filenames.filename_directory,'Tracks',num2str(noFrames,'%d'),'generated_prev.dat'];

%Just to check
fid=fopen(outputfilename,'rt');
fid2=fopen(outputfilename2,'rt');
terminated=false;
terminated2=false;
while (true)
    tline = fgetl(fid);
    tline2 = fgetl(fid2);
    
    if ( (numel(tline)==1) && (tline==-1) )
        terminated=true;
    end
    if ( (numel(tline2)==1) && (tline2==-1) )
        terminated2=true;
    end
    
    if (terminated && terminated2)
        fprintf('Comparison completed successfully\n');
        break;
    end
    
    if (~strcmp(tline,tline2))
        fprintf('Found difference:\n %s\n %s\n',tline,tline2);
        break;
    end
    
    if (terminated || terminated2)
        break;
    end
end
fclose(fid);
fclose(fid2);


function Scripts_run_brox() %#ok<DEFNU>
% ./MoSegEval cars1/cars1Def.dat /BS/galasso_proj_spx/work/VideoProcessingTemp/Carsone/Tracks19generated.txt
% ./MoSegEval cars1/cars1Def.dat cars1/BroxMalikResults/Tracks19.dat
% ./MoSegEval cars1/cars1Defnb.dat /BS/galasso_proj_spx/work/VideoProcessingTemp/Carsone/Tracks19generated.dat
%
% chmod u+x *
% ./conv2ppm
% ./motionsegBM cars1/cars1.bmf 0 19 8
% ./runBroxMalikOnDataset
% ./MoSegEval cars1/cars1Def.dat cars1/BroxMalikResults/Tracks19.dat

