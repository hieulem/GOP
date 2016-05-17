function valid=Writepictureseries(cim,basename,numberformat,nameclosure,startnumber,noFrames,printonscreen,printthetextonscreen)
%The function sets valid to false if some frames are missing
% Related functions: Printthevideoonscreen, Readpictureseries

if ( (~exist('printthetextonscreen','var')) || (isempty(printthetextonscreen)) )
    printthetextonscreen=false;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

valid=true;
count=0;
numberofmissing=[];
for i=startnumber:(noFrames+startnumber-1)
    count=count+1;
    picture_each_filename=[basename,num2str(i,numberformat),nameclosure];
    
    imwrite(cim{count},picture_each_filename);
    
    if (~exist(picture_each_filename,'file'))
        fprintf('File %s not written\n',picture_each_filename);
        valid=false;
        numberofmissing=[numberofmissing,num2str(i,numberformat),', ']; %#ok<AGROW>
        continue;
    end

    if (printonscreen)
        figure(10), imshow(cim{count})
        set(gcf, 'color', 'white');
        title( ['Image at frame ',num2str(count)] );
    end
end

if (printthetextonscreen)
    fprintf('Picture serie written (valid %d)\n',valid);
    if (~isempty(numberofmissing))
        picture_each_filename=[basename,num2str(0,numberformat),nameclosure];
        fprintf('Missing files with format: %s\n',picture_each_filename);
        fprintf('Relative file numbers: %s\n',numberofmissing(1:end-2));
    end
end




% function test_this()
% 
% basename=filename_sequence_basename_frames_or_video.gtbasename;
% numberformat=filename_sequence_basename_frames_or_video.gtnumber_format;
% nameclosure=filename_sequence_basename_frames_or_video.gtclosure;
% startnumber=filename_sequence_basename_frames_or_video.gtstartNumber+12;
% noFrames=122;
% valid=Writepictureseries(gtimages,basename,numberformat,nameclosure,startnumber,noFrames,1,1);