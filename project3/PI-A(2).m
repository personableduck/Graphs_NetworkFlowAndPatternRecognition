close all;
clear all;

addpath('./libsvm_matlab/');
mex HoGfeatures.cc

addpath('img');
addpath('libsvm_matlab');
addpath('img-elec');

load('train-anno.mat')

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
% %% 4-fold cross validation
%     switch validation
%         case 1
%             sel_indices = randperm(491,49);
%             test= sel_indices;
%             train= setdiff(1:491,sel_indices);
%             test1=test;
%             train1=train;
%             
%             save test1.mat test1;
%             save train1.mat train1;
%         case 2
%             sel_indices = randperm(491,49);
%             test= sel_indices;
%             train= setdiff(1:491,sel_indices);
%             test2=test;
%             train2=train;
%             
%             save test2.mat test2;
%             save train2.mat train2;
%         case 3
%             sel_indices = randperm(491,49);
%             test= sel_indices;
%             train= setdiff(1:491,sel_indices);
%             test3=test;
%             train3=train;
%             
%             save test3.mat test3;
%             save train3.mat train3;
%         case 4
%             sel_indices = randperm(491,49);
%             test= sel_indices;
%             train= setdiff(1:491,sel_indices);
%             test4=test;
%             train4=train;
%             
%             save test4.mat test4;
%             save train4.mat train4;
%         case 5
%             sel_indices = randperm(491,49);
%             test= sel_indices;
%             train= setdiff(1:491,sel_indices);
%             test5=test;
%             train5=train;
%             
%             save test5.mat test5;
%             save train5.mat train5;
%     end

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
    
    instance_matrix=[];
    for cnt = 1:160
        instance_matrix(:,cnt) = (face_landmark(:,cnt) - mean(face_landmark(:,cnt)))./ (4*std(face_landmark(:,cnt)));
        if std(face_landmark(:,cnt)) == 0
            instance_matrix(:,cnt) = 0;
        end
    end
    
%% training data
    for attr = 1 : 14 %for each attribute (there are 73 attributes in all)
        index = 1;
        for j = train %each training image
            training_label_vector(index,1) = decided_annotation(j,attr);
            training_instance_matrix(index,:) = instance_matrix(j,:);
            index = index + 1; 
        end

        w_1 = sum(decided_annotation(train,attr) == 1);
        w_minus1 = sum(decided_annotation(train,attr) == -1);

        model(attr) = struct(svmtrain(training_label_vector, training_instance_matrix,strcat('-s 1 -t 2 -c 22 -g 0.002') ));   
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
 
avg_train_accuracy=avg_train_accuracy/5;
avg_test_accuracy=avg_test_accuracy/5;

avg_train_error=avg_train_error/5;
avg_test_error=avg_test_error/5;

avg_precision_lm=avg_precision_lm/5;


figure,
plot(1:14,avg_precision_lm(:),'-g')
hold on
plot(1:14,avg_precision_lm(:),'og')
xlabel('different trait')
ylabel('Average precisions')
legend('Average precisions')
title('Average precisions')

indexmin = find(min(avg_precision_lm(:)) == avg_precision_lm(:));
xmin = indexmin;
ymin = avg_precision_lm(indexmin);

indexmax = find(max(avg_precision_lm(:)) == avg_precision_lm(:));
xmax = indexmax;
ymax = avg_precision_lm(indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

figure,
plot(1:14,avg_test_error(:),'-r')
hold on
plot(1:14,avg_train_error(:),'-b')
legend('test error','training error')
hold on
plot(1:14,avg_test_error(:),'or')
hold on
plot(1:14,avg_train_error(:),'ob')

indexmin = find(min(avg_test_error(:)) == avg_test_error(:));
xmin = indexmin;
ymin = avg_test_error(indexmin);

indexmax = find(max(avg_test_error(:)) == avg_test_error(:));
xmax = indexmax;
ymax = avg_test_error(indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

xlabel('different trait')
ylabel('error rate')
title('Error rate for SVM')

figure,
plot(1:14,avg_test_accuracy(:),'-r')
hold on
plot(1:14,avg_train_accuracy(:),'-b')
legend('test error','training error')
hold on
plot(1:14,avg_test_accuracy(:),'or')
hold on
plot(1:14,avg_train_accuracy(:),'ob')

indexmin = find(min(avg_test_accuracy(:)) == avg_test_accuracy(:));
xmin = indexmin;
ymin = avg_test_accuracy(indexmin);

indexmax = find(max(avg_test_accuracy(:)) == avg_test_accuracy(:));
xmax = indexmax;
ymax = avg_test_accuracy(indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

xlabel('different trait')
ylabel('accuracy rate')
title('accuracy rate for SVM')