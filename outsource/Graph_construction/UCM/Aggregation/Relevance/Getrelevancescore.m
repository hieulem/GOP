function F=Getrelevancescore(ii,jj,ff,similarities,labelledlevelunique,nfigure,stillframe)

if ( (~exist('stillframe','var')) || (isempty(stillframe)) )
    stillframe=1;
end
if ( (~exist('nfigure','var')) || (isempty(nfigure)) )
    nfigure=5;
end


S=Sfromw(similarities);



wlabels=1; %The relevance score of a point to the surrounding ones, one label
nlabels=numel(wlabels);



numberofsuperpixels=max(labelledlevelunique(:));
chosenspxlabel=labelledlevelunique(ii,jj,ff);

Y=ones(numberofsuperpixels,nlabels)*0;
Y(chosenspxlabel,1)=1;



%Show the (partially) labelled video
% Printthevideoonscreen(Y(labelledlevelunique),true,nfigure,false,true,false,false);



%Propagate labels
alpha=0.985;
niterations=500; %Number of iterations in total (nwatchediterations * ceil(niterations/nwatchediterations) )
nwatchediterations=0; %nwatchediterations check are printed within the iterations, natural number

if (nwatchediterations>=1), iterationseachtime=ceil(niterations/nwatchediterations); else iterationseachtime=niterations; end
for i=1: max(nwatchediterations,1)
    
    F=Iteratelabelprop(Y,S,iterationseachtime,alpha);
    
    fprintf('Iterated %d times\n',i*iterationseachtime);
    
    %Visualization
    if (nwatchediterations>0), Printthevideoonscreen((1/(1-alpha))*F(labelledlevelunique),true,nfigure,false,true,false,false); end
end



%F is the result of propagating, the relevance score or label confidence
F=(1/(1-alpha))*F;



%For visualization purposes the initial label is removed
F(chosenspxlabel,1)=0;
%For visualization purposes the initial label is assigned the maximum
F(chosenspxlabel,1)=max(F(:));

%Visualize the video sequence
% Printthevideoonscreen(F(labelledlevelunique),true,nfigure,false,true,false,false);

%Visualize a frame
stillframe=min(stillframe,size(labelledlevelunique,3));
Printthevideoonscreen(cat(3,F(labelledlevelunique),F(labelledlevelunique(:,:,stillframe))),true,nfigure,false,false,false,false);
%(thevideo, printonscreen, nofigure, toscramble, showcolorbar, writethevideo,treatoutliers,outputfile,printthetext)
figure(nfigure), title(['Frame ',num2str(stillframe)])


