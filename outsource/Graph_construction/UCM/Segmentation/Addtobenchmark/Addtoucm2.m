function considerednewucm2=Addtoucm2(frameofinterest,labelledvideo,considerednewucm2,printonscreen)

if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end

dimIi=size(labelledvideo,1);
dimIj=size(labelledvideo,2);

for f=frameofinterest
    newucm2frame=considerednewucm2{f};

    for i=1:dimIi
        ui=min(dimIi,i+1);
        for j=1:dimIj
            uj=min(dimIj,j+1);

            if (labelledvideo(i,j,f)~=labelledvideo(ui,j,f))
                newucm2frame(2*i+1,2*j-1:2*j+1)=considerednewucm2{f}(2*i+1,2*j-1:2*j+1)+1;
            end
            if (labelledvideo(i,j,f)~=labelledvideo(i,uj,f))
                newucm2frame(2*i-1:2*i+1,2*j+1)=considerednewucm2{f}(2*i-1:2*i+1,2*j+1)+1;
            end
        end
    end

    considerednewucm2{f}=newucm2frame;

    if (printonscreen)
%         for level=1:max(considerednewucm2{f}(:))
%             labels2 = bwlabel(considerednewucm2{f} < level);
%             labels = labels2(2:2:end, 2:2:end);
%             Init_figure_no(5), imagesc(labels)
%             title(['Level ',num2str(level)]);
%         end
        Init_figure_no(6), imagesc(considerednewucm2{f})
        drawnow;
    end
end


