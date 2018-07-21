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
function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)

    WINDOW_SIZE = 5;

    % Calculate the vertical and horizontal derivative
    [Ix, Iy] = gradient(image);
    
    Ix_squared = Ix .^ 2;
    IxIy = Ix .* Iy;
    Iy_squared = Iy .^ 2;
    
    windowed_Ix_squared = imgaussfilt(Ix_squared, WINDOW_SIZE);
    windowed_IxIy = imgaussfilt(IxIy, WINDOW_SIZE);
    windowed_Iy_squared = imgaussfilt(Iy_squared, WINDOW_SIZE);
    
    [y, x] = size(image);
    for yind = 1:y
        for xind = 1:x
            M = [windowed_Ix_squared(y,x)  windowed_IxIy(y,x);
                 windowed_IxIy(y,x)  windowed_Iy_squared(y,x);]; 
             
            eigenvalues = eig(M);
        end
    end

end

