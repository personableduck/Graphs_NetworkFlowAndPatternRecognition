function plot_landmark_reconstruction_error(training_set_landmarks,test_set_landmarks,mean_landmark_vector)
%UNTITLED24 Summary of this function goes here
%   Detailed explanation goes here

[r_tr,c_tr]=size(training_set_landmarks);
[r_ts,c_ts]=size(test_set_landmarks);

reconstruction_error=[];
mean_reduced_training_landmarks=mean_reduced_matrix(training_set_landmarks,mean_landmark_vector);
caricature_aa=mean_reduced_training_landmarks*mean_reduced_training_landmarks';
size(caricature_aa)
for k_val=1:150
    [e_vectors_reduced,e_values_reduced,e_vectors_reduced_v]=svds(caricature_aa,k_val);
    %size(e_vectors_reduced)
    for j=1:k_val
        e_vectors_reduced(:,j) = e_vectors_reduced(:,j)/norm(e_vectors_reduced(:,j));
    end
    e_warpings_k=e_vectors_reduced;
    
    reconstructed_test_landmarks=reconstruct_test_landmarks(e_warpings_k,test_set_landmarks,mean_landmark_vector); % Remember: mean added back! 
    % Ready to Display-^
    %if k_val==50 | k_val==60 
    %    display_landmarks(reconstructed_test_landmarks,mean_landmark_vector);
    %end
    
    %-----------Error Analysis of Reconstructed Test Landmarks.
    %Diff: distance between the Two points from Actual Landmarks, and the Test Landmark.
    for i=1:c_ts
        recon_coords=reshape(reconstructed_test_landmarks(:,i),[87,2]);
        orig_coords=reshape(test_set_landmarks(:,i),[87,2]);
        diff=sqrt((recon_coords(:,1)-orig_coords(:,1)).^2 + (recon_coords(:,2)-orig_coords(:,2)).^2); %Gives distance between points
    end
    reconstruction_error(k_val)=double((sum(diff)/(87*27)));
    %disp(k_val);
end

figure;
x=1:1:150;
plot(x,reconstruction_error(1:150));
xlabel('eigen-warppings k'),ylabel('reconstruction error')

end