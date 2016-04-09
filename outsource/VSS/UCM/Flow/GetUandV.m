function [velUm,velVm,velUp,velVp]=GetUandV(UVFlows)
%[velUm,velVm,velUp,velVp]=GetUandV(flows.flows{frame})
%[VelUVm,VelUVp]=GetUandV(flows.flows{frame}): VelUVm=[:,:,[Um,Vm]] VelUVp=[:,:,[Up,Vp]]


rows=size(UVFlows.Um,1);
cols=size(UVFlows.Um,2);
[U,V]=meshgrid(1:cols,1:rows); %pixel coordinates
velUm=UVFlows.Um-U;
velVm=UVFlows.Vm-V;
velUp=UVFlows.Up-U;
velVp=UVFlows.Vp-V;

if (nargout==2)
    velUm=cat(3,velUm,velVm);
    velVm=cat(3,velUp,velVp);
end



% [Y,X]=meshgrid(1:cols,1:rows);
% U(:,:)=flowPlus(:,:,1);
% V(:,:)=flowPlus(:,:,2);
% XP=X+U;
% YP=Y+V;
% U(:,:)=flowMinus(:,:,1);
% V(:,:)=flowMinus(:,:,2);
% XM=X+U;
% YM=Y+V;
