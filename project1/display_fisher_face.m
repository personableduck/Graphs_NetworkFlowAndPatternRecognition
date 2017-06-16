function display_fisher_face(image_vector)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
figure;

min_val=min(double(image_vector));
max_val=max(double(image_vector));
if(min_val<=0)
    image_vector=round(((double(image_vector)-min_val)/(max_val-min_val))*255)
end

imshow(uint8(reshape(image_vector,[256,256])),'border','tight');

end