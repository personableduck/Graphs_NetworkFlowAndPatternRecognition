function [reconstructed_random_faces] = reconstruct_test_faces_random(e_faces,test_set_images,mean_training_set_face,top_e_value)
%Find the weights of the Training Images against the EigenVectors. 

[r,c]=size(test_set_images);
[e_r,e_c]=size(e_faces);

random_image_weights=[];
mean_reduced_matrix_test=mean_reduced_matrix(test_set_images,mean_training_set_face);

%Finding WEIGHTS for EACH TEST IMAGE
for i=1:c
    random_image_weights=[random_image_weights  get_weights_random(e_faces,mean_reduced_matrix_test(:,i),top_e_value,2)];
    size(random_image_weights);
end

%reconstructed_random_faces=(double(random_image_weights)'*double(e_faces)')';
reconstructed_random_faces=double(mean_reduced_matrix((double(random_image_weights)'*double(e_faces)')',mean_training_set_face.*(-1)));

end