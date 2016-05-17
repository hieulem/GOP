function region=Lookupregioninallregionpaths(allregionpaths,frame,nopath)

region=find(allregionpaths.nopath{frame}==nopath,1,'first');
if (isempty(region))
    region=0;
end

% region=0;
% for r=1:size(allregionpaths.nopath{frame},2)
%     if ( allregionpaths.nopath{frame}(r)==nopath )
%         region=r;
%     end
%     if (region)
%         break;
%     end
% end
