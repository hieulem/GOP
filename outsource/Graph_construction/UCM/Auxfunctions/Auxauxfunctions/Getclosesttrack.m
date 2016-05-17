function k=Getclosesttrack(track,ipos,jpos)
% dist_track_mask{which frame,which trajectory}=mask
% track = [ which frame , x or y , which trajectory ]

fc=round( (size(track,1)-1)/2 ) + 1;
noTracks=size(track,3);

%Scans through tracks and computes distances
dist=zeros(1,noTracks);
for k=1:noTracks
    dist(k)=sqrt( (track(fc,1,k)-jpos)^2+(track(fc,2,k)-ipos)^2 );
end

%Computation of the closest trajectory
[c,k]=min(dist); %min only returns the first minimum

% hold on
% plot(track(fc,1,k),track(fc,2,k),'+g');
% hold off
