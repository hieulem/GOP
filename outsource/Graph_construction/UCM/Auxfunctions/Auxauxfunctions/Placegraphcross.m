function Placegraphcross(nfigure,ii,jj,clength,thelwidth)

if ( (~exist('thelwidth','var')) || (isempty(thelwidth)) )
    thelwidth=6;
end
if ( (~exist('clength','var')) || (isempty(clength)) )
    clength=20;
end

figure(nfigure);
hold on;
line([jj-clength jj+clength],[ii ii],'Color','k','LineWidth',thelwidth);
line([jj jj],[ii-clength ii+clength],'Color','k','LineWidth',thelwidth);
hold off;
