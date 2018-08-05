function [features] = get_features(image, x, y, feature_width)

difference = floor(feature_width / 2);

features = zeros(size(x,1), 128);

[im_y, im_x] = size(image);

[dx,dy] = gradient(image);

for ind = 1:size(x,1)
    yval = round(y(ind));
    xval = round(x(ind));

    % Skip the feature if it is out of range.
    if (xval-difference < 1 || xval+difference-1 > im_x || ...
        yval-difference < 1 || yval+difference-1 > im_y)
        continue;
    end

    patch_x = dx(yval-difference:yval+difference-1, ...
                  xval-difference:xval+difference-1);
    patch_y = dy(yval-difference:yval+difference-1, ...
                  xval-difference:xval+difference-1);
              
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

   
    features(ind, :) = reshape(hist, [1 4*4*8]);


end


% features = extractHOGFeatures(image, [x y], 'CellSize', [16 16], 'BlockSize', [4 4], 'NumBins', 8);


