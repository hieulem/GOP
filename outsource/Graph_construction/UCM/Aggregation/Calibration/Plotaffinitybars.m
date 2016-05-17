function Plotaffinitybars(thevalues,theaffinityname,barnames,figurenumber)
% thevalues=[negbin;posbin]; 2 x N
% barnames={'false','true'};
% theaffinityname is used to retrieve min, max, bincount values

numberofbars=size(thevalues,1);
numberofpoints=size(thevalues,2);

if ( (~exist('barnames','var')) || (isempty(barnames)) )
    barnames=cell(0);
    for i=1:numberofbars
        barnames{i}=num2str(i);
    end
end
if ( (~exist('figurenumber','var')) || (isempty(figurenumber)) )
    figurenumber=10;
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
uselog=true;
if (uselog)
    maybelog = @(x) log(x);
else
    maybelog = @(x) x;
end



%Plot dots in correspondence to values of histograms
Init_figure_no(figurenumber);
thecolorratio=2*(numberofbars+1)/numberofbars; %numberofbars colors maximally spaced
for i=1:numberofbars
    thecolor=GiveDifferentColours(i,thecolorratio);
    if (i~=1)
        hold on;
    end
    plot(1:numberofpoints,maybelog(thevalues(i,:)),'.','Color',thecolor)
    if (i~=1)
        hold off;
    end
end
legend(namematrix,'Location','NorthWest')
includebars=false;
if (includebars) %Optional plot of bars
    for i=1:numberofbars
        tmpvalues=thevalues;
        tmpvalues(1:i-1,:)=0;
        tmpvalues(i+1:numberofbars,:)=0;
        thecolor=GiveDifferentColours(i,thecolorratio);
        hold on;
        bar(maybelog(tmpvalues'),'FaceColor',thecolor,'EdgeColor','none');
        hold off;
    end
end
% thevalues(1:2,:)=thevalues(2:-1:1,:);



%Set min, max and bincount according to 
[posbin,negbin,bincenters,themin,themax,casefound]=Inittheparametercalibrationhistogram(theaffinityname); %#ok<ASGLU>



%Set axis tick and title
numberofnumbers=11; %number of ticks to include on x axis
thenumbercentersinbar=1:(numberofpoints-1)/(numberofnumbers-1):numberofpoints;
if (casefound)
    thenumbercenters=themin:(themax-themin)/(numberofnumbers-1):themax;
    set(gca,'XTick',thenumbercentersinbar)
    set(gca,'XTickLabel',num2str(thenumbercenters','%.2g'))
% else
%     thenumbercenters=thenumbercentersinbar;
end
xlabel('bin'); ylabel('count');
title([theaffinityname,' (uselog=',num2str(uselog),')']);



