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

function [histw, vinterval] = histwc(vv, ww, nbins,maxV)
  vv(ww==0) =[];
  ww(ww==0) =[];
  minV  = 0;%min(vv);
  %maxV  = max(vv);
  delta = (maxV-minV)/nbins;
  vinterval = linspace(minV, maxV, nbins)-delta/2.0;
 
 %vinterval = exp(0:log(maxV+1)/(nbins):log(maxV+1 +1e-10))-1 - 1e-20;
  histw = zeros(nbins, 1);
  for i=1:length(vinterval)-1
      ind = intersect(find(vv>vinterval(i)),find(vv<vinterval(i+1)));
      if ~isempty(ind)
          histw(i) = sum( ww(ind));
      end
  end
%   for i=1:length(vv)
%     ind = find(vinterval < vv(i), 1, 'last' );
%     if ~isempty(ind)
%       histw(ind) = histw(ind) + ww(i);
%     end

end