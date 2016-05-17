function valid=Getsegmentswithquickshift(basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,...
    noFrames,ucm2filename,printtodisplay,replaceucmanyway,processsomeframes)

if ( (~exist('processsomeframes','var')) || (isempty(processsomeframes)) )
    processsomeframes=[];
end
if ( (~exist('replaceucmanyway','var')) || (isempty(replaceucmanyway)) )
    replaceucmanyway=false;
end
if ( (~exist('printtodisplay','var')) || (isempty(printtodisplay)) )
    printtodisplay=false;
end

ucm2c=cell(1);
valid=true;
count=0;
for i=startNumberforucm2:(noFrames+startNumberforucm2-1)
    count=count+1;
    
    if ( (~isempty(processsomeframes)) && (~ismember(count,processsomeframes)) )
        continue;
    end
    
    %image filename
    imgFile=[basenameforucm2,num2str(i,numberforucm2),closureforucm2];
    if (~exist(imgFile,'file'))
        fprintf('File %s missing\n',imgFile);
        valid=false;
        return;
    end
    
    ucm2f=[ucm2filename.basename,num2str(i+ucm2filename.startNumber-startNumberforucm2,ucm2filename.number_format),ucm2filename.closure];
    
    if ( (exist(ucm2f,'file')) && (~replaceucmanyway) )
        fprintf('Skipping frame %d, already computed\n',i);
        continue;
    end
    

    theimage = imread(imgFile);
    
    kernelsize=1.24;
    maxdist=kernelsize*3;
    ratio=0.06;

    [Iseg,qslabels] = vl_quickseg(theimage, ratio, kernelsize, maxdist); %,map,gaps,E
    fprintf('Number of labels = %d\n',numel(unique(qslabels)));
    
    ucm2c{1}=uint8(zeros(size(qslabels)*2+1));

    ucm2c=Addtoucm2wmex(1,qslabels,ucm2c,size(qslabels,1),size(qslabels,2),1);

    % for regions
    imwrite(ucm2c{1},ucm2f);

    
    % usage example
    if (printtodisplay)

        %read double sized ucm
        ucm2 = imread(ucm2f);

        % convert ucm to the size of the original image
        ucm = ucm2(3:2:end, 3:2:end);

        % get the boundaries of segmentation at scale k in range [1 255]
        k = 1;
        bdry = (ucm >= k);

        % get the partition at scale k without boundaries:
        labels2 = bwlabel(ucm2 < k);
        labels = labels2(2:2:end, 2:2:end);

        Init_figure_no(91);imshow(imgFile);
        Init_figure_no(92);imshow(ucm);
        Init_figure_no(93);imshow(bdry);
        Init_figure_no(94);imshow(labels,[]);colormap(jet);
        
        clear bdry;
        clear labels2;
        clear labels;
        clear ucm;
    end

    fprintf('\n********** Processed frame %d **********\n\n',count);
end

if (printtodisplay)
    close(91);
    close(92);
    close(93);
    close(94);
end


