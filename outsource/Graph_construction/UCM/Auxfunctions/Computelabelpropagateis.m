function [allthesegmentations,propagated]=Computelabelpropagateis(cim,ucm2,flows,nthresh,threinit,reinitateachframe,printonscreen)



if ( (~exist('reinitateachframe','var')) || (isempty(reinitateachframe)) )
    reinitateachframe=false;
end
if ( (~exist('threinit','var')) || (isempty(threinit)) )
    threinit=0.0;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('nthresh','var')) || (isempty(nthresh)) )
    nthresh=51; %nthresh=3;
end
thresh = 255*linspace(1/(nthresh+1),1-1/(nthresh+1),nthresh)';

noFrames=numel(cim);
dimi=size(cim{1},1);
dimj=size(cim{1},2);

midframe=round((noFrames-1)/2)+1;

%Init the relevant structure to collect all VS
allthesegmentations=cell(1,nthresh);
for t=1:nthresh
    allthesegmentations{t}=zeros(dimi,dimj,noFrames);
end
maxlab=zeros(nthresh,1);
for t=1:nthresh
    %Compute superpixels t at the frame
    labels2 = bwlabel(ucm2{midframe} <= thresh(t));
%     seg = upsampleEdges(labels2);
    seg = labels2(2:2:end, 2:2:end);
    allthesegmentations{t}(:,:,midframe)=seg;
    maxlab(t)=max(seg(:));
    if (printonscreen)
        Init_figure_no(1), imagesc(allthesegmentations{t}(:,:,midframe))
        Printthevideoonscreen(allthesegmentations{t},true,1,false,true);
        %(thevideo, printonscreen, nofigure, toscramble, showcolorbar, writethevideo,treatoutliers,outputfile,printthetext)
    end
end
propagated=allthesegmentations;
% Printthevideoonscreen(propagated{t},true,1,false,true);

useinterp=false;
validtopm=cell(1,nthresh);
for t=1:nthresh
    validtopm{t}=true(dimi,dimj);
end
fprintf('Processing frames forward:');
for ff=midframe+1:noFrames
    fprintf(' %d',ff);

    for t=1:nthresh

        %Compute superpixels t at the frame
        labels2 = bwlabel(ucm2{ff} <= thresh(t));
        seg = labels2(2:2:end, 2:2:end);

        %Propagate labels from previous frame
        istoup=true;
        if (istoup)
            prevff=ff-1;
            theflow=cat(3,flows.flows{ff}.Um,flows.flows{ff}.Vm);
        else
            prevff=ff+1;
            theflow=cat(3,flows.flows{ff}.Up,flows.flows{ff}.Vp);
        end
        
        prevseg=propagated{t}(:,:,prevff);
        % Init_figure_no(1), imagesc(seg)
        % Init_figure_no(1), imagesc(prevseg)
        [propseg,validtopm{t}]=Getawarpedsingleimage(theflow,prevseg,useinterp,validtopm{t});
        % Init_figure_no(1), imagesc(propseg)
        % Init_figure_no(1), imagesc(newseg)
        % Init_figure_no(1), imagesc(validtopm{t})
        
        %Set to zeros the non valid pixels
        propseg(~validtopm{t})=0;

        
        alllabels=reshape(unique(seg),1,[]);
        newseg=zeros(size(seg));
        for j=alllabels

            %Compute the superpixel labels
            propatlabel=propseg(seg==j);
            % Init_figure_no(1), imagesc(seg==j)
            
            [mm,freq]=mode(propatlabel);
            
            if ( (mm~=0) && ((freq/numel(propatlabel))>threinit) )
                newseg(seg==j)=mm;
            else
                %Re-initialize labels at superpixels covered less than threshold in percentage by a label (alternatively consider minimum cover and entropy)
                maxlab(t)=maxlab(t)+1;
                newseg(seg==j)=maxlab(t);
            
                propseg(seg==j)=maxlab(t); %re-initialize a new label to propagate
                validtopm{t}(seg==j)=true; %re-instate valid variable to true
            end
        end
        %Copy the re-initialized labels to the propagated labels frame
        if (reinitateachframe)
            propagated{t}(:,:,ff)=newseg;
        else
            propagated{t}(:,:,ff)=propseg;
        end
        allthesegmentations{t}(:,:,ff)=newseg;
    end
end
fprintf('\n');
%Iterate in the opposite direction
for t=1:nthresh
    validtopm{t}=true(dimi,dimj);
end
fprintf('Processing frames backward:');
for ff=midframe-1:-1:1 %Changed from upward iteration
    fprintf(' %d',ff);

    for t=1:nthresh

        %Compute superpixels t at the frame
        labels2 = bwlabel(ucm2{ff} <= thresh(t));
        seg = labels2(2:2:end, 2:2:end);

        %Propagate labels from previous frame
        istoup=false; %Changed from upward iteration
        if (istoup)
            prevff=ff-1;
            theflow=cat(3,flows.flows{ff}.Um,flows.flows{ff}.Vm);
        else
            prevff=ff+1;
            theflow=cat(3,flows.flows{ff}.Up,flows.flows{ff}.Vp);
        end
        
        prevseg=propagated{t}(:,:,prevff);
        % Init_figure_no(1), imagesc(seg)
        % Init_figure_no(1), imagesc(prevseg)
        [propseg,validtopm{t}]=Getawarpedsingleimage(theflow,prevseg,useinterp,validtopm{t});
        % Init_figure_no(1), imagesc(propseg)
        % Init_figure_no(1), imagesc(newseg)
        % Init_figure_no(1), imagesc(validtopm{t})
        
        %Set to zeros the non valid pixels
        propseg(~validtopm{t})=0;

        
        alllabels=reshape(unique(seg),1,[]);
        newseg=zeros(size(seg));
        for j=alllabels

            %Compute the superpixel labels
            propatlabel=propseg(seg==j);
            % Init_figure_no(1), imagesc(seg==j)
            
            [mm,freq]=mode(propatlabel);
            
            if ( (mm~=0) && ((freq/numel(propatlabel))>threinit) )
                newseg(seg==j)=mm;
            else
                %Re-initialize labels at superpixels covered less than threshold in percentage by a label (alternatively consider minimum cover and entropy)
                maxlab(t)=maxlab(t)+1;
                newseg(seg==j)=maxlab(t);
            
                propseg(seg==j)=maxlab(t); %re-initialize a new label to propagate
                validtopm{t}(seg==j)=true; %re-instate valid variable to true
            end
        end
        %Copy the re-initialized labels to the propagated labels frame
        if (reinitateachframe)
            propagated{t}(:,:,ff)=newseg;
        else
            propagated{t}(:,:,ff)=propseg;
        end
        allthesegmentations{t}(:,:,ff)=newseg;
    end
end
fprintf('\n');






function validtop=test(cim) %#ok<DEFNU>

frame=10;
theflow=cat(3,flows.flows{frame}.Up,flows.flows{frame}.Vp);
tmpprint=true;
Init_figure_no(50), imshow(cim{frame})
title( 'Reference image' );
useinterp=false;
[Ccpm,validtop]=Getawarpedsingleimage(theflow,cim{frame+1},useinterp,[],tmpprint);
Init_figure_no(51), imshow(uint8(Ccpm))

flows.flows{1}.Um(1:5,1:5)
XX(1:5,1:5)
flows.flows{1}.Vm(1:5,1:5)
YY(1:5,1:5)
size(XX)
size(flows.flows{1}.Um)


