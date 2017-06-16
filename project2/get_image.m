function [image_matrix] = get_image(img_number,img_t)
%returns the grayscaled image matrix of the given image number

if img_t==1 
    listing=dir('newface16');
    filename=listing(3+img_number).name;
    str=sprintf('newface16/%s',filename);
else
    listing=dir('nonface16');
    filename=listing(3+img_number).name;
    str=sprintf('nonface16/%s',filename);
end

image_matrix=imread(str);
image_matrix=rgb2gray(image_matrix);

end

