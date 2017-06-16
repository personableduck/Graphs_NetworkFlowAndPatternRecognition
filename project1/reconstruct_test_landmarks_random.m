function [reconstructed_random_landmarks] = reconstruct_test_landmarks_random(e_warpings,test_set_landmarks,mean_landmark_vector,top_e_value)
%UNTITLED23 Summary of this function goes here
%   Detailed explanation goes here

[r,c]=size(test_set_landmarks);
[e_r,e_c]=size(e_warpings);

random_image_weights=[];
mean_reduced_landmarks_test=mean_reduced_matrix(test_set_landmarks,mean_landmark_vector);

for i=1:c
    random_image_weights=[random_image_weights  get_weights_random(e_warpings,mean_reduced_landmarks_test(:,i),top_e_value,1)];
    size(random_image_weights);
end

%size(mean_landmark_vector);
reconstructed_random_landmarks=double(mean_reduced_matrix((double(random_image_weights)'*double(e_warpings)')',mean_landmark_vector.*(-1)));

for i=1:c
        min_val=min(double(reconstructed_random_landmarks(:,i)));
        max_val=max(double(reconstructed_random_landmarks(:,i)));
        if(min_val<=0)
          %    reconstructed_random_landmarks(:,i)=round(((double(reconstructed_random_landmarks(:,i)+mean_landmark_vector)-min_val)/(max_val-min_val))*255);
              reconstructed_random_landmarks(:,i)=round(((double(reconstructed_random_landmarks(:,i))-min_val)/(max_val-min_val))*255);
        end
end



end