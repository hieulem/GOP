function Mcplot(outDir,col,addtofigure)
% plot evaluation results.
% Pablo Arbelaez <arbelaez@eecs.berkeley.edu>

if ( (~exist('addtofigure','var')) || (isempty(addtofigure)) )
    addtofigure=false;
end
if ( (~exist('col','var')) || (isempty(col)) )
    col='r';
end

uselog=true;

if (uselog)
    Maybelog = @(x) log10(x);
else
    Maybelog = @(x) (x);
end

% fprintf('\n%s\n',outDir);

if exist(fullfile(outDir,'evaluations.txt'),'file')
    
    %Read output
    evalRes = dlmread(fullfile(outDir,'evaluations.txt')); % thresh,r,p,f global values across all image for each threshold
    % [stepkmap, globR, globP, avgR, avgP, thecov, clusterassignratio, meanlength, stdlength,stepkcount]

    %Sort output according to stepk
    [ostepk,oidx]=sort(evalRes(:,1),'ascend');
    evalRes=evalRes(oidx,:);
    
    
    
    %Plot global RP
    if (addtofigure)
        figure(1); hold on
    else
        Init_figure_no(1);
    end
    if (size(evalRes,1)>0)
        plot3(Maybelog(evalRes(:,1)),evalRes(:,3),evalRes(:,2),col,'LineWidth',3);
    end
    if (addtofigure)
        hold off
    else
        title('PR curve with global values [stepk,P,R]');
        set(gca,'xlim',[Maybelog(evalRes(1,1)),Maybelog(evalRes(end,1))+0.000001],'ylim',[0,1],'zlim',[0,1])
        if (uselog)
            set(gca,'XTick',log10([1,2,4,10,20,40,100,200,400]))
            set(gca,'XTickLabel',{'1','2','4','10','20','40','100','200','400'})
        else
            set(gca,'XTick',evalRes(:,1))
        end
        view([0,0,1]);
%         set(gca,'YTick',0:0.1:1)
%         set(gca,'ZTick',0:0.1:1)
    end        

    
    
    %Plot average RP
    if (addtofigure)
        figure(2); hold on
    else
        Init_figure_no(2);
    end
    if (size(evalRes,1)>0)
        plot3(Maybelog(evalRes(:,1)),evalRes(:,5),evalRes(:,4),col,'LineWidth',3);
    end
    if (addtofigure)
        hold off
    else
        title('PR curve with average values [stepk,P,R]');
        set(gca,'xlim',[Maybelog(evalRes(1,1)),Maybelog(evalRes(end,1))+0.000001],'ylim',[0,1],'zlim',[0,1])
        if (uselog)
            set(gca,'XTick',log10([1,2,4,10,20,40,100,200,400]))
            set(gca,'XTickLabel',{'1','2','4','10','20','40','100','200','400'})
        else
            set(gca,'XTick',evalRes(:,1))
        end
        view([0,0,1]);
    end        
    
    
    
    %Plot coverage and assigned-to-requested cluster ratio
    if (addtofigure)
        figure(3); hold on
    else
        Init_figure_no(3);
    end
    if (size(evalRes,1)>0)
        plot3(Maybelog(evalRes(:,1)),evalRes(:,7),evalRes(:,6),col,'LineWidth',3);
    end
    if (addtofigure)
        hold off
    else
        title('Assigned-to-requested cluster ratio (ARR) and coverage (C) [stepk,ARR,C]');
        set(gca,'xlim',[Maybelog(evalRes(1,1)),Maybelog(evalRes(end,1))+0.000001],'ylim',[0,1],'zlim',[0,1])
        if (uselog)
            set(gca,'XTick',log10([1,2,4,10,20,40,100,200,400]))
            set(gca,'XTickLabel',{'1','2','4','10','20','40','100','200','400'})
        else
            set(gca,'XTick',evalRes(:,1))
        end
    end
    
    
    
    %Plot count of processed video sequences
    if (size(evalRes,2)>=10)
        if (addtofigure)
            figure(5); hold on
        else
            Init_figure_no(5);
        end
        if (size(evalRes,1)>0)
            plot(evalRes(:,1),evalRes(:,10),col,'LineWidth',3);
        end
        if (addtofigure)
            hold off
        else
            title('Count of video sequences [stepk,occurrences]');
            set(gca,'xlim',[evalRes(1,1),evalRes(end,1)+0.000001])
            set(gca,'XTick',evalRes(:,1))
        end
    end
    
    
    
    %Plot mean and std lengths
    if (size(evalRes,2)>=9)
        if (addtofigure)
            figure(4); hold on
        else
            Init_figure_no(4);
        end
        if (size(evalRes,1)>0)
            plot3(Maybelog(evalRes(:,1)),evalRes(:,8),evalRes(:,9),col,'LineWidth',3);
        end
        if (addtofigure)
            hold off
        else
            title('Mean and std lengths of associated trajectories [stepk,avg,std]');
            set(gca,'xlim',[Maybelog(evalRes(1,1)),Maybelog(evalRes(end,1))+0.000001])
            if (uselog)
                set(gca,'XTick',log10([1,2,4,10,20,40,100,200,400]))
                set(gca,'XTickLabel',{'1','2','4','10','20','40','100','200','400'})
            else
                set(gca,'XTick',evalRes(:,1))
            end
            view([0,0,1]);
        end
    end
    
    
    
    %Visualize the information on screen
    % [stepks, globR, globP, avgR, avgP, thecov, clusterassignratio]
    fprintf('Stepk:'); fprintf('%10d',evalRes(:,1)); fprintf('\n');
    fprintf('globR:'); fprintf('%10.6f',evalRes(:,2)); fprintf('\n');
    fprintf('globP:'); fprintf('%10.6f',evalRes(:,3)); fprintf('\n');
    fprintf('avgR: '); fprintf('%10.6f',evalRes(:,4)); fprintf('\n');
    fprintf('avgP: '); fprintf('%10.6f',evalRes(:,5)); fprintf('\n');
    fprintf('Cover:'); fprintf('%10.6f',evalRes(:,6)); fprintf('\n');
    fprintf('ARR:  '); fprintf('%10.6f',evalRes(:,7)); fprintf('\n');
    
    if (size(evalRes,2)>=9)
        fprintf('avgLn:'); fprintf('%10.6f',evalRes(:,8)); fprintf('\n');
        fprintf('stdLn:'); fprintf('%10.6f',evalRes(:,9)); fprintf('\n');
    end
    
    if (size(evalRes,2)>=10)
        fprintf('Occur:'); fprintf('%10d',evalRes(:,10)); fprintf('\n');
    end
end



%Metrics with object assignment given by max Jaccard index
if exist(fullfile(outDir,'evaluationsf.txt'),'file')
    
    %Read output
    evalRes = dlmread(fullfile(outDir,'evaluationsf.txt')); % thresh,r,p,f global values across all image for each threshold
    % [stepkmap, globR, globP, avgR, avgP, thecov, clusterassignratio, meanlength, stdlength, stepkcount, meanexplainedvariation, stdtheexplainedvariation]

    %Sort output according to stepk
    [ostepk,oidx]=sort(evalRes(:,1),'ascend');
    evalRes=evalRes(oidx,:);
    
    
    
    %Plot global RP
    if (addtofigure)
        figure(6); hold on
    else
        Init_figure_no(6);
    end
    if (size(evalRes,1)>0)
        plot3(Maybelog(evalRes(:,1)),evalRes(:,3),evalRes(:,2),col,'LineWidth',3);
    end
    if (addtofigure)
        hold off
    else
        title('PR curve with global values [stepk,P,R]');
        set(gca,'xlim',[Maybelog(evalRes(1,1)),Maybelog(evalRes(end,1))+0.000001],'ylim',[0,1],'zlim',[0,1])
        if (uselog)
            set(gca,'XTick',log10([1,2,4,10,20,40,100,200,400]))
            set(gca,'XTickLabel',{'1','2','4','10','20','40','100','200','400'})
        else
            set(gca,'XTick',evalRes(:,1))
        end
        view([0,0,1]);
%         set(gca,'YTick',0:0.1:1)
%         set(gca,'ZTick',0:0.1:1)
    end        

    
    
    %Plot average RP
    if (addtofigure)
        figure(7); hold on
    else
        Init_figure_no(7);
    end
    if (size(evalRes,1)>0)
        plot3(Maybelog(evalRes(:,1)),evalRes(:,5),evalRes(:,4),col,'LineWidth',3);
    end
    if (addtofigure)
        hold off
    else
        title('PR curve with average values [stepk,P,R]');
        set(gca,'xlim',[Maybelog(evalRes(1,1)),Maybelog(evalRes(end,1))+0.000001],'ylim',[0,1],'zlim',[0,1])
        if (uselog)
            set(gca,'XTick',log10([1,2,4,10,20,40,100,200,400]))
            set(gca,'XTickLabel',{'1','2','4','10','20','40','100','200','400'})
        else
            set(gca,'XTick',evalRes(:,1))
        end
        view([0,0,1]);
    end        
    
    
    
    %Plot count of processed video sequences
    if (size(evalRes,2)>=10)
        if (addtofigure)
            figure(8); hold on
        else
            Init_figure_no(8);
        end
        if (size(evalRes,1)>0)
            plot(evalRes(:,1),evalRes(:,10),col,'LineWidth',3);
        end
        if (addtofigure)
            hold off
        else
            title('Count of video sequences [stepk,occurrences]');
            set(gca,'xlim',[evalRes(1,1),evalRes(end,1)+0.000001])
            set(gca,'XTick',evalRes(:,1))
        end
    end
    
    
    
    %Plot mean and std explained variation
    if (size(evalRes,2)>=11)
        if (addtofigure)
            figure(9); hold on
        else
            Init_figure_no(9);
        end
        if (size(evalRes,1)>0)
            plot3(Maybelog(evalRes(:,1)),evalRes(:,11),evalRes(:,12),col,'LineWidth',3);
        end
        if (addtofigure)
            hold off
        else
            title('Mean and std explained variation [stepk,avg,std]');
            set(gca,'xlim',[Maybelog(evalRes(1,1)),Maybelog(evalRes(end,1))+0.000001])
            if (uselog)
                set(gca,'XTick',log10([1,2,4,10,20,40,100,200,400]))
                set(gca,'XTickLabel',{'1','2','4','10','20','40','100','200','400'})
            else
                set(gca,'XTick',evalRes(:,1))
            end
            view([0,0,1]);
        end
    end
    
    
    
    %Visualize the information on screen
    fprintf('Optimized for F-measure\n');
    % [stepks, globR, globP, avgR, avgP, thecov, clusterassignratio]
    fprintf('Stepk:'); fprintf('%10d',evalRes(:,1)); fprintf('\n');
    fprintf('globR:'); fprintf('%10.6f',evalRes(:,2)); fprintf('\n');
    fprintf('globP:'); fprintf('%10.6f',evalRes(:,3)); fprintf('\n');
    fprintf('avgR: '); fprintf('%10.6f',evalRes(:,4)); fprintf('\n');
    fprintf('avgP: '); fprintf('%10.6f',evalRes(:,5)); fprintf('\n');
    
    if (size(evalRes,2)>=10)
        fprintf('Occur:'); fprintf('%10d',evalRes(:,10)); fprintf('\n');
    end
end
