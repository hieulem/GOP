function Getiterativeselection(Y,IDX,mapped,nofigman,ucm2,Level,dimtoshow,dimtouse)
% IDX=labelsgt;

if (  ( (~exist('dimtouse','var')) || (isempty(dimtouse)) )  &&  ( (~exist('dimtoshow','var')) || (isempty(dimtoshow)) )  )
    dimtouse=2;
    dimtoshow=[1,2];
elseif ( (~exist('dimtouse','var')) || (isempty(dimtouse)) )
    dimtouse=max(dimtoshow);
elseif ( (~exist('dimtoshow','var')) || (isempty(dimtoshow)) )
    dimtoshow=1:min(3,dimtouse);
end

ndims=numel(dimtoshow);
if (ndims~=2)
    fprintf('Two dimensions are required for the interactive function\n');
    return;
end



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



%Iterative selection
maxselectionid=5;
repratioselected = 2*(maxselectionid+1)/maxselectionid;

allmappedlabels=unique(IDX(Y.index))'; %so as to not consider added indexes (not embedded)
logicalmappedlabels=ismember(IDX(Y.index),allmappedlabels);

numberofelements=sum(sum(mapped>0));
thevideolabels=ones(numberofelements,1);

j=10;
jvideo=1;
while (1)

    j=j+1;
    jvideo=jvideo+1;
    figure(nofigman);
    fprintf('Please adjust the zoom and press return\n');
    pause;

    fprintf('Please select area %d (empty for return)\n',j)

    figure(nofigman);
    p = ginput();
    if (isempty(p))
        break;
    end

    logicalpatchedlabels=logicalmappedlabels;
    logicalpatchedlabels(logicalmappedlabels) = ...
        inpolygon(Y.coords{nd}(dimtoshow(1),logicalmappedlabels), Y.coords{nd}(dimtoshow(2),logicalmappedlabels), p(:,1), p(:,2));

    col=GiveDifferentColours(j,repratioselected); %col='k';

    pointsIn = Y.coords{nd}(dimtoshow,logicalpatchedlabels);
    figure(nofigman);
    hold on;
%     plot(pointsIn(1,:),pointsIn(2,:),['.',GiveAColour(j)]);
    plot(pointsIn(1,:),pointsIn(2,:), '.','Color',col,'LineWidth',3);
    hold off;

    thevideolabels(logicalpatchedlabels)=jvideo;
    printonscreenthevideo=true;
    Labelclusteredvideointerestframes(mapped,thevideolabels,ucm2,Level,[],printonscreenthevideo); %labelledvideo=
end
fprintf('\n');

