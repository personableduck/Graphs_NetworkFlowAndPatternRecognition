function display_feature(type, scale_x, scale_y, x, y, i)

%Read the input image.
I =  rgb2gray(imread('newface16/face16_000010.bmp'));


feature_types = [1 2; 2 1; 1 3; 3 1; 2 2];
end_x = x + feature_types(type,2) * scale_x - 1;
end_y = y + feature_types(type,1) * scale_y - 1;

subplot(2,5,i);


switch type
    
    case 1
        
        
        sC = x;
        sR = y;
        eC = idivide(x+end_x,int32(2));
        eR = end_y;
        
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 255;
            end
        end
        
        sC = idivide(x+end_x,int32(2))+1;
        sR = y;
        eC = end_x;
        eR = end_y;
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 0;
            end
        end
        
        
        imshow(I);
        
        
        
    case 2
        
        sC = x;
        sR = y;
        eC = end_x;
        eR = idivide(y+end_y,int32(2));
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 255;
            end
        end
        sC = x;
        sR = idivide(y+end_y,int32(2))+1;
        eC = end_x;
        eR = end_y;
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 0;
            end
        end
        imshow(I);
        
    case 3
        
        sC = x;
        sR = y;
        eC = idivide(2*x+end_x,int32(3));
        eR = end_y;
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 255;
            end
        end
        sC = idivide(2*x+end_x,int32(3))+1;
        sR = y;
        eC = idivide(x+2*end_x,int32(3));
        eR = end_y;
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 0;
            end
        end
        sC = idivide(x+2*end_x,int32(3))+1;
        sR = y;
        eC = end_x;
        eR = end_y;
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 255;
            end
        end
        imshow(I);
        
    case 4
        
        sC = x;
        sR = y;
        eC = end_x;
        eR = idivide(2*y+end_y,int32(3));
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 255;
            end
        end
        sC = x;
        sR = idivide(2*y+end_y,int32(3))+1;
        eC = end_x;
        eR = idivide(y+2*end_y,int32(3));
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 0;
            end
        end
        sC = x;
        sR = idivide(y+2*end_y,int32(3))+1;
        eC = end_x;
        eR = end_y;
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 255;
            end
        end
        imshow(I);
        
    case 5
        
        sC = x;
        sR = y;
        eC = idivide(x+end_x,int32(2));
        eR = idivide(y+end_y,int32(2));
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 255;
            end
        end
        sC = idivide(x+end_x,int32(2))+1;
        sR = y;
        eC = end_x;
        eR = idivide(y+end_y,int32(2));
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 0;
            end
        end
        sC = x;
        sR = idivide(y+end_y,int32(2))+1;
        eC = idivide(x+end_x,int32(2));
        eR = end_y;
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 255;
            end
        end
        sC = idivide(x+end_x,int32(2))+1;
        sR = idivide(y+end_y,int32(2))+1;
        eC = end_x;
        eR = end_y;
        for r = sR : eR
            for c = sC : eC
                I(r,c) = 0;
            end
        end
        imshow(I);
        
end
end