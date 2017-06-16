
%% Part (1)-problem 1

input_dir = 'C:\Users\1234\Desktop\patternreconization\project1\face_data\face';
image_dims = [256, 256];
 
filenames = dir(fullfile(input_dir, '*.bmp'));
num_images = numel(filenames)-27; %only 150 are training set, rest of 27 is for test.
images = [];
for n = 1:num_images
    filename = fullfile(input_dir, filenames(n).name);
    img = imread(filename);
    if n == 1
        images = zeros(prod(image_dims), num_images);
    end
    images(:, n) = img(:);
end

% steps 1 and 2: find the mean image and the mean-shifted input images
[evectors, score, evalues] = pca(images');
 
num_eigenfaces = 20;
eigen20 = evectors(:, 1:num_eigenfaces);

% display the eigenvectors
%figure;
for n = 1:num_eigenfaces
    evector = reshape(eigen20(:,n), image_dims);
%     figure,imshow(evector,[]);
%     axis off
%     title(['eigenface',num2str(n)])
%     saveas(gcf,['eigen ',num2str(n),'.jpg'])
end

test_images = [];
for k = 1:27
    test_num=150+k;
    filename = fullfile(input_dir, filenames(test_num).name);
    img = imread(filename);
    if k == 1
        test_images = zeros(prod(image_dims), 27);
    end
    test_images(:, k) = img(:);
end

mean_test=mean(test_images,2);
size_test=size(test_images);
for test_num=1:size_test(1,2)
    shifted=test_images(:,test_num)-mean_test;
    a=eigen20'*shifted;
    b=eigen20*a;
    recon(:,test_num)= b + mean_test;
    figure,imshow(reshape(recon(:,test_num),image_dims),[])
    saveas(gcf,['reconstructed_testimg ',num2str(test_num),'.jpg'])
end

%% problem1
input_dir = 'C:\Users\1234\Desktop\patternreconization\project1\face_data\face';
image_dims = [256, 256];
 
filenames = dir(fullfile(input_dir, '*.bmp'));
num_images = numel(filenames)-27; %only 150 are training set, rest of 27 is for test.

training_set_images = [];
for n = 1:num_images
    filename = fullfile(input_dir, filenames(n).name);
    img = imread(filename);
    if n == 1
        training_set_images = zeros(prod(image_dims), num_images);
    end
    training_set_images(:, n) = img(:);
end

test_set_images = [];
for k = 1:27
    test_num=150+k;
    filename = fullfile(input_dir, filenames(test_num).name);
    img = imread(filename);
    if k == 1
        test_set_images = zeros(prod(image_dims), 27);
    end
    test_set_images(:, k) = img(:);
end

mean_landmark_vector=get_mean_image_vector(training_set_images);
display_faces(mean_landmark_vector);

mean_reduced_images=mean_reduced_matrix(training_set_images,mean_landmark_vector);
[e_vectors_reduced,e_values_reduced]=reduced_pca(mean_reduced_images,20);  

e_faces=get_eigen_faces(mean_reduced_images,e_vectors_reduced);
for j=1:20
        e_faces(:,j) = e_faces(:,j)/norm(e_faces(:,j));
end
display_faces(e_faces,mean_landmark_vector);

%Display 27 Reconstructed TEST Faces 
reconstructed_test_faces=reconstruct_test_faces(e_faces,test_set_images,mean_landmark_vector);

display_faces(reconstructed_test_faces,mean_landmark_vector);

%Plotting of Reconstruction Error 
plot_reconstruction_error(training_set_images,test_set_images,mean_reduced_images,mean_landmark_vector);

%% problem(2) landmark

input_dir_land = 'C:\Users\1234\Desktop\patternreconization\project1\face_data\landmark_87';
filenames = dir(fullfile(input_dir_land, '*.dat'));

test_set_landmarks=[];
training_set_landmarks=[];
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

[r,c]=size(training_set_landmarks);

mean_landmark_vector=get_mean_image_vector(training_set_landmarks);

% mean_landmark_vector=sum(double(training_set_landmarks),2);
% mean_landmark_vector=double(double(mean_landmark_vector)./c);
mean_origin=mean_landmark_vector;

mean_landmarks=reshape(mean_landmark_vector,[87,2]);

mean_image=double(mean(images,2));

[mr,mc]=size(mean_landmarks);
mean_landmarks=uint8(ones(mr,mc)*255)-uint8(mean_landmarks);
mean_landmarks=uint8(ones(mr,mc).*255)-uint8(mean_landmarks);
figure,imshow(reshape(mean_image,image_dims),[])
hold on
scatter(mean_landmarks(:,1),mean_landmarks(:,2),30,'filled');

%Display MEAN landmarks
display_landmarks(mean_landmark_vector,mean_landmark_vector);

%Display 5 Eigen warpings
mean_reduced_training_landmarks=mean_reduced_matrix(training_set_landmarks,mean_landmark_vector);
caricature=mean_reduced_training_landmarks*mean_reduced_training_landmarks';
[e_vectors_reduced,e_values_reduced,e_vectors_reduced_v]=svds(caricature,5);
e_warpings=e_vectors_reduced;
display_landmarks(e_warpings,mean_landmark_vector);

%Display 27 TEST Warpings
reconstructed_test_landmarks=reconstruct_test_landmarks(e_warpings,test_set_landmarks,mean_landmark_vector);% Mean added back for Display
display_landmarks(reconstructed_test_landmarks,mean_landmark_vector);

%Plot Reconstruction ERROR Curve
plot_landmark_reconstruction_error(training_set_landmarks,test_set_landmarks,mean_landmark_vector);

%% problem(3)

%DISPLAY MEAN LANDMARKS
caricature=mean_reduced_training_landmarks*mean_reduced_training_landmarks';
[e_vectors_reduced,e_values_reduced,e_vectors_reduced_v]=svds(caricature,10);
e_warpings=e_vectors_reduced;
display_landmarks(e_warpings,mean_landmark_vector);

%DISPLAY 27 RECONSTRUCTED TEST Warpings(LANDMARKS)
reconstructed_test_landmarks=reconstruct_test_landmarks(e_warpings,test_set_landmarks,mean_landmark_vector);% Mean added back for Display
display_landmarks(reconstructed_test_landmarks,mean_landmark_vector);

%MEAN WARP TRAINING IMAGES one at a time
[r,c]=size(training_set_images);
mean_landmarks_matrix=reshape(mean_landmark_vector,[87,2]);
training_images_mean_warpped=[];
for i=1:c %Output: training_images_mean_warpped
    training_images_matrix=reshape(training_set_images(:,i),[256,256]);
    training_landmarks_matrix=reshape(training_set_landmarks(:,i),[87,2]);
    training_images_mean_warpped_matrix=warpImage_kent(training_images_matrix,training_landmarks_matrix,mean_landmarks_matrix);
    training_images_mean_warpped=[training_images_mean_warpped  reshape(training_images_mean_warpped_matrix,[256*256,1])];
end

%TOP 10 EIGEN FACES & DISPLAY Top 10 Eigen Faces %should I decrease5
mean_warpped_image_vector=get_mean_image_vector(training_images_mean_warpped);
mean_reduced_images_w=mean_reduced_matrix(training_images_mean_warpped,mean_warpped_image_vector);
[e_vectors_reduced_w,e_values_reduced_w]=reduced_pca(mean_reduced_images_w,10);      
e_faces_w=get_eigen_faces(mean_reduced_images_w,e_vectors_reduced_w);
for j=1:10
        e_faces_w(:,j) = e_faces_w(:,j)/norm(e_faces_w(:,j));
end
display_faces(e_faces_w,mean_warpped_image_vector);

%DISPLAY RECONSTRUCTION of top 27 Test Faces using Top 10 Eigen 
reconstructed_test_faces_w=reconstruct_test_faces(e_faces_w,test_set_images,mean_warpped_image_vector);
display_faces(reconstructed_test_faces_w,mean_warpped_image_vector);

% (iii) WARP Reconstructed TEST FACES from mean position to RECONSTRUCTED
% Landmarks Position, For all k_val compute Reconstruction ERROR

%DISPLAY "RE"-WARP RECONSTRUCTED TEST IMAGES to reconstructed test Landmarks 
reconstructed_test_images_rewarpped=[];
[r,c]=size(reconstructed_test_faces_w);
for i=1:c
    recon_test_image_matrix=reshape(reconstructed_test_faces_w(:,i),[256,256]);
    recon_test_landmark_matrix=reshape(reconstructed_test_landmarks(:,i),[87,2]);
    recon_test_image_landmark_warpped_matrix=warpImage_kent(recon_test_image_matrix,mean_landmarks_matrix,recon_test_landmark_matrix);
    reconstructed_test_images_rewarpped=[reconstructed_test_images_rewarpped reshape(recon_test_image_landmark_warpped_matrix,[256*256,1])];
end
reconstructed_test_images_rewarpped=double(reconstructed_test_images_rewarpped);

display_faces(reconstructed_test_images_rewarpped,mean_warpped_image_vector);

% PLOT RECONSTRUCTION ERROR CURVE for ALL K 

disp('Entering....');
for k_val=1:150
    % For Landmarks 
    disp('#3');
    disp(k_val);
    [e_vectors_reduced,e_values_reduced,e_vectors_reduced_v]=svds(caricature,k_val);
    e_warpings=e_vectors_reduced;
    
    reconstructed_test_landmarks=25(e_warpings,test_set_landmarks,mean_landmark_vector);% Mean added back for Display
    
    % For Faces
    [e_vectors_reduced_w,e_values_reduced_w]=reduced_pca(mean_reduced_images_w,k_val);       %k_val = 20
    e_faces_w=get_eigen_faces(mean_reduced_images_w,e_vectors_reduced_w);
    for j=1:k_val
        e_faces_w(:,j) = e_faces_w(:,j)/norm(e_faces_w(:,j));
    end
    reconstructed_test_faces_w=reconstruct_test_faces(e_faces_w,test_set_images,mean_warpped_image_vector);
   
    reconstructed_test_images_rewarpped=[];
    [r,c]=size(reconstructed_test_faces_w);
    for i=1:c
        recon_test_image_matrix=reshape(reconstructed_test_faces_w(:,i),[256,256]);
        recon_test_landmark_matrix=reshape(reconstructed_test_landmarks(:,i),[87,2]);
        recon_test_image_landmark_warpped_matrix=warpImage_kent(recon_test_image_matrix,mean_landmarks_matrix,recon_test_landmark_matrix);
        reconstructed_test_images_rewarpped=[reconstructed_test_images_rewarpped reshape(recon_test_image_landmark_warpped_matrix,[256*256,1])];
    end
    reconstructed_test_images_rewarpped=double(reconstructed_test_images_rewarpped);
    
    diff=double(test_set_images)-reconstructed_test_images_rewarpped;
    reconstruction_error_alligned(k_val)=sum(sum(diff.^2))/(256*256*27);
    
end


figure;
x=1:1:150;
plot(x,reconstruction_error_alligned(1:150));
xlabel('eigen-faces k'),ylabel('reconstruction error')
%--------------------------------------------------------------------------

%% problem(4)

caricature=mean_reduced_training_landmarks*mean_reduced_training_landmarks';
[e_vectors_reduced,e_values_reduced,e_vectors_reduced_v]=svds(caricature,10);
e_warpings=e_vectors_reduced;
reconstructed_test_landmarks=reconstruct_test_landmarks_random(e_warpings,test_set_landmarks,mean_landmark_vector,e_values_reduced(1,1));% Mean added back for Display
display_landmarks(reconstructed_test_landmarks,mean_landmark_vector);

%MEAN WARP TRAINING IMAGES one at a time
[r,c]=size(training_set_images);
mean_landmarks_matrix=reshape(mean_landmark_vector,[87,2]);
training_images_mean_warpped=[];
for i=1:c %Output: training_images_mean_warpped
    training_images_matrix=reshape(training_set_images(:,i),[256,256]);
    training_landmarks_matrix=reshape(training_set_landmarks(:,i),[87,2]);
    training_images_mean_warpped_matrix=warpImage_kent(training_images_matrix,training_landmarks_matrix,mean_landmarks_matrix);
    training_images_mean_warpped=[training_images_mean_warpped  reshape(training_images_mean_warpped_matrix,[256*256,1])];
end

%TOP 10 EIGEN FACES & DISPLAY Top 10 Eigen Faces %should I decrease
size(mean_reduced_images)
size(training_images_mean_warpped)
mean_warpped_image_vector=get_mean_image_vector(training_images_mean_warpped);
mean_reduced_images_w=mean_reduced_matrix(training_images_mean_warpped,mean_warpped_image_vector);
[e_vectors_reduced_w,e_values_reduced_w]=reduced_pca(mean_reduced_images_w,10);       %k_val = 20
e_faces_w=get_eigen_faces(mean_reduced_images_w,e_vectors_reduced_w);


for j=1:10
        e_faces_w(:,j) = 1.5*e_faces_w(:,j)/norm(e_faces_w(:,j));
end
display_faces(e_faces_w,mean_warpped_image_vector);

%DISPLAY RECONSTRUCTION of top 27 Test Faces using Top 10 Eigen
reconstructed_test_faces_w=reconstruct_test_faces_random(e_faces_w,test_set_images,mean_warpped_image_vector,e_values_reduced_w(1,1));
display_faces(reconstructed_test_faces_w,mean_warpped_image_vector);

%DISPLAY "RE"-WARP RECONSTRUCTED TEST IMAGES to reconstructed test Landmarks 
reconstructed_test_images_rewarpped=[];
[r,c]=size(reconstructed_test_faces_w);
for i=1:c
    recon_test_image_matrix=reshape(reconstructed_test_faces_w(:,i),[256,256]);
    recon_test_landmark_matrix=reshape(reconstructed_test_landmarks(:,i),[87,2]);
    recon_test_image_landmark_warpped_matrix=warpImage_kent(recon_test_image_matrix,mean_landmarks_matrix,recon_test_landmark_matrix);
    reconstructed_test_images_rewarpped=[reconstructed_test_images_rewarpped reshape(recon_test_image_landmark_warpped_matrix,[256*256,1])];
end
reconstructed_test_images_rewarpped=double(reconstructed_test_images_rewarpped);

display_faces(reconstructed_test_images_rewarpped,mean_warpped_image_vector);

%% Part (2) problem (5)

[female_set_images,male_set_images]=load_female_male_images();

%Calculate mean

female_set_mean = get_mean_image_vector(female_set_images);
male_set_mean = get_mean_image_vector(male_set_images);
total_image_set=[female_set_images male_set_images];

%Finding the SVD of the Total image matrix 

mult_matrix = double(total_image_set') * double(total_image_set);
[u,l,v] = svd(mult_matrix);
[r,c] = size(u);
ce = double(total_image_set) * u;

a=[];
%Diplay the Fisher Face 
eigen_vectors=[];
for i=1:c
  eigen_vectors(:,i) =  u(:,i) /norm( u(:,i));
  a(:,i) =  (ce(:,i)/norm(ce(:,i))) .*sqrt(l(i,i));
end

%Computing the PDF document Equations-- 
y = a' * (female_set_mean - male_set_mean);
z = inv(l*l*eigen_vectors') * y;
w = double(total_image_set)*z;
display_fisher_face(w);
w0 = (w' * male_set_mean + w' * female_set_mean)./2;

%----------------------------------------------------------------------------
%Reading All TEST images - To Check Ficher Classification Error 

[female_set_images_test,male_set_images_test]=load_female_male_test_images();

x_female=[];
x_male=[];
for i=1:10
  x_female =[x_female (w'*double(female_set_images_test(:,i))-w0)];
  x_male = [x_male (w' * double(male_set_images_test(:,i)) - w0)];
end
x_female
x_male
no_fem_pos=0;
no_fem_neg=0;
no_male_pos=0;
no_male_neg=0;

for i=1:10
    if x_female(i)>0
    no_fem_pos=no_fem_pos+1;
    else
    no_fem_neg=no_fem_neg+1;
    end
    
    if x_male(i)>0
    no_male_pos=no_male_pos+1;
    else
    no_male_neg=no_male_neg+1;
    end
end

figure;
pie([no_fem_pos,no_fem_neg]);
labels={'Correctly Classified at Female','Wrongly Classifies as Male'};
legend(labels,'Location','southoutside','Orientation','vertical');
title('Fisher Face -  Female Face Classification');


figure;
pie([no_male_pos,no_male_neg]);
labels={'Correctly Classified at Male','Wrongly Classifies as Female'};
legend(labels,'Location','southoutside','Orientation','vertical');
title('Fisher Face -  Male Face Classification');

%% Part-2 proble(6)

[female_set_landmarks,male_set_landmarks]=load_male_female_landmarks();
total_set_landmarks=[female_set_landmarks male_set_landmarks];
%Calculate mean
female_mean_landmarks = get_mean_image_vector(female_set_landmarks);
male_mean_landmarks = get_mean_image_vector(male_set_landmarks);
total_set_landmarks=[female_set_landmarks male_set_landmarks];
%SVD Calculation
rep_landmarks = double(total_set_landmarks') * double(total_set_landmarks);
[u2,l2,v2] = svd(rep_landmarks);
[r,c] = size(u2);
ce2 = double(total_set_landmarks) * u2;
for i=1:c
  eigen_landmarks(:,i) =  u2(:,i) /norm(u2(:,i));
  a2(:,i) =  (ce2(:,i)/norm(ce2(:,i))) .*sqrt(l2(i,i));
end
%Equations calculated as per PDF Explanation
y2 = a2' * (female_mean_landmarks - male_mean_landmarks);
z2 = inv(l2*l2*eigen_landmarks') * y2;
w2 = double(total_set_landmarks)*z2;


[female_set_images,male_set_images]=load_female_male_images();
total_set_images=[female_set_images male_set_images];
%Calculate mean
female_mean = get_mean_image_vector(female_set_images);
male_mean = get_mean_image_vector(male_set_images);
%SVD Calculation
rep_images = double(total_set_images') * double(total_set_images);
[u,l,v] = svd(rep_images);
[r,c] = size(u);
ce = double(total_set_images) * u;
for i=1:c
  eigen_vectors(:,i) =  u(:,i) /norm( u(:,i));
  a(:,i) =  (ce(:,i)/norm(ce(:,i))) .*sqrt(l(i,i));
end
%Equations calculated as per PDF Explanation
y = a' * (female_mean - male_mean);
z = inv(l*l*eigen_vectors') * y;
w = double(total_set_images)*z;


% Reading ALL TEST IMAGES and TEST LANDMARKS
[female_set_landmarks_test,male_set_landmarks_test]=load_male_female_landmarks_test();
[female_set_images_test,male_set_images_test]=load_female_male_test_images();

size(female_set_landmarks_test)
size(male_set_landmarks_test)
clear y2;
% Computations for the SCATTER PLOT
for i=1:10
  x1(i) = w'* double(female_set_images_test(:,i));
  y1(i) = w2' * double(female_set_landmarks_test(:,i));
  x2(i) = w'* double(male_set_images_test(:,i));
  y2(i) = w2' * double(male_set_landmarks_test(:,i));
end
size(x1)
size(y1)

size(x2)
size(y2)

figure;
scatter(x1,y1);
hold all;

scatter(x2,y2,'filled');
hold all;
x=[ 0 ; 0 ];
y=[ -0.1 ; 0.1];
plot(x,y);