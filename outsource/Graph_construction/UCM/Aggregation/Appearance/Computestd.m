function [STD,SD]=Computestd(labelledlevelvideo,numberofsuperpixelsperframe,concc,conrr,noFrames,noallsuperpixels)

[medianx,mediany,medianf] = Getmedianforstd(noallsuperpixels,numberofsuperpixelsperframe,labelledlevelvideo,noFrames);
v=Getforstd(concc,conrr,medianx,mediany,medianf);
v_sd = Getforsd(concc,conrr,medianx,mediany);
SD = sparse([concc,conrr],[conrr,concc],[v_sd,v_sd],noallsuperpixels,noallsuperpixels);
STD = sparse([concc,conrr],[conrr,concc],[v,v],noallsuperpixels,noallsuperpixels);

