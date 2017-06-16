function integralMatrix = getIntegralImage(A)
%Returns the integral matrix of the image paddd with zeroes to the laft and
%top

unpadded_matrix=cumsum(cumsum(double(A),2),1);

left_padded=[unpadded_matrix(:,1).*0 unpadded_matrix];
top_padded=[left_padded(1,:).*0; left_padded];
integralMatrix=top_padded;
end

