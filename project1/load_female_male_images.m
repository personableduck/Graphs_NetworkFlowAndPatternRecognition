function [female_image,male_image] = load_female_male_images()
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
listing=dir('face_data/female_face');
training_set_images=[];

female_image=[];
for i=0:74
    image_name=sprintf('face_data/female_face/%s',listing(4+i).name);
    single_image_matrix=imread(image_name);
    female_image=[female_image,single_image_matrix(:)];
end

listing=dir('face_data/male_face');

male_image=[];
for i=0:77
    image_name=sprintf('face_data/male_face/%s',listing(4+i).name);
    single_image_matrix=imread(image_name);
    male_image=[male_image,single_image_matrix(:)];
end



end
