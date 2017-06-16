function [t1,x1,y1,sx1,sy1] = get_feature_details(index)
%returns all the feature parameters for the features
count=0;
flag=0;
for t=1:5
        for x=1:16
             for y=1:16
                for sx=1:16
                    for sy=1:16
                        if(is_valid_feature(t,x,y,sx,sy)==1)
                            
                            %if sx==2 && sy==1 && x==2 && y==1
                            %if count==1
                            count=count+1;
                            if(count==index)
                                
                                t1=t;
                                x1=x;
                                y1=y;
                                sx1=sx;
                                sy1=sy;
                                flag=1;
                                break
                            end
                            
                        end
                        if flag==1
                            break
                        end
                    end
                    if flag==1
                            break
                        end
                end
                if flag==1
                            break
                        end
             end
            if flag==1
                            break
                        end
        end
        if flag==1
                            break
                        end
    end



end

