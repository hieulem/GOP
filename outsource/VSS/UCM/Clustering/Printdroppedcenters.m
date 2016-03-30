function Printdroppedcenters(C,agroupnumber)

droppedcentres=isnan(C(:,1));
if (any(droppedcentres))
    nodropped=sum(droppedcentres);
    whichdropped=find(droppedcentres);
    fprintf('%d groups: dropped %d clusters ( ',agroupnumber,nodropped); fprintf('%d ',whichdropped); fprintf(')\n');
end
