function display_faces(image_vectors,mean_image_vector) 
%diaplays the "image_vector"s are subplot images for screenshot
[r,c]=size(image_vectors);
image_vectors;
if(c==1)
    figure;
    imshow(uint8(reshape(image_vectors,[256,256])));
    disp('hey');
end

if(c==20) % Printing the Eigen Faces -- Don't Print Always. Eigen Faces are NOT NORMALIZED outside. 
    eface_fig=figure;
    set(eface_fig,'Position',[100,100,600,480]);
    for i=1:20
        subplottight(4,5,i);
        min_val=min(double(image_vectors(:,i)));
        max_val=max(double(image_vectors(:,i)));
        if(min_val<=0)
            image_vectors(:,i)=round(((double(image_vectors(:,i))-min_val)/(max_val-min_val))*255);
        end
        imshow(uint8(reshape(image_vectors(:,i),[256,256])),[],'border','tight');
    end
end

if(c==27) % Printing the Recostructed Test Faces % Can print anytime, Normalized outside as 'double' values
    c=20;
       test_recon=figure;
       set(test_recon,'Position',[100,100,400,480]);
    for i=1:c
        subplottight(6,5,i);
        min_val=min(double(image_vectors(:,i)));
        max_val=max(double(image_vectors(:,i)));
        if(min_val<=0)
            image_vectors(:,i)=round(((double(image_vectors(:,i))+(-1*min_val))/(max_val+(-1)*min_val))*255);
        end
        imshow(uint8(reshape(image_vectors(:,i),[256,256])),'border','tight');
    end
end

end