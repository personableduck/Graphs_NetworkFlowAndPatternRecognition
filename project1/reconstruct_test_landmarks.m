function [reconstructed_test_landmarks] = reconstruct_test_landmarks(e_warpings,test_set_landmarks,mean_landmark_vector)
%UNTITLED23 Summary of this function goes here
%   Detailed explanation goes here

[r,c]=size(test_set_landmarks);
[e_r,e_c]=size(e_warpings);

test_image_weights=[];
mean_reduced_landmarks_test=mean_reduced_matrix(test_set_landmarks,mean_landmark_vector);

for i=1:c
    test_image_weights=[test_image_weights  get_test_weights(e_warpings,mean_reduced_landmarks_test(:,i))];
    size(test_image_weights);
end

%size(mean_landmark_vector);
reconstructed_test_landmarks=double(mean_reduced_matrix((double(test_image_weights)'*double(e_warpings)')',mean_landmark_vector.*(-1)));

for i=1:c
        min_val=min(double(reconstructed_test_landmarks(:,i)));
        max_val=max(double(reconstructed_test_landmarks(:,i)));
        if(min_val<=0)
          %    reconstructed_test_landmarks(:,i)=round(((double(reconstructed_test_landmarks(:,i)+mean_landmark_vector)-min_val)/(max_val-min_val))*255);
              reconstructed_test_landmarks(:,i)=round(((double(reconstructed_test_landmarks(:,i))-min_val)/(max_val-min_val))*255);
        end
end



end