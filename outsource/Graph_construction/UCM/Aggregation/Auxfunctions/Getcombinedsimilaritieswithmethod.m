function [similarities,wgtsimilarities]=Getcombinedsimilaritieswithmethod(similarities,newsimilarities,mrgmth,options,wgtsimilarities,wgtnewsimilarity) %#ok<INUSL>

if (any(size(similarities)~=size(newsimilarities)))
    fprintf('Similarities to combine of different sizes [%d,%d]-[%d,%d]\n',size(similarities,1),size(similarities,2),size(newsimilarities,1),size(newsimilarities,2));
    
    maxx=max(size(similarities,1),size(newsimilarities,1));
    maxy=max(size(similarities,2),size(newsimilarities,2));
    
    if ( (size(similarities,1)<maxx) || (size(similarities,2)<maxy) )
        [tmpx,tmpy,tmpv]=find(similarities);
        similarities=sparse(tmpx,tmpy,tmpv,maxx,maxy);
        if ( (~isempty(wgtsimilarities)) && (numel(wgtsimilarities)>1) )
            [tmpx,tmpy,tmpv]=find(wgtsimilarities);
            wgtsimilarities=sparse(tmpx,tmpy,tmpv,maxx,maxy);
        end
        fprintf('Similarities'' size adjusted\n');
    end
    if ( (size(newsimilarities,1)<maxx) || (size(newsimilarities,2)<maxy) )
        [tmpx,tmpy,tmpv]=find(newsimilarities);
        newsimilarities=sparse(tmpx,tmpy,tmpv,maxx,maxy);
        if ( (~isempty(wgtnewsimilarity)) && (numel(wgtnewsimilarity)>1) )
            [tmpx,tmpy,tmpv]=find(wgtnewsimilarity);
            wgtnewsimilarity=sparse(tmpx,tmpy,tmpv,maxx,maxy);
        end
        fprintf('Newsimilarities'' size adjusted\n');
    end
end



switch (mrgmth)

    case 'prod'
        
        domultiply=true;
        [similarities,wgtsimilarities]=Averagesparsematriceswithweights(similarities,newsimilarities,[],[],domultiply);
        
    case 'ssum'
        
        similarities=similarities+newsimilarities;
        
    case 'wsum'
        
        domultiply=false;
        [similarities,wgtsimilarities]=Averagesparsematriceswithweights(similarities,newsimilarities,wgtsimilarities,wgtnewsimilarity,domultiply);
        
    case 'wsumz'
        
        domultiply=false;
        [similarities,wgtsimilarities]=Averagesparsematriceswithweightszero(similarities,newsimilarities,wgtsimilarities,wgtnewsimilarity,domultiply);
        
    otherwise
        
        fprintf('merging method\n');
        
end



if ( (~exist('wgtsimilarities','var')) || (isempty(wgtsimilarities)) )
    wgtsimilarities=1;
end




function Test_the_function() %#ok<DEFNU>

b=sparse(10000000,20000000);
a=sparse(20000000,10000000);

a(1,1)=1; a(2,2)=1;
b(1,1)=0.1; b(3,1)=0.1;

wa=1;
wa=a; wa(a~=0)=1;
wb=2;
wb=b; wb(b~=0)=2;

[c,wc]=Getcombinedsimilaritieswithmethod(a,b,'prod',[],wa,wb);

full(c(1:3,1:3))
full(wc)

[c,wc]=Getcombinedsimilaritieswithmethod(a,b,'wsumz',[],wa,wb);

full(c(1:3,1:3))
full(wc(1:3,1:3))

[c,wc]=Getcombinedsimilaritieswithmethod(a,b,'wsum',[],wa,wb);

full(c(1:3,1:3))
full(wc(1:3,1:3))







a=[1,0,0;0,1,0];
a=sparse(a);

b=[0.1,0;0,0;0.1,0];
b=sparse(b);

wa=1;
wa=a; wa(a~=0)=1;
wb=2;
wb=b; wb(b~=0)=2;

[c,wc]=Getcombinedsimilaritieswithmethod(a,b,'prod',[],wa,wb);

full(c)
full(wc)

[c,wc]=Getcombinedsimilaritieswithmethod(a,b,'wsumz',[],wa,wb);

full(c)
full(wc)

[c,wc]=Getcombinedsimilaritieswithmethod(a,b,'wsum',[],wa,wb);

full(c)
full(wc)

