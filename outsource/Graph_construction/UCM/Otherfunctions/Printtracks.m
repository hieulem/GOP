function Printtracks(track,image)

noTracks=size(track,3);

figure(15)
imshow(image)
set(gcf, 'color', 'white');

hold on
for k=1:noTracks
    line(track(:,1,k),track(:,2,k),'Color','y');
    plot(track(:,1,k),track(:,2,k),'+g');
    plot(track(1,1,k),track(1,2,k),'+r');
end
hold off

