function [flows,flowwasmodified]=Filtertheflows(flows,allthelabels,sigmax,sigmam,factorGaussian,G)
%Filter optical flow with bilateral filtering

if ( (~exist('sigmax','var')) || (isempty(sigmax)) ) %defining the Gaussian for spatial neighbouring
    sigmax=6.9;
end
if ( (~exist('sigmam','var')) || (isempty(sigmam)) ) %defining the Gaussian for motion
    sigmam=3.6;
end
if ( (~exist('factorGaussian','var')) || (isempty(factorGaussian)) ) %defining the spatial Gaussian size
    factorGaussian=2.5;
end

%defining the Gaussian function
gsize=max(1,fix(sigmax*factorGaussian)); %gsize can be varied independently from sigmax
                            %2*sigma should infact be enough

if ( (~exist('G','var')) || (isempty(G)) ) %so as not to have to produce the same gaussian always
    G=fspecial('gaussian',gsize*2+1,sigmax);
end

flowwasmodified=false;

noFrames=numel(allthelabels);
dimIi=size(allthelabels{1},1);
dimIj=size(allthelabels{1},2);

mask=false(dimIi,dimIj);

[Uref,Vref]=meshgrid(1:dimIj,1:dimIi); %pixel coordinates

for f=1:noFrames
    
    if (flows.whichDone(f)>=3) %so the filtering process is not reiterated out of mistake
        continue;
    end
    
    newflow.Up=Uref;
    newflow.Vp=Vref;
    newflow.Um=Uref;
    newflow.Vm=Vref;
    
    [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});

    for l=1:max(allthelabels{f}(:))
        
        mask= (allthelabels{f}==l);
        
%         figure(10)
%         set(gcf, 'color', 'white');
%         imagesc(mask);
%         imagesc(abs(flows.flows{f}.Vm-newflow.Vm));
%         title ('Mask of selected area');

        %valid for all points in mask
        [r,c]=find(mask);
        startMi=min(r); endMi=max(r);
        startMj=min(c); endMj=max(c);

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

            for pm=1:2 %p is 1, m is 2, the computation is also done for f=1 and noFrames, counting on the zero-initialised flow
                
                if (pm==1)
                    velUpm=velUp;
                    velVpm=velVp;
                else
                    velUpm=velUm;
                    velVpm=velVm;
                end
                
                velUpij=velUpm(i,j);
                velVpij=velVpm(i,j);
                velUpuse=velUpm(startGi:endGi,startGj:endGj);
                velVpuse=velVpm(startGi:endGi,startGj:endGj);

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
                %this can be inserted into flows.flows.Up and Vp (i,j)
                
                if (pm==1)
                    newflow.Up(i,j)=avgX(1);
                    newflow.Vp(i,j)=avgX(2);
                else
                    newflow.Um(i,j)=avgX(1);
                    newflow.Vm(i,j)=avgX(2);
                end
            end
        end
    end
    flows.flows{f}=newflow;
    flows.whichDone(f)=3; %3 in whichDone will identify a bilateral-filtered smoothed flow
    flowwasmodified=true;
end

