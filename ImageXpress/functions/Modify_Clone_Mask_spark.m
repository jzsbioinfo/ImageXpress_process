

function mask = Modify_Clone_Mask(I)

% I = imread('20190907-test_A01_w1.tif');

I = imread('Z:\20190816__Spark\Images\A1\20190816_A1_1_O_Bf_Raw_ccbdf0bc-b5bc-4a09-932a-2222febc90cc.tiff');

threshold = 0;

I(I>threshold) = 10000;
% I = imread([Files(i).folder '/' Files(i).name]);
I_small              = imresize(I,size(I)/1);


%  imshow(I_small)
[~,threshold] = edge(I_small,'sobel');
fudgeFactor   = 1; % 0.6  0.5 
BWs           = edge(I_small,'sobel',threshold * fudgeFactor);



% BWs = BWs*(-1);
% figure
%imshow(BWs)
% title('Binary Gradient Mask')
% imshowpair(I,BWs)
%%

% BWs(BWs==0) = 2;
% 
% BWs(BWs==1) = 0;
%% Step 3: Dilate the Image

se90 = strel('line',5,90);  % 创建直线长度5，角度90
se0  = strel('line',5,0);  % 创建直线长度5，角度90

BWsdil = imdilate(BWs,[se90 se0]);
BWsdil = bwareaopen(BWsdil, 100000);
% imshow(BWsdil)
% 
% title('Dilated Gradient Mask')

%% Step 4: Fill Interior Gaps
[x y] = find(BWsdil);

%%
% reconstruct circle from data
[xc,yc,Re,a] = circfit(x,y);
% figure  
% plot(x,y,'o'), title(' measured points')

%% Step 7: Visualize the Segmentation

[rows,cols] = size(I_small);
cirCtr = [xc,yc]; % center of the circle in pixels
% cirDia = Re*2*0.9; % circle diameter in pixels
% x = ((1:cols) - cirCtr(2));
% y = ((1:rows) - cirCtr(1));
% [Xdata,Ydata] = meshgrid(x,y); % rows x cols
% [Theta,R] = cart2pol(Xdata,Ydata); % rows x cols
% mask = R;
% mask(mask <= cirDia / 2) = 1; % nan the center
% mask(mask > cirDia / 2) = 0; % black out the outside
% 
% imshowpair(I_small,mask);
% 
% mask = imresize(mask,size(I));
mask = cirCtr;
mask = cirCtr([2,1]);
% imshowpair(I,mask);
