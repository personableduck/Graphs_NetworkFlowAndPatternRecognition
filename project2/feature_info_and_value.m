function value = feature_info_and_value(I,feature_index)
flag = 0;
count=0;
for type = 1:5 %type of feature
    for scale_x = 1 : 16 %scale_x
        for scale_y = 1 : 16 %scale_y
            for x = 1 : 16 %x (column location)
                for y = 1 : 16 %y (row location)
                    if(possible_feature(type,x,y,scale_x,scale_y) == true)
                        count= count+1;
                        if count ==  feature_index
                            flag = 1;
                            value = value_of_feature(I, type, scale_x, scale_y, x, y);
                            break;
                        end
                    end
                end
                if flag == 1
                    break;
                end
            end
            if flag == 1
                break;
            end
            
        end
        if flag == 1
            break;
        end
    end
    if flag == 1
        break;
    end
end

end

function value = value_of_feature(I, type, scale_x, scale_y, x, y)

%first find the sums of each sub_rectangle
feature_types = [1 2; 2 1; 1 3; 3 1; 2 2];
end_x = x + feature_types(type,2) * scale_x - 1;
end_y = y + feature_types(type,1) * scale_y - 1;


%Define rectangular region as [startingRow, startingColumn, endingRow, endingColumn].
%J = integralImage(I);
%regionSum = J(eR+1,eC+1) - J(eR+1,sC) - J(sR,eC+1) + J(sR,sC)

if(type==1)
    sC = x;
    sR = y;
    eC = idivide(x+end_x,int32(2));
    eR = end_y;
    sum_left = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    sC = idivide(x+end_x,int32(2))+1;
    sR = y;
    eC = end_x;
    eR = end_y;
    sum_right = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    value = sum_right - sum_left;
end

if(type==2)
    sC = x;
    sR = y;
    eC = end_x;
    eR = idivide(y+end_y,int32(2));
    sum_top = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    sC = x;
    sR = idivide(y+end_y,int32(2))+1;
    eC = end_x;
    eR = end_y;
    sum_bottom = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    value = sum_bottom - sum_top;
end

if(type==3)
    sC = x;
    sR = y;
    eC = idivide(2*x+end_x,int32(3));
    eR = end_y;
    sum_left = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    sC = idivide(2*x+end_x,int32(3))+1;
    sR = y;
    eC = idivide(x+2*end_x,int32(3));
    eR = end_y;
    sum_middle = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    sC = idivide(x+2*end_x,int32(3))+1;
    sR = y;
    eC = end_x;
    eR = end_y;
    sum_right = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    value = sum_middle - (sum_left + sum_right);
end

if(type==4)
    sC = x;
    sR = y;
    eC = end_x;
    eR = idivide(2*y+end_y,int32(3));
    sum_top = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    sC = x;
    sR = idivide(2*y+end_y,int32(3))+1;
    eC = end_x;
    eR = idivide(y+2*end_y,int32(3));
    sum_middle = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    sC = x;
    sR = idivide(y+2*end_y,int32(3))+1;
    eC = end_x;
    eR = end_y;
    sum_bottom = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    value = sum_middle - (sum_top + sum_bottom);
end

if(type==5)
    sC = x;
    sR = y;
    eC = idivide(x+end_x,int32(2));
    eR = idivide(y+end_y,int32(2));
    sum11 = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    sC = idivide(x+end_x,int32(2))+1;
    sR = y;
    eC = end_x;
    eR = idivide(y+end_y,int32(2));
    sum12 = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    sC = x;
    sR = idivide(y+end_y,int32(2))+1;
    eC = idivide(x+end_x,int32(2));
    eR = end_y;
    sum21 = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    sC = idivide(x+end_x,int32(2))+1;
    sR = idivide(y+end_y,int32(2))+1;
    eC = end_x;
    eR = end_y;
    sum22 = II(eR+1,eC+1) - II(eR+1,sC) - II(sR,eC+1) + II(sR,sC);
    value = (sum12 + sum21) - (sum11 + sum22);
end


end