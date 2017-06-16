test_image1=imread('D:\patternreconization\project2\Test_and_background_Images\Test_Image_1.jpg');
test_image2=imread('D:\patternreconization\project2\Test_and_background_Images\Test_Image_2.jpg');

gr1=rgb2gray(test_image1);
gr2=rgb2gray(test_image2);

resize_gr1=imresize(gr1,0.07);
figure,imshow(resize_gr1)
rectangle('position', [224 145 15 15], 'EdgeColor', 'r');

resize_gr1=imresize(gr1,0.07);
figure,imshow(resize_gr1)
rectangle('position', [224 145 15 15], 'EdgeColor', 'r');
rectangle('position', [272 143 15 15], 'EdgeColor', 'r');
rectangle('position', [352 148 15 15], 'EdgeColor', 'r');
rectangle('position', [212 121 15 15], 'EdgeColor', 'r');
rectangle('position', [81 146 15 15], 'EdgeColor', 'r');
rectangle('position', [46 145 15 15], 'EdgeColor', 'r');
rectangle('position', [49 120 15 15], 'EdgeColor', 'r');
rectangle('position', [74 119 15 15], 'EdgeColor', 'r');
rectangle('position', [97 119 15 15], 'EdgeColor', 'r');


figure,imshow(resize_gr1)
rectangle('position', [224 145 15 15], 'EdgeColor', 'r');
rectangle('position', [272 143 15 15], 'EdgeColor', 'r');
rectangle('position', [352 148 15 15], 'EdgeColor', 'r');
rectangle('position', [212 121 15 15], 'EdgeColor', 'r');
rectangle('position', [81 146 15 15], 'EdgeColor', 'r');
rectangle('position', [46 145 15 15], 'EdgeColor', 'r');
rectangle('position', [74 119 15 15], 'EdgeColor', 'r');
rectangle('position', [97 119 15 15], 'EdgeColor', 'r');
rectangle('position', [125 136 15 15], 'EdgeColor', 'r');



h = getframe;
im = h.cdata;
re_im=imresize(im,1.5);
figure,imshow(re_im)

rectangle('position', [4 222 15 15], 'EdgeColor', 'r');
rectangle('position', [46 125 15 15], 'EdgeColor', 'r');
rectangle('position', [176 167 15 15], 'EdgeColor', 'r');
rectangle('position', [357 145 15 15], 'EdgeColor', 'r');
rectangle('position', [40 188 15 15], 'EdgeColor', 'r');
rectangle('position', [127 228 15 15], 'EdgeColor', 'r');
rectangle('position', [343 224 15 15], 'EdgeColor', 'r');
 
resize_gr2=imresize(gr2,0.05);


%%second

resize_gr2=imresize(gr2,0.08);
figure,imshow(resize_gr2)

rectangle('position', [385 161 15 15], 'EdgeColor', 'r');
rectangle('position', [293 166 15 15], 'EdgeColor', 'r');
rectangle('position', [228 158 15 15], 'EdgeColor', 'r');
rectangle('position', [163 159 15 15], 'EdgeColor', 'r');
rectangle('position', [138 162 15 15], 'EdgeColor', 'r');
rectangle('position', [199 136 15 15], 'EdgeColor', 'r');
rectangle('position', [291 133 15 15], 'EdgeColor', 'r');
rectangle('position', [320 132 15 15], 'EdgeColor', 'r');
rectangle('position', [401 128 15 15], 'EdgeColor', 'r');
rectangle('position', [396 117 15 15], 'EdgeColor', 'r');

rectangle('position', [3 159 15 15], 'EdgeColor', 'r');
rectangle('position', [100 151 15 15], 'EdgeColor', 'r');

h2 = getframe;
im2 = h2.cdata;
re_im2=imresize(im2,1.5);
figure,imshow(re_im2)

rectangle('position', [84 219 15 15], 'EdgeColor', 'r');
rectangle('position', [13 220 15 15], 'EdgeColor', 'r');
rectangle('position', [75 177 15 15], 'EdgeColor', 'r');
rectangle('position', [302 184 15 15], 'EdgeColor', 'r');
rectangle('position', [341 186 15 15], 'EdgeColor', 'r');
rectangle('position', [374 183 15 15], 'EdgeColor', 'r');
rectangle('position', [450 179 15 15], 'EdgeColor', 'r');
rectangle('position', [599 158 15 15], 'EdgeColor', 'r');


rectangle('position', [444 251 15 15], 'EdgeColor', 'r');
rectangle('position', [538 247 15 15], 'EdgeColor', 'r');
rectangle('position', [526 194 15 15], 'EdgeColor', 'r');
rectangle('position', [216 213 15 15], 'EdgeColor', 'r');
rectangle('position', [105 213 15 15], 'EdgeColor', 'r');

h22 = getframe;
im22 = h22.cdata;
re_im22=imresize(im22,1.5);
figure,imshow(re_im22)

rectangle('position', [337 288 15 15], 'EdgeColor', 'r');
rectangle('position', [377 288 15 15], 'EdgeColor', 'r');
rectangle('position', [573 259 15 15], 'EdgeColor', 'r');
rectangle('position', [592 429 15 15], 'EdgeColor', 'r');
rectangle('position', [434 242 15 15], 'EdgeColor', 'r');
rectangle('position', [544 315 15 15], 'EdgeColor', 'r');
rectangle('position', [754 272 15 15], 'EdgeColor', 'r');

size_1r=size(resize_gr1);







test_ft_set=[];
for i=1:size_1r(1,2)-15   
    for j=1:size_1r(1,1)-15
        test_ft_set{i,j}=imcrop(resize_gr1,[i j 15 15]);
    end
end

test_size_lop=size(test_ft_set);

test_feature=[]
for p = 1:test_size_lop(1,1)
    p
    for qq = 1:test_size_lop(1,2)
        qq
        tempImage = test_ft_set{p,qq};

        %for this RGB image, convert it to grey scale
        %find the integral image
        II = getIntegralImage(tempImage);

        %find the value of each feature for this image
        count=0;
        for i = 1 : 2 %type
            for scale_x = 1 : 16 %scale_x
                for scale_y = 1 : 16 %scale_y
                    for x = 1 : 16 %x
                        for y = 1 : 16 %y
                            if(possible_feature(i,x,y,scale_x,scale_y) == true)
                                count= count+1;
                                %find the value (difference of rectangles)
                                test_feature(count,p) = feature_value(II,i,x,y,scale_x,scale_y);
                            end
                        end
                    end
                end
            end
        end
    end
end
