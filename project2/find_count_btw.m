function count_btw = find_count_btw(counts,centers,th1,th2)
%find the range between two thresholds 

n=max(size(centers));
if th1>th2
   temp=th1;
   th1=th2;
   th2=temp;
end


for i=1:n
    if centers(i)>th1
        break
    end
end
count_btw(1)=i-1;

for i=1:n
    if centers(i)>th2
        break
    end
end

count_btw(2)=i-1;


end

