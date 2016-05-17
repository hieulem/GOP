function Representgraphconnections(track,dist_track_mask,imagefc,thecorrespondingtrack,allweights,nofigure,colourratio,colourforimage,colourforedges,colourfortrack)


%track = [ which frame , x or y , which trajectory ]
% dist_track_mask{which frame,which trajectory}=mask

fc=round( (size(dist_track_mask,1)-1)/2 ) + 1;

if ( (~exist('nofigure','var')) || (isempty(nofigure)) )
    nofigure=16;
end
if ( (~exist('colourratio','var')) || (isempty(colourratio)) )
    colourratio=1/2;
end
if ( (~exist('colourforimage','var')) || (isempty(colourforimage)) )
    colourforimage=[1,1,0];
end
if ( (~exist('colourforedges','var')) || (isempty(colourforedges)) )
    colourforedges=[1,0,0];
end
if ( (~exist('colourfortrack','var')) || (isempty(colourfortrack)) )
    colourfortrack=[1,0,1];
end
thickeredges=false;

allothers=1:size(dist_track_mask,2);
allothers(thecorrespondingtrack)=[];
imagefc=Colourtheimage(imagefc,dist_track_mask(fc,thecorrespondingtrack),nofigure,colourratio,colourfortrack,colourforedges,thickeredges);
if (~isempty(allothers))
    Colourtheimage(imagefc,dist_track_mask(fc,allothers),nofigure,colourratio,colourforimage,colourforedges,thickeredges);
end


noTracks=size(dist_track_mask,2);

hold on
for k=1:noTracks
    plot(track(fc,1,k),track(fc,2,k),'+b');
end
hold off



if ( (~exist('allweights','var')) || (isempty(allweights)) )
    allweights=ones(1,numel(allothers)-1)*0.6;
end



for i=1:numel(allothers)
    hold on
    line([track(fc,1,thecorrespondingtrack);track(fc,1,allothers(i))],...
        [track(fc,2,thecorrespondingtrack);track(fc,2,allothers(i))],...
        'Color',GiveDifferentColours(1-allweights(i),4/3),'LineWidth',2.3);
    hold off
end







function Colour()

figure(16)
for i=1:-0.01:-0
    hold on
    line([1;123],[1;123],'Color',GiveDifferentColours(i,4/3),'LineWidth',3);
    hold off
    pause(0.1)
end
%1 is blue, 0 is red, numbers inbetween follow matlab convention with
%repratio=4/3