%findThresh.m
%
%fit WMM to intensity, color, and orientation features and find their
%thresholds
%

function [thresh, wblParams] = findThresh(labelsList, wp1, percentile, fitMethod, mSelection, affMatrixI, affMatrixC, affMatrixO, showWbl)

pdf_wbl3mixture = @(x,p,a1,a2,b1,b2,c2) p*wblpdf3(x,a1,b1,0) + (1-p)*wblpdf3(x,a2,b2,c2);

minO = 0.0000001;

isGray = 0;
if isempty(affMatrixC) 
    isGray = 1;
end


affMatrixO(affMatrixO == minO) = 0;

%single or double WBL for intensity similarity distances
%subChunk = 2; %fit wmm on every subChunk number of frames

%experiment 1: compute thresholds on 1 frame + its temporal connections
numFrames = length(labelsList);

thresh.I = zeros(numFrames, 1);
thresh.C = zeros(numFrames, 1);
thresh.O = zeros(numFrames, 1);

%tic
for i = 1:numFrames
    
    %toNode = find(from == labelsList(i));
    if i == 1
        fromNode = 1;
    else
        fromNode = labelsList(i-1)+1;
    end
    toNode = labelsList(i);
    
    %MLE or NLS
    if fitMethod == 1
        
        params = wblfit(nonzeros(affMatrixI(fromNode:toNode,fromNode:toNode)));
        ai = params(1);
        bi = params(2);
        resnormI1 = sum(log(wblpdf(nonzeros(affMatrixI(fromNode:toNode, fromNode:toNode)), ai, bi)));
        %graphWbl(nonzeros(affMatrix(:,:,1)), params);
        [p1i a1i a2i b1i b2i c2i resnormI2 optNi] = wblMixture_EM( affMatrixI(fromNode:toNode, fromNode:toNode), fitMethod, 'sum', 2, 'intensity', showWbl );
        [aicI, bicI] = aicbic([resnormI1, resnormI2], [2, 6], [length(nonzeros(affMatrixI(fromNode:toNode, fromNode:toNode))), length(nonzeros(affMatrixI(fromNode:toNode, fromNode:toNode)))]);

        if strcmp(mSelection, 'bic') == 1
            icI = bicI;
            [minAICi, modeli] = min(bicI);
        else
            icI = aicI;
            [minAICi, modeli] = min(aicI);
        end
    else
        [~, ai, ~, bi, ~, ~, resnormI1, ~] = wblMixture_EM( affMatrixI(fromNode:toNode, fromNode:toNode), fitMethod, 'sum', 1, 'intensity', showWbl );
        [p1i a1i a2i b1i b2i c2i resnormI2 optNi] = wblMixture_EM( affMatrixI(fromNode:toNode,fromNode:toNode), fitMethod, 'sum', 2, 'intensity', showWbl );
        [minAICi, modeli] = min(aicRSS(optNi, [resnormI1, resnormI2], [2,6]));
    end

    if wp1 == eps || modeli == 2
        thresh.I(i) = findDip(nonzeros(affMatrixI(fromNode:toNode, fromNode:toNode)), p1i, a1i, a2i, b1i, b2i, c2i);
        wblParams.p1i(i) = p1i;
        wblParams.a1i(i) = a1i;
        wblParams.a2i(i) = a2i;
        wblParams.b1i(i) = b1i;
        wblParams.b2i(i) = b2i;
        wblParams.c2i(i) = c2i;
    else
        
        thresh.I(i) = wblinv(percentile, ai, bi);
        
    end
    if thresh.I(i) < wp1
        
        thresh.I(i) = wp1;
    end
    
    
    %for non-greyscale images
    if isGray == 0
        
        %MLE
        
        if fitMethod == 1
            
            params = wblfit(nonzeros(affMatrixC(fromNode:toNode, fromNode:toNode)));
            
            ac = params(1);
            bc = params(2);
            resnormC1 = sum(log(wblpdf(nonzeros(affMatrixC(fromNode:toNode, fromNode:toNode)), ac, bc)));
            
            try
            [p1c a1c a2c b1c b2c c2c resnormC2 optNc] = wblMixture_EM( affMatrixC(fromNode:toNode, fromNode:toNode), fitMethod, 'sum', 2, 'color', showWbl );
            catch err
                keyboard
            end
            
            [aicC, bicC] = aicbic([resnormC1, resnormC2], [2, 6], [length(nonzeros(affMatrixC(fromNode:toNode, fromNode:toNode))), length(nonzeros(affMatrixC(fromNode:toNode, fromNode:toNode)))]);
            if strcmp(mSelection, 'bic') == 1
                icC = bicC;
                [minAICc, modelc] = min(bicC);
            else
                icC = aicC;
                [minAICc, modelc] = min(aicC);
            end
        else
            [~, ac, ~, bc, ~, ~, resnormC1, ~] = wblMixture_EM( affMatrixC(fromNode:toNode, fromNode:toNode), fitMethod, 'sum', 1, 'color', showWbl );
            [p1c a1c a2c b1c b2c c2c resnormC2 optNc] = wblMixture_EM( affMatrixC(fromNode:toNode, fromNode:toNode), fitMethod, 'sum', 2, 'color', showWbl );
            [minAICc, modelc] = min(aicRSS(optNc, [resnormC1, resnormC2], [2,6]));
        end
        
        
        if wp1 == eps || modelc == 2
            thresh.C(i) = findDip(nonzeros(affMatrixC(fromNode:toNode, fromNode:toNode)), p1c, a1c, a2c, b1c, b2c, c2c);
            wblParams.p1c(i) = p1c;
            wblParams.a1c(i) = a1c;
            wblParams.a2c(i) = a2c;
            wblParams.b1c(i) = b1c;
            wblParams.b2c(i) = b2c;
            wblParams.c2c(i) = c2c;
        else
            
            thresh.C(i) = wblinv(percentile, ac, bc);
            
        end
        if thresh.C(i) < wp1
            
            thresh.C(i) = wp1;
        end
        
    else
        thresh.C(i) = 1;
    end
    
    %for orientation
    try
        if ~isempty(nonzeros(affMatrixO))
            
            if fitMethod == 1
                
                params = wblfit(nonzeros(affMatrixO));
                ao = params(1);
                bo = params(2);
                resnormO1 = sum(log(wblpdf(nonzeros(affMatrixO), ao, bo)));
                %graphWbl(nonzeros(affMatrix(:,:,3)), params);
                [p1o a1o a2o b1o b2o c2o resnormO2 optNo] = wblMixture_EM( affMatrixO(fromNode:toNode, fromNode:toNode), fitMethod, 'sum', 2, 'orientation', showWbl );
                [aicO, bicO] = aicbic([resnormO1, resnormO2], [2, 6], [length(nonzeros(affMatrixO(fromNode:toNode, fromNode:toNode))), length(nonzeros(affMatrixO(fromNode:toNode, fromNode:toNode)))]);
                if strcmp(mSelection, 'bic') == 1
                    icO = bicO;
                    [minAICo, modelo] = min(bicO);
                else
                    icO = aicO;
                    [minAICo, modelo] = min(aicO);
                end
            else
                [~, ao, ~, bo, ~, ~, resnormO1, ~] = wblMixture_EM( affMatrixO(fromNode:toNode, fromNode:toNode), fitMethod, 'sum', 1, 'orientation', showWbl );
                [p1o a1o a2o b1o b2o c2o resnormO2 optNo] = wblMixture_EM( affMatrixO(fromNode:toNode, fromNode:toNode), fitMethod, 'sum', 2, 'orientation', showWbl );
                [minAICo, modelo] = min(aicRSS(optNo, [resnormO1, resnormO2], [2,6]));
            end
            
            [modeli, modelc modelo];
        else
            modelo = 1;
        end
        
        if wp1 == eps || modelo == 2
            thresh.O(i) = findDip(nonzeros(affMatrixO(fromNode:toNode, fromNode:toNode)), p1o, a1o, a2o, b1o, b2o, c2o);
            wblParams.p1o(i) = p1o;
            wblParams.a1o(i) = a1o;
            wblParams.a2o(i) = a2o;
            wblParams.b1o(i) = b1o;
            wblParams.b2o(i) = b2o;
            wblParams.c2o(i) = c2o;
        else
            
            thresh.O(i) = wblinv(percentile, ao, bo);
            
        end
        if thresh.O(i) < wp1
            
            thresh.O(i) = wp1;
        end
        
    catch err
        thresh.O(i) = 1;
    end
    %progressbar(i/numFrames);
end

%delete(gcf);
%close all;
%toc
