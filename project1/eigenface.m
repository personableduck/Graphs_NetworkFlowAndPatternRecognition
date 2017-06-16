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
mean_face = mean(images, 2);
shifted_images = images - repmat(mean_face, 1, num_images);

%trick need
%[evectors, score, evalues] = princomp(images);
[evectors, score, evalues] = pca(images');
%C=images*evectors;
%evectors=C;

%The eigenfaces PCA computes are the eigenvectors of transpose(T) * T.  
%This matrix is too large to work with directly, but there is a trick: compute the eigenvectors of T * transpose(T).  
%If v is an eigenvector of T * transpose(T), 
%then transpose(T) * v is an eigenvector of transpose(T) * T. trick_ev=(images')*evectors;

% steps 3 and 4: calculate the ordered eigenvectors and eigenvalues
%[evectors, score, evalues] = princomp(images');
 
% step 5: only retain the top 'num_eigenfaces' eigenvectors (i.e. the principal components)
num_eigenfaces = 20;
evectors = evectors(:, 1:num_eigenfaces);
 
% display the eigenvectors
%figure;
for n = 1:num_eigenfaces
    %subplot(2, ceil(num_eigenfaces/2), n);
    evector = reshape(evectors(:,n), image_dims);
    figure,imshow(evector,[]);
end