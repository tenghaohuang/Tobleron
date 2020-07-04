function point = deCasteljau(u, pts, i, j)
    if i == 1
        point = pts(:, j);
    else
        point = u * deCasteljau(u, pts, i - 1, j) + (1 - u) * deCasteljau(u, pts, i - 1, j - 1);
    end
end

