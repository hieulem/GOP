function output=Plotsegmeval(outDir,plotsuperpose,col)
% plot evaluation results
% Pablo Arbelaez <arbelaez@eecs.berkeley.edu>
%
% modified by Fabio Galasso
% September 2012

output=struct();

if ( (~exist('plotsuperpose','var')) || (isempty(plotsuperpose)) )
    plotsuperpose=false;
end
if ( (~exist('col','var')) || (isempty(col)) )
    col='r';
end

%Determine case dir for printing hline
wherefilesep=strfind(outDir(1:end-1),filesep); %one character (t from Output) is truncated or filesep is removed)
if (numel(wherefilesep)>=2)
    casebenchdir=outDir(wherefilesep(end-1)+1:wherefilesep(end)-1);
else
    casebenchdir='CASEDIR';
end

fprintf('%s\n',casebenchdir);


%Boundary metrics
if (exist(fullfile(outDir,'eval_bdry_globalthr.txt'),'file'))
    
    %%% Boundary statistics %%%
    prvals = dlmread(fullfile(outDir,'eval_bdry_globalthr.txt')); % thresh,r,p,f global values across all image for each threshold
    prvals = prvals( (prvals(:,2)>=0.01) ,:); %only those threshold numbers for recall > 0.01

    evalRes = dlmread(fullfile(outDir,'eval_bdry_globossods.txt'));
    
    if (plotsuperpose)
        figure(1);
    else
        Init_figure_no(1), Plotisofig();
    end
    hold on
    if (size(prvals,1)>1) %if only one hierarchical level is present, the figures correspond to ODS
        plot(prvals(1:end,2),prvals(1:end,3),col,'LineWidth',3);
        title('Bourndary PR Curve');
    else
        plot(evalRes(2),evalRes(3),'o','MarkerFaceColor',col,'MarkerEdgeColor',col,'MarkerSize',8);
        title('Bourndary PR Curve'); %Just the value corresponding to the maxmimum F is plotted, i.e. G-ODS
    end
    hold off
    
    fprintf('Boundary PR\n');
    fprintf('   ODS: F( %1.2f, %1.2f ) = %1.2f   [th = %1.2f]\n',evalRes(2:4),evalRes(1));
    fprintf('   OIS: F( %1.2f, %1.2f ) = %1.2f\n',evalRes(5:7));
    fprintf('   Area_PR = %1.2f\n',evalRes(8));
    output.B_ODS=evalRes(4); output.B_OSS=evalRes(7); output.B_area=evalRes(8);
    
    %statistics based on best R
    if (exist(fullfile(outDir,'eval_bdryglobodsoss_rmax.txt'),'file'))
        evalResjr = dlmread(fullfile(outDir,'eval_bdryglobodsoss_rmax.txt'));
        fprintf('Boundary (best R cases)\n');
        fprintf('   G-ODS: F( R %1.2f, P %1.2f ) = %1.2f   [th = %1.2f]\n',evalResjr(2:4),evalResjr(1));
        fprintf('   G-OIS: F( R %1.2f, P %1.2f ) = %1.2f\n',evalResjr(5:7));
    end
end


%Segmentation covering
if (exist(fullfile(outDir,'eval_cover.txt'),'file'))
    evalRes = dlmread(fullfile(outDir,'eval_cover.txt')); %bestT, bestR, R_best, R_best_total
    fprintf('Region\n');
    fprintf('   GT covering: ODS = %1.2f [th = %1.2f]. OSS = %1.2f. Best = %1.2f\n',evalRes(2),evalRes(1),evalRes(3:4));
    output.SC_ODS=evalRes(2); output.SC_OSS=evalRes(3); output.SC_Best=evalRes(4);
    
end

%PRI and VI
if (exist(fullfile(outDir,'eval_RI_VOI.txt'),'file'))
    evalRes = dlmread(fullfile(outDir,'eval_RI_VOI.txt'));
    fprintf('Region\n');
    fprintf('   Rand Index: ODS = %1.2f [th = %1.2f]. OSS = %1.2f.\n',evalRes(2),evalRes(1),evalRes(3));
    fprintf('   Var. Info.: ODS = %1.2f [th = %1.2f]. OSS = %1.2f.\n',evalRes(5),evalRes(4),evalRes(6));
    output.PRI_ODS=evalRes(2); output.PRI_OSS=evalRes(3); output.VI_ODS=evalRes(5); output.VI_OSS=evalRes(6);

end



