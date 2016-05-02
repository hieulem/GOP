%biconeSat.m
%
%transform a cone/cube saturation into bicone style, which is modulated by
%lightness

function output = biconeSat(satImg, lightness)

l50 = find(lightness > 50);  %y = (-1/50) x + 2
s50 = find(lightness <= 50); %y = (1/50) x 

satImg(l50) = satImg(l50).* (lightness(l50)*(-1/50)+2);
satImg(s50) = satImg(s50).* (lightness(s50)*(1/50));

output = satImg;