%findDip.m
%
%given a mixture model, this function finds where the crossing is -- the dip
%location
%
%thresh: where posterior of component 2 first becomes larger than the
%posterior of component 1.
%flag: 0 means the 2nd component was fitted fine
%      1 means 2nd component was not fitted well, and used 1st component's
%      xth percentile instead.

function [thresh flag]= findDip( x, p, a1, a2, b1, b2, c2)

sortedXw = sort(nonzeros(x));
pdf1w = p.*wblpdf3(sortedXw, a1,b1,0);
pdf2w = (1-p).*wblpdf3(sortedXw, a2 , b2, c2);

%mode1 = a1*(((b1-1)/b1)^(1/b1));


% pdfW = pdf1w+pdf2w;

%find the crossing of the mixture model 
[pdfMax1, pdfInd1] = max(pdf1w);
% [pdfMax2, pdfInd2] = max(pdf2w);

%find the first peak of pdf1w, starting from pdfInd1
xInd = pdfInd1;
% while pdfW(xInd+1) >= pdfW(xInd)
%     xInd = xInd + 1;
% end

% %use the minimum dip threshold as to start the dip search
% xInd = find(sortedXw >= wp1);

dip = 0;
for i = xInd(1):length(pdf2w)
    
    if pdf2w(i) > pdf1w(i)
        dip = i;
        break;
    end
end


%if no dip is found, use the mode of the 2nd Weibull
 w1Mode = a1*(((b1-1)/b1)^(1/b1));
 flag = 0;
 
if dip == 0
    
    %thresh = 0;
%     if b2 == 1
%         thresh = c2;
%     else
%         thresh = a2*(((b2-1)/b2)^(1/b2))+c2; %the mode of the 2nd component
%     end

    %thresh = wblinv(0.95, a1, b1);
    thresh = wblinv(0.6, a1, b1);

    %if there is no 2nd Weibull, or ridiculously bad fit, set it at 1st
    %component's 90th percentile
%    
%     if thresh < w1Mode || (thresh > a1*nthroot(-1*(log(1-0.95)), b1) )
%         thresh = a1*nthroot(-1*(log(1-0.7)), b1);
%     end
    
    flag = 1;
    
else
    thresh = sortedXw(dip);
    
    %if thresh < w1Mode || (thresh > a1*nthroot(-1*(log(1-0.95)), b1) && p > 0.8)
    if thresh < w1Mode || (dip/length(sortedXw)) >= 0.96
         w2Mode = a2*(((b2-1)/b2)^(1/b2))+c2;
         thresh = min(a1*nthroot(-1*(log(1-0.7)), b1), w2Mode);
         flag = 1;
    end
end



