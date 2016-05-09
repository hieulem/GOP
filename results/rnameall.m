di = 'matresult/';
d = dir(di)
d(1:2) =[];
for i=1:length(d)
    k = d(i).name;
    new = ['chisq_',k];
    cm = ['mv ',di,k,' ', di,new]
    dos(cm)
end
