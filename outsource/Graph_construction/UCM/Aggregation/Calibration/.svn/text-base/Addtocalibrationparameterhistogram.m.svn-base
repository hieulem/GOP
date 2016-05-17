function thebincounts=Addtocalibrationparameterhistogram(bincenters,thevalues,thebincounts,printonscreen)
% thevalues=sva(addtopos); thebincounts=posbin;

if ( (~exist('thebincounts','var')) || (isempty(thebincounts)) )
    thebincounts=zeros(1,numel(bincenters));
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end



[abincount] = hist(thevalues,bincenters);

thebincounts=thebincounts+abincount;

if (printonscreen)
    Init_figure_no(10);
    hist(thevalues,bincenters);
    xlabel('bin'); ylabel('count');
end
