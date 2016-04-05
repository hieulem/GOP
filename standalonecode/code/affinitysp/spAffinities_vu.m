function aff = spAffinities_vu(imseg, imedge)

height = size(imseg, 1);
width = size(imseg, 2);
imgsize = [height, width];

% Convolution to get the border pixels
xfilter = [-1 1];
yfilter = [-1; 1];

paddedseqx = double([imseg imseg(:, end)]);
paddedseqy = double([imseg; imseg(end,:)]);

xmask = conv2(paddedseqx, xfilter, 'valid');
ymask = conv2(paddedseqy, yfilter, 'valid');

horId = find(xmask ~= 0);
verId = find(ymask ~= 0);

%id = union(horId, verId);

[yhor, xhor] = ind2sub(imgsize, horId);
[yver, xver] = ind2sub(imgsize, verId);
%[yid, xid] = ind2sub(imgsize, id);



maxSuperpixelId = max(imseg(:));
aff = zeros(maxSuperpixelId, maxSuperpixelId);
weight = zeros(maxSuperpixelId, maxSuperpixelId);

% Check horizontal
for i = 1:size(horId)
    
    x = xhor(i);
    y = yhor(i);
    aff(imseg(y, x), imseg(y, x+ 1)) = aff(imseg(y, x), imseg(y, x+ 1)) + imedge(y, x) + imedge(y, x+1);
    aff(imseg(y, x + 1), imseg(y, x)) = aff(imseg(y, x), imseg(y, x+ 1));
    weight(imseg(y, x), imseg(y, x+ 1)) = weight(imseg(y, x), imseg(y, x+ 1)) + 1;
    weight(imseg(y, x + 1), imseg(y, x)) = weight(imseg(y, x), imseg(y, x+ 1));
end

% Check vertical
for i = 1:size(verId)
    
    x = xver(i);
    y = yver(i);
    
    % The if statement to ensure we do not count multiple times of a pixel
    % for a pair of superpixel
    %if (x == width || imseg(y + 1, x) ~= imseg(y, x + 1))
    aff(imseg(y, x), imseg(y + 1, x)) = aff(imseg(y, x), imseg(y + 1, x)) + imedge(y,x) + imedge(y + 1, x);
    aff(imseg(y + 1, x), imseg(y, x)) = aff(imseg(y, x), imseg(y + 1, x));
    weight(imseg(y, x), imseg(y + 1, x)) = weight(imseg(y, x), imseg(y + 1, x)) + 1;
    weight(imseg(y + 1, x), imseg(y, x)) = weight(imseg(y, x), imseg(y + 1, x));
    %end
end

weight(weight == 0) = 1;
aff = aff ./ weight;
%aff(aff == 0) = Inf;
aff(1:(maxSuperpixelId+1):end) = 0;

end











