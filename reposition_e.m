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
        [minX, iX] = min(diffX);
        [minY, iY] = min(diffY);
        
        dist = sqrt((cPoly(1, :) - a) .^ 2 + (cPoly(2, :) - b) .^ 2);
        dist_sorted = sort(dist);
        dist1 = dist_sorted(1);
        dist2 = dist_sorted(2);
        idx_1 = find(dist == dist1);
        idx_2 = find(dist == dist2);
        if iX == iY && minX < 1 && minY < 1
            i = iX;
            pointSelected = true;
            break;
        elseif abs(idx_1 - idx_2) == 1            
            if (idx_1 < idx_2)
                idx_prev = idx_1;
                idx_next = idx_2;
            else
                idx_prev = idx_2;
                idx_next = idx_1;
            end
            edgeSelected = true;
            break;
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

