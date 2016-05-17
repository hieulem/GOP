function region=lookUpRegioninAllregionsframes(allregionsframes,frame,level,label)

region=0;
for r=1:size(allregionsframes{frame},2)
    for l=1:size(allregionsframes{frame}{r}.ll,1)
        if ( (allregionsframes{frame}{r}.ll(l,1)==level) &&...
                (allregionsframes{frame}{r}.ll(l,2)==label) )
            region=r;
        end
        if (region)
            break;
        end
    end
    if (region)
        break;
    end
end
