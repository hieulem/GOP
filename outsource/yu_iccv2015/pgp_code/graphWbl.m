%graphWbl.m
%
%given data, and the fitted Wbl parameters, graph them together.

function output = graphWbl(x, wblParams)

optimalBin = @(x) round(max(x)/(2*(quantile(x,0.75)-quantile(x, 0.25))*(length(x)^(-1/3))));

n = length(x);

%find the optimal bin for x (Izenman 1991), and normalize each bin into a
%probability (matlab method)
optN = optimalBin(x);

if optN < 15
    optN = 15;
end

if optN > 200
    optN = 45;
end

minX = min(x);
maxX = max(x);
binCtrs = linspace(minX(1), maxX(1), optN);
binWidth = binCtrs(2)-binCtrs(1);
counts = hist(x, binCtrs);
prob = counts/(n*binWidth);


%plot it out
xInd = linspace(0, maxX(1), 100);

figure('Color',[1 1 1]),
bar(binCtrs, prob, 'hist');
hold on,

if size(wblParams,1) == 1

    plot(xInd, wblpdf(xInd, wblParams(1), wblParams(2)), 'r', 'lineWidth', 3);

else
    
    %plot each component
    for i = 1:size(wblParams,1)
        plot(xInd, wblParams(i,1).*wblpdf3(xInd, wblParams(i,2), wblParams(i,3), wblParams(i,4)), 'color', [0 0.75 0], 'lineWidth', 3);
        hold on,
    end
    
    %plot the mixture last
    plot(xInd, wblMixtureN(xInd, wblParams), 'r', 'lineWidth', 3);

end
    grid on,
    hold off,







