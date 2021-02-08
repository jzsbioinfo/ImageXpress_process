% 
% 
% %%
% 1. Compute a segmentation function. This is an image whose dark regions are the objects you are trying to segment.
% 
% 2. Compute foreground markers. These are connected blobs of pixels within each of the objects.
% 
% 3. Compute background markers. These are pixels that are not part of any object.
% 
% 4. Modify the segmentation function so that it only has minima at the foreground and background marker locations.
% 
% 5. Compute the watershed transform of the modified segmentation function.
% %%


close all;

bw   = BWfinal; % background pic
se   = strel('disk',5);
fgm  = imerode(mask_old,se);

imshowpair(fgm,bw)





D  = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
%bgm = imdilate(bgm,ones(3,3));
imshowpair(fgm,bgm)
title('Watershed Ridge Lines)')


gmag = imgradient(bw);
imshow(gmag,[])
title('Gradient Magnitude')


% gmag2 = imimposemin(I, bgm | fgm4);
% imshow(gmag2)

% gmag2 = imimposemin(I, bgm | fgm);
% imshow(gmag2)

gmag2 = imimposemin(+[BWfinal], bgm | fgm);
imshow(gmag2)

% I_eq_c = imcomplement(I_eq);


L = watershed(gmag2);

labels = imdilate(L==0,ones(5,5)) + 2*bgm + 3*fgm4;
I4 = labeloverlay(I,labels);
figure;
imshow(I4)
title('Markers and Object Boundaries Superimposed on Original Image')
% 



figure;
imagesc(L);

figure;
Fi = L.*uint8(BWfinal);

Fi = bwareaopen(Fi, 100);


imshowpair(I,Fi>0)


% BWfinal(L==0)=0;
% 
% imshow(BWfinal)
% title('Markers and Object Boundaries Superimposed on Original Image')

