function [female_set_landmarks_test,male_set_landmarks_test] = load_male_female_landmarks_test()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
listing=dir('face_data/female_landmark_87');

single_landmark_matrix=[];
female_set_landmarks_test=[];
for i=75:84
    image_name=sprintf('face_data/female_landmark_87/%s',listing(4+i).name);
    single_landmark_matrix=dlmread(image_name);
    female_set_landmarks_test=[female_set_landmarks_test,single_landmark_matrix(:)];
end

listing=dir('face_data/male_landmark_87');
male_set_landmarks_test=[];
for i=78:87
    image_name=sprintf('face_data/male_landmark_87/%s',listing(4+i).name);
    single_landmark_matrix=dlmread(image_name);
    size(single_landmark_matrix);
    male_set_landmarks_test=[male_set_landmarks_test,single_landmark_matrix(:)];
end


end