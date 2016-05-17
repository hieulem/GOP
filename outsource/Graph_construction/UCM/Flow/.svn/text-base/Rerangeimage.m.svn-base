function I=Rerangeimage(I,newmin,newmax,usetanh,usemeanstd,usemin,usemax,printonscreen)
%The function re-ranges the I image to [newmin,newmax]
%if usetanh==1 tanh are used to rerange
%if usetanh==0 the min and max of I, or alternatively usemin and usemax are used to rerange (linear transformation)
%if usemin and usemax are not defined the min and max I are used

if ( (~exist('usetanh','var')) || (isempty(usetanh)) )
    usetanh=false;
end
if ( (~exist('newmin','var')) || (isempty(newmin)) )
    newmin=0;
end
if ( (~exist('newmax','var')) || (isempty(newmax)) )
    newmax=1;
end
if ( (~exist('usemeanstd','var')) || (isempty(usemeanstd)) )
    usemeanstd=false;
end
if ( (~exist('printonscreen','var')) || (isempty(printonscreen)) )
    printonscreen=false;
end
if ( (~exist('usemin','var')) || (isempty(usemin)) )
    usemin=min(I(:));
end
if ( (~exist('usemax','var')) || (isempty(usemax)) )
    usemax=max(I(:));
end

if (printonscreen)
    fprintf('Using Min %f, max %f to normalize\n',usemin,usemax);
    Init_figure_no(308), imagesc(I), title('Image');
end

if (~usetanh)
    I=( (I-usemin)/(usemax-usemin) ); %Simple rescaling to the range [usemin,usemax]
else
    if (~usemeanstd)
        I=( (I-usemin)/(usemax-usemin) ); %Simple rescaling to the range [usemin,usemax]
        
        if (usetanh==2)
            I=(1-exp(-I))./(1+exp(-I)); %min max in range [0,1]
        else            
            I=tanh(I); %min max in range [0,1]
        end
        
    else
        meanI=mean(I(:));
        stdI=std(I(:));
        if (printonscreen)
            fprintf('Mean %f, standard deviation %f\n',meanI,stdI);
            Init_figure_no(308), imagesc(I), title('Image');
        end
    
        % (I-meanI)/stdI means zero mean and one std
        I=(I-meanI)/stdI;
        
        I= 0.5*tanh(I)+0.5; %min max in range [0,1]
    end
        
    if (printonscreen)
        fprintf('Tanh output: new mean %f, new standard deviation %f, new min %f, new max %f\n',mean(I(:)),std(I(:)), min(I(:)), max(I(:)) );
        Init_figure_no(309), imagesc(I), title('Image re-normalized');
    end
end

%The new theoretical min (min(I(:))) and max (max(I(:))) of I are 0 and 1 at the maximum
if ( (min(I(:))<0) || (max(I(:))>1) )
    fprintf('Normalized [0,1] Image exceeding the [0,1] range\n');
end

%Normalize the I image to [newmin,newmax]
I= I * (newmax-newmin) + newmin;
if (printonscreen)
    fprintf('New min %f, new max %f\n',min(I(:)),max(I(:)));
    Init_figure_no(309), imagesc(I), title('Image re-normalized');
end



function Other_functions() %#ok<DEFNU>

x=-10:0.01:10;

Init_figure_no(6), plot(x,tanh(x));
hold on, plot(x,min(max( x ,-1),1),'r'), hold off;
hold on, plot(x,(1-exp(-x))./(1+exp(-x)),'g'), hold off;
set(gca,'xlim',[0,5])

hold on, plot(x,(1-exp(-2*x))./(1+exp(-2*x)),'k'), hold off; %tanh with exp written expicitly

