%drawGraph.m
%
%This function visualizes a given graph of a sparse matrix, overlayed on
%the original superpixl image.

function output = drawGraph(inputImg, labelImg, graphST)

fullMatrix = full(graphST);
wEntries = nonzeros(graphST);

figure, imshow(inputImg);

for j = 1:size(fullMatrix,2)
    for i = 1:size(fullMatrix,1)
        if fullMatrix(i,j) ~= 0
            
            hold on
            
            %first find the center of both from and to regions:
            tempImg = [];
            tempImg = labelImg == j;
            ctFrom = regionprops(bwlabel(tempImg), 'centroid');
            
            tempImg = [];
            tempImg = labelImg == i;
            ctTo = regionprops(bwlabel(tempImg), 'centroid');
            
            %draw the line
            if fullMatrix(i,j) > 0
                line([round(ctFrom(1).Centroid(1)) round(ctTo(1).Centroid(1))], [round(ctFrom(1).Centroid(2)) round(ctTo(1).Centroid(2))], 'Color', 'b', 'lineWidth', 2);
            else
                line([round(ctFrom(1).Centroid(1)) round(ctTo(1).Centroid(1))], [round(ctFrom(1).Centroid(2)) round(ctTo(1).Centroid(2))], 'Color', 'w', 'lineWidth', 2);
            end
       end
    end
end

hold off








