function [training_set_landmarks,test_set_landmarks] = load_0_176_landmark_images() %loads both the 150 training and the 27 test images as vectors each appended into matrices
input_dir_land = 'C:\Users\1234\Desktop\patternreconization\project1\face_data\landmark_87';
filenames = dir(fullfile(input_dir_land, '*.dat'));

training_set_landmarks=[];
test_set_landmarks=[];
for i=1:150
    land_filename=fullfile(input_dir_land, filenames(i).name);
    single_landmark_matrix=dlmread(land_filename);
    single_landmark_matrix=single_landmark_matrix(2:88,:);
    training_set_landmarks=[training_set_landmarks,single_landmark_matrix(:)];

end

for i=151:177
    land_filename=fullfile(input_dir_land, filenames(i).name);
    single_landmark_matrix=dlmread(land_filename);
    single_landmark_matrix=single_landmark_matrix(2:88,:);
    test_set_landmarks=[test_set_landmarks,single_landmark_matrix(:)];
end

end