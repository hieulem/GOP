function Add_to_figure(vect,nofigure,groupno)


%The function adds to figure the data in vect.
%If vect is 2xN it uses plot3 adding a third dimension as a count
%If vect is 1xN it uses plot adding a second dimension as a count
%If vect is 2x1 it uses plot plotting the point with a + on the screen

col=GiveDifferentColours(groupno);

figure(nofigure);
hold on
if (size(vect,2)>1)
    if (size(vect,1)>1)
        plot3(vect(1,:),vect(2,:),1:size(vect,2),'Color',col)
    else
        plot(vect(1,:),1:size(vect,2),'Color',col)
    end
else
    if (size(vect,1)>1)
        plot(vect(1),vect(2),'+','color',col)
    else
        plot(vect(1),1,'+','color',col)
    end
end
hold off
