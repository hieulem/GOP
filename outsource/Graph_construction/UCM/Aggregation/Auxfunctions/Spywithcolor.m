function Spywithcolor(similarities,numberoffigure,mapped)
%The function creates an image of the same size as similarities, coloring
%from blue to red according to the value and leaving white the non-defined
%part

if ( (~exist('numberoffigure','var')) || (isempty(numberoffigure)) )
    numberoffigure=3;
end

% Init_figure_no(5); spy(similarities);

numberofpoints=size(similarities,1);

theimage=ones(numberofpoints,numberofpoints,3); %a color image

[r,c,v]=find(similarities);

enlargedots=true;
thedotsize=[3,3];
for i=1:numel(r)
    
    color=GiveDifferentColours(1-v(i),4/3);
    
    if (enlargedots)
        theimage(r(i):r(i)+thedotsize(1)-1,c(i):c(i)+thedotsize(2)-1,:)=cat(3,repmat(color(1),thedotsize),repmat(color(2),thedotsize),repmat(color(3),thedotsize));
    else
        theimage(r(i),c(i),:)=color;
    end
end
if (enlargedots)
    theimage=theimage(1:numberofpoints,1:numberofpoints,:);
end
Init_figure_no(numberoffigure), imagesc(uint8(theimage.*255));



if ( (exist('mapped','var')) && (~isempty(mapped)) )
    linecoord=[];
    theframe=1;
    while ( max(mapped(theframe,:)) < numberofpoints )
        linecoord=[linecoord, max(mapped(theframe,:)) ]; %#ok<AGROW>
        theframe=theframe+1;
        if (theframe>size(mapped,1))
            break;
        end
    end
    figure(numberoffigure);
    hold on;
    line([ones(size(linecoord));ones(size(linecoord)).*numberofpoints],[linecoord;linecoord],'Color','k','LineStyle','--')
    line([linecoord;linecoord],[ones(size(linecoord));ones(size(linecoord)).*numberofpoints],'Color','k','LineStyle','--')
    hold off;
    
%     set(gca,'FontSize',17);
end

