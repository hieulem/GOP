%aicRSS.m
%
%computes AIC with Residual Sum of Squares Error, with finite sample size
%(more penalty for more parameters)

function output = aicRSS( n, rss, params )

%AIC with RSS: AIC = n ln(RSS/n) + 2k + C, C can be ignored for model
%comparison

aic = n.*log(rss./n) + 2.*params;

%AICc is AIC with a correction for finite sample sizes:
%AICc = AIC + 2k(k+1)/(n-k-1)

output = aic + 2.*params.*(params+1)./(n-params-1);
