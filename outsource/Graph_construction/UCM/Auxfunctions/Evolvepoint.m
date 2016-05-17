function [px,py]=Evolvepoint(x,y,mask,flowatframe,isforward,sigmax,sigmam,factorGaussian,printonscreen)
%x and y are the point or the array of points that we want to propagate,
%forward or backward depending on isforward
%mask is the region mask that they belong to, therefore the points must
%belong to the same mask
%The function returns -1 for both the predicted x and y if it could not
%predict their position, in agreement with the initializing value of px and
%py
%inputs <=0 are not considered valid and function returns -1 for px and py

if ( (~exist('sigmax','var')) || (isempty(sigmax)) ) %defining the Gaussian for spatial neighbouring
    sigmax=6.9;
%     sigmax=7.4;
end
if ( (~exist('sigmam','var')) || (isempty(sigmam)) ) %defining the Gaussian for motion
    sigmam=3.6;
%     sigmam=1;
end
if ( (~exist('factorGaussian','var')) || (isempty(factorGaussian)) ) %defining the spatial Gaussian size
    factorGaussian=2.5;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=true; %The function displays images by default
end

dimIi=size(mask,1);
dimIj=size(mask,2);

[X,Y]=meshgrid(1:dimIj,1:dimIi);

% [velUm,velVm,velUp,velVp]=GetUandV(flowatframe);
if (isforward)
%     velU=velUp;
%     velV=velVp;
    velU=flowatframe.Up-X;
    velV=flowatframe.Vp-Y;
else
%     velU=velUm;
%     velV=velVm;
    velU=flowatframe.Um-X;
    velV=flowatframe.Vm-Y;
end
% clear velUm; clear velVm; clear velUp; clear velVp;


%alternative implementation
% Xmask=X.*mask;
% Ymask=Y.*mask;
% startMi=min(min(Ymask)); endMi=max(max(Ymask));
% startMj=min(min(Xmask)); endMj=max(max(Xmask));

%valid for all points in mask
[r,c]=find(mask);
startMi=min(r); endMi=max(r);
startMj=min(c); endMj=max(c);

%defining the Gaussian function
gsize=max(1,fix(sigmax*factorGaussian)); %gsize can be varied independently from sigmax
                            %2*sigma should infact be enough

if (printonscreen)
    figure(10)
    set(gcf, 'color', 'white');
    imagesc(mask);
    title ('Mask of selected area');
    
    hold on
    plot(x,y,'.g');
    hold off
end

%x and y are rounded as far as the region to use is concerned
ry=round(y);
rx=round(x);

%initialization of the predicted positions
px=zeros(size(x));
py=zeros(size(y));

for k=1:numel(rx)
    
    if ((x(k)<1)||(y(k)<1)||(x(k)>dimIj)||(y(k)>dimIi)) %it deos not really make sense to propagate a point out of the mask
        px(k)=-1; %in fact if x or y are less than 1 or more than dimI, interpolation of motion is NaN
        py(k)=-1;
%         fprintf('\nFunction has been passed out of image points to propagate\n\n');
        continue;
    end
    
    i=ry(k); %the rounded x and y are valid for the size of the region to use
    j=rx(k); %they should not be used for the coordinates to predict
    
    startGi=max(startMi,i-gsize); %coordinates of G part in the image
    endGi=min(endMi,i+gsize);
    startGj=max(startMj,j-gsize);
    endGj=min(endMj,j+gsize);
    if ( (startGi>endGi)||(startGj>endGj) ) %in this case the region is empty, it only triggers if the point is out of more than factorGaussian*sigmax
        px(k)=-1;
        py(k)=-1;
%         fprintf('\nEncountered a point very far from the mask, so the masktouse use is empty\n\n');
%         fprintf('i=%d,j=%d,startGi=%f,endGi=%f,startGj=%f,endGj=%f\n',i,j,startGi,endGi,startGj,endGj);
        continue;
    end


    Xuse=X(startGi:endGi,startGj:endGj);
    Yuse=Y(startGi:endGi,startGj:endGj);
%     distanceGuse=exp( - ( (Xuse-x(k)).^2+(Yuse-y(k)).^2 ) / (2*sigmax^2) );

    maskuse=mask(startGi:endGi,startGj:endGj);

    %position in the extracted area
%     i0=i-startGi+1;
%     j0=j-startGj+1;

%     velUpij=velU(i,j);
%     velVpij=velV(i,j);
    velUij=interp2(X,Y,velU,x(k),y(k));
    velVij=interp2(X,Y,velV,x(k),y(k));
    velUuse=velU(startGi:endGi,startGj:endGj);
    velVuse=velV(startGi:endGi,startGj:endGj);

%     motionGuse=exp( - ( (velUuse-velUij).^2+(velVuse-velVij).^2 ) / (2*sigmam^2) );

    distancemotionGuse=exp( -( (Xuse-x(k)).^2+(Yuse-y(k)).^2 )/(2*sigmax^2) -( (velUuse-velUij).^2+(velVuse-velVij).^2 )/(2*sigmam^2) );
    
%     sum(sum(abs(distancemotionGuse)-abs(distanceGuse.*motionGuse)))

    
%     W=maskuse.*distanceGuse.*motionGuse;
    W=maskuse.*distancemotionGuse;
    sumW=sum(W(:));

%     W=W./sumW;
%     avgUu=sum(W(:).*velUuse(:));
%     avgUv=sum(W(:).*velVuse(:));

    avgUu=sum(sum(W.*velUuse))/sumW;
    avgUv=sum(sum(W.*velVuse))/sumW;
    
    if (isnan(avgUu)||isnan(avgUv)) %it means that sumW was zero to machine accuracy,
            %because the point may have been out of the mask too much, or
            %because it was a bit out of the mask but point inside had a close motion
        px(k)=-1;
        py(k)=-1;
%         fprintf('\nEncountered a point much out of the mask or out of the mask and with dissimilar motion\n\n');
%         sumW
        continue;
    end

    avgX=[ x(k) + avgUu ; y(k) + avgUv ];
    
    %this computes the variance
%     velUuse=velUuse-avgUu; 
%     velVuse=velVuse-avgUv;
% 
%     W=W./sumW;
%     mixterm= sum(sum( W.*velUuse.*velVuse )) ;
%     covM=[ sum(sum( W.*(velUuse.^2) )) , mixterm; mixterm , sum(sum(W.*(velVuse.^2 ) )) ];
    
    px(k)=avgX(1);
    py(k)=avgX(2);
end

if (printonscreen)
    figure(10)
    hold on
    plot(px,py,'.r');
    hold off
end
