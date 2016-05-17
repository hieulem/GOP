function [posbin,negbin]=Groundtruthbinningaffinityvalues(sxa,sya,sva,labelsgt,thiscase,printonscreen)
% posbin and negbing are row vectors
% labelsgt=theoptiondata.labelsgt;

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
printonscreeninsidefunction=false;


[posbin,negbin,bincenters,themin,themax]=Inittheparametercalibrationhistogram(thiscase);



%Select elements to add
addtopos=false(size(sva));
addtoneg=false(size(sva));

addtopos( (labelsgt(sxa)>0) & (labelsgt(sya)>0) & (labelsgt(sya)==labelsgt(sxa)) )=true;
addtoneg( (labelsgt(sxa)>0) & (labelsgt(sya)>0) & (labelsgt(sya)~=labelsgt(sxa)) )=true;


posbin=Addtocalibrationparameterhistogram(bincenters,sva(addtopos),posbin,printonscreeninsidefunction);
negbin=Addtocalibrationparameterhistogram(bincenters,sva(addtoneg),negbin,printonscreeninsidefunction);

if (printonscreen)
    figurenumber=10;
    Plotaffinityplots([negbin;posbin],[],thiscase,{'false','true'},figurenumber)
%     Plotaffinitybars([negbin;posbin],thiscase,{'false','true'},figurenumber)
end





%Sample code to represent histograms
if (false)
    %log of counts
    bincounts=log(max(bincounts,1));

%     bincounts(1,20)=6000000;

    Init_figure_no(20);
    surf(bincenters{2},bincenters{1},bincounts);
    xlabel('V flow'); ylabel('U flow');

    Init_figure_no(21);
    [xx,yy,zz]=find(bincounts);
    plot3(bincenters{1}(xx),bincenters{2}(yy),zz,'.');
    xlabel('U flow'); ylabel('V flow');

    Init_figure_no(24);
    imagesc([bincenters{2}(1),bincenters{2}(end)],[bincenters{1}(1),bincenters{1}(end)],bincounts)
    xlabel('V flow'); ylabel('U flow');

%     Init_figure_no(27);
%     bar3(bincenters{1},bincounts);
%     xlabel('V flow'); ylabel('U flow');
end










