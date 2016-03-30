function Collectevalaluatereg(outDir)
% Pablo Arbelaez <arbelaez@eecs.berkeley.edu>
%
% modified by Fabio Galasso
% October 2012

%SC
fname = fullfile(outDir, 'eval_cover.txt');
S = dir(fullfile(outDir,'*_ev2.txt'));
if ( (length(dir(fname))~=1) && (~isempty(S)) )
    
    % deduce nthresh from files
    AA = dlmread(fullfile(outDir,S(1).name));
    nthresh = size(AA,1);
    
    cntR_total = zeros(nthresh,1);
    sumR_total = zeros(nthresh,1);
    cntP_total = zeros(nthresh,1);
    sumP_total = zeros(nthresh,1);
    cntR_best = 0;
    sumR_best = 0;
    cntP_best = 0;
    sumP_best = 0;
    
    cntR_best_total = 0;
    
    scores = zeros(numel(S),4);
    
    fprintf('Processing regions:');
    for i = 1:numel(S),
        
        fprintf(' %d',i);
%         iid = S(i).name(1:end-8);
%         fprintf(2,'Processing image %s (%d/%d)...\n',iid,i,length(S));
        
        evFile1 = fullfile(outDir,S(i).name);
        tmp  = dlmread(evFile1);

        %check and adjust different number of coarse-to-fine levels
        %This is used for algorithm which do not let the user fix the
        %number of levels. The finest level is replicated
        tmpsize=size(tmp,1);
        if (tmpsize<nthresh) %if not of equal size, the final line is replicated
            tmp=[tmp;repmat(tmp(end,:),nthresh-tmpsize,1)]; %#ok<AGROW>
        elseif (tmpsize>nthresh)
            cntR_total=[cntR_total;repmat(cntR_total(end),tmpsize-nthresh,1)]; %#ok<AGROW>
            sumR_total=[sumR_total;repmat(sumR_total(end),tmpsize-nthresh,1)]; %#ok<AGROW>
            cntP_total=[cntP_total;repmat(cntP_total(end),tmpsize-nthresh,1)]; %#ok<AGROW>
            sumP_total=[sumP_total;repmat(sumP_total(end),tmpsize-nthresh,1)]; %#ok<AGROW>
            nthresh=tmpsize;
        end
        
        thresh = tmp(:, 1);
        cntR = tmp(:, 2);
        sumR = tmp(:, 3);
        cntP = tmp(:, 4);
        sumP = tmp(:, 5);
        
        R = cntR ./ (sumR + (sumR==0));
        P = cntP ./ (sumP + (sumP==0));
        
        [bestR ind] = max(R);
        bestT = thresh(ind(1));
        bestP = P(ind(1));
        scores(i,:) = [i bestT bestR bestP ];
        
        cntR_total = cntR_total + cntR;
        sumR_total = sumR_total + sumR;
        cntP_total = cntP_total + cntP;
        sumP_total = sumP_total + sumP;
        
        ff=find(R==max(R));
        cntR_best = cntR_best + cntR(ff(end));
        sumR_best = sumR_best + sumR(ff(end));
        cntP_best = cntP_best + cntP(ff(end));
        sumP_best = sumP_best + sumP(ff(end));
        
        evFile2 = fullfile(outDir,[S(i).name(1:end-5) '3.txt']);
        tmp  = dlmread(evFile2);
        cntR_best_total = cntR_best_total + tmp(1);
        
    end
    fprintf('\n');
    
    R = cntR_total ./ (sumR_total + (sumR_total==0));
    
    [bestR ind] = max(R);
    bestT = thresh(ind(1));
    
    
    fname = fullfile(outDir,'eval_cover_img.txt');
    fid = fopen(fname,'w');
    if fid==-1,
        error('Could not open file %s for writing.',fname);
    end
    fprintf(fid,'%10d %10g %10g %10g\n',scores');
    fclose(fid);
    
    fname = fullfile(outDir,'eval_cover_th.txt');
    fid = fopen(fname,'w');
    if fid==-1,
        error('Could not open file %s for writing.',fname);
    end
    fprintf(fid,'%10g %10g\n',[thresh R]');
    fclose(fid);
    
    R_best = cntR_best ./ (sumR_best + (sumR_best==0));
    
    R_best_total = cntR_best_total / sumR_total(1) ;
    
    fname = fullfile(outDir,'eval_cover.txt');
    fid = fopen(fname,'w');
    if fid==-1,
        error('Could not open file %s for writing.',fname);
    end
    fprintf(fid,'%10g %10g %10g %10g\n',bestT, bestR, R_best, R_best_total);
    fclose(fid);
    
    %bestT,bestR,bestP numbers in scores (eval_cover_img.txt) from best R,P,F across the thresholds for each image:
    %for each image, R and P are computed for all thresholds and the best
    %values are chosen according to R

    %R values and T in eval_cover_th.txt: for each image, cntR and sumR are summed
    %to form a total for each threshold. cntR_total/sumR_total are the global
    %R scores for each threshold
    
    %bestT, bestR, R_best, R_best_total in eval_cover.txt: cntR/P and
    %sumR/P are summed for each threshold across the images to form
    %cntR/P_total and sumR/P_total. The best R value across the thresholds
    %is bestR and its index is bestT. The best values of R and P across
    %thresholds are chosen according to R and summed up across images to
    %form cntR/P_best and sumR/P_best. Their ratio provides R_best.
    %The best R, considering for each ground truth segment the best matched
    %segment (over all thresholds) from the computed segmentation, is
    %summed up and divided by the summed total for the R for the lowest
    %threshold to provide R_best_total
    
end

%PRI and VI
fname = fullfile(outDir, 'eval_RI_VOI.txt');
S = dir(fullfile(outDir,'*_ev4.txt'));
if ( (length(dir(fname))~=1) && (~isempty(S)) )
    
    % deduce nthresh from files
    AA = dlmread(fullfile(outDir,S(1).name));
    nthresh = size(AA,1);
    
    globalRI = zeros(nthresh,1);
    globalVOI = zeros(nthresh,1);
    RI_best = 0;
    VOI_best = 0;
    
    fprintf('Processing regions (PRI, VI):');
    for i = 1:numel(S),
        
        fprintf(' %d',i);
%         iid = S(i).name(1:end-8);
%         fprintf(2,'Processing image %s (%d/%d)...\n',iid,i,length(S));
        
        evFile3 = fullfile(outDir,S(i).name);
        tmp  = dlmread(evFile3);

        %check and adjust different number of coarse-to-fine levels
        %This is used for algorithm which do not let the user fix the
        %number of levels. The finest level is replicated
        tmpsize=size(tmp,1);
        if (tmpsize<nthresh) %if not of equal size, the final line is replicated
            tmp=[tmp;repmat(tmp(end,:),nthresh-tmpsize,1)]; %#ok<AGROW>
        elseif (tmpsize>nthresh)
            globalRI=[globalRI;repmat(globalRI(end),tmpsize-nthresh,1)]; %#ok<AGROW>
            globalVOI=[globalVOI;repmat(globalVOI(end),tmpsize-nthresh,1)]; %#ok<AGROW>
            nthresh=tmpsize;
        end
        
        thresh = tmp(:, 1);
        globalRI = globalRI + tmp(:,2);
        globalVOI = globalVOI + tmp(:,3);
        
        ff = find( tmp(:,2)==max(tmp(:,2)) );
        RI_best = RI_best + tmp(ff(end),2);
        ff = find( tmp(:,3)==min(tmp(:,3)) );
        VOI_best = VOI_best + tmp(ff(end),3);
    end
    fprintf('\n');
    
    globalRI = globalRI / numel(S);
    globalVOI = globalVOI / numel(S);
    RI_best = RI_best / numel(S);
    VOI_best = VOI_best / numel(S);
    [bgRI igRI]=max(globalRI);
    [bgVOI igVOI]=min(globalVOI);
    
    fname = fullfile(outDir,'eval_RI_VOI_thr.txt');
    fid = fopen(fname,'w');
    if fid==-1,
        error('Could not open file %s for writing.',fname);
    end
    fprintf(fid,'%10g %10g %10g\n',[thresh globalRI globalVOI]');
    fclose(fid);

    fname = fullfile(outDir,'eval_RI_VOI.txt');
    fid = fopen(fname,'w');
    if fid==-1,
        error('Could not open file %s for writing.',fname);
    end
    fprintf(fid,'%10g %10g %10g %10g %10g %10g\n',thresh(igRI), bgRI, RI_best, thresh(igVOI),  bgVOI, VOI_best);
    fclose(fid);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute f-measure fromm recall and precision
function [f] = fmeasure(r,p)
f = 2*p.*r./(p+r+((p+r)==0));

% interpolate to find best F and coordinates thereof
function [bestT,bestR,bestP,bestF] = maxF(thresh,R,P)
bestT = thresh(1);
bestR = R(1);
bestP = P(1);
bestF = fmeasure(R(1),P(1));
for i = 2:numel(thresh),
  for d = linspace(0,1),
    t = thresh(i)*d + thresh(i-1)*(1-d);
    r = R(i)*d + R(i-1)*(1-d);
    p = P(i)*d + P(i-1)*(1-d);
    f = fmeasure(r,p);
    if f > bestF,
      bestT = t;
      bestR = r;
      bestP = p;
      bestF = f;
    end
  end
end




