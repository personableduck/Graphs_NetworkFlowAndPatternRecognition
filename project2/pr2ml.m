
count=0;
intensity_diff_face=[];
intensity_diff_nonface=[];
types=[1 2; 2 1; 1 3; 3 1; 2 2 ];
%%%%%Set image LIMIT here
img_lim=200;
for img_t=1:2
    count=0;
for img=1:img_lim
    image_matrix=get_image(img,img_t);
    integral_matrix=getIntegralImage(image_matrix);
    count=0;
    for t=1:1
        for x=1:16
             for y=1:16
                for sx=1:16
                    for sy=1:16
                        if(is_valid_feature(t,x,y,sx,sy)==1)
                            
                            %if sx==2 && sy==1 && x==2 && y==1
                            %if count==1
                                %[t,x,y,sx,sy]
                                %count
                                switch img_t
                                    case 1
                                        count=count+1;
                                        intensity_diff_nonface(count,img)=get_intensity_diff(integral_matrix,t,x,y,sx,sy);
                                    case 2
                                        count=count+1;
                                        intensity_diff_face(count,img)=get_intensity_diff(integral_matrix,t,x,y,sx,sy);
                                end
                            %end
                        end
                    end
                end
            end
        end
    end
   end
end
%intensity_diff(1:20)
%intensity_diff
%max(intensity_diff)
face=size(intensity_diff_face);
size(intensity_diff_nonface);
count;
disp('Intensity Differences of Faces and Non-Faces calculated.');

%%%Plotting the histogram
%hist(intensity_diff(2,:));
sz=size(intensity_diff_face(:,1));
%max =max(size(intensity_diff_face(:,1)))
%%% Threshold Calculation -- 
for i =  1:max(sz)%max(size(intensity_diff_face(:,1))) %32384
    intensity_diff_face_row = double((intensity_diff_face(i,:))); %11838
    
    intensity_diff_nonface_row = double((intensity_diff_nonface(i,:))); %45356
    
    
    mean_face = double(mean(intensity_diff_face_row));
    mean_nonface = double(mean(intensity_diff_nonface_row));
    variance_face = var(intensity_diff_face_row);
    variance_nonface = var(intensity_diff_nonface_row);
    a = ((variance_face * mean_nonface) - (variance_nonface * mean_face)) / (variance_face - variance_nonface)
    b = ((variance_face * (mean_nonface^2)) - (variance_nonface * (mean_face^2)) - (variance_face * variance_nonface * log(variance_face/variance_nonface)))/(variance_face - variance_nonface);
    threshold(i,1) = double((a - real(sqrt(a^2 - b))));%left threshold
    threshold(i,2) = double((a + real(sqrt(a^2 - b))));%right threshld
    
    [counts_f,centers_f]=hist(intensity_diff_face_row);% considering =< & >= of the histograms
    [counts_n,centers_n]=hist(intensity_diff_nonface_row);
    f_lims=find_count_btw(counts_f,centers_f,threshold(i,1),threshold(i,2));% return as row
    n_lims=find_count_btw(counts_n,centers_n,threshold(i,1),threshold(i,2));% return as row

    
    f_between=sum(histc(intensity_diff_face_row,f_lims));      % give range as row
    n_between=sum(histc(intensity_diff_nonface_row,n_lims));    % give range as row
    
    if(f_between>n_between)
        threshold(i,3)=1;
    else
        threshold(i,3)=0;
    end
    
    
end

total_faces_btw_ths=sum(threshold(:,3))
disp('Thresholds & their Polarity Calculated');
%Run Adaboost Code
%global variables to wrok with 

[tot_features,temp]=size(threshold);
img_lim_face=img_lim;                   % check the for loop ; you've used common img_lim 
img_lim_nonface=img_lim;
%initialize weights here
weights_face=1:img_lim;
weights_nonface=1:img_lim;
weights_face(:)=1/(2*img_lim_face);
weights_nonface(:)=1/(2*img_lim_nonface);
error=[];
min_error_index=[];
beta=[];
T_lim=100;
for t=1:T_lim %fix in T_lim
    %normalize the weights 
    sum_weights=sum(weights_face)+sum(weights_nonface);
    weights_face=weights_face./sum_weights;
    weights_nonface=weights_nonface./sum_weights;
    for j=1:max(size(threshold))
        error(t,j)=0;
        th=threshold(j,3);
        for i=1:img_lim_face
            
            if intensity_diff_face(j,i)>=threshold(j,1) && intensity_diff_face(j,i)<=threshold(j,2)
                decision=threshold(j,3);
                %disp('here');
            else
                decision=~threshold(j,3);
                %disp('here_neg');
            end
            decision;
            wt=weights_face(i);
            d=weights_face(i)*abs(decision-1);
            error(t,j)=error(t,j)+weights_face(i)*abs(decision-1);
            %if isnan(error(j))
                %wt;
                %d;
                %disp('$$$$$$$$$$$$');
                %break
            %end
        end
        %before=error(j)
        
        const=i-1;
        for i=1:img_lim_nonface
            if intensity_diff_nonface(j,i)>=threshold(j,1) && intensity_diff_nonface(j,i)<=threshold(j,2)
                decision=threshold(j,3);
            else
                decision=~threshold(j,3);
            end
            decision;
            error(t,j)=error(t,j)+weights_nonface(i)*abs(decision-0);
        end
        %after=error(j) 
    end
    
    
    t
    %t
    %find(error==min(error))
    find_array=find(error(t,:)==min(error(t,:)));
    min_error_index(t)=find_array(1);%get the feature with minimum error
    min_index=min_error_index(t);
    %update_weights
    e_t=error(t,min_error_index(t));
    error_t(t)=e_t;
    beta(t)=e_t/(1-e_t);
    
    for i=1:img_lim_face
        if intensity_diff_face(min_index,i)>=threshold(min_index,1) && intensity_diff_face(min_index,i)<=threshold(min_index,2)
                decision=threshold(min_index,3);
                
        else
                decision=~threshold(min_index,3);
        end
        if decision==1
            e_i=0;
        else
            e_i=1;
        end
        weights_face(i)=weights_face(i)*(beta(t).^(1-e_i));
    end
    for i=1:img_lim_nonface
        if intensity_diff_nonface(min_index,i)>=threshold(min_index,1) && intensity_diff_nonface(min_index,i)<=threshold(min_index,2)
                decision=threshold(min_index,3);
        else
                decision=~threshold(min_index,3);
        end
        if decision==0
            e_i=0;
        else
            e_i=1;
        end
        weights_nonface(i)=weights_nonface(i)*(beta(t).^(1-e_i));
    end
    weights_face;
end

disp('done');
 h=min_error_index;
beta;


%Super classifier classifications: 
%just for faces

for i=1:img_lim_face
    left(i)=0;
    right=0;
    for t=1:max(size(h))
        alpha_t=log(1/beta(t));
 
            if intensity_diff_face(h(t),i)>=threshold(h(t),1) && intensity_diff_face(h(t),i)<=threshold(h(t),2)
                decision=threshold(h(t),3);
                %threshold(h(t),3)
                %disp('here');
            else
                decision=~threshold(h(t),3); 
            end
            
        left(i)=left(i)+alpha_t*decision;
        right=right+alpha_t;
    end
    
    right=right/2;
    [left,right]
    if(left(i)>=right)
        super_classification(i)=1;
    else
        super_classification(i)=0;
    end
end
const=i-1;

for i=1:img_lim_nonface
    left=0;
    right=0;
    for t=1:max(size(h))
        alpha_t=log(1/beta(t));
 
            if intensity_diff_nonface(h(t),i)>=threshold(h(t),1) && intensity_diff_nonface(h(t),i)<=threshold(h(t),2)
                decision=threshold(h(t),3);
            else
                decision=~threshold(h(t),3); 
            end
            
        left=left+alpha_t*decision;
        right=right+alpha_t;
    end
    
    right=right/2;
    if(left>=right)
        super_classification(const+i)=1;
    else
        super_classification(const+i)=0;
    end
end
super_classification;
disp('done super classification');

%After superclassification
h_main=h;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Working on Real Boost

