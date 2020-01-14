function cPoly = deleteP(cPoly)
    pointSelected = false;
    while not (pointSelected)
        
        [a, b] = ginput(1);
        diffX = abs(cPoly(1, :) - a);
        diffY = abs(cPoly(2, :) - b);
        [minX, iX] = min(diffX);
        [minY, iY] = min(diffY);
        
        dist = sqrt((cPoly(1, :) - a) .^ 2 + (cPoly(2, :) - b) .^ 2);
        dist_sorted = sort(dist);
        dist1 = dist_sorted(1);
        if(size(dist_sorted,2)==1)
            pointSelected = true;
            i=1;
            break;
        end
        dist2 = dist_sorted(2);
        idx_1 = find(dist == dist1);
        idx_2 = find(dist == dist2);
        if iX == iY && minX < 20 && minY < 20
            i = iX;
            pointSelected = true;
            break;
        end
    end
    
    % Select new pos
    if (pointSelected)
        tmp =[];
        count =0;
        for n =1:size(cPoly,2)
            if(n==i)
                continue;
            else
                count = count+1;
                tmp(1,count) = cPoly(1,n)
                tmp(2,count) = cPoly(2,n)
            end
        end
        cPoly = tmp

    end
end