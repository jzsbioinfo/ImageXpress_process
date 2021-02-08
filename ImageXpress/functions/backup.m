%% afterwards 

% 
%     close all;
%     
%  for i = 34%  : length(Files)
%      
% I        = imread([Files(i).folder '/' Files(i).name],'PixelRegion',{[3000 3000+2000],[1 2000]});
% mask_old = Budding(i-1).mask;
% 
% % cells in previous image must be cells in next image
% I_old= I;
% I(mask_old)=max(I(:));
% imshow(I);
% 
% 
% % cells mask of current image
% Params.fudgeFactor        = 0.5;   % larger value will remove background noise
% Params.small_holes        = 0;     % holes threshold, 0 as fill all holes.
% Params.clear_border       = 0;     % remove border cells or not
% Params.remove_small_patch = 300;
% 
% 
% BWfinal  = Clone_RHX(I,Params);
% BWfinal  = water_baseon_previous(BWfinal,mask_old); % remove merge case 
% BWfinal  = bwareaopen(BWfinal, 100);
% BWfinal  = imclearborder(BWfinal,4);
% 
% 
% % imshow(BWfinal)
% 
% figure;
% imshowpair(I_old,BWfinal)
% title(['t = ' num2str(i) ' ( time point )']);
% % imwrite(uint16(BWfinal),['Final.tif'], 'tif' );
% 
% 
%     Budding(i).ROIs             = regionprops(BWfinal, 'ConvexHull');  % find boundary for each cell
%     Budding(i).centroid         = regionprops(BWfinal, 'centroid');        % find position for each cell
%     Budding(i).area             = regionprops(BWfinal, 'area');        % find position for each cell
%     Budding(i).mask             = BWfinal;  % find boundary for each cell
% 
% %     mask_old = BWfinal;
% 
%  end


bb
% %%
% close all;
% tic;
% for i = 1 : 31
%     
% I = imread([Files(i).folder '/' Files(i).name],'PixelRegion',{[3000 3000+2000],[1 2000]});
% 
% % I = imread([Files(i).folder '/' Files(i).name]);
% 
% toc;
% tic;
% 
% % I = I + mask_old*255;
% % imshow(I);
% % J = imcrop(I,[0 1656 3256 5400]);
% % imwrite(uint16(J),['small/' Files(i).name(1:end-5) '_small.tif'], 'tif' );
% 
% Params.fudgeFactor        = 0.5;   % larger value will remove background noise
% Params.small_holes        = 0;     % holes threshold, 0 as fill all holes.
% Params.clear_border       = 1;     % remove border cells or not
% Params.remove_small_patch = 300;
% 
% 
% BWfinal = Clone_RHX(I,Params);
% 
% 
% % figure;
% % imshowpair(I,BWfinal)
% % title(['t = ' num2str(i) ' ( time point )']);
% 
% % imwrite(uint16(BWfinal),['Final.tif'], 'tif' );
% 
% 
%     Budding(i).ROIs             = regionprops(BWfinal, 'ConvexHull');  % find boundary for each cell
%     Budding(i).centroid         = regionprops(BWfinal, 'centroid');        % find position for each cell
%     Budding(i).area             = regionprops(BWfinal, 'area');        % find position for each cell
%     Budding(i).mask             = BWfinal;  % find boundary for each cell
% 
% end
% 
% toc;

%%


