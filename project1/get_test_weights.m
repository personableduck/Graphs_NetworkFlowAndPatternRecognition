function [test_image_weight] = get_test_weights(e_faces,test_set_image_shifted)
%Find weights of the given test face.
%Output: Weights of test face wrt to the Eigen Faces as a Column Vector

[r,c]=size(e_faces);
test_image_weight=double(e_faces)'*double(test_set_image_shifted);

end
