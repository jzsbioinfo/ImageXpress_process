
%一次读取多帧tif图片
function f=imreadstack(imname,resolution)
info = imfinfo(imname);
num_images = numel(info);

length(resolution)

if length(resolution)>num_images
    resolution = 1:num_images;
end
    
    f=zeros(info(1).Height,info(1).Width, length(resolution));

    
h=waitbar(0,'Reading Image, Please wait...');
j=1;


for k = 1:length(resolution)
    waitbar(k/length(resolution),h,'Reading Image, Please wait...');
    f(:,:,j) =imread(imname, resolution(k));
    j=j+1;
end
close(h);

end

