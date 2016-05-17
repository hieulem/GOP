function [bincounts,bincenters]=Loadalltheflowsfornormalization(basedrive,applytimefilter,printonscreen)

if ( (~exist('applytimefilter','var')) || (isempty(applytimefilter)) )
    applytimefilter=false;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
printonscreeninsidefunction=false;

allcasesnames=Provideallnamesofcases(basedrive);

extremum=60;

minU=-extremum; maxU=extremum; minV=-extremum; maxV=extremum; binunumbers=301;binvnumbers=301; %odd number of bins for best alignment in the visualization
[bincounts,bincenters]=Prepareatwodhistogram(minU,maxU,minV,maxV,binunumbers,binvnumbers);

for i=1:numel(allcasesnames)
    filenames=Getfilenames(allcasesnames{i});
    
    load(filenames.filename_flows);
    
    if (applytimefilter)
        framedepth=2;
        flows=Mediantimefilter(flows,framedepth);
    end
    
    noFrames=numel(flows.flows);
    for f=1:noFrames
        [velUm,velVm,velUp,velVp]=GetUandV(flows.flows{f});
%         velVm(:)=0;
%         velVp(:)=-0;
        if (f>1)
            bincounts=Addflowtohistogramtwo(-velUm,-velVm,bincenters,bincounts,printonscreeninsidefunction);
        end
        if (f<noFrames)
            bincounts=Addflowtohistogramtwo(velUp,velVp,bincenters,bincounts,printonscreeninsidefunction);
        end
    end

end

%log of counts
bincounts=log(max(bincounts,1));



if (printonscreen)
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

