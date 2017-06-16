function validity = is_valid_feature (t,x,y,sx,sy)
%returns if a particular feature is valid in the 1x16 image or not

types=[1 2; 2 1; 1 3; 3 1; 2 2 ];

x_sz=types(t,2)*sx;
y_sz=types(t,1)*sy;
    if(x+x_sz-1<=16 && y+y_sz-1<=16)
       validity=1;
    else
        validity=0;
    end
end

