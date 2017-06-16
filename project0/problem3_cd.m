img1=imread('C:\Users\1234\Desktop\patternreconization\code\examples\images\1.png');

net=ans
net.layers= net.layers(1:end-1);
img = single(img1) - net.averageImage;
res = vl_simplenn(net, img);
figure, imagesc(res(2).x(:,:,1))

figure,imshow(img1)

for i=1:32
figure,imagesc(res(2).x(:,:,i));
axis off
title(['filter',num2str(i)])
saveas(gcf,['fileter ',num2str(i),'.jpg'])

end