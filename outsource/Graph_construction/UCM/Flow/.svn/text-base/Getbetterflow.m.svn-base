function Getbetterflow(flows)

f=1;



%Extraction of flow at frame
[velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
Init_figure_no(9), imagesc(velUp);
Init_figure_no(10), imagesc(velVp);
Init_figure_no(11), imagesc(sqrt((velUp.^2)+(velVp.^2)));



%Optical flow legend
theimage=Getflowlegend(256,256,true);
for i=1:3
    fprintf('Channel %d, max %f, min %f\n',i, max(max(theimage(:,:,i))),min(min(theimage(:,:,i))));
end
%Check gamut
themin=0;
themax=255;
ijk=zeros(1,1,3);
for i=themin:themax-themin:themax
    for j=themin:themax-themin:themax
        for k=themin:themax-themin:themax
            ijk(1,1,:)=[i;j;k];
            ispresent=any(any( all(theimage==repmat(ijk,[size(theimage,1),size(theimage,2),1]),3) ));
            fprintf('Colour code [%d, %d, %d], ispresent %d\n',i,j,k,ispresent);
        end
    end
end



%The code defines 8 image quadrants (1,2,3,4,6,7,8,9) with different colours
themin=0;
themax=255;
desideredsize=[128,128];
dimi=desideredsize(1);
dimj=desideredsize(2);
spanimage=zeros(dimi,dimj,3);
count=0;
for i=themin:themax-themin:themax
    for j=themin:themax-themin:themax
        for k=themin:themax-themin:themax
            count=count+1;
            if (count==5)
                count=count+1;
            end
            [mini,maxi,minj,maxj]=Getquadrantrange(count,dimi,dimj);
            spanimage(mini:maxi,minj:maxj,1)=i;
            spanimage(mini:maxi,minj:maxj,2)=j;
            spanimage(mini:maxi,minj:maxj,3)=k;
        end
    end
end
Init_figure_no(13), imshow(spanimage/255);



%Transformation of the eight quadrants
Lab=Rgbtolab(spanimage,[],[],true);

fprintf('L channel (%.16f,%.16f)\na channel (%.16f,%.16f)\nb channel (%.16f,%.16f)\n',...
    min(min(Lab(:,:,1))),max(max(Lab(:,:,1))),...
    min(min(Lab(:,:,2))),max(max(Lab(:,:,2))),...
    min(min(Lab(:,:,3))),max(max(Lab(:,:,3))) );

% Lab(:,:,1)=50;

Rgb=Labtorgb(Lab,[],[],true);

isequal(spanimage,Rgb)



%Values about gamut extracted from the quadrants (fully saturated colours)
minL=0; maxL=100;
minab=-86.1812575110439383; maxab=98.2351514395151639;



%%%Creation of image with optical flow
f=1;
[velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
[min(min(velUp)), max(max(velUp)), min(min(velVp)), max(max(velVp))]

a=velUp;
b=velVp;
L=zeros(size(a));
Rgb=Labtorgb(L,a,b,true);

a=Rerangeimage(velUp,minab,maxab);
b=Rerangeimage(velVp,minab,maxab);
L=ones(size(a))*50;
[min(min(a)), max(max(a)), min(min(b)), max(max(b))]
Rgb=Labtorgb(L,a,b,true);



%Add normalised U and V vectors to the a and b channels
f=1;
[velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
theimage=cim{f};
Lab=Rgbtolab(theimage,[],[],true);
fprintf('L channel (%.16f,%.16f)\na channel (%.16f,%.16f)\nb channel (%.16f,%.16f)\n',...
    min(min(Lab(:,:,1))),max(max(Lab(:,:,1))),...
    min(min(Lab(:,:,2))),max(max(Lab(:,:,2))),...
    min(min(Lab(:,:,3))),max(max(Lab(:,:,3))) );

% Lprime=Rerangeimage(sqrt((velUp.^2)+(velVp.^2)),minL,maxL);
usemeanstd=true; usetanh=true;
% aprime=Rerangeimage(velUp,minab,maxab,usetanh,usemeanstd);
% bprime=Rerangeimage(velVp,minab,maxab,usetanh,usemeanstd);
phasedifference=0;
[aprime,bprime]=Rerangeflows(velUp,velVp,minab,maxab,usetanh,usemeanstd,phasedifference,[],[],true);
Init_figure_no(306), imagesc(aprime), title('U flow re-normalized');
Init_figure_no(307), imagesc(bprime), title('V flow re-normalized');

% Lab(:,:,1)=0.5*Lab(:,:,1)+0.5*Lprime;
Lab(:,:,2)=0.5*Lab(:,:,2)+0.5*aprime;
Lab(:,:,3)=0.5*Lab(:,:,3)+0.5*bprime;
Init_figure_no(302), imagesc(Lab(:,:,2)), title('a channel');
Init_figure_no(303), imagesc(Lab(:,:,3)), title('b channel');

Rgb=Labtorgb(Lab,[],[],true);




%%%Creation of image with optical flow without normalization

%Values about gamut extracted from the quadrants (fully saturated colours)
minL=0; maxL=100;
minab=-86.1812575110439383; maxab=98.2351514395151639;

%Computation of min and maxflow
[minflow, maxflow]=Minmaxflows(flows, true);

% %Computation of statistics of magnitude of flows
% %Case quantile at each frame
% imagepixels=size(cim{1},1)*size(cim{1},2);
% percentagediscarded=0.0003; %Percentage of values to be discarded at each frame in total
% neglectextremapixels=min(max( round(percentagediscarded*imagepixels/2) ,0),floor(imagepixels/2)); %Pixels to discard at each extrema
% takenimagepixels=imagepixels-2*neglectextremapixels; %Pixels to keep at each frame
% allmagnitude=zeros(2*takenimagepixels*(noFrames-1),1);
% noFrames=numel(flows.flows);
% count=0;
% for f=1:noFrames
%     [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
%     if (f>1)
%         magnitude=sqrt(velUm.^2+velVm.^2);
%         allmagnitude(count*takenimagepixels+1:count*takenimagepixels+takenimagepixels)=Addquantiledmagnitudes(magnitude(:),neglectextremapixels);
%         count=count+1;
%     end
%     if (f<noFrames)
%         magnitude=sqrt(velUp.^2+velVp.^2);
%         allmagnitude(count*takenimagepixels+1:count*takenimagepixels+takenimagepixels)=Addquantiledmagnitudes(magnitude(:),neglectextremapixels);
%         count=count+1;
%     end
% end
% %neglectpixels are allowed to be neglected at each extreme in each image
% fprintf('Magnitudes %d, frames %d, pixels at frame %d, discarded pixels at frame in total %d,\n mean %f, std %f, min %.10f, max %.10f\n',...
%     numel(allmagnitude), 2*(noFrames-1), imagepixels, neglectextremapixels*2,mean(allmagnitude), ...
%     std(allmagnitude), min(allmagnitude), max(allmagnitude));


% %Computation of statistics of magnitude of flows
% %Case quantile on all magnitudes
% imagepixels=size(cim{1},1)*size(cim{1},2);
% allmagnitude=zeros(2*imagepixels*(noFrames-1),1);
% noFrames=numel(flows.flows);
% count=0;
% for f=1:noFrames
%     [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
%     if (f>1)
%         magnitude=sqrt(velUm.^2+velVm.^2);
%         allmagnitude(count*imagepixels+1:count*imagepixels+imagepixels)=magnitude(:);
%         count=count+1;
%     end
%     if (f<noFrames)
%         magnitude=sqrt(velUp.^2+velVp.^2);
%         allmagnitude(count*imagepixels+1:count*imagepixels+imagepixels)=magnitude(:);
%         count=count+1;
%     end
% end
% %neglectpixels are allowed to be neglected at each extreme in each image
% percentagediscarded=0.0003;
% neglectpixels=min(max( round(percentagediscarded*imagepixels) ,1),imagepixels);
% neglectpixelsprobabilities=(neglectpixels/imagepixels);
% fprintf('Magnitudes %d, frames %d, pixels at frame %d, discarded pixels in total %d, mean %f, std %f,\n quantiles %.10f %.10f, min %f, max %f\n',...
%     numel(allmagnitude), 2*(noFrames-1), imagepixels, neglectpixels*2*(noFrames-1),mean(allmagnitude), ...
%     std(allmagnitude), quantile(allmagnitude,neglectpixelsprobabilities), quantile(allmagnitude,1-neglectpixelsprobabilities),...
%     min(allmagnitude), max(allmagnitude));
% fprintf('Magnitudes %d, frames %d, pixels at frame %d, discarded pixels in total %d, mean %f, std %f,\n quantiles %.10f %.10f, min %f, max %f\n',...
%     numel(allmagnitude), 2*(noFrames-1), imagepixels, neglectpixels*2*(noFrames-1),mean(allmagnitude), ...
%     std(allmagnitude), Gettruequantile(allmagnitude,neglectpixelsprobabilities), Gettruequantile(allmagnitude,1-neglectpixelsprobabilities),...
%     min(allmagnitude), max(allmagnitude));


%Case considered
f=1;
[velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
Uflow=velUp;
Vflow=velVp;

%Data prior to normalization
Lab=zeros(size(cim{1},1),size(cim{1},2),3);
Lab(:,:,1)=0.5*minL+0.5*maxL;
Lab(:,:,2)=min(max(Uflow,minab),maxab);
Lab(:,:,3)=min(max(Vflow,minab),maxab);
fprintf('L channel (%.16f,%.16f)\na channel (%.16f,%.16f)\nb channel (%.16f,%.16f)\n',...
    min(min(Lab(:,:,1))),max(max(Lab(:,:,1))),...
    min(min(Lab(:,:,2))),max(max(Lab(:,:,2))),...
    min(min(Lab(:,:,3))),max(max(Lab(:,:,3))) );
Rgb=Labtorgb(Lab,[],[],true);

%Normalization
usemeanstd=false;
usetanh=false;
phasedifference=0;
[aprime,bprime]=Rerangeflows(Uflow,Vflow,minab,maxab,usetanh,usemeanstd,phasedifference,minflow,maxflow,true);
Lab=zeros(size(cim{1},1),size(cim{1},2),3);
Lab(:,:,1)=0.5*minL+0.5*maxL;
Lab(:,:,2)=min(max(aprime,minab),maxab);
Lab(:,:,3)=min(max(bprime,minab),maxab);

%Data upon normalization
fprintf('L channel (%.16f,%.16f)\na channel (%.16f,%.16f)\nb channel (%.16f,%.16f)\n',...
    min(min(Lab(:,:,1))),max(max(Lab(:,:,1))),...
    min(min(Lab(:,:,2))),max(max(Lab(:,:,2))),...
    min(min(Lab(:,:,3))),max(max(Lab(:,:,3))) );
Rgb=Labtorgb(Lab,[],[],true);




f=1;
[velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
[min(min(velUp)), max(max(velUp)), min(min(velVp)), max(max(velVp))]
magnitude=sqrt(velUp.^2+velVp.^2);
[ min(magnitude(:)) , max(magnitude(:)) ]

a=velUp;
b=velVp;
L=zeros(size(a));
Rgb=Labtorgb(L,a,b,true);

a=Rerangeimage(velUp,minab,maxab);
b=Rerangeimage(velVp,minab,maxab);
L=ones(size(a))*50;
[min(min(a)), max(max(a)), min(min(b)), max(max(b))]
Rgb=Labtorgb(L,a,b,true);



%Add normalised U and V vectors to the a and b channels
f=1;
[velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
theimage=cim{f};
Lab=Rgbtolab(theimage,[],[],true);
fprintf('L channel (%.16f,%.16f)\na channel (%.16f,%.16f)\nb channel (%.16f,%.16f)\n',...
    min(min(Lab(:,:,1))),max(max(Lab(:,:,1))),...
    min(min(Lab(:,:,2))),max(max(Lab(:,:,2))),...
    min(min(Lab(:,:,3))),max(max(Lab(:,:,3))) );

% Lprime=Rerangeimage(sqrt((velUp.^2)+(velVp.^2)),minL,maxL);
usemeanstd=true; usetanh=true;
% aprime=Rerangeimage(velUp,minab,maxab,usetanh,usemeanstd);
% bprime=Rerangeimage(velVp,minab,maxab,usetanh,usemeanstd);
phasedifference=0;
[aprime,bprime]=Rerangeflows(velUp,velVp,minab,maxab,usetanh,usemeanstd,phasedifference,[],[],true);
Init_figure_no(306), imagesc(aprime), title('U flow re-normalized');
Init_figure_no(307), imagesc(bprime), title('V flow re-normalized');

% Lab(:,:,1)=0.5*Lab(:,:,1)+0.5*Lprime;
Lab(:,:,2)=0.5*Lab(:,:,2)+0.5*aprime;
Lab(:,:,3)=0.5*Lab(:,:,3)+0.5*bprime;
Init_figure_no(302), imagesc(Lab(:,:,2)), title('a channel');
Init_figure_no(303), imagesc(Lab(:,:,3)), title('b channel');

Rgb=Labtorgb(Lab,[],[],true);
