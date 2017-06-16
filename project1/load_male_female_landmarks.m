function [female_set_landmarks,male_set_landmarks] = load_male_female_landmarks()

listing=dir('face_data/female_landmark_87');

female_set_landmarks=[];
for i=0:74
    image_name=sprintf('face_data/female_landmark_87/%s',listing(4+i).name);
    single_landmark_matrix=dlmread(image_name);
    single_landmark_matrix=single_landmark_matrix(1:87,:);
    female_set_landmarks=[female_set_landmarks,single_landmark_matrix(:)];

end

listing=dir('face_data/male_landmark_87');
male_set_landmarks=[];
for i=0:77
    image_name=sprintf('face_data/male_landmark_87/%s',listing(4+i).name);
    single_landmark_matrix=dlmread(image_name);
    single_landmark_matrix=single_landmark_matrix(1:87,:);
    male_set_landmarks=[male_set_landmarks,single_landmark_matrix(:)];
end


end