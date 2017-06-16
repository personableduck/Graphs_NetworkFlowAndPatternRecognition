training_set=[];
test_set=[];

selectFiles;
training_number_set=150;
test_number_set=27;

for i=1:training_number_set    
    training_set{1,i}=double(imread([read_dir,file_1{1,i}]));
end

for j=1:test_number_set
    input_num=training_number_set+j;
    test_set{1,j}=imread([read_dir,file_1{1,input_num}]);
end

sum_tr=training_set{1,1};
for index=2:150
    sum_tr=sum_tr+training_set{1,index};
end
mean_tr=sum_tr/150;

ex=test_set{1,j}-mean_tr+mean(mean_tr(:));

avg_img=stack_avg(file_1,read_dir);

eigenface=training_set{1,1}-avg_img;

% Compute the reconstruction error. 
errREC = max(max(abs(X-XR)))

[values,vectors] = eig(training_set{1,1});

training_set{1,1}(1,:);

%trial_1
%[V,D] = eig(A)

for out_input=1:150
    
    A= training_set{1,out_input}(1,:);
    for index=2:256
        B= training_set{1,1}(index,:);
        A = horzcat(A,B);
    end
    
    if(out_input==1)
        comb_eigen=A;
    else
        eigenfaces=A;
        comb_eigen=[comb_eigen; eigenfaces;];
    end
    
end

trans_comb=comb_eigen.';