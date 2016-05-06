%graphWbl.m
%
%given data, and the fitted Wbl parameters, graph them together.

function output = graphWbl(x, wblParams)

optimalBin = @(x) round(max(x)/(2*(quantile(x,0.75)-quantile(x, 0.25))*(length(x)^(-1/3))));

n = length(x);

bin = 15;
n = length(x);

%another approach: Izenman 1991
q75 = quantile(x,0.75);
q25 = quantile(x, 0.25);
binWidth = 2*(q75-q25)*n^(-1/3);
optN = round(max(x)/binWidth);

%set smallest and largest condition
if optN < bin
    optN = bin;
end

if optN == Inf
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
h = get(gca,'child');
set(h,'FaceColor',[.9 .9 .9]);
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







