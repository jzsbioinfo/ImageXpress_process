

function mask = Clone_Mask(I)

I_small              = imresize(I,size(I)/50);

 imshow(I_small)
[~,threshold] = edge(I_small,'sobel');
fudgeFactor   = 0.8; % 0.6  0.5 
BWs           = edge(I_small,'sobel',threshold * fudgeFactor);

imshow(BWs)
title('Binary Gradient Mask')
% imshowpair(I,BWs)

%% Step 3: Dilate the Image

se90 = strel('line',5,90);
se0  = strel('line',5,0);

BWsdil = imdilate(BWs,[se90 se0]);
BWsdil = bwareaopen(BWsdil, 500);
imshow(BWsdil)

title('Dilated Gradient Mask')

%% Step 4: Fill Interior Gaps
[x y] = find(BWsdil);

%%
% reconstruct circle from data
[xc,yc,Re,a] = circfit(x,y);
   
% plot(x,y,'o'), title(' measured points')

%% Step 7: Visualize the Segmentation

[rows,cols] = size(I_small);
cirCtr = [xc,yc]; % center of the circle in pixels
cirDia = Re*2*0.9; % circle diameter in pixels
x = ((1:cols) - cirCtr(2));
y = ((1:rows) - cirCtr(1));
[Xdata,Ydata] = meshgrid(x,y); % rows x cols
[Theta,R] = cart2pol(Xdata,Ydata); % rows x cols
mask = R;
mask(mask <= cirDia / 2) = 1; % nan the center
mask(mask > cirDia / 2) = 0; % black out the outside

imshowpair(I_small,mask);

mask = imresize(mask,size(I));
mask = cirCtr;
% imshowpair(I,mask);
