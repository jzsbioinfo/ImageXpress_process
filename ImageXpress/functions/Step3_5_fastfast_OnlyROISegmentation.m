clear;
clc;

% Step1: Read "prediction.csv"
load('../Result/prediction.mat');

Size   = size(Data_whole_image,2);
Frames = size(Data_whole_image,1);

% Step2: Parameters for segmenation
CellSize =  20;  % budding ~20  fission ~100
Level    =  .6;   % budding ~.6   fission 2
disp('--------*------------*------------')
disp(['CellSize is :',num2str(CellSize)]  )
disp(['Level is :',num2str(Level)]  )
disp('--------*------------*------------')

tic;

% Step3: Parameters for segmenation
for i=1:Frames

% Step3.1: Get prediction
Prediction = reshape(imresize(Data_whole(i,:,:),Size/(size(Data_whole,2))),Size,Size);
Image      = reshape(Data_whole_image(i,:,:),Size,Size);


%figure(1)
%subplot(1,2,1)
%imshow(Image)
%subplot(1,2,2)
%imshow(Prediction)

% Step3.2: Water_segmentation
BW = bwareaopen(water_segmentation(im2bw(Prediction),Level,CellSize),CellSize);

Output(i).Image=Image;
Output(i).Prediction=Prediction;
Output(i).Name = File(i,1:end-4);

% Step3.3: Avoid when fail!!
[L,num] = bwlabel(BW);
if num==0
    continue;
    disp('No Cell!!!')    
end


% Step3.4: Generate centroids!!
s  = regionprops(BW, 'centroid');
centroids = cat(1, s.Centroid);

% Step3.5: Generate ROIs!!
ROIs  = regionprops(BW, 'ConvexHull');

% Step3.6: Generate ROIs!!
s  = regionprops(BW, 'Area');
Areas = cat(1, s.Area);



%  Scale ROIs!!
ScaleFactor = 1.1;
for m=1:length(ROIs)
    ROIs(m).ConvexHull(:,1) = (ROIs(m).ConvexHull(:,1)-centroids(m,1))*ScaleFactor+centroids(m,1);
    ROIs(m).ConvexHull(:,2) = (ROIs(m).ConvexHull(:,2)-centroids(m,2))*ScaleFactor+centroids(m,2);
end



Output(i).ROIs = ROIs;
Output(i).centroids = centroids;
Output(i).factor = Factor(i);
Output(i).Area  = Areas;

end

clearvars -except Output
save('../Result/Output.mat')

YeastbowROI=rmfield(Output,{'Image','Prediction'});
clearvars Output

save('../Result/YeastbowROI.mat')

disp('Segmentation Done!')


% Step4: Generate Fiji ROI files!!
Step3_8_GenerateFijiRoi('../Result/')
toc;

disp('Fiji ROI have been generated!')


delete('../Result/Output.mat')
delete('../Result/prediction.mat')
cd ../
zip('Result.zip','Result');
rmdir('Result/','s');
disp('Fiji ROI have been generated!')




