%% problem 1

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

for num_eigenfaces=1:149
    
    eigen_x = evectors(:, 1:num_eigenfaces);
    for test_num=1:size_test(1,2)
    shifted=test_images(:,test_num)-mean_test;
    a=eigen_x'*shifted;
    b=eigen_x*a;
    recon(:,test_num)= b + mean_test;
    end
    
    diff=test_images - recon;
    size_diff=size(diff);
    errorsL2(num_eigenfaces,1)=num_eigenfaces;
    errorsL2(num_eigenfaces,2)=norm(diff(:)); %/sqrt(size_diff(1,1)*size_diff(1,2)*150);
end

figure,plot(errorsL2(:,1),errorsL2(:,2))
xlabel('eigen-warppings k'),ylabel('reconstruction error')

%% problem2 warping

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
mean_image_vector=sum(double(training_set_landmarks),2);
mean_image_vector=double(double(mean_image_vector)./c);
mean_origin=mean_image_vector;

mean_landmarks=reshape(mean_image_vector,[87,2]);

mean_image=double(mean(images,2));

[mr,mc]=size(mean_landmarks);
mean_landmarks=uint8(ones(mr,mc)*255)-uint8(mean_landmarks);
mean_landmarks=uint8(ones(mr,mc).*255)-uint8(mean_landmarks);
figure,imshow(reshape(mean_image,image_dims),[])
hold on
scatter(mean_landmarks(:,1),mean_landmarks(:,2),30,'filled');

%---------------------------------------------

[land_evectors, land_score, land_evalues] = pca(training_set_landmarks');

num_eigenland = 5;
eigen_5 = land_evectors(:, 1:num_eigenland);

eigen_11= eigen_5(:, 1) + mean_origin;
eigen_landmarks_11=reshape(eigen_11,[87,2]);

[mr,mc]=size(eigen_landmarks_11);
eigen_landmarks_11=uint8(ones(mr,mc)*255)-uint8(eigen_landmarks_11);
eigen_landmarks_11=uint8(ones(mr,mc).*255)-uint8(eigen_landmarks_11);
figure,imshow(reshape(mean_image,image_dims),[])
hold on
scatter(mean_landmarks(:,1),mean_landmarks(:,2),30,'filled');
scatter(eigen_landmarks_11(:,1),eigen_landmarks_11(:,2),30,'filled');

[r,c]=size(landmark_vector);
size(landmark_vector);
landmark_coordinates=[];
if(c==1)
    size(mean_landmarks)
    mean_landmarks=reshape(mean_landmarks,[87,2]);
    [mr,mc]=size(mean_landmarks);
    mean_landmarks=uint8(ones(mr,mc).*255)-uint8(mean_landmarks);
    figure;
    scatter(mean_landmarks(:,1),mean_landmarks(:,2),30,'filled');
end

landmark_coordinates=[];                            %landmark_vector     =   e_warpping
mean_landmarks_disp=reshape(mean_landmarks,[87,2]);
if(c==5)
    for i=1:c
        landmark_coordinates=[landmark_coordinates reshape(landmark_vector(:,i)+mean_landmarks,[87,2])];
    end
    
    figure;
    landmark_coordinates;
    %normalize landmark coordinates
    for i=1:2*c
        min_val=min(double(landmark_coordinates(:,i)));
        max_val=max(double(landmark_coordinates(:,i)));
        if(min_val<=0)
            landmark_coordinates(:,i)=round(((double(landmark_coordinates(:,i))+(-1*min_val))/(max_val+(-1)*min_val))*255);
        end
    end
    
    %plotting the Mean Scatter + Landmark Scatter
    [lr,lc]=size(landmark_coordinates);
    landmark_coordinates=uint8(ones(lr,lc).*255)-(uint8(landmark_coordinates));
    for i=1:c
       
        subplot(2,3,i);
        landmark_coordinates(:,(2*i)-1);
        landmark_coordinates(:,2*i);
        scatter(landmark_coordinates(:,(2*i)-1),landmark_coordinates(:,2*i),6,'filled','MarkerEdgeColor',[1 0 0]);
        ylim([0,300]);
        %scatter(mean_landmarks_disp(:,1),mean_landmarks_disp(:,2),6,'filled','MarkerEdgeColor',[0 0 1]);
    end
end

landmark_coordinates=[];
mean_landmarks_disp=reshape(mean_landmarks,[87,2]);
if(c==27)
    for i=1:c
        landmark_coordinates=[landmark_coordinates reshape(landmark_vector(:,i),[87,2])];
    end
    
    fig_handle=figure;
    set(fig_handle,'Position',[100 100 1000 800]);
    landmark_coordinates;
    %normalize landmark coordinates
    for i=1:2*c
        min_val=min(double(landmark_coordinates(:,i)));
        max_val=max(double(landmark_coordinates(:,i)));
        if(min_val<=0)
            landmark_coordinates(:,i)=round(((double(landmark_coordinates(:,i))+(-1*min_val))/(max_val+(-1)*min_val))*255);
        end
    end
    
    %plotting the Mean Scatter + Landmark Scatter
    [lr,lc]=size(landmark_coordinates);
    landmark_coordinates=uint8(ones(lr,lc).*255)-(uint8(landmark_coordinates));
    for i=1:c
       
        subplot(5,6,i);
        landmark_coordinates(:,(2*i)-1);
        landmark_coordinates(:,2*i);
        r=rand;
        scatter(mean_landmarks(:,1),mean_landmarks(:,2),30,'filled');
        hold on
        scatter(landmark_coordinates(:,(2*i)-1),landmark_coordinates(:,2*i),6,'filled','MarkerEdgeColor',[1-r*r r 1-r]);
        %scatter(mean_landmarks_disp(:,1),mean_landmarks_disp(:,2),6,'filled','MarkerEdgeColor',[0 0 1]);     
    end
end


%----------------------------------------------
mean_reduced_training_landmarks=mean_reduced_matrix(training_set_landmarks,mean_landmark_vector);
caricature=mean_reduced_training_landmarks*mean_reduced_training_landmarks';

[e_vectors,e_values,e_vectors_v]=pca(training_set_landmarks');
e_warpings=e_vectors(:, 1:5);
try_1=e_warpings(:,1)+mean_image_vector;

% [r,c]=size(try_1);
% mean_e_warpings=sum(double(try_1),2);
% mean_e_warpings=double(double(mean_e_warpings)./c);

e_landmarks=reshape(try_1,[87,2]);

[mr,mc]=size(e_landmarks);
e_landmarks=uint8(ones(mr,mc)*255)-uint8(e_landmarks);
e_landmarks=uint8(ones(mr,mc).*255)-uint8(e_landmarks);
scatter(e_landmarks(:,1),e_landmarks(:,2),30,'filled');

hold on 
quiver(mean_landmarks(:,1),mean_landmarks(:,2),e_landmarks(:,1),e_landmarks(:,2))

training_set_landmarks1=reshape(training_set_landmarks(:,1),[87,2]);
mean_landmarks=reshape(mean_image_vector,[87,2]);

[warpedImage] = warpImage_kent(Image, originalMarks, desiredMarks)

input_img=images(:,1);
warpedImage=warpImage_kent(input_img,training_set_landmarks1,mean_landmarks);

[mr,mc]=size(training_set_landmarks1);
training_set_landmarks1=uint8(ones(mr,mc)*255)-uint8(training_set_landmarks1);
training_set_landmarks1=uint8(ones(mr,mc).*255)-uint8(training_set_landmarks1);
% figure,imshow(reshape(mean_image,image_dims),[])
% hold on
hold on
quiver(mean_landmarks(:,1),mean_landmarks(:,2),training_set_landmarks1(:,1),training_set_landmarks1(:,2))
scatter(training_set_landmarks1(:,1),training_set_landmarks1(:,2),30,'filled');


%display 5 eigen wartping
mean_reduced_training_landmarks=mean_reduced_matrix(training_set_landmarks,mean_landmark_vector);
caricature=mean_reduced_training_landmarks*mean_reduced_training_landmarks';
[e_vectors_reduced,e_values_reduced,e_vectors_reduced_v]=svds(caricature,5);
e_warpings=e_vectors_reduced;

display_landmarks(e_warpings,mean_landmark_vector);

%___________try

landmark_coordinates=[];                            %landmark_vector     =   e_warpping
mean_landmarks_disp=reshape(mean_landmark_vector,[87,2]);

for i=1:5
    landmark_coordinates=[landmark_coordinates reshape(e_warpings(:,i)+mean_landmark_vector,[87,2])];
end

figure;

for i=1:2*5
    min_val=min(double(landmark_coordinates(:,i)));
    max_val=max(double(landmark_coordinates(:,i)));
    if(min_val<=0)
        landmark_coordinates(:,i)=round(((double(landmark_coordinates(:,i))+(-1*min_val))/(max_val+(-1)*min_val))*255);
    end
end

%plotting the Mean Scatter + Landmark Scatter
[lr,lc]=size(landmark_coordinates);
landmark_coordinates=uint8(ones(lr,lc).*255)-(uint8(landmark_coordinates));
for i=1:5

    subplot(2,3,i);
    landmark_coordinates(:,(2*i)-1);
    landmark_coordinates(:,2*i);
    
    scatter(mean_landmarks(:,1),mean_landmarks(:,2),6,'filled');
    hold on
    scatter(landmark_coordinates(:,(2*i)-1),landmark_coordinates(:,2*i),6,'filled','MarkerEdgeColor',[1 0 0]);
    ylim([0,300]);
    %scatter(mean_landmarks_disp(:,1),mean_landmarks_disp(:,2),6,'filled','MarkerEdgeColor',[0 0 1]);
end