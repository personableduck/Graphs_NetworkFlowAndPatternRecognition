function plot_reconstruction_error(training_set_images,test_set_images,mean_reduced_images,mean_image_vector)

%Finds reconstruction error for every k [ 0:150 ] 
%Output: Plots the Reconstruction errror against the Number of Eigen faces taken. 

[r_tr,c_tr]=size(training_set_images);
[r_ts,c_ts]=size(test_set_images);

reconstruction_error=[];
[e_vectors_reduced,e_values_reduced]=reduced_pca(mean_reduced_images,150);  %SVD of Caricatur'Caricature!!
    
    for j=1:150
        e_vectors_reduced(:,j) = e_vectors_reduced(:,j)/norm(e_vectors_reduced(:,j));
    end
for k_val=1:150
    %Generation of Eigen Faces
    disp('#1');
    disp(k_val);
    e_faces=get_eigen_faces(mean_reduced_images,e_vectors_reduced(:,1:k_val));
    for j=1:k_val
        e_faces(:,j) = e_faces(:,j)/norm(e_faces(:,j));
    end
    %Reconstructino of 27 Test Faces 
    reconstructed_test_faces=reconstruct_test_faces(e_faces,test_set_images,mean_image_vector); %MEAN ADDED back!!!
    
    %Finding The DIFFERENCE in INTENSITIES - btw the Reconstructed Test Face and the actual Test Face
    diff=double(test_set_images)-reconstructed_test_faces;
    reconstruction_error(k_val)=sum(sum(double(diff.^2)))/(256*256*27);
end

figure;
x=1:1:150;
plot(x,reconstruction_error(1:150));
xlabel('eigenface k'),ylabel('reconstruction error')
end