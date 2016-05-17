function [ii,jj,ff]=Selectpointframe(partcim)

ii=[];
jj=[];

nfigure=5;
Printthevideoonscreen(partcim,true,nfigure,false,false,false,false);

Init_figure_no(nfigure);
ff=1;
while (1)
    
    figure(nfigure);
    imagesc(partcim{ff});
    theanswer = input(['Please select the frame and press return [return to accept current - ',num2str(ff),']\n']);
    
    if (isempty(theanswer))
        break;
    end
    
    if ( (theanswer<=0) || (theanswer>numel(partcim)) )
        Printthevideoonscreen(partcim,true,nfigure,false,false,false,false);
    else
        ff=theanswer;
    end
end
fprintf('\n');



figure(nfigure);
imagesc(partcim{ff});

fprintf('Please adjust the zoom and press return\n');
pause;

fprintf('Please select a point\n')
figure(nfigure);
p = ginput(1);
if (isempty(p))
    return;
end
    
fprintf('\n');

ii=round(p(2));
jj=round(p(1));
