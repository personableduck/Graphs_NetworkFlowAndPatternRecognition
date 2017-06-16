function intensity = get_block_intensity(A,lt_x,lt_y,rt_x,rt_y,rb_x,rb_y,lb_x,lb_y)
%gets the intensity of the given block marked by the four x,y values

block_corners=[lt_x,lt_y,rt_x,rt_y,rb_x,rb_y,lb_x,lb_y];



%[A(rb_x+1,rb_y+1),A(rt_x+1,rt_y),A(lb_x,lb_y+1),A(lt_x,lt_y)]

intensity=double(A(rb_y+1,rb_x+1)-A(rt_y+1,rt_x)-A(lb_y,lb_x+1)+A(lt_y,lt_x));

end

