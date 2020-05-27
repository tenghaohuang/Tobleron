function cPoly = reposition(cPoly)
    
    % Select point
    pointSelected = false;
    edgeSelected = false;
    i = -1;
    idx_prev = -1;
    idx_next = -1;
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
    
    % Select new pos
    if (pointSelected)
        
        scatter(cPoly(1, i), cPoly(2, i), 'g');
        [a, b] = ginput(1);
        cPoly(1, i) = a;
        cPoly(2, i) = b;
        plot(cPoly);
    end
    
    if (edgeSelected)
        disp(idx_prev)
        disp(idx_next)
        plot(cPoly(1, idx_prev: idx_next), cPoly(2, idx_prev: idx_next), 'g-');
        [a, b] = ginput(1);
        idx_curr = idx_prev;
        cPoly = [cPoly(1, 1: idx_curr) a cPoly(1, idx_curr + 1: end); cPoly(2, 1: idx_curr) b cPoly(2, idx_curr + 1: end)];
    end
end

