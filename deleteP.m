function cPoly = deleteP(cPoly)
    pointSelected = false;
    display('step 1')
    while not (pointSelected)
        
        [a, b] = ginput(1);
        diffX = abs(cPoly(1, :) - a);
        diffY = abs(cPoly(2, :) - b);

        dist = sqrt((cPoly(1, :) - a) .^ 2 + (cPoly(2, :) - b) .^ 2);
        

        [minDist,pos] = min(dist);
        
        display(pos);
        if minDist<10
            i = pos;
            pointSelected = true;
            break;
%         else
%             display(iX);
%             display(iY);
%             display(minX);
%             display(minY);
        end
    end
    display('step 2')
    % Select new pos
    if (pointSelected)
        tmp =[];
        count =0;
        for n =1:size(cPoly,2)
            if(n==i)
                continue;
            else
                count = count+1;
                tmp(1,count) = cPoly(1,n);
                tmp(2,count) = cPoly(2,n);
            end
        end
        cPoly = tmp;

    end
     display('step 3')
end