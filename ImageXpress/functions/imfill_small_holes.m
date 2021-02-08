
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
