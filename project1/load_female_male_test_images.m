function [female_test_image,male_test_image] = load_female_male_test_images()

listing=dir('face_data/female_face');
training_set_images=[];
female_test_image=[];
for i=75:84
    image_name=sprintf('face_data/female_face/%s',listing(4+i).name);
    single_image_matrix=imread(image_name);
    female_test_image=[female_test_image,single_image_matrix(:)];
end

male_test_image=[];
listing=dir('face_data/male_face');

for i=78:87
    image_name=sprintf('face_data/male_face/%s',listing(4+i).name);
    single_image_matrix=imread(image_name);
    male_test_image=[male_test_image,single_image_matrix(:)];
end



end