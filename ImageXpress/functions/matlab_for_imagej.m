
function merge_adjust =  Merge_and_Adjust(BF, Seg, FI)


Merge=zeros([size(I_old) 3]);
BWfinal_2 = uint16(BWfinal)*25500;

I_FI_2 = uint16(BWfinal)*25500;


I_old = I;
I_old_min=min(I_old(:));
I_old_max=max(I_old(:));


% Calculate the standard deviation and the image mean for stretching.
n = 4;  
Idouble = im2double(I_old); 
avg = mean2(Idouble);
sigma = std2(Idouble);

% Adjust the contrast based on the standard deviation.
I_old_adj = imadjust(I_old,[avg-n*sigma avg+n*sigma],[]);

imshow(I_old_adj)


imshow(I_old)
imshow(imadjust(I_old))
I_old        = (I_old-I_old_min)/(I_old_max-I_old_min)*255;
imshow(I_old)
I_old   =   uint16(imadjust(I));
imshow(I_old)


Merge(:,:,1) = I_old_adj  +1*I_FI;
Merge(:,:,2) = I_old_adj  + 0*BWfinal_2;
Merge(:,:,3) = I_old_adj  + 0*BWfinal_2; ;



figure;
imshow(uint16(Merge));


saveas(gcf,'test.png')