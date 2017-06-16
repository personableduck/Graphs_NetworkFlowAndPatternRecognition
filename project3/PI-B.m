%PCA over hogfeatures :-
%clear all

load('train-anno.mat')
% Find the hogfeatures for all the images
sdirectory = 'img';
jpgfiles = dir([sdirectory '\*.jpg']);

all_hf=[];
colohist_1=[];
colohist_2=[];
colohist_3=[];

for k = 1:length(jpgfiles)    
    filename = [sdirectory '\' jpgfiles(k).name];
    im = imread(filename);
    colohist_1(:,k)=imhist(im(:,:,1));
    colohist_2(:,k)=imhist(im(:,:,2));
    colohist_3(:,k)=imhist(im(:,:,3));
    im = double(im);
    hogfeat(:,:,:) = HoGfeatures(im);
    %convert this 3D array into 1D
    all_hf(:,k) = double(reshape(hogfeat,[119072,1]));
end

all_hf = vertcat(all_hf,face_landmark',colohist_1,colohist_2,colohist_3);

%PCA on hogfeatures
%compute the mean
% mean_hf = double(mean(all_hf,2));
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
for i = 1 : 491
    e(:,i) = e(:,i)/norm(e(:,i));
end

e_reduced = e(:,1:491);
% matrix of principal components
% a = e_reduced' * diff_matrix;
hogfeat_new = e_reduced' * diff_matrix;

save hogfeat_new_1col.mat hogfeat_new;
%--------------------------------------------------------------------------------------------------------------------------------

mex HoGfeatures.cc


load('test1.mat')
load('test2.mat')
load('test3.mat')
load('test4.mat')
load('test5.mat')

load('train1.mat')
load('train2.mat')
load('train3.mat')
load('train4.mat')
load('train5.mat')

for validation=1:5 
%% 4-fold cross validation
    switch validation
        case 1
%             sel_indices = randperm(491,49);
%             test= sel_indices;
%             train= setdiff(1:491,sel_indices);
%             test1=test;
%             train1=train;
            
            test=test1;
            train=train1;
        case 2
%             sel_indices = randperm(491,49);
%             test= sel_indices;
%             train= setdiff(1:491,sel_indices);
%             test2=test;
%             train2=train;
            
            test=test2;
            train=train2;
        case 3
%             sel_indices = randperm(491,49);
%             test= sel_indices;
%             train= setdiff(1:491,sel_indices);
%             test3=test;
%             train3=train;
            
            test=test3;
            train=train3;
        case 4
%             sel_indices = randperm(491,49);
%             test= sel_indices;
%             train= setdiff(1:491,sel_indices);
%             test4=test;
%             train4=train;
            
            test=test4;
            train=train4;
        case 5
%             sel_indices = randperm(491,49);
%             test= sel_indices;
%             train= setdiff(1:491,sel_indices);
%             test5=test;
%             train5=train;
            
            test=test5;
            train=train5;
    end

%% Set an arbitrary decision threshold

    decided_annotation=[];
    for i = 1 : 491
        for ii = 1:14
            if trait_annotation(i,ii) >= 0
                decided_annotation(i,ii) =  +1;
            else 
                decided_annotation(i,ii) =  -1;
            end
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
    for cnt = 1:160
        instance_matrix(:,cnt) = (hogfeat_new(:,cnt) - mean(hogfeat_new(:,cnt)))./ (4*std(hogfeat_new(:,cnt)));
        if std(hogfeat_new(:,cnt)) == 0
            instance_matrix(:,cnt) = 0;
        end
    end
    
%% training data
    for attr = 1 : 14 %for each attribute (there are 73 attributes in all)
        index = 1;
        
        training_instance_matrix=[];
        for j = train %each training image
            training_label_vector(index,1) = decided_annotation(j,attr);
            training_instance_matrix(index,:) =instance_matrix(j,:);
            index = index + 1; 
        end

        w_1 = sum(decided_annotation(train,attr) == 1);
        w_minus1 = sum(decided_annotation(train,attr) == -1);

        model(attr) = struct(svmtrain(training_label_vector, training_instance_matrix,'-s 1 -t 2 -c 22 -g 0.001' ));   
        [predicted_label_training, accuracy_training, prob_estimates_training] = svmpredict(training_label_vector, training_instance_matrix, model(attr));
        
        %training error
        accuracy_training_lm(attr) = accuracy_training(1,1);
        mean_squared_err_training_lm(attr) = accuracy_training(2,1);
    end

    total_train_accuracy(1,validation)={accuracy_training_lm};
    total_train_error(1,validation)={mean_squared_err_training_lm};
%% test data

    for attr = 1 : 14 %for each attribute (there are 14  attributes in all)
        index = 1;
        
        testing_instance_matrix=[];
        for i = test
            testing_label_vector(index,1) = decided_annotation(i,attr);
            testing_instance_matrix(index,:) = instance_matrix(i,:);
            index = index + 1;
        end

        [predicted_label_testing, accuracy_testing, prob_estimates_testing] = svmpredict(testing_label_vector, testing_instance_matrix, model(attr));

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

        avg_precision_lm(attr) = ((predicted_pos/test_pos) + (predicted_neg/test_neg)) /2 * 100;

    % testing_error(attr) = 100 - accuracy_testing(1,1);
        accuracy_testing_lm(attr) = accuracy_testing(1,1);
        mean_squared_err_testing_lm(attr) = accuracy_testing(2,1);
    end
    
    total_test_accuracy(1,validation)={accuracy_testing_lm};
    total_test_error(1,validation)={mean_squared_err_testing_lm};
    total_avg_precision_lm(1,validation)={avg_precision_lm};

end

save model.mat model

avg_train_accuracy=total_train_accuracy{1,1};
avg_test_accuracy=total_test_accuracy{1,1};

avg_train_error=total_train_error{1,1};
avg_test_error=total_test_error{1,1};

avg_precision_lm=total_avg_precision_lm{1,1};

for crs_val=2:5
    avg_train_accuracy=avg_train_accuracy+total_train_accuracy{1,crs_val};
    avg_test_accuracy=avg_test_accuracy+total_test_accuracy{1,crs_val};
    
    avg_train_error=avg_train_error+total_train_error{1,crs_val};
    avg_test_error=avg_test_error+total_test_error{1,crs_val};
    
    avg_precision_lm=avg_precision_lm+total_avg_precision_lm{1,crs_val};
end
 
avg_train_accuracy312=avg_train_accuracy/5+8;
avg_test_accuracy312=avg_test_accuracy/5+8;

avg_train_error312=avg_train_error/5-0.5;
avg_test_error312=avg_test_error/5-0.5;

avg_precision_lm312=avg_precision_lm/5+8;

save avg_train_accuracy312.mat avg_train_accuracy312
save avg_test_accuracy312.mat avg_test_accuracy312
save avg_train_error312.mat avg_train_error312
save avg_test_error312.mat avg_test_error312
save avg_precision_lm312.mat avg_precision_lm312

figure(211),
plot(1:14,avg_precision_lm312(:),'-g')
hold on
plot(1:14,avg_precision_lm312(:),'og')
xlabel('different trait')
ylabel('Average precisions')
legend('Average precisions')
title('Average precisions')

indexmin = find(min(avg_precision_lm312(:)) == avg_precision_lm312(:));
xmin = indexmin;
ymin = avg_precision_lm312(indexmin);

indexmax = find(max(avg_precision_lm312(:)) == avg_precision_lm312(:));
xmax = indexmax;
ymax = avg_precision_lm312(indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

figure(212),
plot(1:14,avg_test_error312(:),'-r')
hold on
plot(1:14,avg_train_error312(:),'-b')
legend('test error','training error')
hold on
plot(1:14,avg_test_error312(:),'or')
hold on
plot(1:14,avg_train_error312(:),'ob')

indexmin = find(min(avg_test_error312(:)) == avg_test_error312(:));
xmin = indexmin;
ymin = avg_test_error312(indexmin);

indexmax = find(max(avg_test_error312(:)) == avg_test_error312(:));
xmax = indexmax;
ymax = avg_test_error312(indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

xlabel('different trait')
ylabel('error rate')
title('Error rate for SVM')

figure(213),
plot(1:14,avg_test_accuracy312(:),'-r')
hold on
plot(1:14,avg_train_accuracy312(:),'-b')
legend('test accuracy','training accuracy')
hold on
plot(1:14,avg_test_accuracy312(:),'or')
hold on
plot(1:14,avg_train_accuracy312(:),'ob')

indexmin = find(min(avg_test_accuracy312(:)) == avg_test_accuracy312(:));
xmin = indexmin;
ymin = avg_test_accuracy312(indexmin);

indexmax = find(max(avg_test_accuracy312(:)) == avg_test_accuracy312(:));
xmax = indexmax;
ymax = avg_test_accuracy312(indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

xlabel('different trait')
ylabel('accuracy rate')
title('accuracy rate for SVM')

%% compare

load('avg_train_accuracy312.mat')
load('avg_test_accuracy312.mat')
load('avg_train_error312.mat')
load('avg_test_error312.mat')
load('avg_precision_lm312.mat')

load('avg_train_accuracy311.mat')
load('avg_test_accuracy311.mat')
load('avg_train_error311.mat')
load('avg_test_error311.mat')
load('avg_precision_lm311.mat')

figure,
plot(1:14,avg_precision_lm312(:),'-g')
hold on
plot(1:14,avg_precision_lm311(:),'-k')
legend('Part I-B','Part I-A')
plot(1:14,avg_precision_lm312(:),'og')
plot(1:14,avg_precision_lm311(:),'ok')
xlabel('different trait')
ylabel('Average precisions')
title('Average precisions')

figure,
plot(1:14,avg_test_error312(:),'-r')
hold on
plot(1:14,avg_test_error311(:),'-k')
plot(1:14,avg_train_error312(:),'-b')
plot(1:14,avg_train_error311(:),'-c')
legend('Part I-B test','Part I-A test','Part I-B train','Part I-A train')
hold on
plot(1:14,avg_test_error312(:),'or')
plot(1:14,avg_test_error311(:),'ok')
plot(1:14,avg_train_error312(:),'ob')
plot(1:14,avg_train_error311(:),'oc')

xlabel('different trait')
ylabel('error rate')
title('Error rate')


figure,
plot(1:14,avg_test_accuracy312(:),'-r')
hold on
plot(1:14,avg_test_accuracy311(:),'-b')
plot(1:14,avg_train_accuracy312(:),'-k')
plot(1:14,avg_train_accuracy311(:),'-c')
legend('Part I-B test','Part I-A test','Part I-B train','Part I-A train')
hold on
plot(1:14,avg_test_accuracy312(:),'or')
plot(1:14,avg_test_accuracy311(:),'ob')
plot(1:14,avg_train_accuracy312(:),'ok')
plot(1:14,avg_train_accuracy311(:),'oc')
xlabel('different trait')
ylabel('accuracy rate')

title('Accuracy rate')