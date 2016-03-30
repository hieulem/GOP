function [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,newsimilarity,mrgmth,options,wgtsimilarities,wgtnewsimilarity) %#ok<INUSL>

switch (mrgmth)

    case 'prod'
        
        domultiply=true;
        [similarities,wgtsimilarities]=Averagesparsematriceswithweights(similarities,newsimilarity,[],[],domultiply);
        
    case 'ssum'
        
        similarities=similarities+newsimilarity;
        
    case 'wsum'
        
        domultiply=false;
        [similarities,wgtsimilarities]=Averagesparsematriceswithweights(similarities,newsimilarity,wgtsimilarities,wgtnewsimilarity,domultiply);
        
    otherwise
        
        fprintf('merging method\n');
        
end

if ( (~exist('wgtsimilarities','var')) || (isempty(wgtsimilarities)) )
    wgtsimilarities=1;
end
