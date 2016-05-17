function [basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2]=...
    Nameucmfiles(filename_sequence_basename_frames_or_video,cim,additionalname,allowwarping,flows,replacetheucm,printonscreen)
%flows is unnecessary is allowwarping is set to false
%additionalname=colorflowname;
%cim=Rgb;

if ( (~exist('replacetheucm','var')) || (isempty(replacetheucm)) )
    replacetheucm=false;
end

if ( (~exist('allowwarping','var')) || (isempty(allowwarping)) )
    if ( (isfield(filename_sequence_basename_frames_or_video,'wrpbasename')) && (exist('flows','var')) && (isstruct(flows)) )
        allowwarping=true;
    else
        allowwarping=false;
    end
end
if (~exist('additionalname','var'))
    additionalname=[];
end

noFrames=numel(cim);

if ( (isfield(filename_sequence_basename_frames_or_video,'wrpbasename')) || (isfield(filename_sequence_basename_frames_or_video,'corbasename')) )
    numberforucm2=filename_sequence_basename_frames_or_video.wrpnumber_format;
    closureforucm2=filename_sequence_basename_frames_or_video.wrpclosure;
    startNumberforucm2=filename_sequence_basename_frames_or_video.wrpstartNumber;
    if (isfield(filename_sequence_basename_frames_or_video,'wrpbasename')) %warped sequence is generated
        basenameforucm2=[filename_sequence_basename_frames_or_video.wrpbasename,additionalname];
    else %the original sequence is used for the segmentation instead of the warped
        basenameforucm2=[filename_sequence_basename_frames_or_video.corbasename,additionalname];
    end
else
    basenameforucm2=[filename_sequence_basename_frames_or_video.basename,additionalname];
    numberforucm2=filename_sequence_basename_frames_or_video.number_format;
    closureforucm2=filename_sequence_basename_frames_or_video.closure;
    startNumberforucm2=filename_sequence_basename_frames_or_video.startNumber;
end

[wrpcim,wrpvalid]=Readpictureseries(basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,noFrames,printonscreen); %#ok<ASGLU>
clear wrpcim; %the above line is only to verify that the desired warped frames exist
if ( (~wrpvalid) || (replacetheucm) )
    if (allowwarping)
        useinterp=false;
        howmanyframestowarpinbothdirs=2;
        ratios=[];  %in this way default value defined in Getawarpedframenew is used (ratios=[2.25 1.5 1])
        Getwarpedsequence(flows,cim,noFrames,useinterp,basenameforucm2,...
            numberforucm2,closureforucm2,...
            startNumberforucm2,printonscreen,howmanyframestowarpinbothdirs,ratios);
    else
        Writepictureseries(cim,basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,noFrames,printonscreen);
    end
end


