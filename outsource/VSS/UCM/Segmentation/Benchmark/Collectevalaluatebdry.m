function [ bestF, bestP, bestR, bestT, F_max, P_max, R_max, Area_PR] = Collectevalaluatebdry(outDir,addstr)
% function [ bestF, bestP, bestR, bestT, F_max, P_max, R_max, Area_PR ] = Collectevalaluatebdry(outDir)
%
% calculate P, R and F-measure from individual evaluation files
%
% Pablo Arbelaez <arbelaez@eecs.berkeley.edu>
%
% modified by Fabio Galasso
% October 2012

if ( (~exist('addstr','var')) || (isempty(addstr)) )
    addstr=''; %The string is inserted in front of the output files
                %It also replaces 1 in _ev1.txt files
end

fname = fullfile(outDir, [addstr,'eval_bdry_globossods.txt']);
if (length(dir(fname))==1),
  tmp = dlmread(fname); 
  bestT = tmp(1);
  bestR = tmp(2);
  bestP = tmp(3);
  bestF = tmp(4);
  R_max = tmp(5);
  P_max = tmp(6);
  F_max = tmp(7);
  Area_PR = tmp(8);
else

    if (isempty(addstr))
        S = dir(fullfile(outDir,'*_ev1.txt'));
    else
        S = dir(fullfile(outDir,['*_ev',addstr,'.txt']));
    end
    
    if (~isempty(S))

        % deduce nthresh from .pr files
        filename = fullfile(outDir,S(1).name);
        AA = dlmread(filename); % thresh cntR sumR cntP sumP

        thresh = AA(:,1);

        nthresh = numel(thresh);
        cntR_total = zeros(nthresh,1);
        sumR_total = zeros(nthresh,1);
        cntP_total = zeros(nthresh,1);
        sumP_total = zeros(nthresh,1);
        cntR_max = 0;
        sumR_max = 0;
        cntP_max = 0;
        sumP_max = 0;
        scores = zeros(length(S),5);

        %statistics based on best R
        cntR_maxjr = 0;
        sumR_maxjr = 0;
        cntP_maxjr = 0;
        sumP_maxjr = 0;
        scoresjr = zeros(length(S),5);

        fprintf('Processing boundaries:');
        for i = 1:length(S),

            fprintf(' %d',i);
            % iid = S(i).name(1:end-8);
            % fprintf(2,'Processing image %s (%d/%d)...\n',iid,i,length(S));

            filename = fullfile(outDir,S(i).name);
            AA  = dlmread(filename);

            %check and adjust different number of coarse-to-fine levels
            %This is used for algorithm which do not let the user fix the
            %number of levels. The finest level is replicated
            AAsize=size(AA,1);
            if (AAsize<nthresh) %if not of equal size, the final line is replicated
                AA=[AA;repmat(AA(end,:),nthresh-AAsize,1)]; %#ok<AGROW>
            elseif (AAsize>nthresh)
                thresh=[thresh;repmat(thresh(end),AAsize-nthresh,1)]; %#ok<AGROW>
                cntR_total=[cntR_total;repmat(cntR_total(end),AAsize-nthresh,1)]; %#ok<AGROW>
                sumR_total=[sumR_total;repmat(sumR_total(end),AAsize-nthresh,1)]; %#ok<AGROW>
                cntP_total=[cntP_total;repmat(cntP_total(end),AAsize-nthresh,1)]; %#ok<AGROW>
                sumP_total=[sumP_total;repmat(sumP_total(end),AAsize-nthresh,1)]; %#ok<AGROW>
                nthresh=AAsize;
            end

            cntR = AA(:, 2);
            sumR = AA(:, 3);
            cntP = AA(:, 4);
            sumP = AA(:, 5);

            R = cntR ./ (sumR + (sumR==0));
            P = cntP ./ (sumP + (sumP==0));
            F = fmeasure(R,P);

            [bestT,bestR,bestP,bestF] = maxF(thresh,R,P); %Best F-measure for the segmentation, and corresponding thr, p, r
            scores(i,:) = [i bestT bestR bestP bestF];

            %statistics based on best R
            [bestjrR ind] = max(R);
            bestjrT = thresh(ind(1));
            bestjrF = F(ind(1));
            bestjrP = P(ind(1));
            scoresjr(i,:) = [i bestjrT bestjrR bestjrP bestjrF];

            %Aggregate for ODS
            cntR_total = cntR_total + cntR;
            sumR_total = sumR_total + sumR;
            cntP_total = cntP_total + cntP;
            sumP_total = sumP_total + sumP;

            %Aggregate for OSS
            ff=find(F==max(F));
            cntR_max = cntR_max + cntR(ff(1));
            sumR_max = sumR_max + sumR(ff(1));
            cntP_max = cntP_max + cntP(ff(1));
            sumP_max = sumP_max + sumP(ff(1));

            %statistics based on best R
            rr=find(R==max(R));
            cntR_maxjr = cntR_maxjr + cntR(rr(1));
            sumR_maxjr = sumR_maxjr + sumR(rr(1));
            cntP_maxjr = cntP_maxjr + cntP(rr(1));
            sumP_maxjr = sumP_maxjr + sumP(rr(1));
        end
        fprintf('\n');


        %Global P and R for each thr
        R = cntR_total ./ (sumR_total + (sumR_total==0));
        P = cntP_total ./ (sumP_total + (sumP_total==0));
        F = fmeasure(R,P);
        [bestT,bestR,bestP,bestF] = maxF(thresh,R,P);

        %statistics based on best R
        [bestjrR ind] = max(R);
        bestjrT = thresh(ind(1));
        bestjrF = F(ind(1));
        bestjrP = P(ind(1));

        %statistics based on best R
        fname = fullfile(outDir,[addstr,'eval_bdry_segmbestrscores.txt']);
        fid = fopen(fname,'w');
        if fid==-1,
            error('Could not open file %s for writing.',fname);
        end
        fprintf(fid,'%10d %10g %10g %10g %10g\n',scoresjr');
        fclose(fid);

        %List of [id,bestT,bestR,bestP,bestF] for each segmentation
        %best values correspond to bestF for each segmentation
        fname = fullfile(outDir,[addstr,'eval_bdry_segmbestscores.txt']);
        fid = fopen(fname,'w');
        if fid==-1,
            error('Could not open file %s for writing.',fname);
        end
        fprintf(fid,'%10d %10g %10g %10g %10g\n',scores');
        fclose(fid);
        %for each image, R, P and F are computed for all thresholds and the best
        %values are chosen according to F

        %Global P and R for each thr, plotted
        fname = fullfile(outDir,[addstr,'eval_bdry_globalthr.txt']);
        fid = fopen(fname,'w');
        if fid==-1,
            error('Could not open file %s for writing.',fname);
        end
        fprintf(fid,'%10g %10g %10g %10g\n',[thresh R P F]');
        fclose(fid);
        %R,P,F numbers (eval_bdry_globalthr.txt) for each threshold across all images:
        %global values for R and P, F computed from them

        %statistics based on best R
        R_maxjr = cntR_maxjr ./ (sumR_maxjr + (sumR_maxjr==0));
        P_maxjr = cntP_maxjr ./ (sumP_maxjr + (sumP_maxjr==0));
        F_maxjr = fmeasure(R_maxjr,P_maxjr);

        R_max = cntR_max ./ (sumR_max + (sumR_max==0));
        P_max = cntP_max ./ (sumP_max + (sumP_max==0));
        F_max = fmeasure(R_max,P_max);

        [Ru, indR] = unique(R);
        Pu = P(indR);
        Ri = 0 : 0.01 : 1;
        if numel(Ru)>1,
            P_int1 = interp1(Ru, Pu, Ri);
            P_int1(isnan(P_int1)) = 0;
            Area_PR = sum(P_int1)*0.01;

        else
            Area_PR = 0;
        end


        %statistics based on best global R
        fname = fullfile(outDir,[addstr,'eval_bdryglobodsoss_rmax.txt']);
        fid = fopen(fname,'w');
        if fid==-1,
            error('Could not open file %s for writing.',fname);
        end
        fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g\n',bestjrT,bestjrR,bestjrP,bestjrF,R_maxjr,P_maxjr,F_maxjr);
        fclose(fid);

        %Aggregated performance ODS and OSS
        fname = fullfile(outDir,[addstr,'eval_bdry_globossods.txt']);
        fid = fopen(fname,'w');
        if fid==-1,
            error('Could not open file %s for writing.',fname);
        end
        fprintf(fid,'%10g %10g %10g %10g %10g %10g %10g %10g\n',bestT,bestR,bestP,bestF,R_max,P_max,F_max,Area_PR);
        fclose(fid);
    end
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

