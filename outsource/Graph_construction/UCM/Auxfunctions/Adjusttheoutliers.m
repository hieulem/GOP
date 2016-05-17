function IDX=Adjusttheoutliers(IDX)
%This function converts outliers -1 to single point clusters
%Outliers -10 are left unchanged

outliers=find(IDX==(-1));
nooutliers=numel(outliers);

maxset=max(IDX);

count=maxset;
for i=outliers'
    
    count=count+1;
    IDX(i)=count;
    
end

fprintf('Clusters assigned %d', maxset);
if (nooutliers>0)
    fprintf(', number of outliers %d, replacing them with single entry clusters\n',nooutliers);
else
    fprintf('\n');
end    
