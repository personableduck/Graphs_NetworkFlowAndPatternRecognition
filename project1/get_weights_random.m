function [test_image_weight] = get_weights_random(e_faces,test_set_image_shifted,top_e_value,check)
%Find weights of the given test face.
%Output: Weights of test face wrt to the Eigen Faces as a Column Vector

[r,c]=size(e_faces);
%t=top_e_value;
if check==1
t=25;
end
if check==2
t=4;
end

s=sqrt(top_e_value);
r= -t + (t+t)*rand(c,1);
%test_image_weight=double(e_faces)'*double(test_set_image_shifted);
test_image_weight=r;

if check==2
test_image_weight
end