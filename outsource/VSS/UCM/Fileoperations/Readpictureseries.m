function [picturecell,valid,nfigure]=Readpictureseries(basename,numberformat,nameclosure,startnumber,noFrames,printonscreen,readfunc)
%The function sets valid to false if some frames are missing
% Related functions: Writepictureseries, Printthevideoonscreen

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('readfunc','var')) || (isempty(readfunc)) )
    readfunc=@imread;
end

nfigure=10;

if (printonscreen)
    Init_figure_no(nfigure);
end

valid=true;
picturecell=cell(1,noFrames);
count=0;
numberofmissing=[];
for i=startnumber:(noFrames+startnumber-1)
    count=count+1;
    picture_each_filename=[basename,num2str(i,numberformat),nameclosure];
    
    if (~exist(picture_each_filename,'file'))
%         fprintf('File %s missing\n',picture_each_filename);
        numberofmissing=[numberofmissing,num2str(i,numberformat),', ']; %#ok<AGROW>
        valid=false;
        continue;
    end

    try
        picturecell{count}=readfunc(picture_each_filename);
    catch EEE %#ok<NASGU>
        fprintf('Imread could not load the image\n');
        numberofmissing=[numberofmissing,num2str(i,numberformat),', ']; %#ok<AGROW>
        valid=false;
        continue;
    end
    
    if (printonscreen)
        figure(nfigure), imshow(picturecell{count});
        title( ['Image at frame ',num2str(count)] );
        pause(0.1);
    end
end

if (~isempty(numberofmissing))
    picture_each_filename=[basename,num2str(0,numberformat),nameclosure];
    fprintf('Missing files with format: %s\n',picture_each_filename);
    fprintf('Relative file numbers: %s\n',numberofmissing(1:end-2));
end


