%wblMixture.m
%
%this function uses EM with MLE to fit two Weibull distributions to data.
%
%mode = 1: EM
%mode = 2: nonlinear least-squares
%lsqMode = 'sum' or 'max'
%howMany = 1 or 2

function [p a1 a2 b1 b2 c2 resnorm optN n] = wblMixture_EM2( beginLB, affMatrix, labelsList, mode, howMany, fName, sampledInd, toShow )


%%compute for the null distribution (same cluster) by finding the set of
%%weights that's from the most similar neighbor


% 
% affMatrix = x0;
x0 = nonzeros(affMatrix);


n = length(x0);

% optN = sshist(x0, 20:100); %find the optimal # of bins
bin = 25;

%another approach: Izenman 1991
q75 = quantile(x0,0.75);
q25 = quantile(x0, 0.25);
binWidth = 2*(q75-q25)*n^(-1/3);
optN = round(max(x0)/binWidth);

% set smallest and largest condition
if isempty(optN)|| optN < bin
    optN = bin;
end

if  optN == Inf || optN > 75
    %optN = 45;
    optN = 75;
end

binCtrs = linspace(min(x0), max(x0), optN);
binWidth = binCtrs(2)-binCtrs(1);
counts = hist(x0,binCtrs);
prob = counts ./ (n * binWidth);

if prob(1) > prob(2)
    prob(1) = 0;
    ind = x0 == eps;
    
    x0(ind) = 0;
    x0 = nonzeros(x0);
    
end



if howMany == 1
    
    pdf_wbl3mixture = @(x, a, b) wblpdf(x,a,b);
    param1 = wblfit(x0);
    
    
    if param1(2) < 1
        param1(2) = 1;
    end
    start = [param1(1) param1(2)];
    
    lb = [0 1];
    ub = [Inf Inf];
    cut0 = 0;
    %options = statset('MaxIter',800, 'MaxFunEvals',1600);
else
    
    pdf_wbl3mixture = @(x,p,a1,a2,b1,b2,c2) p*wblpdf3(x,a1,b1,0) + (1-p)*wblpdf3(x,a2,b2,c2);
    
    
    
    %         we want to keep vast majority of the temporal connections, therefore
    %         the temporal connections are our component 1 guess
    if strcmp(fName, 'motion') == 0
        %data1 = zeros(2*size(affMatrix,1),1);
        %data2 = zeros(2*size(affMatrix,1),1);
        data1 = zeros(2*length(sampledInd),1);
        count1 = 1;
        count2 = 1;
        
        %for i = 1:size(affMatrix,1)
        for i = 1:length(sampledInd)

            tttt = find(affMatrix(i,:));
            fromF = find(sampledInd(i)-1+beginLB <= labelsList,1);
            
            ttT = tttt(tttt>= labelsList(fromF)); %temporal
            ttS = setdiff(tttt, ttT);   %spacial
            
            if ~isempty(ttT)
                [~, minInd] = min(affMatrix(i,ttT));
                data1(count1) = affMatrix(i,ttT(minInd));
                count1 = count1 + 1;
            end
            
            if ~isempty(ttS)
                [~, minInd] = min(affMatrix(i,ttS));
                data1(count1) = affMatrix(i,ttS(minInd));
                ttS(minInd) = [];
                count1 = count1 + 1;
            end
            if ~isempty(ttS)
                [~, minInd] = min(affMatrix(i,ttS));
                data1(count1) = affMatrix(i,ttS(minInd));
                ttS(minInd) = [];
                count1 = count1 + 1;
            end
            
        end
        
        
        data1 = nonzeros(data1);
        data2 = x0(x0 > quantile(data1, 0.6));
        
        %data2 = setdiff(x0, data1);
    else
        
        %         data1 = x0(x0<=quantile(x0, 0.9));
        %         data2 = setdiff(x0, data1);
        %             data1 = initX{1};
        %             data2 = initX{2};
        %

        data1 = x0(x0 < quantile(x0, 0.75));
        %data2 = x0(x0 > quantile(data1, 0.75));
        data2 = setdiff(x0, data1);
        
    end
    
%         data1 = initX{1};
%         data2 = initX{2};
%         
%     if length(data2)/(length(data1)+length(data2)) < 0.1
%         data2 = x0(x0 > quantile(data1, 0.75));
%     end
%         
        
    
    size1 = length(data1);
    size2 = length(data2);
    
    
    %cutGuess = 0.5:0.1:0.8;
    
    cutGuess = [0.5, 0.65];
    
    if strcmp(fName, 'motion') == 1
        cutGuess = 0.75:0.05:0.85;
    end
    cut0 = quantile(x0, cutGuess);
    
%             cutGuess = 0:0.05:0.15;
%             cut0 = quantile(data2, cutGuess);
    
    for i = 1:length(cut0)
        
        
        
        params0 = wblfit(nonzeros(data1));
        a1 = params0(1);
        b1 = params0(2);
        
%                         data2 = data2(data2 >= cut0(i));
%         
%                         params2 = wblfit(data2-cut0(i)+eps);
        params2 = wblfit(data2);
        a2 = params2(1);
        b2 = params2(2);
        
        pStart = min((size1/(size1+size2))-eps, 0.85);
        
%                         start(i,:) = [pStart, max(a1, 0.01), max(a2,0), max(b1,1), max(b2,1.5), cut0(i)];
%                         lb(i,:) = [max(pStart-0.25, 0.55) 0.01 0 1 1.5 cut0(i)/2];
%                         ub(i,:) = [0.90 Inf Inf Inf Inf cut0(i)+eps];
        
%         if strcmp(fName, 'motion') == 1 || strcmp(fName, 'Orientation') == 1
%             start(i,:) = [pStart-0.1, max(a1, 0.01), max(a2,0), max(b1,1), max(b2,1.5), cut0(i)+eps];
%             lb(i,:) = [pStart-0.15 0.01 0 1 1.5 quantile(x0, 0.1)];
%         else
            start(i,:) = [pStart, max(a1, 0.01), max(a2,0), max(b1,1), max(b2,1.5), cut0(i)+eps];
            lb(i,:) = [pStart-0.1 0.01 0 1 1.5 quantile(x0, 0.1)];
%         end
        
        
%         if strcmp(fName, 'motion') == 1 || strcmp(fName, 'Orientation') == 1
%             ub(i,:) = [0.9 Inf Inf Inf Inf inf];
%         else
            ub(i,:) = [0.85 Inf Inf Inf Inf inf];
%         end
    end
    
end

if mode == 1
    
    %mle
    
    if howMany == 2
        
        options = statset('MaxIter',400, 'MaxFunEvals',800, 'FunValCheck', 'off', 'Robust', 'on', 'Display', 'off');
        
        for i = 1:length(cut0)
            %             try
            paramEsts(i,:) = mle(x0, 'pdf', pdf_wbl3mixture, 'start',start(i,:), 'lower',lb(i,:), 'upper', ub(i,:), 'options', options);
            
            %negative log-likelihood
            %try
            resnorm(i) = sum(log(pdf_wbl3mixture(x0,paramEsts(i,1),paramEsts(i,2), paramEsts(i,3), paramEsts(i,4), paramEsts(i,5), paramEsts(i,6) )));
            %                     catch err
            %                         keyboard;
            %                     end
            
        end
        
        [maxVal, maxInd] = max(resnorm);
        
        resnorm = maxVal;
        paramEsts = paramEsts(maxInd,:);
        
    else
        resnorm = sum(log(wblpdf(x0, start(1), start(2))));
        paramEsts = start;
    end
    
else
    
    
    y = x0;
    for i = 1:length(x0)
        tempP(1:length(binCtrs),1) = x0(i);
        tempP(:,2) = binCtrs;
        temp = abs(tempP(:,1)-tempP(:,2));
        [minP, ind] = min(temp);
        y(i,2) = prob(ind(1));
    end
    options = statset('MaxIter',500, 'MaxFunEvals',1000, 'FunValCheck', 'off', 'Robust', 'on', 'Display', 'off');
    
    F = @(x) lsFunc(x0,y(:,2),x, howMany);
    
    for i = 1:length(cut0)
        %         try
        if howMany == 2
            [paramEsts(i,:), resnorm(i)] = lsqnonlin(F, start(i,:), lb(i,:), ub(i,:), options);   % Invoke optimizer
        else
            paramEsts = lsqnonlin(F, start, lb, ub, options);   % Invoke optimizer
            resnorm = sum(F(paramEsts).^2);
        end
        %         catch err
        %             keyboard
        %         end
        %resnorm(i) = sum(log(pdf_wbl3mixture(x0,paramEsts(i,1),paramEsts(i,2), paramEsts(i,3), paramEsts(i,4), paramEsts(i,5), paramEsts(i,6) )));
    end
    
    [maxVal, maxInd] = max(resnorm);
    
    resnorm = maxVal;
    paramEsts = paramEsts(maxInd,:);
    
end

if howMany == 2
    p = paramEsts(1);
    a1 = paramEsts(2);
    a2 = paramEsts(3);
    b1 = paramEsts(4);
    b2 = paramEsts(5);
    c2 = paramEsts(6);
else
    p = 1;
    a1 = paramEsts(1);
    a2 = 0;
    b1 = paramEsts(2);
    b2 = 0;
    c2 = 0;
    
end

if toShow == 1
    
    figure('Color',[1 1 1]), bar(binCtrs,prob,'hist');
    h = get(gca,'child');
    set(h,'FaceColor',[.9 .9 .9]);
    xgrid = linspace(0,max(x0),100);
    grid on;
    
    
    if howMany == 2
        pdfEst = pdf_wbl3mixture(xgrid, p, a1, a2, b1, b2, c2);
    else
        pdfEst = pdf_wbl3mixture(xgrid, a1, b1);
    end
    
    %draw the posterior
    line(xgrid,pdfEst, 'lineWidth', 2.5)
    
    hold on
    if howMany == 1
        if mode == 1
            title(['Single component Weibull model (', fName, '), optimized with MLE']);
        else
            title(['Single component Weibull model (', fName, '), optimized with NLS']);
        end
        p = 1;
    end
    pdfEst1 = p*wblpdf3(xgrid, a1, b1, 0);
    line(xgrid,pdfEst1, 'color', 'r', 'lineWidth', 1)
    
    if howMany == 2
        if mode == 1
            title(['Two-component WMM (', fName, '), optimized with MLE']);
        else
            title(['Two-component WMM (', fName, '), optimized with NLS']);
        end
        hold on
        pdfEst2 = (1-p)*wblpdf3(xgrid, a2, b2, c2);
        line(xgrid,pdfEst2, 'color', 'r', 'lineWidth', 1)
    end
    hold off
    
    
end






