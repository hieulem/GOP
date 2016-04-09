function [flowvariancep,flowvariancem]=Computeflowvariance(conrr,concc,labels,velUp,velVp,velUm,velVm,mapped,frame,labelsatframe,thedepth,printonscreen)
%frame=f;

if ( (~exist('thedepth','var')) || (isempty(thedepth)) )
    thedepth=3;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

printonscreeninsidefunction=false;

numberoflabels=max(labels(:));

flowvariancep=zeros(size(labels));
flowvariancem=zeros(size(labels));

for alabel=1:numberoflabels

    
    globallabel=mapped(frame,alabel);
    globalneighlabels=Getneighborlabels(globallabel,concc,conrr,thedepth,printonscreeninsidefunction,labels,mapped);
    neighlabels=labelsatframe(globalneighlabels);

    themask=ismember(labels,neighlabels); %(size(labels));
    % Init_figure_no(12), imagesc(themask)

    uvalues=velUp(themask);
    vvalues=velVp(themask);
    flowvariancep(labels==alabel)=var(uvalues)+var(vvalues);
    uvalues=velUm(themask);
    vvalues=velVm(themask);
    flowvariancem(labels==alabel)=var(uvalues)+var(vvalues);
end

if (printonscreen)
    Init_figure_no(13), imagesc(flowvariancep);
end


    