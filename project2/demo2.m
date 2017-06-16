
for i=1:img_test_lim
    left_nonface(i)=0;
    right=0;
    for t=1:max(size(h))
        alpha_t=log(1/beta(t));
 
            if intensity_diff_nonface_test(i,t)>=threshold(h(t),1) && intensity_diff_nonface(i,t)<=threshold(h(t),2)
                decision(i,t)=threshold(h(t),3);
                %{
                if threshold(h(t),3)==0
                    decision=-1;
                else
                    decision=1;
                end
                %}
            else
                decision(i,t)=~threshold(h(t),3);
                %{
                if threshold(h(t),3)==0
                    decision=1;
                else
                    decision=-1;
                end
                %}
            end
        right=right+alpha_t;
        left_nonface(i)=left_nonface(i)+alpha_t*decision(i*t);
        
    end
   left_nonface(i)=left_nonface(i)-(right/2); 
end