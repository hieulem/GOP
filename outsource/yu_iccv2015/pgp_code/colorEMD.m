%colorEMD.m
%
%this function calculates the emd score between 2 2-D histograms of hue 
%AND saturation
%
%Chen-Ping Yu

function output = colorEMD( patch1H, patch2H, patch1S, patch2S )

% %find out how many gray pixels there are
% p1gray = patch1H == -1;
% p1gray = sum(p1gray);
% 
% p2gray = patch2H == -1;
% p2gray = sum(p2gray);
% 
% %if either region contains more than 50% of gray pixels, we deem it as no
% %hue.
% if (p1gray >= round(length(patch1H)*0.5)) || (p2gray >= round(length(patch2H)*0.5))
%     output = -1;
% else
    
    %what is the diameter of the circle that you want?
    %make it a multiple of 2. 130 diameter makes it possible for 360 colors,
    %which is a full circle of Hue, while 8 bit (256 colors) takes d = 76.
    d = 76;
    
    %get the cosd and sind
    dimA1 = round(cosd(patch1H).*(d/2).*patch1S)+(d/2)+1;
    dimA2 = d+2-(round(sind(patch1H).*(d/2).*patch1S)+(d/2)+1);
    dimB1 = round(cosd(patch2H).*(d/2).*patch2S)+(d/2)+1;
    dimB2 = d+2-(round(sind(patch2H)*(d/2).*patch2S)+(d/2)+1);
    
    %a d+1*d+1 circle
    hist1 = zeros(d+1,d+1);
    hist2 = zeros(d+1,d+1);
    
    %now build the histograms 1
    ind1 = sub2ind([d+1,d+1], dimA2, dimA1);
%     for i = 1:length(ind1)
%         hist1(ind1(i)) = hist1(ind1(i)) + 1;
%     end
    [u, m, n] = unique(ind1);
    counts = accumarray(n(:), 1);
    hist1(u) = counts;
    
    %normalize the histogram so it sums to 1
    total1 = sum(sum(hist1));
    hist1 = hist1./total1;
    
    %now build the histograms 2
    ind2 = sub2ind([d+1,d+1], dimB2, dimB1);
%     for i = 1:length(ind2)
%         hist2(ind2(i)) = hist2(ind2(i)) + 1;
%     end
    [u, m, n] = unique(ind2);
    counts = accumarray(n(:), 1);
    hist2(u) = counts;
    
    %normalize the histogram so it sums to 1
    total2 = sum(sum(hist2));
    hist2 = hist2./total2;
    
    %compute mallow's as the sum of 2 marginal mallow's distances
    hist1x = sum(hist1,1);
    hist1y = sum(hist1,2);
    hist2x = sum(hist2,1);
    hist2y = sum(hist2,2);
    
    n = size(hist1x,2);
    
    mallow_x = sum(abs(cumsum(hist1x-hist2x)))/n;
    mallow_y = sum(abs(cumsum(hist1y-hist2y)))/n;
  
    %output = emd_r(hist1, hist2);
    output = (mallow_x + mallow_y);
 %end

