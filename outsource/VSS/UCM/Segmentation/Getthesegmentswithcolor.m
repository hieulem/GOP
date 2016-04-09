function valid=Getthesegmentswithcolor(basenameforucm2,numberforucm2,closureforucm2,startNumberforucm2,...
    noFrames,ucm2filename,printtodisplay,basenameforcolor,numberforcolor,closureforcolor,startNumberforcolor,...
    replaceucmanyway,processsomeframes,saveworkfiles,saveworkimages)
% DESCRIPTION:
%   Code to compute globalPb and hierarchical regions, as described in:
%
%   P. Arbelaez, M. Maire, C. Fowlkes and J. Malik. 
%   From Contours to Regions: An Empirical Evaluation. CVPR 2009.
%
%   M. Maire, P. Arbelaez, C. Fowlkes and J. Malik. 
%   Using Contours to Detect and Localize Junctions in Natural Images. CVPR
%   2008.
% 
% WARNINGS:
%   This code is still under development and testing. It is being distributed on its
%   present form for educational and research purposes only. The final public
%   release will probably be different. 
%
%   If you use any portion of this code, please acknowledge our work by
%   citing the two papers above.
%
%   Please report any bugs or improvements to the address below.
%
%   latest version : April 1st 2009
%
%   Pablo Arbelaez.
%   <arbelaez@eecs.berkeley.edu>

% DIRECTIONS: 
%  unzip and update the absolute path in the file lib/spectralPb.m
% 

if ( (~exist('processsomeframes','var')) || (isempty(processsomeframes)) )
    processsomeframes=[];
end
if ( (~exist('replaceucmanyway','var')) || (isempty(replaceucmanyway)) )
    replaceucmanyway=false;
end
if ( (~exist('printtodisplay','var')) || (isempty(printtodisplay)) )
    printtodisplay=false;
end
if ( (~exist('saveworkimages','var')) || (isempty(saveworkimages)) )
    saveworkimages=false;
end
if ( (~exist('saveworkfiles','var')) || (isempty(saveworkfiles)) )
    saveworkfiles=false;
end


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
    
    %color image from flow filename
    icolor=i-startNumberforucm2+startNumberforcolor;
    colorFile=[basenameforcolor,num2str(icolor,numberforcolor),closureforcolor];
    if (~exist(colorFile,'file'))
        fprintf('File %s missing\n',colorFile);
        valid=false;
        return;
    end

    %output filenames
    outFile=[ucm2filename.basename,num2str(i+ucm2filename.startNumber-startNumberforucm2,ucm2filename.number_format),'_gPb.mat'];
    ucmf=[ucm2filename.basename,num2str(i+ucm2filename.startNumber-startNumberforucm2,ucm2filename.number_format),'_ucm.bmp'];
    ucm2f=[ucm2filename.basename,num2str(i+ucm2filename.startNumber-startNumberforucm2,ucm2filename.number_format),ucm2filename.closure];
    
    if ( (exist(ucm2f,'file')) && (~replaceucmanyway) )
        fprintf('Skipping frame %d, already computed\n',i);
        continue;
    end
    
    %%% compute globalPb %%%
    rsz = 1.0;

    printthetextonscreen=false;
    [gPb_orient, gPb_thin, textons] =Globalpbcolornadd(imgFile, colorFile, outFile, rsz, count, saveworkimages, printthetextonscreen);
    if (~saveworkfiles)
        delete(outFile);
    end
    clear gPb_thin;
    clear textons;
    %load('/BS/galasso_proj_spx/work/VideoProcessingTemp/Syntheticai/ucm2images/ucm2image00_gPb.mat');
    %Init_figure_no(20), imshow(max(gPb_orient,[],3))
    %Init_figure_no(21), imshow(cim{1})
    %Init_figure_no(22), imshow(gPb_thin)
    %Init_figure_no(23), imshow(ucm2{1})
    
    
    %%% compute Hierarchical Regions %%%
%     load(outFile,'gPb_orient');
    % load data/101087_gPb.mat gPb_orient

    
    % for boundaries
    ucm = contours2ucm(gPb_orient, 'imageSize');
    if (saveworkfiles)
        imwrite(ucm,ucmf);
    end
    

    % for regions
    ucm2 = contours2ucm(gPb_orient, 'doubleSize');
    imwrite(ucm2,ucm2f);

    
    % usage example
    if (printtodisplay)

        %read double sized ucm
        ucm2 = imread(ucm2f);

        % convert ucm to the size of the original image
        ucm = ucm2(3:2:end, 3:2:end);

        % get the boundaries of segmentation at scale k in range [1 255]
        k = 100;
        bdry = (ucm >= k);

        % get the partition at scale k without boundaries:
        labels2 = bwlabel(ucm2 <= k);
        labels = labels2(2:2:end, 2:2:end);

        figure(91);imshow(imgFile);
        figure(92);imshow(ucm);
        figure(93);imshow(bdry);
        figure(94);imshow(labels,[]);colormap(jet);
        
        clear bdry;
        clear labels2;
        clear labels;
    end

    clear gPb_orient;
    clear ucm;
    clear ucm2;
    
    fprintf('\n********** Processed frame %d **********\n\n',count);
end



