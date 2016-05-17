function [scores] = test_rf_new(X, model, threshold, map,calibr)
  
[~, votes] = forestApply(single(full(X)),model);  
scores = votes(:,2);
    
if map    
[sc,ind]=sort(scores,'descend');
scores(ind)  = interp1(calibr.x,calibr.p,sc,'nearest','extrap');
scores(isnan(scores)) = 0;
end    
    
mat = (scores<threshold);   
scores(mat>0)=0.0001;   

end

