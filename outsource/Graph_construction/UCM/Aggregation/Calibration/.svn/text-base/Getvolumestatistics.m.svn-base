function [npoints,sumvol,sumsqrdvol,sumvolabth,sumsqrdvolabth,sumnconn,sumsqrdnconn,sumnconnabth,sumsqrdnconnabth]=Getvolumestatistics(sxa,sya,sva,noallsuperpixels)

th=0.01;

% tic
npoints=0; sumvol=0; sumsqrdvol=0; sumvolabth=0; sumsqrdvolabth=0; sumnconn=0; sumsqrdnconn=0; sumnconnabth=0; sumsqrdnconnabth=0;

for i=1:noallsuperpixels
    
    npoints=npoints+1;
    
    allsvai= [sva(sxa==i) ; sva(sya==i)];
    volumeabth= sum(allsvai(allsvai>th)) / 2;
    volume= sum(allsvai) / 2;
    
    nconn=numel(allsvai)/2;
    nconnabth=sum(allsvai>th)/2;
    
    sumsqrdnconnabth=sumsqrdnconnabth+ nconnabth^2;
    sumnconnabth=sumnconnabth+ nconnabth;
    
    sumsqrdnconn=sumsqrdnconn+ nconn^2;
    sumnconn=sumnconn+ nconn;
    
    sumsqrdvolabth=sumsqrdvolabth+ volumeabth^2;
    sumvolabth=sumvolabth+ volumeabth;
    
    sumsqrdvol=sumsqrdvol+ volume^2;
    sumvol=sumvol+ volume;
    
end
% toc

%Computation exploiting that the similarities have zero diagonal elements
% tic
% npoints=0; sumvol=0; sumsqrdvol=0;
% for i=1:noallsuperpixels
%     
%     npoints=npoints+1;
%     
%     volume= ( sum(sva(sxa==i)) + sum(sva(sya==i)) ) / 2;
%     
%     sumsqrdvol=sumsqrdvol+ volume^2;
%     sumvol=sumvol+ volume;
%     
% end
% toc

%This is the appropriate calculation, it equals the one above for
%similarities with zero diagonal elements
% tic
% npoints=0; sumvol=0; sumsqrdvol=0;
% for i=1:noallsuperpixels
%     
%     npoints=npoints+1;
%     
%     volume= ( sum(sva( (sxa==i)&(sya~=i) )) + sum(sva( (sya==i)&(sxa~=i) )) ) / 2;
%     
%     sumsqrdvol=sumsqrdvol+ volume^2;
%     sumvol=sumvol+ volume;
%     
% end
% toc

