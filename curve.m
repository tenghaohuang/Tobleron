
function curve()
% Init control polygon
%figure;
%axis([0 1 0 1]);
%imshow('frame3.jpg');
[x, y] = getpts();
x = x';
y = y';
canManipulatePts = false;

while (true)
    clf;
    %imshow('frame3.jpg');
    % Plot control polygon
    hold on;
    plot(x, y, 'b-o');
    hold on;

    % Allocate Memory for curve
    stepSize = 0.01; % hundreds pts + 1
    u = 0: stepSize: 1;
    numOfU = length(u);
    c = zeros(2, numOfU);

    % Iterate over curve and apply deCasteljau
    numOfPts = length(x);
    pts = [x; y];
    for i = 1: numOfU
        ui = u(i);
        c(:, i) = deCasteljau(ui, pts, numOfPts, numOfPts);
    end
    
    % Plot curve
    %axis([0 1 0 1]);
    plot(c(1, :), c(2, :), '-r');
    canManipulatePts = true;

    % Manipulate points
    if (canManipulatePts)
        pts = reposition(pts);
        x = pts(1, :);
        y = pts(2, :);
    end
end

