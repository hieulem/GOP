function Init_figure_no(nofigure,figuretitle)

figure(nofigure), clf, set(gcf, 'color', 'white');

if (exist('figuretitle','var') && (~isempty(figuretitle)) )
    title(figuretitle);
end

set(gca,'xtick',[],'ytick',[]);

% axis off;
% set(gca,'FontSize',17);

% print('-dpng','Affinity2aba.png')
% print('-depsc2','Affinity2aba.eps')
