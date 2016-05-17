function [px,py]=Propagatepxy(px,py,vicinityThreshold,maskmap,dimIi,dimIj,allmasks,flows,...
    startFrame,endFrame,sigmax,sigmam,factorGaussian,printonscreen,filter_flow)
%The distinction of whether to propagate forward or backward is done on the
%basis of the start and end frame

%The vicinityThreshold states how close points have to be to the edge of
%the image to not being propagated
%minimum for this is 1 and dimIij, as beyond these values it is not even
%possible to interpolate the velocity
%vicinityThreshold could in theory depend sigmax

if ( (~exist('filter_flow','var')) || (isempty(filter_flow)) ) %defining the Gaussian for spatial neighbouring
    filter_flow=false;
end
if ( (~exist('sigmax','var')) || (isempty(sigmax)) ) %defining the Gaussian for spatial neighbouring
    sigmax=6.9;
end
if ( (~exist('sigmam','var')) || (isempty(sigmam)) ) %defining the Gaussian for motion
    sigmam=3.6;
end
if ( (~exist('factorGaussian','var')) || (isempty(factorGaussian)) ) %defining the spatial Gaussian size
    factorGaussian=2.5;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=true; %The function displays images by default
end

if (startFrame==endFrame)
    return;
elseif (startFrame<endFrame)
    increase=+1;
    isforward=1;
else %(startFrame>endFrame)
    increase=-1;
    isforward=0;
end
    

pointsinsideimage=1;
for f=startFrame:increase:(endFrame-increase)
    ccount=maskmap(f);

    if (~pointsinsideimage) %from when any point slips out of the image, the propagation is stopped (outputs set to -1)
        px(:,ccount+increase)=-1;
        py(:,ccount+increase)=-1;
        continue;
    end
    
    %we want to propagate the points which have not been propagated yet, i.e. those with pxy(:,ccount+increase)==-1
    %and it is sensible to propagate only those inside the image (those with
    %pxy(:,ccount)>=vicinityThreshold and pxy(:,ccount)<=(dimIji-vicinityThreshold) )
    %propagating only points inside the image allows us to check whether
    %any slipped out after the propagation
    whichtopropagate=find( ( (px(:,ccount)>=vicinityThreshold) .* (px(:,ccount)<=(dimIj-vicinityThreshold)) .* (px(:,ccount+increase)==(-1)) ) ...
        .* ( (py(:,ccount)>=vicinityThreshold) .* (py(:,ccount)<=(dimIi-vicinityThreshold)) .* (py(:,ccount+increase)==(-1)) ) )';
    xx=px(whichtopropagate,ccount);
    yy=py(whichtopropagate,ccount);
    if (~(isempty(xx)||isempty(yy)))
        if ( (flows.whichDone(f)==3) || (~filter_flow) )
            [xx,yy]=Evolvepointforfilteredflows(xx,yy,flows.flows{f},isforward,printonscreen);
        else
            [xx,yy]=Evolvepoint(xx,yy,allmasks(:,:,ccount),flows.flows{f},isforward,sigmax,sigmam,factorGaussian,printonscreen);
        end
    end
    
    for k=1:numel(xx)
        if ((xx(k)<1)||(yy(k)<1)||(xx(k)>dimIj)||(yy(k)>dimIi)) %if a point slips outside of the image then the propagation is stopped
            pointsinsideimage=0;
%             fprintf('\nAn estimated point has propagated to outside the following image\n\n');
            break;
        elseif ( (allmasks( floor(yy(k)),floor(xx(k)),ccount+increase )==0)||(allmasks( floor(yy(k)),ceil(xx(k)),ccount+increase )==0)||...
                    (allmasks( ceil(yy(k)),floor(xx(k)),ccount+increase )==0)||(allmasks( ceil(yy(k)),ceil(xx(k)),ccount+increase )==0) )
                %if a point is propagated to an area outside of the mask then the propagation is nulled
            xx(k)=-1;
            yy(k)=-1;
%             fprintf('\nAn estimated point has propagated to outside the following mask\n\n');
        end
    end
    
    if (pointsinsideimage)
        px(whichtopropagate,ccount+increase)=xx;
        py(whichtopropagate,ccount+increase)=yy;
    else %if any point slips outside then the propagation stops at the previous frame
        px(:,ccount+increase)=-1;
        py(:,ccount+increase)=-1;
    end
end

    
