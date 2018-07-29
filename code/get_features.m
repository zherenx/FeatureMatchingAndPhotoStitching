% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, feature_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature vector should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

%Placeholder that you can delete. Empty features.


difference = floor(feature_width / 2);

features = zeros(size(x,1), 128);

[im_y, im_x] = size(image);

[dx,dy] = gradient(image);

for ind = 1:size(x,1)
    yval = round(y(ind));
    xval = round(x(ind));

    % Skip the feature if it is out of range.
    if (round(xval)-difference < 1 || round(xval)+difference-1 > im_x || ...
        round(yval)-difference < 1 || round(yval)+difference-1 > im_y)
        continue;
    end

    patch_x = dx(round(yval)-difference:round(yval)+difference-1, ...
                  round(xval)-difference:round(xval)+difference-1);
    patch_y = dy(round(yval)-difference:round(yval)+difference-1, ...
                  round(xval)-difference:round(xval)+difference-1);
              
    g = fspecial('gaussian', [16 16], 1);
    patch_x = imfilter(patch_x, g);
    patch_y = imfilter(patch_y, g);
    
    uv = cell(8,1);
    uv{1} = [1,0];
    uv{2} = [sqrt(2),sqrt(2)];
    uv{3} = [0,1];
    uv{4} = [-sqrt(2),sqrt(2)];
    uv{5} = [-1,0];
    uv{6} = [-sqrt(2),-sqrt(2)];
    uv{7} = [0,-1];
    uv{8} = [sqrt(2),-sqrt(2)];
    
    amp = zeros(8);
    
    hist = zeros(4,4,8);
    
    for hist_i = 1:4
        for hist_j = 1:4
            bound_i = hist_i * 4;
            bound_j = hist_j * 4;
            for patch_i = bound_i-3:bound_i
                for patch_j = bound_j-3:bound_j
                    cur_grad = [patch_x(patch_i,patch_j);patch_y(patch_i,patch_j)];
                    for i = 1:8
                        amp(i) = uv{i} * cur_grad;
                    end
                    [val,I] = maxk(amp,2);
                    hist(hist_i,hist_j,I(1)) = hist(hist_i,hist_j,I(1)) + val(1);
                    hist(hist_i,hist_j,I(2)) = hist(hist_i,hist_j,I(2)) + val(2);
                end
            end
        end
    end
    

%     [features_patch, visualization] = extractHOGFeatures(patch, ...
%         'CellSize', [16 16], 'BlockSize', [4 4]);

   

    index = 1;
    for i = 1:4
        for j = 1:4
            for k = 1:8
                features(ind,index) = hist(i,j,k) / 16;
                index = index + 1;
            end
        end
    end

%     features(y, x) = features_patch;
end


% features = extractHOGFeatures(image, [x y], 'CellSize', [16 16], 'BlockSize', [4 4], 'NumBins', 8);


