function bincounts=Addflowtohistogramtwo(velU,velV,bincenters,bincounts,printonscreen)

% velU=velUp;velV=velVp;

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('bincounts','var')) || (isempty(bincounts)) )
    bincounts=zeros([numel(bincenters.ucenters),numel(bincenters.vcenters)]);
end

[abincount] = hist3([velU(:),velV(:)],'Ctrs',bincenters);

bincounts=bincounts+abincount;

if (printonscreen)
    Init_figure_no(10);
    hist3([velU(:),velV(:)],'Ctrs',bincenters);
    xlabel('U flow'); ylabel('V flow');

    Init_figure_no(20);
    surf(bincenters{2},bincenters{1},bincounts);
    xlabel('V flow'); ylabel('X flow');
    
end





