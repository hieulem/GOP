% HISTWC  Weighted histogram count given number of bins
%
% This function generates a vector of cumulative weights for data
% histogram. Equal number of bins will be considered using minimum and
% maximum values of the data. Weights will be summed in the given bin.
%
% Usage: [histw, vinterval] = histwc(vv, ww, nbins)
%
% Arguments:
%       vv    - values as a vector
%       ww    - weights as a vector
%       nbins - number of bins
%
% Returns:
%       histw     - weighted histogram
%       vinterval - intervals used
%
%
%
% See also: HISTC, HISTWCV

% Author:
% mehmet.suzen physics org
% BSD License
% July 2013

function [histw, vinterval1,vinterval2] = histwc2D(vv1,vv2, ww, nbins1,nbins2,maxV1,maxV2)
vv1(ww==0) =[];
vv2(ww==0) =[];
ww(ww==0) = [];

minV  = 0;%min(vv);
%maxV  = max(vv);
delta1 = (maxV1-minV)/nbins1;
vinterval1 = linspace(minV, maxV1, nbins1)-delta1/2.0;

delta2 = (maxV2-minV)/nbins2;
vinterval2 = linspace(minV, maxV2, nbins2)-delta2/2.0;
%vinterval = exp(0:log(maxV+1)/(nbins):log(maxV+1 +1e-10))-1 - 1e-20;
histw = zeros(nbins1, nbins2);
for i=1:length(vinterval1)-1
    a = (vv1>vinterval1(i)).*(vv1<vinterval1(i+1));
    for j=1:length(vinterval2)-1
        
      %  b= find((vv2<vinterval2(j+1)).*(vv2>vinterval2(j)));
        %ind = intersect(find(vv1>vinterval1(i)),find(vv1<vinterval1(i+1)));
      %  ind2 = intersect(find(vv2<vinterval2(j+1)),find(vv2>vinterval2(j)));
        ind = find(a.*(vv2<vinterval2(j+1)).*(vv2>vinterval2(j)));
        if ~isempty(ind)
            histw(i,j) = sum( ww(ind));
        end
    end
end
%   for i=1:length(vv)
%     ind = find(vinterval < vv(i), 1, 'last' );
%     if ~isempty(ind)
%       histw(ind) = histw(ind) + ww(i);
%     end

end