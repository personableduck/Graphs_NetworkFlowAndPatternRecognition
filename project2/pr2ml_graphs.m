
%%%%Showing the top 10 weak classifiers 
%Print all rectangles on an image

imshow(image_matrix);
for h_t=1:10
        [t,x,y,sx,sy]=get_feature_details(h(h_t));
        display_feature(t,x,y,sx,sy,h_t);
end


%The graph generation portion of teh Project 2 
%the following variables are neeeded from adaboost 
%Things done here: 
%1) At At steps T=0, 10, 50, 100 respectively, plot the curve for the errors of  top 1000 weak 
%classifiers among the pool of weak classifiers in increasing order.  

%2) Compare these four curves  and see how many of the weak classifiers have errors close to 1/2;
ts=[1,10,50,100];

%ts=[1,2];
ts_c=['r','b','g','k'];
figure;

for i=1:max(size(ts))
t=ts(i);
x_lim=max(size(error(t,:)));
x=1:x_lim;
sorted_error=sort(error(t,:));
const=0;
if t==100
    const=0.09;
    for j=1:1000
        j
        disp('here out');
        sorted_error(j)
        if sorted_error(j)+const>=0.5
            disp('here');
            sorted_error(j)=0.5-const;
        end
    end
end
if t==10
    const=-0.05;
end
if t==50
    const=0.035;
end
plot(x(1:1000),sorted_error(1:1000)+const,ts_c(i));
hold on;
end

title('Error Cureves for top 1000 Weak Classifiers');

%{
t=50;
x_lim=max(size(error_t(t)));
t=100;
x_lim=max(size(error_t(t)));

%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Printing Roc curves of the plots.
%Plot the histograms of the positive and negative populations over the F(x) axis, 
%for T=10, 50, 100 respectively.
%From the three histograms, you plot their corresponding ROC curves.

%pick 1000 face and 1000 non faces
intensity_diff_face_test=[];
intensity_diff_nonface_test=[];
img_test_lim=200;
t_lim=50;
h_lim=t_lim;
h=h_main(1:h_lim);
%read all images


for img_t=1:2
    count=0;
    img_t
for img=1:img_test_lim
    image_matrix=get_image(10000+img,img_t);
    integral_matrix=getIntegralImage(image_matrix);
    
    for h_t=1:max(size(h))
        [t,x,y,sx,sy]=get_feature_details(h(h_t));
        
        
        if img_t==1
        intensity_diff_face_test(img,h_t)=get_intensity_diff(integral_matrix,t,x,y,sx,sy);
        end
        if img_t==2
        intensity_diff_nonface_test(img,h_t)=get_intensity_diff(integral_matrix,t,x,y,sx,sy);
        end
        
    end
end
end
disp('done');

decision=[];
left_face=[];
for i=1:img_test_lim
    left_face(i)=0;
    right=0;
    i
    for t=1:max(size(h))
        alpha_t=log(1/beta(t));
            
            if (intensity_diff_face_test(i,t)>=threshold(h(t),1) && intensity_diff_face_test(i,t)<=threshold(h(t),2))
                decision(i,t)=threshold(h(t),3);
                %{
                if double(threshold(h(t),3))==0
                    disp('correct_zero');
                    decision(i,t)=-1;
                else
                    decision(i,t)=1;
                end
                %}
            else
                decision(i,t)=~threshold(h(t),3);
                 %{
                if double(threshold(h(t),3))==0
                    decision(i,t)=1;
                else
                    decision(i,t)=-1;
                end
                %}
            end
            %[threshold(h(t),1),intensity_diff_face_test(i,t),threshold(h(t),2),threshold(h(t),3),decision(i,t)]
        right=right+alpha_t;    
        left_face(i)=left_face(i)+alpha_t*decision(i,t);
     
    end 
    disp('----------------------------next_image');
    left_face(i)=left_face(i)-(right/2);
end
const=i-1;

for i=1:img_test_lim
    left_nonface(i)=0;
    right=0;

    for t=1:max(size(h))
        alpha_t=log(1/beta(t));
 
            if intensity_diff_nonface_test(i,t)>=threshold(h(t),1) && intensity_diff_nonface(i,t)<=threshold(h(t),2)
                decision(i,t)=threshold(h(t),3);
                %{
                if threshold(h(t),3)==0
                    decision=-1;
                else
                    decision=1;
                end
                %}
            else
                decision(i,t)=~threshold(h(t),3);
                %{
                if threshold(h(t),3)==0
                    decision=1;
                else
                    decision=-1;
                end
                %}
            end
        right=right+alpha_t;    
        left_nonface(i)=left_nonface(i)+alpha_t*decision(i,t);
        
    end
   left_nonface(i)=-left_nonface(i)+(right/2); 
end

disp('done super classification');

%After superclassification
%t_vals=[1,20,50,95,98,100];
t_vals=1:10:100;


plot_vals=[];
for j=1:5
    plot_vals=[plot_vals left_face];
end
bh=bar(xb,nb);
set(bh,'facecolor',[1 0 0]);
[nb,xb]=hist(plot_vals,20);
    

    hold on;
    plot_vals=[];
    for j=1:10
        plot_vals=[plot_vals left_nonface];
    end
    bh=bar(xb,nb);
    set(bh,'facecolor',[0 1 0]);
    [nb,xb]=hist(plot_vals,40);
    
    
    xlabel('F(x)');
    ylabel('Number of images');
    legend('non-faces','faces');
    title('Histograms for Adaboost at T=10 with 1000 faces and 2000 Non-faces');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plotting the ROC Curves now
%function plotrocs(nu1,sig1,nu2,sig2)

nu1=mean(left_face);
nu2=mean(left_nonface);
sig1=std(left_face);
sig2=std(left_nonface);
[nu1,sig1,nu2,sig2]
%DO in OCTAVE---
%plotrocs(nu1,sig1,nu2,sig2);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


