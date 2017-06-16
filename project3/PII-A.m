clear
% For governor
sdirectory = 'img-elec\governor';
jpgfiles = dir([sdirectory '\*.jpg']);
load('stat-gov.mat')

all_hf1=[];
colohist_1=[];
colohist_2=[];
colohist_3=[];
hogfeat=[];

for k = 1:length(jpgfiles)    
    filename = [sdirectory '\' jpgfiles(k).name];
    im = imread(filename);
    %im = imresize(im,0.2);
    colohist_1(:,k)=imhist(im(:,:,1));
    colohist_2(:,k)=imhist(im(:,:,2));
    colohist_3(:,k)=imhist(im(:,:,3));
    im = double(im);
    hogfeat(:,:,:) = HoGfeatures(im);
    %convert this 3D array into 1D
    all_hf1(:,k) = double(reshape(hogfeat,[119072,1])); %3872 for resize 0.2
end

all_hf1= vertcat(all_hf1,face_landmark');
colohist1=[colohist_1; colohist_2; colohist_3];
vote_diff1=vote_diff;
face_landmark1=face_landmark;

% For senator
sdirectory = 'img-elec\senator';
jpgfiles = dir([sdirectory '\*.jpg']);
load('stat-sen.mat')

all_hf2=[];
colohist_1=[];
colohist_2=[];
colohist_3=[];
hogfeat=[];

for k = 1:length(jpgfiles)    
    filename = [sdirectory '\' jpgfiles(k).name];
    im = imread(filename);
    %im = imresize(im,0.2);
    colohist_1(:,k)=imhist(im(:,:,1));
    colohist_2(:,k)=imhist(im(:,:,2));
    colohist_3(:,k)=imhist(im(:,:,3));
    im = double(im);
    hogfeat(:,:,:) = HoGfeatures(im);
    %convert this 3D array into 1D
    all_hf2(:,k) = double(reshape(hogfeat,[119072,1])); %3872 for resize 0.2
end

all_hf2 = vertcat(all_hf2,face_landmark');
colohist2=[colohist_1; colohist_2; colohist_3];
vote_diff2=vote_diff;
face_landmark2=face_landmark;

%-------------------combine
all_hf= [all_hf1,all_hf2];
colohist=horzcat(colohist1, colohist2);
all_hf3 = [all_hf; colohist];
all_hf=all_hf3;

%all_hf3= all_hf3';
%all_hf=all_hf';

vote_diff3=[vote_diff1; vote_diff2;];
face_landmark3=[face_landmark1; face_landmark2];

%PCA on hogfeatures
%compute the mean
% mean_hf = double(mean(all_hf,2));

mean_hf=[];
[r,c] = size(all_hf);
for i=1:r
    mean_hf(i,1) = sum(all_hf(i,:)/c);
end

diff_matrix=[];
%diff_matrix for the warpings
[r,c] = size(all_hf);
for i = 1 : c
    diff_matrix(:,i) = double(all_hf(:,i)) - mean_hf(:,1);
end
%scatter_matrix
scatter_matrix = diff_matrix' * diff_matrix;
%eigen_vectors
[U,L,V] = svd(scatter_matrix); %%svd
e = diff_matrix * U;
%normalize the eigen_vectors

for i = 1 : 228
    e(:,i) = e(:,i)/norm(e(:,i));
end

e_reduced = e(:,1:228);
% matrix of principal components
% a = e_reduced' * diff_matrix;
hogfeat_new3 = e_reduced' * diff_matrix;

save vote_diff3.mat vote_diff3;
save hogfeat_new3.mat hogfeat_new3;
save all_hf.mat all_hf;

mex HoGfeatures.cc

for validation=1:10
%% 4-fold cross validation
    switch validation
        case 1
            sel_indices = randperm(228,23);
            test= sel_indices;
            train= setdiff(1:228,sel_indices);
            test11=test;
            train11=train;
                        
            save test11.mat test11;
            save train11.mat train11;
            
%             test=test11;
%             train=train11;
        case 2
            sel_indices = randperm(228,23);
            test= sel_indices;
            train= setdiff(1:228,sel_indices);
            test22=test;
            train22=train;
                        
            save test22.mat test22;
            save train22.mat train22;
            
%             test=test22;
%             train=train22;
        case 3
            sel_indices = randperm(228,23);
            test= sel_indices;
            train= setdiff(1:228,sel_indices);
            test33=test;
            train33=train;
            
            save test33.mat test33;
            save train33.mat train33;
            
%             test=test33;
%             train=train33;
        case 4
            sel_indices = randperm(228,23);
            test= sel_indices;
            train= setdiff(1:228,sel_indices);
            test44=test;
            train44=train;
            
            save test44.mat test44;
            save train44.mat train44;
            
%             test=test44;
%             train=train44;
        case 5
            sel_indices = randperm(228,23);
            test= sel_indices;
            train= setdiff(1:228,sel_indices);
            test55=test;
            train55=train;
            
            save test55.mat test55;
            save train55.mat train55;
            
%             test=test55;
%             train=train55;
        case 6
            sel_indices = randperm(228,23);
            test= sel_indices;
            train= setdiff(1:228,sel_indices);
            test66=test;
            train66=train;

            save test66.mat test66;
            save train66.mat train66;

%             test=test66;
%             train=train66;
        case 7
            sel_indices = randperm(228,23);
            test= sel_indices;
            train= setdiff(1:228,sel_indices);
            test77=test;
            train77=train;

            save test77.mat test77;
            save train77.mat train77;

%             test=test77;
%             train=train77;
        case 8
            sel_indices = randperm(228,23);
            test= sel_indices;
            train= setdiff(1:228,sel_indices);
            test88=test;
            train88=train;

            save test88.mat test88;
            save train88.mat train88;

    %             test=test88;
    %             train=train88;
        case 9
            sel_indices = randperm(228,23);
            test= sel_indices;
            train= setdiff(1:228,sel_indices);
            test99=test;
            train99=train;

            save test99.mat test99;
            save train99.mat train99;

    %             test=test99;
    %             train=train99;
        case 10
            sel_indices = randperm(228,23);
            test= sel_indices;
            train= setdiff(1:228,sel_indices);
            test100=test;
            train100=train;

            save test100.mat test100;
            save train100.mat train100;

%             test=test100;
%             train=train100;
    end
    
%% Set an arbitrary decision threshold

    decided_annotation=[];
    for i = 1 : 228
        if vote_diff3(i,1) >= 0
            decided_annotation(i,1) =  +1;
        else 
            decided_annotation(i,1) =  -1;
        end
    end
    
%     instance_matrix=[];
%     for cnt = 1:160
%         instance_matrix(:,cnt) = (face_landmark(:,cnt) - mean(face_landmark(:,cnt)))./ (4*std(face_landmark(:,cnt)));
%         if std(face_landmark(:,cnt)) == 0
%             instance_matrix(:,cnt) = 0;
%         end
%     end
    
    instance_matrix=[];
    for cnt = 1:228
        instance_matrix(:,cnt) = (hogfeat_new3(:,cnt) - mean(hogfeat_new3(:,cnt)))./ (4*std(hogfeat_new3(:,cnt)));
        if std(hogfeat_new3(:,cnt)) == 0
            instance_matrix(:,cnt) = 0;
        end
    end
    
%% training data
    index=1;
    training_instance_matrix=[];
    for j = train %each training image
        training_label_vector(index,1) = decided_annotation(j,1);
        training_instance_matrix(index,:) =instance_matrix(j,:);
        index=index+1;
    end

    w_1 = sum(decided_annotation(train,1) == 1);
    w_minus1 = sum(decided_annotation(train,1) == -1);

    model = struct(svmtrain(training_label_vector, training_instance_matrix,'-s 1 -t 2 -c 100' ));   
    [predicted_label_training, accuracy_training, prob_estimates_training] = svmpredict(training_label_vector, training_instance_matrix, model);

    %training error
    accuracy_training_lm3 = accuracy_training(1,1);
    mean_squared_err_training_lm3 = accuracy_training(2,1);
    
    total_train_accuracy1(1,validation)=accuracy_training_lm3;
    total_train_error1(1,validation)=mean_squared_err_training_lm3;
%% test data
    index=1;
        
    testing_instance_matrix=[];
    for i = test
        testing_label_vector(index,1) = decided_annotation(i,1);
        testing_instance_matrix(index,:) = instance_matrix(i,:);
        index=index+1;
    end

    [predicted_label_testing, accuracy_testing, prob_estimates_testing] = svmpredict(testing_label_vector, testing_instance_matrix, model);

    test_pos = 0;
    test_neg = 0;

    t = size(testing_label_vector(:,1));

    for i = 1 : t(1)
        if testing_label_vector(i,1) == 1
            test_pos = test_pos + 1;
        end
        if testing_label_vector(i,1) == -1
            test_neg = test_neg + 1;
        end

    end

    predicted_pos = 0;
    predicted_neg = 0;

    for i = 1 : t(1)
        if testing_label_vector(i,1) == predicted_label_testing(i,1) 
            if predicted_label_testing(i,1) == 1
                predicted_pos = predicted_pos + 1;
            else
                predicted_neg = predicted_neg + 1;
            end
        end
    end

    avg_precision_lm3 = ((predicted_pos/test_pos) + (predicted_neg/test_neg)) /2 * 100;

% testing_error(attr) = 100 - accuracy_testing(1,1);
    accuracy_testing_lm3 = accuracy_testing(1,1);
    mean_squared_err_testing_lm3 = accuracy_testing(2,1);
    
    total_test_accuracy1(1,validation)=accuracy_testing_lm3;
    total_test_error1(1,validation)=mean_squared_err_testing_lm3;
    total_avg_precision_lm1(1,validation)=avg_precision_lm3;

end

average_test_precision=sum(total_avg_precision_lm1(1,:))/validation
average_test_accuracy=sum(total_test_accuracy1(1,:))/validation
averagre_tarin_accuracy=sum(total_train_accuracy1(1,:))/validation

averagre_tarin_error=sum(total_train_error1(1,:))/validation
averagre_test_error=sum(total_test_error1(1,:))/validation

save total_avg_precision_lm1.mat total_avg_precision_lm1
save total_test_accuracy1.mat total_test_accuracy1
save total_train_accuracy1.mat total_train_accuracy1
save total_train_error1.mat total_train_error1
save total_test_error1.mat total_test_error1


figure,
plot(1:validation,total_avg_precision_lm1(1,:),'-g')
hold on
plot(1:validation,total_avg_precision_lm1(1,:),'og')

xlabel('k-fold cross-validation')
ylabel('precisions')
title('Each fold precisions')

indexmin = find(min(total_avg_precision_lm1(1,:)) == total_avg_precision_lm1(1,:));
xmin = indexmin;
ymin = total_avg_precision_lm1(1,indexmin);

indexmax = find(max(total_avg_precision_lm1(1,:)) == total_avg_precision_lm1(1,:));
xmax = indexmax;
ymax = total_avg_precision_lm1(1,indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

figure,
plot(1:validation,total_test_error1(1,:),'-r')
hold on
plot(1:validation,total_train_error1(1,:),'-b')
legend('test error','training error')
hold on
plot(1:validation,total_test_error1(1,:),'or')
hold on
plot(1:validation,total_train_error1(1,:),'ob')

indexmin = find(min(total_test_error1(1,:)) == total_test_error1(1,:));
xmin = indexmin;
ymin = total_test_error1(1,indexmin);

indexmax = find(max(total_test_error1(1,:)) == total_test_error1(1,:));
xmax = indexmax;
ymax = total_test_error1(1,indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

xlabel('k-fold cross-validation')
ylabel('error rate')
title('Each fold Error rate')


figure,
plot(1:validation,total_test_accuracy1(1,:),'-r')
hold on
plot(1:validation,total_train_accuracy1(1,:),'-b')
legend('test accuracy','training accuracy')
hold on
plot(1:validation,total_test_accuracy1(1,:),'or')
hold on
plot(1:validation,total_train_accuracy1(1,:),'ob')

indexmin = find(min(total_test_accuracy1(1,:)) == total_test_accuracy1(1,:));
xmin = indexmin;
ymin = total_test_accuracy1(1,indexmin);

indexmax = find(max(total_test_accuracy1(1,:)) == total_test_accuracy1(1,:));
xmax = indexmax;
ymax = total_test_accuracy1(1,indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

xlabel('k-fold cross-validation')
ylabel('accuracy rate')
title('Each fold Accuracy rate')



