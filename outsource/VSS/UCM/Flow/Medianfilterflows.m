function [flows,flowwasmodified]=Medianfilterflows(flows,allthelabels,xyradius,G)
%Filter optical flow with bilateral filtering

if ( (~exist('xyradius','var')) || (isempty(xyradius)) ) %defining the Gaussian for spatial neighbouring
    xyradius=3; %6.9 sigma for bilateral filtering
end

if ( (~exist('G','var')) || (isempty(G)) ) %Speed computation by passing precomputed filter
    %Define a boolean filter of size [xyradius+1,xyradius+1], true at (distances < xyradius)
    xycenter=[xyradius+1,xyradius+1];
    [X,Y]=meshgrid(1:2*xyradius+1,1:2*xyradius+1);
    alldistancessquared= (X-xycenter(1)).^2 + (Y-xycenter(2)).^2 ;
    G= ( alldistancessquared <= (xyradius^2) );
end

flowwasmodified=false;

%Video sizes
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
        
%         Init_figure_no(10);
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

            startGi=max(startMi,i-xyradius); endGi=min(endMi,i+xyradius); %coordinates of G part in the image
            startGj=max(startMj,j-xyradius); endGj=min(endMj,j+xyradius);

            maskuse=mask(startGi:endGi,startGj:endGj);
%             Init_figure_no(112),imagesc(maskuse)

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
                
                velUpuse=velUpm(startGi:endGi,startGj:endGj);
                velVpuse=velVpm(startGi:endGi,startGj:endGj);
                % Init_figure_no(113),imagesc(velUpuse)
                
                avgUu=median(velUpuse(maskuse));
                avgUv=median(velVpuse(maskuse));

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
%     [velUm,velVm,velUp,velVp]=GetUandV(newflow);

    flows.flows{f}=newflow;
    flows.whichDone(f)=3; %3 in whichDone will identify a bilateral-filtered smoothed flow
    flowwasmodified=true;
end

