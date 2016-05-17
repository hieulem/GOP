function theassignedlabel=Findthecolour(colourtocompare,colourcode)

theassignedlabel=0;
for i=1:numel(colourcode)
    if (all(colourtocompare==colourcode{i}))
        theassignedlabel=i;
        break;
    end
end


