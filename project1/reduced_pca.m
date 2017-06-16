function [e_vectors,e_values] = reduced_pca(image_matrix,k_val) %returns the top k EigenValues and k EigenVectors of the A'A matrix

[r,c]=size(image_matrix);
pca_matrix=double(image_matrix)'*double(image_matrix);  %determines the matrix for which PCA is to be applied

[e_vectors,e_values,e_veclist]=svds(pca_matrix,k_val);                    %Singular Value Decomposition of the pca_matrix is found


end