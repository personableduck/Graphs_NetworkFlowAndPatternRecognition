function [reconstructed_test_faces] = reconstruct_test_faces(e_faces,test_set_images,mean_training_set_face)
%Find the weights of the Training Images against the EigenVectors. 

[r,c]=size(test_set_images);
[e_r,e_c]=size(e_faces);

test_image_weights=[];
mean_reduced_matrix_test=mean_reduced_matrix(test_set_images,mean_training_set_face);

%Finding WEIGHTS for EACH TEST IMAGE
for i=1:c
    test_image_weights=[test_image_weights  get_test_weights(e_faces,mean_reduced_matrix_test(:,i))];
    size(test_image_weights);
end

%reconstructed_test_faces=(double(test_image_weights)'*double(e_faces)')';
reconstructed_test_faces=double(mean_reduced_matrix((double(test_image_weights)'*double(e_faces)')',mean_training_set_face.*(-1)));


%Normalize Reconstructed Face Array(Column) 
%for i=1:c
        %min_val=min(double(reconstructed_test_faces(:,i)));
        %max_val=max(double(reconstructed_test_faces(:,i)));
        %if(min_val<=0)
          %    reconstructed_test_faces(:,i)=round(((double(reconstructed_test_faces(:,i)+mean_training_set_face)-min_val)/(max_val-min_val))*255);
          %    reconstructed_test_faces(:,i)=round(((double(reconstructed_test_faces(:,i))-min_val)/(max_val-min_val))*255);
        %end
%end

%for j=1:c
%        reconstructed_test_faces(:,j) = double(reconstructed_test_faces(:,j)/norm(reconstructed_test_faces(:,j)));
%end
end
