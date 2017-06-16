function [e_faces] = get_eigen_faces(image_matrix,e_vectors) %returns the vectors of the top k eigen faces

[r,c]=size(e_vectors);
size(image_matrix);
e_faces=double(image_matrix)*double(e_vectors);

end
