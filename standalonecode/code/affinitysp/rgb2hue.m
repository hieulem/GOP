%rgb2hue.m
%
%this function transforms an rgb image into its hue colorspace
%

function outImg = rgb2hue(inputImg)

inputImg = double(inputImg);

%outImg0 = rgb2hsv(inputImg);
outImg = zeros(size(inputImg,1), size(inputImg,2));

for i = 1:size(outImg,1)
    for j = 1:size(outImg,2)
        
        r = inputImg(i,j,1);
        g = inputImg(i,j,2);
        b = inputImg(i,j,3);
        
        val = (180/pi)*atan2(sqrt(3)*(g-b), 2*r - g - b );
        
        if val < 0
            val = 360+val;
        end
        
        if r == g && r == b
            val = -1;
        end
        
        outImg(i,j) = val;
        
        %341~20 = red, 0.75
        %21~60 = orange, 0.875
        %61~100 = yellow, 1.0
        %101~140 = green, 0
        %141~180 = sky-blue, 0.125
        %181~220 = darker blue, 0.25
        %221~260 = blue, 0.375
        %261~300  = purple, 0.5
        %301~340 = pink, 0.625
        
%         if outImg0(i,j,1)*360 >= 341 || outImg0(i,j,1)*360 <= 20
%             outImg(i,j) = 0.75;
%         end
%         
%         if outImg0(i,j,1)*360 >= 21 && outImg0(i,j,1)*360 <= 60
%             outImg(i,j) = 0.875;
%         end
%         
%         if outImg0(i,j,1)*360 >= 61 && outImg0(i,j,1)*360 <= 100
%             outImg(i,j) = 1.0;
%         end
%         
%         if outImg0(i,j,1)*360 >= 101 && outImg0(i,j,1)*360 <= 140
%             outImg(i,j) = 0;
%         end
%         
%         if outImg0(i,j,1)*360 >= 141 && outImg0(i,j,1)*360 <= 180
%             outImg(i,j) = 0.125;
%         end
%         
%         if outImg0(i,j,1)*360 >= 181 && outImg0(i,j,1)*360 <= 220
%             outImg(i,j) = 0.25;
%         end
%         
%         if outImg0(i,j,1)*360 >= 221 && outImg0(i,j,1)*360 <= 260
%             outImg(i,j) = 0.375;
%         end
%         
%         if outImg0(i,j,1)*360 >= 261 && outImg0(i,j,1)*360 <= 300
%             outImg(i,j) = 0.5;
%         end
%         
%         if outImg0(i,j,1)*360 >= 301 && outImg0(i,j,1)*360 <= 340
%             outImg(i,j) = 0.625;
%         end
% %         outImg(i,j) = sind(outImg0(i,j,1)*180);
% %         
% %         if outImg0(i,j,1)*360 > 180
% %             outImg(i,j) = outImg(i,j)*-1;
% %         end
        
        
    end
end






