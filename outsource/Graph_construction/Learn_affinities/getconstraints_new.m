function [scores] = getconstraints_new(X,type,threshold,map)
% RF model
data= load(['RF_model/',type,'/model.mat'],'model');
model=data.model; 
% calibration function
calibr= load(['calibration/',type,'/map.mat']);

[scores] = test_rf_new(X, model{1}, threshold, map, calibr);
end

