function [mean_reduced_images] = mean_reduced_matrix(images_matrix,mean_image_vector)

[r,c]=size(images_matrix);
mean_reduced_images=[];

for i=1:c
     mean_reduced_images=[mean_reduced_images,double(images_matrix(:,i))-double(mean_image_vector)];
end

end