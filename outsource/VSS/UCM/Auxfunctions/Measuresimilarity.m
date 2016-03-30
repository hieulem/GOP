function similarity=Measuresimilarity(newmask,predictedMask,printonscreen)
%the function does not require that the first mask be logical

similarity=( double(sum(predictedMask(newmask>0))) + double(sum(newmask(predictedMask>0))) ) /...
    ( double(sum(newmask(:))) + double(sum(predictedMask(:))) );
if (nargin<3)||(printonscreen)
    fprintf('Similarity is %f\n',similarity);
end
