[r,c]=size(land_mark);
size(land_mark);
landmark_coordinates=[];
if(c==1)
    size(mean_landmark)
    mean_landmark=reshape(mean_landmark,[87,2]);
    [mr,mc]=size(mean_landmark);
    mean_landmark=uint8(ones(mr,mc).*255)-uint8(mean_landmark);
    figure;
    scatter(mean_landmark(:,1),mean_landmark(:,2),30,'filled');
end

landmark_coordinates=[];                            %landmark_vector     =   e_warpping
mean_landmarks_disp=reshape(mean_landmark,[87,2]);
if(c==5)
    for i=1:c
        landmark_coordinates=[landmark_coordinates reshape(land_mark(:,i)+mean_landmark,[87,2])];
    end
    
    figure;
    landmark_coordinates;
    %normalize landmark coordinates
    for i=1:2*c
        min_val=min(double(landmark_coordinates(:,i)));
        max_val=max(double(landmark_coordinates(:,i)));
        if(min_val<=0)
            landmark_coordinates(:,i)=round(((double(landmark_coordinates(:,i))+(-1*min_val))/(max_val+(-1)*min_val))*255);
        end
    end
    
    %plotting the Mean Scatter + Landmark Scatter
    [lr,lc]=size(landmark_coordinates);
    landmark_coordinates=uint8(ones(lr,lc).*255)-(uint8(landmark_coordinates));
    for i=1:c
       
        subplot(2,3,i);
        landmark_coordinates(:,(2*i)-1);
        landmark_coordinates(:,2*i);
        scatter(landmark_coordinates(:,(2*i)-1),landmark_coordinates(:,2*i),6,'filled','MarkerEdgeColor',[1 0 0]);
        ylim([0,300]);
        %scatter(mean_landmarks_disp(:,1),mean_landmarks_disp(:,2),6,'filled','MarkerEdgeColor',[0 0 1]);
    end
end

landmark_coordinates=[];
mean_landmarks_disp=reshape(mean_landmark,[87,2]);
if(c==27)
    for i=1:c
        landmark_coordinates=[landmark_coordinates reshape(land_mark(:,i),[87,2])];
    end
    
    fig_handle=figure;
    set(fig_handle,'Position',[100 100 1000 800]);
    landmark_coordinates;
    %normalize landmark coordinates
    for i=1:2*c
        min_val=min(double(landmark_coordinates(:,i)));
        max_val=max(double(landmark_coordinates(:,i)));
        if(min_val<=0)
            landmark_coordinates(:,i)=round(((double(landmark_coordinates(:,i))+(-1*min_val))/(max_val+(-1)*min_val))*255);
        end
    end
    
    %plotting the Mean Scatter + Landmark Scatter
    [lr,lc]=size(landmark_coordinates);
    landmark_coordinates=uint8(ones(lr,lc).*255)-(uint8(landmark_coordinates));
    for i=1:c
       
        subplot(5,6,i);
        landmark_coordinates(:,(2*i)-1);
        landmark_coordinates(:,2*i);
        r=rand;
        figure,scatter(landmark_coordinates(:,(2*i)-1),landmark_coordinates(:,2*i),6,'filled','MarkerEdgeColor',[1-r*r r 1-r]);
        %scatter(mean_landmarks_disp(:,1),mean_landmarks_disp(:,2),6,'filled','MarkerEdgeColor',[0 0 1]);
    end
end