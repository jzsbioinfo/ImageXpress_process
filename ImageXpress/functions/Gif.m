
function Gif(Name,i)

M=getframe(gcf);
% M.cdata=imresize(M.cdata(:,:,:),[400,400]);
nn=frame2im(M);
[nn,cm]=rgb2ind(nn,256);

if i==1
imwrite(nn,cm,Name,'gif','LoopCount',1,'DelayTime',0.00001);
else 
imwrite(nn,cm,Name,'gif','WriteMode','append','DelayTime',0.00001)
end
