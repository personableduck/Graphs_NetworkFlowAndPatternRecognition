
%%%%%%%%%%%%%% 2_1
%Plotting the weak Classifier histograms for random 5 - 
% Type 1 --- val_f(1,:)
% Type 2 --- val_f(10000,:)
% Type 3 --- val_f(20000,:)
% Type 4 --- val_f(28000,:)
% Type 5 --- val_f(32000,:)

new_array=val_f(1,:);
close all;
[y,x]=hist(new_array);
plot(x,y);
hold on;
new_array=val_nf(11100,:);
[y,x]=hist(new_array);
plot(x,y,'r--');
legend('face','nonface');
title('A randomly selected Type 2 Features Histogram');
hold on;


