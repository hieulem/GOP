function outpixels=Measureoutpixels(newmask,predictedMask,print)
%the function does not require that the first mask be logical

outpixels = double(sum(newmask(:))) + double(sum(predictedMask(:))) - double(sum(predictedMask(newmask>0))) - double(sum(newmask(predictedMask>0)));
if (nargin<3)||(print)
    fprintf('Pixels left out from masks are %f\n',outpixels);
end