function Compactmc(theDir,iids,allnames,nameoccurrences,stepkocc,maxscorerow)
%Compact the results in theDir

% allnames
nameoccurrences(:)=false;
stepkocc=sort(stepkocc,'ascend');



%Accumulate results
allthescores=zeros(maxscorerow,numel(stepkocc),numel(allnames)); %written as allthescores(:,:,videoseq), no need to traspose in fprintf
for i = 1:numel(iids)

    inFile = fullfile(theDir, strcat(iids(i).name(1:end-4), '.txt'));

    score = dlmread(inFile);
    % score=[1 stepk,2 createdk,3 noallobjects,4 averageprecision,5 averagerecall,6 allprecisepixels,7 allrecalledpixels,
    %8 totalobjectpixels,9 coveredpixels,10 totpixels,11 totallengths,12 totalsquaredlength]

    thevideoname=Findthevideosequencename(iids(i).name);

    [allnames,nameoccurrences,stepkocc,repeatedocc,thevpos,allthepos]=Findaddcheckavideoname(allnames,nameoccurrences,stepkocc,thevideoname,score(:,1));

    for j=1:size(score,1)
        if (repeatedocc(j))
            fprintf('Excluding repeated\n');
            continue;
        end

        allthescores(1:numel(score(j,:)),allthepos(j),thevpos)=score(j,:)';
    end

    if (mod(i,20)==0), fprintf(' %d', i); end
end
fprintf('\n');



%empty theDir
delete(fullfile(theDir, '*.txt'))
% rmdir(theDir,'s');
% mkdir(theDir);



%write results in a new theDir
writeformat=[]; %'%10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g %10g\n'
for j=1:maxscorerow
    writeformat=[writeformat,'%10g ']; %#ok<AGROW>
end
writeformat=[writeformat(1:end-1), '\n'];


for i=1:numel(allnames)
    outFile = fullfile(theDir, strcat(allnames{i}, '.txt'));
    fid = fopen(outFile,'w');
    if fid==-1,
        error('Could not open file %s for writing.',outFile);
    end
    fprintf(fid,writeformat, allthescores(:,:,i));
    fclose(fid);
end
