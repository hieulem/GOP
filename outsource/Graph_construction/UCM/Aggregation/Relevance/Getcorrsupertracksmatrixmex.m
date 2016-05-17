function corrsupertracks=Getcorrsupertracksmatrixmex(labelledlevelunique,labelledlowerunique,maxnotracks,noallsuperpixels)


USEMEX=true;

if (USEMEX)
    
    corrsupertracks=Getcorrsupertracksmatrixmx(labelledlevelunique,labelledlowerunique,maxnotracks,noallsuperpixels); % Getcorrsupertracksmatrixmx.cpp
    
%     for i=1:numel(labelledlowerunique)
%         
%         pi= labelledlevelunique(i)-1;
%         pj= labelledlowerunique(i)-1;
%         thevalue=pj*maxnotracks + pi + 1;
%         
%         %fprintf('i(c) (%d), pi (%d) labelledlevelunique[i] (%d), pj (%d) labelledlowerunique[i] (%d), linear index (%d)\n',i-1, pi,labelledlevelunique(i),pj,labelledlowerunique(i),pj*maxnotracks + pi);
%         
%         if (   (  corrsupertracks( labelledlevelunique(i) , labelledlowerunique(i) )  ~=  true  )   ||   (  corrsupertracks( thevalue )  ~=  true  )   )
%             fprintf('Difference at %d\n',i);
%             break;
%         end
%     end

else
    
    corrsupertracks=false(maxnotracks,noallsuperpixels);
    
    for i=1:numel(labelledlowerunique)
        
        corrsupertracks( labelledlevelunique(i) , labelledlowerunique(i) )=true;
        
    end

end

