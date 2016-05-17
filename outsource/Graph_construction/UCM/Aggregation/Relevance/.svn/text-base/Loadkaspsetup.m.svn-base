function [alpha,sigma]=Loadkaspsetup(nametag)


switch(nametag)
    
    case 'PokerHand'
        alpha=3000;
        sigma=0.6;
        
    case 'Musk'
        alpha=8;
        sigma=30;
        
    case 'MagicGamma'
        alpha=8;
        sigma=36;
        
    case 'Connect4'
        alpha=200;
        sigma=50;
        
    case 'USCI'
        alpha=500;
        sigma=10;
        
    otherwise
        fprintf('Requested setup not evailable\n');
        alpha=[];
        sigma=[];
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The bandwidth parameter (sigma)
% This value is to be searched over a range
% The following, in the form of (reduction ratio, sigma), are examples 
% of good (by no means the best) values based on our experiments.
% Note even for the same dataset, the optimal sigma varies for different 
% reduction ratios
%
% Musk			(1/8,30)
% Magic Gamma		(1/8,36)
% Connect-4		(1/200,50) 
% USCI			(1/500,10)
% Poker Hand		(1/3000,0.6)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
