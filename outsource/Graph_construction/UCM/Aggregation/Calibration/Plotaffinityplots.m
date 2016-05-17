function Plotaffinityplots(thevalues,bincenters,theaffinityname,barnames,figurenumber,usecumulative,doresampling,uselog,usethiscolor,addtofigure)
% thevalues=[negbin;posbin]; 2 x N
% barnames={'false','true'};
% theaffinityname is used to retrieve min, max, bincount values
% arrays are passed in input but the function internally uses cell arrays

%Setup parameters
if ( (~exist('usethiscolor','var')) || (isempty(usethiscolor)) )
    usethiscolor=[];
end
if ( (~exist('addtofigure','var')) || (isempty(addtofigure)) )
    addtofigure=false;
end
if ( (~exist('doresampling','var')) || (isempty(doresampling)) )
    doresampling=false;
end
if ( (~exist('uselog','var')) || (isempty(uselog)) )
    uselog=true;
end
if ( (~exist('usecumulative','var')) || (isempty(usecumulative)) )
    usecumulative=false;
end
if (iscell(thevalues)), numberofbars=numel(thevalues); else numberofbars=size(thevalues,1); end
if ( (~exist('barnames','var')) || (isempty(barnames)) )
    barnames=cell(0);
    for i=1:numberofbars
        barnames{i}=num2str(i);
    end
end
if ( (~exist('theaffinityname','var')) || (isempty(theaffinityname)) )
    theaffinityname='Affinity';
end
if ( (~exist('figurenumber','var')) || (isempty(figurenumber)) )
    figurenumber=10;
end



%Check sufficient input parameters
if (isempty(bincenters)) %bincenters in input
    %Set bincenters according to theaffinityname
    [posbin,negbin,bincenters,themin,themax,casefound]=Inittheparametercalibrationhistogram(theaffinityname); %#ok<ASGLU>
    if (~casefound)
        fprintf('Affinity name or bincenters required\n');
        return;
    end
end
if (iscell(bincenters)), suppnumberbars=numel(bincenters); else suppnumberbars=size(bincenters,1); end
if (numberofbars~=suppnumberbars) %bincenters for each value
    if ( (suppnumberbars~=1) || (iscell(bincenters)) )
        fprintf('bincenters and thevalues\n');
        return;
    else
        bincenters=repmat(bincenters,numberofbars,[]);
    end
end



%Switch from arrays to cell arrays
newthevalues=cell(1,numberofbars);
newbincenters=cell(1,numberofbars);
if (iscell(bincenters))
    newbincenters=bincenters;
else
    for i=1:numberofbars
        newbincenters{i}=bincenters(i,:);
    end
end
if (iscell(thevalues))
    newthevalues=thevalues;
else
    for i=1:numberofbars
        newthevalues{i}=thevalues(i,:);
    end
end



%Prepare namematrix with the names assigned
maxstrlen=0;
for i=1:numberofbars
    maxstrlen=max(maxstrlen,numel(barnames{i}));
end
namematrix=ones(numberofbars,maxstrlen)*32;namematrix=char(namematrix);
for i=1:numberofbars
    namematrix(i,1:numel(barnames{i}))=barnames{i};
end



%Switch on whether to use log representation
if (uselog)
    maybelog = @(x) log10(x);
else
    maybelog = @(x) x;
end



%Compute cumulative distribution or resample if requested
if ( (usecumulative) || (doresampling) )
    
    %set to flip thevalues if usecumulative==true and bincenters are in inverted order
    reversevalues=false(1,numberofbars);
    for i=1:numberofbars
        if (newbincenters{i}(1)>newbincenters{i}(end))
            reversevalues(i)=true;
        end; %boolean indicating whether the value was flipped
    end
    
    %flip thevalues
    for i=1:numberofbars
        if (reversevalues(i))
            newthevalues{i}=flipdim(newthevalues{i},2);
            newbincenters{i}=flipdim(newbincenters{i},2);
        end
    end
    
    %cumulative sum of thevalues
    for i=1:numberofbars
        newthevalues{i}=cumsum(newthevalues{i},2);
    end
    
    %eliminate replicated values
    for i=1:numberofbars
        [tmpbincenters,bincentersindex,newbincentersindex]=unique(newbincenters{i},'last'); %#ok<NASGU>
        if (numel(tmpbincenters)~=numel(newbincenters{i}))
            newthevalues{i}=newthevalues{i}(bincentersindex);
            newbincenters{i}=tmpbincenters;
        end
    end
    
    %resample
    if (doresampling)
        [posbin,negbin,bincentersresampling]=Inittheparametercalibrationhistogram('resampled'); %#ok<ASGLU>

        for i=1:numberofbars
            newthevalues{i} = interp1(newbincenters{i},newthevalues{i},bincentersresampling);
            newbincenters{i}= bincentersresampling;
            reversevalues(i)= false; %bincentersresampling is already in the correct order
        end
    end
    
    %derivative of thevalues (inverse cumsum)
    if (~usecumulative)
        for i=1:numberofbars
            newthevalues{i}=[newthevalues{i}(1),diff(newthevalues{i},1,2)];
        end
    end

    %unflip values if not requested
    for i=1:numberofbars
        if (reversevalues(i))
            newthevalues{i}=flipdim(newthevalues{i},2);
            newbincenters{i}=flipdim(newbincenters{i},2);
        end
    end
end



%Plot dots in correspondence to values of histograms
if (addtofigure)
    figure(figurenumber); hold on
else
    Init_figure_no(figurenumber);
end
thecolorratio=2*(numberofbars+1)/numberofbars; %numberofbars colors maximally spaced
thermax=-Inf; thermin=Inf;
for i=1:numberofbars
    if (isempty(usethiscolor))
        thecolor=GiveDifferentColours(i,thecolorratio);
    else
        if (iscell(usethiscolor)), thecolor=usethiscolor{i}; else thecolor=usethiscolor; end
    end
    if ( (i~=1) && (~addtofigure) )
        hold on;
    end
    plot(newbincenters{i},maybelog(newthevalues{i}),'.','Color',thecolor)
    if ( (i~=1) && (~addtofigure) )
        hold off;
    end
    thermax=max(thermax,newbincenters{i}(end)); thermin=min(thermin,newbincenters{i}(1));
%     thermax=max(thermax,max(newbincenters{i})); thermin=min(thermin,min(newbincenters{i}));
end
if (addtofigure)
    hold off
else
    legend(namematrix,'Location','NorthWest')
    theylabel='count'; if (uselog), theylabel=['log10 ',theylabel]; end;
    xlabel('value'); ylabel(theylabel);
    set(gca,'xlim',[thermin-0.005,thermax+0.005]) %Visualize the extrema
    if (isstruct(theaffinityname))
        if (isfield(theaffinityname,'name'))
            thetitle=[theaffinityname.name,' (uselog10=',num2str(uselog),')'];
        else
            thetitle=['(uselog10=',num2str(uselog),')'];
        end
    else
        thetitle=[theaffinityname,' (uselog10=',num2str(uselog),')'];
    end
    if (usecumulative), thetitle=[thetitle,' cumulative']; end;
    if (doresampling), thetitle=[thetitle,' resampled']; end;
    title(thetitle);
    % thevalues(1:2,:)=thevalues(2:-1:1,:);
end



