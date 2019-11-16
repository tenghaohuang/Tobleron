function [points]=cleanPts(pts)
    len = size(pts,2);
for i =1:len
    if(i<=size(pts,2))
        if(pts(1,i)==pts(2,i))
            pts(:,i)=[];
        end
    end
end
points = pts;
end