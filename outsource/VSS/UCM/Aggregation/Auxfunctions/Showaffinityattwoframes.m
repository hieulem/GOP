function Showaffinityattwoframes(similarities,frames,labelledlevelvideo,mapped,numberofsuperpixelsperframe,fTHR,sTHR,onenode,cim)
%TODO: include print of best n connections
% frames=[1,33];

if ( (~exist('onenode','var')) || (isempty(onenode)) )
    onenode=[];
    useonenode=false;
else
    useonenode=true;
end

startff=mapped(frames(1),1);
endff=mapped(frames(1),find(mapped(frames(1),:)~=0,1,'last'));
startsf=mapped(frames(2),1);
endsf=mapped(frames(2),find(mapped(frames(2),:)~=0,1,'last'));

maxlab=max( max(max(labelledlevelvideo(:,:,frames(1)))) , max(max(labelledlevelvideo(:,:,frames(2)))) );
colormap=randperm(maxlab);

fflabels=labelledlevelvideo(:,:,frames(1));
sflabels=labelledlevelvideo(:,:,frames(2));

fflabels(:)=colormap(fflabels(:));
sflabels(:)=colormap(sflabels(:));

%Allow for same frame links
if (frames(1)==frames(2))
    usesameframe=true;
    offset=0;
else
    usesameframe=false;
    offset=size(fflabels,2);
end

[X,Y]=meshgrid(1:size(fflabels,2),1:size(fflabels,1));
% Init_figure_no(2), imagesc(X);
% Init_figure_no(3), imagesc(Y);
fcoords=zeros(2,maxlab);
scoords=zeros(2,maxlab);
for i=1:maxlab
    fmask=(fflabels==colormap(i));
    % Init_figure_no(4), imagesc(fmask);
    if (any(fmask(:)))
        fcoords(:,colormap(i))=[ median(Y(fmask)) ; median(X(fmask)) ]; %ij coordinates
    % hold on; plot(fcoords(2,colormap(i)),fcoords(1,colormap(i)),'g+'); hold off;
    end
    
    smask=(sflabels==colormap(i));
    % Init_figure_no(5), imagesc(smask);
    
    if (any(smask(:)))
        scoords(:,colormap(i))=[ median(Y(smask)) ; median(X(smask)) ];
    % hold on; plot(scoords(2,colormap(i)),scoords(1,colormap(i)),'w+'); hold off;
    end
end

[framebelong,labelsatframe,numberofelements]=Getmappedframes(mapped); %#ok<NASGU,ASGLU>

localsimilarity=similarities([startff:endff,startsf:endsf],[startff:endff,startsf:endsf]);
[r,c,v]=find(localsimilarity);
% fTHR=1; sTHR=1; %consider affinities in [fTHR,sTHR]
if (usesameframe)
    Init_figure_no(1),imagesc(fflabels);
else
    Init_figure_no(1),imagesc([fflabels,sflabels]);
end

%insert transparent image
if ( (exist('cim','var')) && (~isempty(cim)) )
    hold on;
    if (usesameframe)
        bigimg=cim{frames(1)};
    else
        bigimg=[cim{frames(1)},cim{frames(2)}];
    end
    h=imagesc(bigimg);
    
    alphadata=ones(size(bigimg,1),size(bigimg,2)).*0.7;
    set(h,'AlphaData',alphadata);
    hold off;
end

hold on;
for i=1:numel(r)
    
    if ( (v(i)<fTHR) || (v(i)>sTHR) )
        continue;
    end
    one=r(i);
    two=c(i);
    if (one>=two)
        continue;
    end
    %value is v(i)
    if ( (useonenode) && ((onenode~=one)&&(onenode~=two)) )
        continue;
    end

    if ( (one<=numberofsuperpixelsperframe(frames(1))) && (two>numberofsuperpixelsperframe(frames(1))) ) %one in ff, two in sf
        if (one<=numberofsuperpixelsperframe(frames(1)))
            globsf=two-numberofsuperpixelsperframe(frames(1))+startsf-1;
            globff=one+startff-1;
        else
            globff=one-numberofsuperpixelsperframe(frames(1))+startsf-1;
            globsf=two+startff-1;
        end
        fflab=colormap(labelsatframe(globff));
        sflab=colormap(labelsatframe(globsf));
%         labelsatframe(globff)
%         labelsatframe(globsf)
        
        color=GiveDifferentColours(1-v(i),4/3);
        
        line( [fcoords(2,fflab),scoords(2,sflab)+offset] , [fcoords(1,fflab),scoords(1,sflab)] ,'Color',color); %,'LineWidth',3
        plot(fcoords(2,fflab),fcoords(1,fflab),'+g'); %,'MarkerSize',10
        plot(scoords(2,sflab)+offset,scoords(1,sflab),'+g'); %,'MarkerSize',10
    end
end
hold off;


