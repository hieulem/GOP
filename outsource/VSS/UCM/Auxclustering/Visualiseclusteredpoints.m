function Visualiseclusteredpoints(Y,IDX,dimtouse,nofigure, distributecolours, includenumbers, E, includegraph, dimtoshow)

if ( (~exist('nofigure','var')) || (isempty(nofigure)) )
    nofigure=20;
end
if (  ( (~exist('dimtouse','var')) || (isempty(dimtouse)) )  &&  ( (~exist('dimtoshow','var')) || (isempty(dimtoshow)) )  )
    dimtouse=2;
    dimtoshow=[1,2];
elseif ( (~exist('dimtouse','var')) || (isempty(dimtouse)) )
    dimtouse=max(dimtoshow);
elseif ( (~exist('dimtoshow','var')) || (isempty(dimtoshow)) )
    dimtoshow=1:min(3,dimtouse);
end
if ( (~exist('distributecolours','var')) || (isempty(distributecolours)) )
    distributecolours=false;
end
if ( (~exist('includegraph','var')) || (isempty(includegraph)) )
    includegraph=false;
end
if (  ( (~exist('E','var')) || (isempty(E)) )  &&  (includegraph)  )
    fprintf('The graph representation requires the matrix E\n');
    includegraph=false;
end
if ( (~exist('includenumbers','var')) || (isempty(includenumbers)) )
    includenumbers=false;
end

outlierid=(-10);

%Input analysis
if (dimtouse<max(dimtoshow))
    fprintf('Dimension to use specified smaller than the ones to show, setting it accordingly\n');
    dimtouse=max(dimtoshow);
end
[nd,maxdim,maxdimd]=Getchosend(Y,dimtouse);
if (isempty(nd))
    if (maxdim>dimtouse)
        fprintf('Dimension specified not among the computed, using maximum manifold dimension\n');
        nd=maxdimd;
    else
        fprinptf('Could not match requested dimension\n');
        return;
    end
end



if (distributecolours)
    numberofids=numel(unique(IDX));
    if (any(IDX==outlierid)), numberofids=numberofids-1; end
    repratio = 2*(numberofids+1)/numberofids;
else
    repratio=[];
end



ndims=numel(dimtoshow);
Init_figure_no(nofigure);
title(sprintf('%d-dimensional Isomap embedding (%s)',ndims,num2str(dimtoshow)));

hold on
if (ndims==2)
    for i=unique(IDX(Y.index))' %so as to not consider added indexes (not embedded)
        col=GiveDifferentColours(i,repratio);
        if (i==(outlierid)), col=[0,0,0]; end; %(outlierid) labels represent outliers, in black
        plot(Y.coords{nd}(dimtoshow(1),(IDX(Y.index)==i)), Y.coords{nd}(dimtoshow(2),(IDX(Y.index)==i)), '.','Color',col,'LineWidth',3);
%         plot(Y.coords{nd}(dimtoshow(1),(IDX(Y.index)==i)), Y.coords{nd}(dimtoshow(2),(IDX(Y.index)==i)), ['.',GiveAColour(i)]);

        if (includenumbers)
            whichones=find(IDX(Y.index)==i);
            for j=whichones
                text(Y.coords{nd}(dimtoshow(1),j), Y.coords{nd}(dimtoshow(2),j), num2str(Y.index(j)), 'FontSize',17);
            end
        end

        if (includegraph)
            gplot(E(Y.index, Y.index), [Y.coords{nd}(dimtoshow(1),:); Y.coords{nd}(dimtoshow(2),:)]');
        end
    end
elseif (ndims==3)
    for i=unique(IDX(Y.index))' %so as to not consider added indexes (not embedded)
        col=GiveDifferentColours(i,repratio);
        if (i==(outlierid)), col=[0,0,0]; end; %(outlierid) labels represent outliers, in black
        scatter3(Y.coords{nd}(dimtoshow(1),(IDX(Y.index)==i)), Y.coords{nd}(dimtoshow(2),(IDX(Y.index)==i)), Y.coords{nd}(dimtoshow(3),(IDX(Y.index)==i)),3,col);

        if (includenumbers)
            whichones=find(IDX(Y.index)==i);
            for j=whichones
                text(Y.coords{nd}(dimtoshow(1),j), Y.coords{nd}(dimtoshow(2),j), Y.coords{nd}(dimtoshow(3),j),num2str(Y.index(j)), 'FontSize',17);
            end
        end
    end
end
hold off



