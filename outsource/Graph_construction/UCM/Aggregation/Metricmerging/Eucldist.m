function dist=Eucldist(vec1,vec2)

dist=sqrt(sum((vec1(:)-vec2(:)).^2));