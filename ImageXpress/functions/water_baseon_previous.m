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


% close all;
function bw3 = water_baseon_previous(Cells,Seeds)
%%
bw   = Cells; % background pic
mask = Seeds;
% imshowpair(bw,mask,'blend')

D = -bwdist(~bw);
% imshow(D,[])

D2 = imimposemin(D,mask);
% imshow(D2,[])

Ld2 = watershed(D2);
bw3 = bw;
bw3(Ld2 == 0) = 0;
% imshow(bw3)