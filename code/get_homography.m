function homography = get_homography(matches, x1, y1, x2, y2)

    [n, ~] = size(matches);
    
    numTrial = 1000;
    numSelectedPts = 4;
    inlier_epsilon = 16;
    
    num_inliers_best = 0;
    inliers_ind = [];
    
    [nx1, ~] = size(x1);
    [nx2, ~] = size(x2);
    min_x1x2 = min(nx1, nx2);
    
    
    for trial = 1:numTrial
        % Randomly select 4 positions of matches
        randnum = randi(n, [1 numSelectedPts]);
        indArr = [];
        for i = randnum
            indArr = [indArr; matches(i, :)];
        end
            
        h = computeHomography(indArr, x1, y1, x2, y2);
        
        % Transform features1 using the homography computed
        transformed_x1y1 = [x1 y1 ones(numel(x1), 1)] * h';

        % scale coordinates: making the z component to become 1
        transformed_x1y1 = transformed_x1y1(1:min_x1x2, :);
        z = transformed_x1y1(:, end);
        transformed_x1y1 = bsxfun(@rdivide, transformed_x1y1, z);
        transformed_x1y1 = transformed_x1y1(:, 1:2);

        x2y2 = [x2 y2];
        x2y2 = x2y2(1:min_x1x2, :);
        ssd_result = ssd(transformed_x1y1, x2y2);
        num_inliers = sum(ssd_result < inlier_epsilon);
        
        % Record the homography if it produces most inliers so far
        if num_inliers > num_inliers_best
            num_inliers_best = num_inliers;
            inliers_ind = find(ssd_result < inlier_epsilon);
        end
    end
    
    % Recompute homography for the greatest inliers
    homography = computeHomography([inliers_ind inliers_ind], x1, y1, x2, y2);
end


function h = computeHomography(indexArr, x1, y1, x2, y2)
    % Computing homography for a given point pair
    A = [];
    
    [row, ~] = size(indexArr);

    for ind = 1:row
        x = x1(indexArr(ind, 1)); y = y1(indexArr(ind, 1));
        xprime = x2(indexArr(ind, 2)); yprime = y2(indexArr(ind, 2));

        A = [A; [x y 1 0 0 0 -xprime*x -xprime*y -xprime]];
        A = [A; [0 0 0 x y 1 -yprime*x -yprime*y -yprime]];
    end

    [~, ~, V] = svd(A);
    h = V(:, end);
    h = transpose(reshape(h, [3 3]));
    
    % Scale the homography so that the last element is 1
%     h = h ./ h(end, end);
end


function result = ssd(matrix1, matrix2)
    % sum the difference result on each row 
    result = sqrt(sum((matrix1 - matrix2) .^ 2, 2));
end