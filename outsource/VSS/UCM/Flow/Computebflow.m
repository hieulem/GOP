function [flows,filename_sequence_basename_frames_or_video]=Computebflow(filename_sequence_basename_frames_or_video,flows,noFrames,cim,filenames)


if (  ( (~isfield(filename_sequence_basename_frames_or_video,'bflowdir')) || (isempty(filename_sequence_basename_frames_or_video.bflowdir)) ||...
    (~exist(filename_sequence_basename_frames_or_video.bflowdir,'dir')) )  &&  (~ispc)  ) %Flow files to be computed
    
%     if (  ( (~isfield(filename_sequence_basename_frames_or_video,'btracksfile')) || (isempty(filename_sequence_basename_frames_or_video.btracksfile)) ||...
%         (~exist(filename_sequence_basename_frames_or_video.btracksfile,'file')) )...
%             &&  (~ispc)  )
        filename_sequence_basename_frames_or_video=Blongtracks(filename_sequence_basename_frames_or_video,noFrames,filenames,cim);
%     else
%         fprintf('Tracks present flowfiles not, or pc\n');
%         return;
%     end

    if ( (~isfield(filename_sequence_basename_frames_or_video,'bflowdir')) || (isempty(filename_sequence_basename_frames_or_video.bflowdir)) ||...
            (~exist(filename_sequence_basename_frames_or_video.bflowdir,'dir')) )
        fprintf('Computation of flows with brox otpical flow algorithm');
        return;
    end
end

% bflowfile='ForwardFlow000.flo';
% filename_sequence_basename_frames_or_video.bflowdir
% img = readFlowFile([filename_sequence_basename_frames_or_video.bflowdir,bflowfile]);
% writeFlowFile(img, '1ForwardFlow000.flo');
% colorTest();
% Init_figure_no(1), imagesc(img(:,:,1)/max(max(img(:,:,1))))
% Init_figure_no(1), imagesc(img(:,:,2)/max(max(img(:,:,2))))

%we assume all directories containing optical flow outputs have this filename at least
basename=[filename_sequence_basename_frames_or_video.bflowdir,'ForwardFlow'];
number_format='%03d';
closure='.flo';
startNumber=0;
[forwardf,isvalid]=Readpictureseries(basename,number_format,closure,startNumber,noFrames-1,false,@readFlowFile);

basename=[filename_sequence_basename_frames_or_video.bflowdir,'BackwardFlow'];
[backwardf,isvalida]=Readpictureseries(basename,number_format,closure,startNumber,noFrames-1,false,@readFlowFile);

isvalid=isvalid&isvalida;

if (~isvalid)
    fprintf('Optical flow computation\n');
    return;
end


rows=size(forwardf{1},1);
cols=size(forwardf{1},2);

[U,V]=meshgrid(1:cols,1:rows); %pixel coordinates

for frame=1:noFrames
    
    if frame>1
        flowMinus=backwardf{frame-1};
        Um=U+flowMinus(:,:,1);
        Vm=V+flowMinus(:,:,2);
    else
        Um=U;
        Vm=V;
    end
    if frame<noFrames
        flowPlus=forwardf{frame};
        Up=U+flowPlus(:,:,1);
        Vp=V+flowPlus(:,:,2);
    else
        Up=U;
        Vp=V;
    end
    
    flows.flows{frame}.Um=Um;
    flows.flows{frame}.Vm=Vm;
    flows.flows{frame}.Up=Up;
    flows.flows{frame}.Vp=Vp;

    flows.whichDone(frame)=1; %sets the flag to not repeat the operation

end

if (false)
    Getmainmenu(filenames,cim,ucm2,flows);
end

