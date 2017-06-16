function [mean_image_vector] = get_mean_image_vector(input_vector_matrix) 
%Gives the mean of the matrix row-wise 
%Output: Column Vector
[r,c]=size(input_vector_matrix);
mean_image_vector=sum(double(input_vector_matrix),2);
mean_image_vector=double(double(mean_image_vector)./c);
end