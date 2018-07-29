% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [width, height, confidence, scale, orientation] = get_interest_points(image, feature_width)

    WINDOW_SIZE = feature_width;
    shift = 5;

    % Calculate the vertical and horizontal derivative
    [Ix, Iy] = gradient(image);
    
    Ix_squared = Ix .^ 2;
    IxIy = Ix .* Iy;
    Iy_squared = Iy .^ 2;
    
    windowed_Ix_squared = imgaussfilt(Ix_squared, 2, 'FilterSize' ,9);
    windowed_IxIy = imgaussfilt(IxIy, 2, 'FilterSize' ,9);
    windowed_Iy_squared = imgaussfilt(Iy_squared, 2, 'FilterSize' ,9);
    
    
    [height, width] = size(image);
%     eigenvalues = zeros(y,x,2);
    R = zeros(height,width);
    k = 0.05;
    for y = 1:height
        for x = 1:width

            if y > shift && y < height - shift ...
                    && x > shift && x < width - shift
            M11 = windowed_Ix_squared(y-shift:y+shift,x-shift:x+shift);
            M12 = windowed_IxIy(y-shift:y+shift,x-shift:x+shift);
            M21 = windowed_IxIy(y-shift:y+shift,x-shift:x+shift);
            M22 = windowed_Iy_squared(y-shift:y+shift,x-shift:x+shift);
            M = [mean(M11(:))  mean(M12(:));
                 mean(M21(:))  mean(M22(:))];
             
%             eigenvalues(y,x,:) = eig(M);
            eigenvalue = eig(M);
            
            R(y,x) = eigenvalue(1) * eigenvalue(2) - ...
                k * (eigenvalue(1) + eigenvalue(2)) ^ 2;             
            end

        end
    end
    
%     R = windowed_Ix_squared .* windowed_Iy_squared - windowed_IxIy.^2 ...
%         - k * (windowed_Ix_squared + windowed_Iy_squared).^2;
    

%     threshold = max(R(:)) * 0.1;

%     avg_r = mean(mean(R))
%     threshold = abs(5 * avg_r)

    sum = 0;
    counter = 0;
    for i = 1:height
        for j = 1:width
            if R(i,j) > 0
                sum = sum + R(i,j);
                counter = counter + 1;
            end
        end
    end

    threshold = sum / counter * 5;

    
%     R1= ordfilt2(R,400,ones(20));
%     suppressed = (R1==R) & (R > threshold);

    filtered = R .* (R > threshold);
    suppressed = imregionalmax(filtered);

    [height, width] = find(suppressed);
end

