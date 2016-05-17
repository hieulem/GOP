function STT=Getshortterm_cpp_friendly(labelledlevelvideo, mapped, flows, graphdepth, multcount, options, theoptiondata, filenames)
%for inverse mapping
%[frame,label]=find(mapped==indexx);

%paper options:
% options.sttuexp=false; options.sttlambd=1; options.sttsqv=false;

%optimized options (default):
% options.sttuexp=false; options.sttlambd=1; options.sttsqv=false;



if ( (~exist('graphdepth','var')) || (isempty(graphdepth)) )
    graphdepth=2;
end
if ( (~exist('multcount','var')) || (isempty(multcount)) )
    multcount=1.5; %or 2, meaning a more central frame is counted multcount time the adjacent
                    %1 means that all adjacent frames are given the same
                    %importance, no matter how close they are to the
                    %central frame
end



printonscreen=false;

noFrames=size(labelledlevelvideo,3);
maxnumberofsuperpixelsperframe=max(labelledlevelvideo(:));

% dim = size(ucm2{1}(2:2:end, 2:2:end));
% dimIi=dim(1);
% dimIj=dim(2);

% [X,Y]=meshgrid(1:dimIj,1:dimIi);



noallsuperpixels=max(mapped(:));



% averageconnectionthrough=5; estimateofterms=floor(noallsuperpixels*(averageconnectionthrough^graphdepth)/2);
% map.reserve(estimateofterms )
%%%* sizeof(double)

USECPPIMPLEMENTATION=true;
if (USECPPIMPLEMENTATION)
    
    % % ------------CPP Implementation--------------------------------------
    % % **********************************************************************
    [syo,sxo,svo]=STT_cppfriendly(graphdepth,noFrames,labelledlevelvideo,multcount,maxnumberofsuperpixelsperframe,flows,mapped);
    % % --------------------------------------------------------------------
    
else

    % % ------------Matlab Implementation--------------------------------------
    % % Comment this block when using the CPP Code---------------------------
    
    similarity=sparse(noallsuperpixels,noallsuperpixels);
    similaritydone=sparse(noallsuperpixels,noallsuperpixels);
    
    for frame=1:(noFrames-1)
        
        labelsonone = labelledlevelvideo(:,:,frame);
    %     labels2 = bwlabel(ucm2{frame} < Level);
    %     labelsonone = labels2(2:2:end, 2:2:end);
        nolabelsone=max(max(labelsonone));
        
        masksonframe=false(size(labelsonone,1),size(labelsonone,2),nolabelsone);
        for label=1:nolabelsone
            masksonframe(:,:,label)=(labelsonone==label);
        end
        
        importanceforprobability=1; %value is decreased by multcount in successive graphdepths
        firstframe=true;
        
        for frameup=(frame+1):  (  min( (frame+graphdepth) , noFrames )  )
            atdepth=frameup-frame;
            
            labelsontwo = labelledlevelvideo(:,:,frameup);
    %         labels2 = bwlabel(ucm2{frameup} < Level);
    %         labelsontwo = labels2(2:2:end, 2:2:end);
    %         nolabelstwo=max(max(labelsontwo));
    
            if (firstframe)
                firstframe=false;
            else
                importanceforprobability=importanceforprobability/multcount;
            end
    
            for label=1:nolabelsone
                
                themask=masksonframe(:,:,label);
        %         Init_figure_no(2), imagesc(themask);
                predictedMask=Evolveregionsfastwithfilteredflows(themask,flows.flows{frame},printonscreen);
                if (graphdepth>1)
                    masksonframe(:,:,label)=(predictedMask>0.5); %update masksonframe for next graph depth
                end
        %         Init_figure_no(3), imagesc(predictedMask);
                interestedpixels=(predictedMask>0);
    
                interestedlabels=unique(labelsontwo(interestedpixels));
    
                for il=interestedlabels'
    
                    maskontwo=(labelsontwo==il);
    
    %                 shapesimilarity=Measuremaxsimilaritywmex(maskontwo,predictedMask,false);
                    shapesimilarity=Measuresimilaritymex(maskontwo,predictedMask,false);
        %             shapesimilarity=Measuresimilarity(maskontwo,predictedMask,0);
                    %similarity_out_pixels=Measureoutpixelswithmex(mask2,predictedMask,false); _number of pixels outside
                    %similarity_out_pixels=Measureoutpixels(mask2,predictedMask,0); _number of pixels outside
                    
                    globlabel=mapped(frame,label);
                    globil=mapped(frameup,il);
                    
                    similarity(globlabel,globil)=shapesimilarity*importanceforprobability;
                    similarity(globil,globlabel)=similarity(globlabel,globil);
                    
                    similaritydone(globlabel,globil)=true;
                    similaritydone(globil,globlabel)=true;
                end
            end
        end
        
    end
    
    %Get the graph from similaritydone and the value from similarity
    [sxo, syo, svo]=find(similaritydone);
    svo=similarity(sub2ind(size(similarity),sxo,syo));
    
%     [sxo, syo, svo]=find(similarity); %This version does not report the affinities defined zero

    % % --------------------------------------------------------------------------------------------

end



% similarity=sparse(sxo,syo,svo,noallsuperpixels,noallsuperpixels);

STT=Getsttfromindexedrawvalues(sxo, syo, svo, noallsuperpixels, options);
% figure(5), imagesc(STT)



%Add data to paramter calibration directory
if ( (isfield(options,'calibratetheparameters')) && (~isempty(options.calibratetheparameters)) && (options.calibratetheparameters) )
    thiscase='stt';
    printonscreenincalibration=false;
    Addthisdataforparametercalibration([sxo;syo],[syo;sxo],[svo;svo],thiscase,theoptiondata,filenames,noallsuperpixels,printonscreenincalibration);
end


%To test that in flow U and V are actually X and Y
% [X,Y]=meshgrid(1:dimIj,1:dimIi);
% thefl.Up=ones(dimIi,dimIj)*3+X;
% thefl.Vp=ones(dimIi,dimIj)*1.5+Y;
% thefl.Vm=ones(dimIi,dimIj)*(-1.5)+Y;
% thefl.Um=ones(dimIi,dimIj)*(-3)+X;
% maskk=false(dimIi,dimIj);
% maskk(4:40,5:50)=true;
% maskk(41:60,5:20)=true;
% Init_figure_no(1), imagesc(maskk);
% predictedMask=Evolveregionsfastwithfilteredflows(maskk,thefl,false);
% Init_figure_no(2), imagesc(predictedMask);




