


function BWfinal = Clone_RHX(I,Params)

[~,threshold] = edge(I,'sobel');
fudgeFactor   = Params.fudgeFactor; % 0.6  0.5 
BWs           = edge(I,'sobel',threshold * fudgeFactor);

% imshow(BWs)
% title('Binary Gradient Mask')

%% Step 3: Dilate the Image

se90 = strel('line',3,90);
se0  = strel('line',3,0);

BWsdil = imdilate(BWs,[se90 se0]);
BWsdil = bwareaopen(BWsdil, Params.remove_small_patch);
% imshow(BWsdil)
% 
% title('Dilated Gradient Mask')

%% Step 4: Fill Interior Gaps
% BWdfill = imfill(BWsdil,'holes');
if Params.small_holes>0
BWdfill  = imfill_small_holes(BWsdil,Params.small_holes);
else
BWdfill = imfill(BWsdil,'holes');
end
% previous = imread('y_7.tif')>0;
% BWdfill  = BWdfill | previous;
% imshow(BWdfill)
% title('Binary Image with Filled Holes')

%% Step 5: Remove Connected Objects on Border
BWnobord = (BWdfill);
if Params.clear_border
    BWnobord = imclearborder(BWdfill,4);
end
% imshow(BWnobord)
% title('Cleared Border Image')


%% Step 6: Smooth the Object

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
BWfinal = bwareaopen(BWfinal, Params.remove_small_patch);

end


% original = BWsdil;
% imshow(original)

function new = imfill_small_holes(original,hole_size)

%% Step 1: Fill all holes using imfill:
filled = imfill(original, 'holes');
% imshow(filled)
% title('All holes filled')

%% Step 2: Identify the hole pixels using logical operators:
holes = filled & ~original;
% imshow(holes)
% title('Hole pixels identified')

%% Step 3: Use bwareaopen on the holes image to eliminate small holes:
bigholes = bwareaopen(holes, hole_size);
% imshow(bigholes)
% title('Only the big holes')

%% Step 4: Use logical operators to identify small holes:
smallholes = holes & ~bigholes;
% imshow(smallholes)
% title('Only the small holes')

%% Step 5: Use a logical operator to fill in the small holes in the original image:
new = original | smallholes;
% imshow(new)
% title('Small holes filled')

end









%% Step 7: Visualize the Segmentation
