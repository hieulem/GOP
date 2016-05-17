function predictedMask=EvolveRegionFast(mask,flowatframe,sigmax,sigmam,factorGaussian,printonscreen,G)

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

%for debugging
% m=[0   0   0   0   0   0   0   0
% 0   0   1   1   1   0   0   0
% 0   0   0   1   0   0   0   0
% 0   0   0   1   0   0   0   0
% 0   0   0   0   0   0   0   0
% ];
% mm=[0   0   0   0   0   0   0   0
% 0   0   0   1   1   1   1   0
% 0   0   0   0   1   0   0   0
% 0   0   0   0   1   0   0   0
% 0   0   0   0   1   0   0   0
% ];
% mask=m;
% flowatframe=flows.flows{1};
% predictedMask=EvolveRegionFast(mask,flowatframe);
% similarity=Measuresimilarity(mm,predictedMask)
% velUp=repmat(1.5,size(mask));
% velVp=repmat(0,size(mask));
% velUm=velUp;

[velUm,velVm,velUp,velVp]=GetUandV(flowatframe);
% [VelUVm,VelUVp]=GetUandV(flowatframe); %VelUVm=[:,:,[Um,Vm]] VelUVp=[:,:,[Up,Vp]]
dimIi=size(velUm,1);
dimIj=size(velUm,2);

%valid for all points in mask
[r,c]=find(mask);
startMi=min(r); endMi=max(r);
startMj=min(c); endMj=max(c);

%defining the Gaussian function
gsize=max(1,fix(sigmax*factorGaussian)); %gsize can be varied independently from sigmax
                            %2*sigma should infact be enough

if ( (~exist('G','var')) || (isempty(G)) ) %so as not to have to produce the same gaussian always
    G=fspecial('gaussian',gsize*2+1,sigmax);
end

if (printonscreen)
    figure(10)
    set(gcf, 'color', 'white');
    imagesc(mask);
    title ('Mask of selected area');
end

predictedMask=zeros(dimIi,dimIj);


for k=1:numel(r)

    i=r(k);
    j=c(k);

%     figure(10);
%     hold on;
%     hb=plot(j,i,'w+');
%     hold off;

    startGi=max(startMi,i-gsize); endGi=min(endMi,i+gsize); %coordinates of G part in the image
    startGj=max(startMj,j-gsize); endGj=min(endMj,j+gsize);

    distanceGuse=G( (startGi:endGi)-i+gsize+1 , (startGj:endGj)-j+gsize+1); %G part in use
    %in fact G coincides with Gaussian for distances

    maskuse=mask(startGi:endGi,startGj:endGj);
% % % figure(112),imagesc(maskuse)
% % % set(gcf, 'color', 'white');

    %position in the extracted area
%     i0=i-startGi+1;
%     j0=j-startGj+1;

    velUpij=velUp(i,j);
    velVpij=velVp(i,j);
    velUpuse=velUp(startGi:endGi,startGj:endGj);
    velVpuse=velVp(startGi:endGi,startGj:endGj);

    motionGuse=exp( - ( (velUpuse-velUpij).^2+(velVpuse-velVpij).^2 ) / (2*sigmam^2) );
% % % figure(113),imagesc(motionGuse)
% % % set(gcf, 'color', 'white');

    W=maskuse.*distanceGuse.*motionGuse;
    sumW=sum(W(:));
% % % figure(111),imagesc(W)
% % % set(gcf, 'color', 'white');

    W=W./sumW;
    avgUu=sum(W(:).*velUpuse(:));
    avgUv=sum(W(:).*velVpuse(:));

%     avgUu=sum(sum(W.*velUpuse))/sumW; %This is a better approximation
%     avgUv=sum(sum(W.*velVpuse))/sumW; %but requires ad hoc parameters

    
    
    avgX=[ j + avgUu ; i + avgUv ];
%     figure(10);
%     hold on;
%     hp=plot(avgX(1),avgX(2),'g+');
%     hold off;
    
    [avgX(1),xminus,xplus]=Adjust_the_number(avgX(1),1,dimIj);
    [avgX(2),yminus,yplus]=Adjust_the_number(avgX(2),1,dimIi);
    
    %This is used to distribute the energy onto the pixels
    predictedMask(yplus,xplus)= predictedMask(yplus,xplus)+...
        (avgX(1)-xminus)*(avgX(2)-yminus);
    predictedMask(yminus,xminus)= predictedMask(yminus,xminus)+...
        (xplus-avgX(1))*(yplus-avgX(2));
    predictedMask(yplus,xminus)= predictedMask(yplus,xminus)+...
        (xplus-avgX(1))*(avgX(2)-yminus);
    predictedMask(yminus,xplus)= predictedMask(yminus,xplus)+...
        (avgX(1)-xminus)*(yplus-avgX(2));

%     figure(119)
%     set(gcf, 'color', 'white');
%     imagesc(predictedMask);
%     title ('Mask of predicted area');

%     delete(hb);
%     delete(hp);
end


if (printonscreen)
    figure(117)
    set(gcf, 'color', 'white');
    imagesc(predictedMask);
    title ('Mask of predicted area');
end


function [value,vminus,vplus]=Adjust_the_number(value,minlimit,maxlimit)

if ( (value>=minlimit)&&(value<=maxlimit) )
    vminus=floor(value);
    vplus=ceil(value);
else
    if (value<=maxlimit) %it means it is true (value<minlimit)
        value=minlimit;
        vminus=minlimit;
        vplus=vminus+1;
    else
        value=maxlimit;
        vplus=maxlimit;
        vminus=vplus-1;
    end
end

if (vminus==vplus) %it means that 'value' is an integer
    if (vplus<maxlimit)
        vplus=vminus+1;
    else
        vminus=vplus-1;
    end
end

