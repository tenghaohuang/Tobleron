function [points]=cleanPts(pts)
if(isempty(pts))
    points =[];
    return;
end
    len = size(pts,2);
    counter =1;
    global index;
    index = [];
for i =1:len
    
        if(pts(1,i)==pts(2,i)&&pts(1,i)==0)
           index(counter) = i;
           counter = counter+1;
        end
        
end
for i = 1:size(index,2)
    if(index(i)~=0)
    pts(:,index(i))=[];
        for j=i+1:size(index,2)
            index(j)=index(j)-1;
        end
    end
end
points = pts;
end
