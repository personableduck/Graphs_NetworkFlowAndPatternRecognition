function intensity_diff = get_intensity_diff(integral_matrix,t,x,y,sx,sy)
% Give the difference in the intensity of the shaded-unshaded blocks in the
% given type of feature for the given type of imag

type=[1 2; 2 1; 1 3; 3 1; 2 2 ];

unshaded=0;
shaded=0;
switch t
    case 1
        
        txlength=type(t,2)*sx-1;
        tylength=type(t,1)*sy-1;
        lt_x=x;
        lt_y=y;
        lb_x=x;
        lb_y=y+tylength;
        rt_x=x+txlength;
        rt_y=y;
        rb_x=x+txlength;
        rb_y=y+tylength;
        
        [lt_x,lt_y,rt_x,rt_y,rb_x,rb_y,lb_x,lb_y];
        int_t_x=x+((txlength+1)/2)-1;
        int_t_y=y;
        int_b_x=x+((txlength+1)/2)-1;
        int_b_y=y+tylength;
        
        %[int_t_x, int_t_y, int_b_x, int_b_y]
        
        
        unshaded=get_block_intensity(integral_matrix,lt_x,lt_y,int_t_x,int_t_y,int_b_x,int_b_y,lb_x,lb_y);
        shaded=get_block_intensity(integral_matrix,int_t_x+1,int_t_y,rt_x,rt_y,rb_x,rb_y,int_b_x+1,int_b_y);
        intensity_diff=double(shaded-unshaded);
    case 2
        txlength=type(t,2)*sx-1;
        tylength=type(t,1)*sy-1;
        lt_x=x;
        lt_y=y;
        lb_x=x;
        lb_y=y+tylength;
        rt_x=x+txlength;
        rt_y=y;
        rb_x=x+txlength;
        rb_y=y+tylength;
        
        int_l_x=x;
        int_l_y=y+((tylength+1)/2)-1;
        int_r_x=x+txlength;
        int_r_y=y+((tylength+1)/2)-1;
        
        unshaded=get_block_intensity(integral_matrix,lt_x,lt_y,rt_x,rt_y,int_r_x,int_r_y+1,int_l_x,int_l_y+1);
        shaded=get_block_intensity(integral_matrix,int_l_x,int_l_y+1,int_r_x,int_r_y+1,rb_x,rb_y,lb_x,lb_y);
        intensity_diff=double(shaded-unshaded);
    case 3
        txlength=type(t,2)*sx-1;
        tylength=type(t,1)*sy-1;
        lt_x=x;
        lt_y=y;
        lb_x=x;
        lb_y=y+tylength;
        rt_x=x+txlength;
        rt_y=y;
        rb_x=x+txlength;
        rb_y=y+tylength;
        
        int_lt_x=x+((txlength+1)/3)-1;
        int_lt_y=y;
        int_rt_x=x+((2*(txlength+1))/3)-1;
        int_rt_y=y;
        int_rb_x=x+((2*(txlength+1))/3)-1;
        int_rb_y=y+tylength;
        int_lb_x=x+((txlength+1)/3)-1;
        int_lb_y=y+tylength;
        
        unshaded=get_block_intensity(integral_matrix,lt_x,lt_y,int_lt_x,int_lt_y,int_lb_x,int_lb_y,lb_x,lb_y);
        unshaded=unshaded+get_block_intensity(integral_matrix,int_rt_x+1,int_rt_y,rt_x,rt_y,rb_x,rb_y,int_rb_x+1,int_rb_y);
        shaded=get_block_intensity(integral_matrix,int_lt_x+1,int_lt_y,int_rt_x,int_rt_y,int_rb_x+1,int_rb_y,int_lb_x,int_lb_y);
        intensity_diff=double(shaded-unshaded);
    case 4 
        txlength=type(t,2)*sx-1;
        tylength=type(t,1)*sy-1;
        lt_x=x;
        lt_y=y;
        lb_x=x;
        lb_y=y+tylength;
        rt_x=x+txlength;
        rt_y=y;
        rb_x=x+txlength;
        rb_y=y+tylength;
        
        int_lt_x=x;
        int_lt_y=y+((tylength+1)/3)-1;
        int_rt_x=x+txlength;
        int_rt_y=y+((tylength+1)/3)-1;
        int_rb_x=x+txlength;
        int_rb_y=y+((2*(tylength+1)/3))-1;
        int_lb_x=x;
        int_lb_y=y+((2*(tylength+1)/3))-1;
        
        unshaded=get_block_intensity(integral_matrix,lt_x,lt_y,rt_x,rt_y,int_rt_x,int_rt_y,int_lt_x,int_lt_y);
        unshaded=unshaded+get_block_intensity(integral_matrix,int_lb_x,int_lb_y+1,int_rb_x,int_rb_y+1,rb_x,rb_y,lb_x,lb_y);
        shaded=get_block_intensity(integral_matrix,int_lt_x,int_lt_y+1,int_rt_x,int_rt_y+1,int_rb_x,int_rb_y,int_lb_x,int_lb_y);
        intensity_diff=double(shaded-unshaded);
    case 5
        txlength=type(t,2)*sx-1;
        tylength=type(t,1)*sy-1;
        lt_x=x;
        lt_y=y;
        
        rt_x=x+txlength;
        rt_y=y;
        rb_x=x+txlength;
        rb_y=y+tylength;
        lb_x=x;
        lb_y=y+tylength;
        
       [lt_x,lt_y,rt_x,rt_y,rb_x,rb_y,lb_x,lb_y];
        
        c_x=x+uint8((txlength+1)/2)-1;
        c_y=y+uint8((tylength+1)/2)-1;
        ct_x=x+uint8((txlength+1)/2)-1;
        ct_y=y;
        cl_x=x;
        cl_y=y+uint8((tylength+1)/2)-1;
        cr_x=x+txlength;
        cr_y=y+uint8((tylength+1)/2)-1;
        cb_x=x+uint8((txlength+1)/2)-1;
        cb_y=y+tylength;
        
        
        
        unshaded=get_block_intensity(integral_matrix,lt_x,lt_y,ct_x,ct_y,c_x,c_y,cl_x,cl_y);
        unshaded=unshaded+get_block_intensity(integral_matrix,c_x+1,c_y+1,cr_x,cr_y+1,rb_x,rb_y,cb_x+1,cb_y);
        
        shaded=get_block_intensity(integral_matrix,ct_x+1,ct_y,rt_x,rt_y,cr_x,cr_y,c_x+1,c_y);
        shaded=shaded+get_block_intensity(integral_matrix,cl_x,cl_y+1,c_x,c_y+1,cb_x,cb_y,lb_x,lb_y);
        intensity_diff=double(shaded-unshaded);
end


end

