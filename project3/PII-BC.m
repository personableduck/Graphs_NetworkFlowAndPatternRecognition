clear
load('hogfeat_new3')
load('train-anno.mat')

decided_annotation=[];
for i = 1 : 228
    for ii = 1:14
        if trait_annotation(i,ii) >= 0
            decided_annotation(i,ii) =  +1;
        else 
            decided_annotation(i,ii) =  -1;
        end
    end
end

mex HoGfeatures.cc
load('model_hog')
load('vote_diff3')
%% Set an arbitrary decision threshold

% decided_annotation=[];
% for i = 1 : 228
%     if vote_diff3(i,1) >= 0
%         decided_annotation(i,1) =  +1;
%     else 
%         decided_annotation(i,1) =  -1;
%     end
% end

load('hogfeat_new3')
load('all_hf')
load('prob_real_training')

instance_matrix=[];
for cnt = 1:228
    instance_matrix(:,cnt) = (hogfeat_new3(:,cnt) - mean(hogfeat_new3(:,cnt)))./ (4*std(hogfeat_new3(:,cnt)));
    if std(hogfeat_new3(:,cnt)) == 0
        instance_matrix(:,cnt) = 0;
    end
end   


%% training data
for attr=1:14

    training_label_vector = decided_annotation(:,attr);
    training_instance_matrix =instance_matrix;%hogfeat_new3;

    %model = struct(svmtrain(training_label_vector, training_instance_matrix,'-s 1 -t 2 -c 22' ));   
    [predicted_label_training, accuracy_training, prob_estimates_training] = svmpredict(training_label_vector, training_instance_matrix, model(attr));              
    prob_estimates_training_wn(:,attr)=prob_estimates_training;

end

save prob_estimates_training_wn.mat prob_estimates_training_wn;
%% subtraction part

pick_loop=length(vote_diff3)/2;

for order_ft=1:pick_loop
    array_num=2*order_ft-1;    
    k=randperm(2,1); 
    if(k==1)
        new_estimation(order_ft,:)=prob_estimates_training_wn(array_num+1,:)-prob_estimates_training_wn(array_num,:);
        new_vote_diff(order_ft,1)=vote_diff3(array_num+1)-vote_diff3(array_num);
    else
        new_estimation(order_ft,:)=prob_estimates_training_wn(array_num,:)-prob_estimates_training_wn(array_num+1,:);
        new_vote_diff(order_ft,1)=vote_diff3(array_num)-vote_diff3(array_num+1);
    end
end

save new_vote_diff.mat new_vote_diff; 
save new_estimation.mat new_estimation; 

%% win or lose

instance_matrix=[];
for cnt = 1:14
    instance_matrix(:,cnt) = (new_estimation(:,cnt) - mean(new_estimation(:,cnt)))./ (4*std(new_estimation(:,cnt)));
    if std(new_estimation(:,cnt)) == 0
        instance_matrix(:,cnt) = 0;
    end
end   

decided_annotation=[];

new_annot=length(new_vote_diff);

for i = 1 : new_annot
    if new_vote_diff(i,1) >= 0
        decided_annotation(i,1) =  +1;
    else 
        decided_annotation(i,1) =  -1;
    end
end

%% training data

training_label_vector= decided_annotation;
training_instance_matrix= instance_matrix;

model2 = struct(svmtrain(training_label_vector, training_instance_matrix,'-s 1 -t 2 -c 22 -g 0.1' ));
[predicted_label_training, accuracy_training, prob_estimates_training] = svmpredict(training_label_vector, training_instance_matrix, model2);

new_ft=prob_estimates_training;

instance_matrix=[];

for cnt = 1:1
    instance_matrix(:,cnt) = (new_ft(:,cnt) - mean(new_ft(:,cnt)))./ (4*std(new_ft(:,cnt)));
    if std(new_ft(:,cnt)) == 0
        instance_matrix(:,cnt) = 0;
    end
end   


for validation=1:10 
%% 4-fold cross validation
    switch validation
        case 1
            sel_indices = randperm(114,20);
            test= sel_indices;
            train= setdiff(1:114,sel_indices);
            test111=test;
            train111=train;                                  
%             test=test111;
%             train=train111;
        case 2
            sel_indices = randperm(114,20);
            test= sel_indices;
            train= setdiff(1:114,sel_indices);
            test222=test;
            train222=train;

%             test=test222;
%             train=train222;
        case 3
            sel_indices = randperm(114,20);
            test= sel_indices;
            train= setdiff(1:114,sel_indices);
            test333=test;
            train333=train;
            
            
%             test=test333;
%             train=train333;
        case 4
            sel_indices = randperm(114,20);
            test= sel_indices;
            train= setdiff(1:114,sel_indices);
            test444=test;
            train444=train;
            
%             test=test444;
%             train=train444;
        case 5
            sel_indices = randperm(114,20);
            test= sel_indices;
            train= setdiff(1:114,sel_indices);
            test555=test;
            train555=train;
        case 6
            sel_indices = randperm(114,20);
            test= sel_indices;
            train= setdiff(1:114,sel_indices);
            test666=test;
            train666=train;                                  
%             test=test111;
%             train=train111;
        case 7
            sel_indices = randperm(114,20);
            test= sel_indices;
            train= setdiff(1:114,sel_indices);
            test777=test;
            train777=train;

%             test=test222;
%             train=train222;
        case 8
            sel_indices = randperm(114,20);
            test= sel_indices;
            train= setdiff(1:114,sel_indices);
            test888=test;
            train888=train;
            
            
%             test=test333;
%             train=train333;
        case 9
            sel_indices = randperm(114,20);
            test= sel_indices;
            train= setdiff(1:114,sel_indices);
            test999=test;
            train999=train;
            
%             test=test444;
%             train=train444;
        case 10
            sel_indices = randperm(114,20);
            test= sel_indices;
            train= setdiff(1:114,sel_indices);
            test1000=test;
            train1000=train;
            
           
%             test=test555;
%             train=train555;
    end
    
    index = 1;
    training_label_vector=[];
    training_instance_matrix=[];
    
    for j = train %each training image
        training_label_vector(index,1) = decided_annotation(j,1);
        training_instance_matrix(index,:) = instance_matrix(j,:);
        index = index + 1; 
    end

    model = struct(svmtrain(training_label_vector, training_instance_matrix,'-s 1 -t 2 -c 100 -g 0.1' ));
    [predicted_label_training, accuracy_training, prob_estimates_training] = svmpredict(training_label_vector, training_instance_matrix, model);

    accuracy_training_lm3 = accuracy_training(1,1);
    mean_squared_err_training_lm3 = accuracy_training(2,1);
    
    total_train_accuracy3(1,validation)=accuracy_training_lm3;
    total_train_error3(1,validation)=mean_squared_err_training_lm3;

    
%% test data

    index = 1;
    testing_label_vector=[];
    testing_instance_matrix=[];
    for i = test
        testing_label_vector(index,1) = decided_annotation(i,1);
        testing_instance_matrix(index,:) = new_ft(i,:);
        index = index + 1;
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

    total_test_accuracy3(1,validation)=accuracy_testing_lm3;
    total_test_error3(1,validation)=mean_squared_err_testing_lm3;
    total_avg_precision_lm3(1,validation)=avg_precision_lm3;
      
end

corr(training_label_vector,prob_estimates_training)
corr(testing_label_vector,prob_estimates_testing)

average_test_precision=sum(total_avg_precision_lm3(1,:))/validation
average_test_accuracy=sum(total_test_accuracy3(1,:))/validation
averagre_tarin_accuracy=sum(total_train_accuracy3(1,:))/validation

averagre_tarin_error=sum(total_train_error3(1,:))/validation
averagre_test_error=sum(total_test_error3(1,:))/validation

% save total_avg_precision_lm3.mat total_avg_precision_lm3
% save total_test_accuracy3.mat total_test_accuracy3
% save total_train_accuracy3.mat total_train_accuracy3
% save total_train_error3.mat total_train_error3
% save total_test_error3.mat total_test_error3

figure,
plot(1:validation,total_avg_precision_lm3(1,:),'-g')
hold on
plot(1:validation,total_avg_precision_lm3(1,:),'og')

xlabel('k-fold cross-validation')
ylabel('precisions')
title('Each fold precisions')

indexmin = find(min(total_avg_precision_lm3(1,:)) == total_avg_precision_lm3(1,:));
xmin = indexmin;
ymin = total_avg_precision_lm3(1,indexmin);

indexmax = find(max(total_avg_precision_lm3(1,:)) == total_avg_precision_lm3(1,:));
xmax = indexmax;
ymax = total_avg_precision_lm3(1,indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

figure,
plot(1:validation,total_test_error3(1,:),'-r')
hold on
plot(1:validation,total_train_error3(1,:),'-b')
legend('test error','training error')
hold on
plot(1:validation,total_test_error3(1,:),'or')
hold on
plot(1:validation,total_train_error3(1,:),'ob')

indexmin = find(min(total_test_error3(1,:)) == total_test_error3(1,:));
xmin = indexmin;
ymin = total_test_error3(1,indexmin);

indexmax = find(max(total_test_error3(1,:)) == total_test_error3(1,:));
xmax = indexmax;
ymax = total_test_error3(1,indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

xlabel('k-fold cross-validation')
ylabel('error rate')
title('Each fold Error rate')


figure,
plot(1:validation,total_test_accuracy3(1,:),'-r')
hold on
plot(1:validation,total_train_accuracy3(1,:),'-b')
legend('test accuracy','training accuracy')
hold on
plot(1:validation,total_test_accuracy3(1,:),'or')
hold on
plot(1:validation,total_train_accuracy3(1,:),'ob')

indexmin = find(min(total_test_accuracy3(1,:)) == total_test_accuracy3(1,:));
xmin = indexmin;
ymin = total_test_accuracy3(1,indexmin);

indexmax = find(max(total_test_accuracy3(1,:)) == total_test_accuracy3(1,:));
xmax = indexmax;
ymax = total_test_accuracy3(1,indexmax);

strmin = ['Minimum = ',num2str(ymin)];
text(xmin,ymin,strmin,'HorizontalAlignment','right');

strmax = ['Maximum = ',num2str(ymax)];
text(xmax,ymax,strmax,'HorizontalAlignment','right');

xlabel('k-fold cross-validation')
ylabel('accuracy rate')
title('Each fold Accuracy rate')

load('train-anno.mat')

correaltion=[];
for index=1:14
    correaltion(index,1)=abs(corr(trait_annotation(1:94,index),prob_estimates_training));
end

figure,plot(1:14,correaltion(:,1),'-k')

xlabel('Each 14 features')
ylabel('Correlation coefficients')
title('Correlation coefficients 14 feature with election outcome')
%svmtrain(new_vote_diff,prob_real_training,

% %% compare
% load('total_avg_precision_lm1')
% load('total_test_accuracy1')
% load('total_train_accuracy1')
% load('total_train_error1')
% load('total_test_error1')
% 
% load('total_avg_precision_lm3')
% load('total_test_accuracy3')
% load('total_train_accuracy3')
% load('total_train_error3')
% load('total_test_error3')
% 
% figure,
% plot(1:10,total_avg_precision_lm3(:),'-g')
% hold on
% plot(1:10,total_avg_precision_lm1(:),'-k')
% legend('PartII-B','PartII-A')
% plot(1:10,total_avg_precision_lm3(:),'og')
% plot(1:10,total_avg_precision_lm1(:),'ok')
% xlabel('k-fold cross-validation')
% ylabel('Average precisions')
% title('Average precisions')
% 
% figure,
% plot(1:10,total_test_error3(:),'-r')
% hold on
% plot(1:10,total_test_error1(:),'-k')
% plot(1:10,total_train_error3(:),'-b')
% plot(1:10,total_train_error1(:),'-c')
% legend('PartII-B test','PartII-A test','PartII-B train','PartII-A train')
% hold on
% plot(1:10,total_test_error3(:),'or')
% plot(1:10,total_test_error1(:),'ok')
% plot(1:10,total_train_error3(:),'ob')
% plot(1:10,total_train_error1(:),'oc')
% 
% xlabel('k-fold cross-validation')
% ylabel('error rate')
% title('Error rate')
% 
% 
% figure,
% plot(1:10,total_test_accuracy3(:),'-r')
% hold on
% plot(1:10,total_test_accuracy1(:),'-b')
% plot(1:10,total_train_accuracy3(:),'-k')
% plot(1:10,total_train_accuracy1(:),'-c')
% legend('Part I-B test','Part I-A test','Part I-B train','Part I-A train')
% hold on
% plot(1:10,total_test_accuracy3(:),'or')
% plot(1:10,total_test_accuracy1(:),'ob')
% plot(1:10,total_train_accuracy3(:),'ok')
% plot(1:10,total_train_accuracy1(:),'oc')
% xlabel('k-fold cross-validation')
% ylabel('accuracy rate')
% 
% title('Accuracy rate')

