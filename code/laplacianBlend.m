function im = laplacianBlend(im1, im2, mask)
    numLevels = 4;
    
    [gauss1, laplace1] = getPyramids(im1, numLevels);
    [gauss2, laplace2] = getPyramids(im2, numLevels);
    
    mask = single(mask);
    
    % Build a Gaussian pyramid of region mask
    maskPyramid = cell(1, numLevels);
    maskPyramid{1} = mask;
    for iter = 2:numLevels
        im = impyramid(maskPyramid{iter-1}, 'reduce');
        im = imgaussfilt(im, 0.5 * iter);
        maskPyramid{iter} = im;
    end
    
    % Blend each level of pyramid using region mask from the same level
    blendedPyramid = cell(1, numLevels);
    for iter = numLevels:-1:1
        maxsize = max(size(laplace1{iter}), size(laplace2{iter}));
        lp1 = imresize(laplace1{iter}, maxsize(1:2));
        lp2 = imresize(laplace2{iter}, maxsize(1:2));
        mask = imresize(maskPyramid{iter}, maxsize(1:2));
        blendedPyramid{iter} = lp1 .* (1 - mask) + ...
                               lp2 .* mask;
    end
    
    % Collapse the pyramid to get the final blended image
    last_mask = impyramid(maskPyramid{end}, 'reduce');
    im = gauss1{end} .* (1 - last_mask) + gauss2{end} .* last_mask;
    
    for iter = numLevels:-1:1
        im = impyramid(im, 'expand');
        maxsize = max(size(im), size(blendedPyramid{iter}));
        im = imresize(im, maxsize(1:2)) + imresize(blendedPyramid{iter}, maxsize(1:2));
    end
    
    [im1xsize, im1ysize, ~] = size(im1);
    im = imresize(im, [im1xsize im1ysize]);
    
end


function [gaussPyramid, laplacianPyramid] = getPyramids(im, numLevels)
    gaussPyramid = cell(1, numLevels+1);
    laplacianPyramid = cell(1, numLevels);

    gaussPyramid{1} = im;
    for iter = 1:numLevels
        original = gaussPyramid{iter};
        reduced = impyramid(original, 'reduce');
        expanded = impyramid(reduced, 'expand');
        
        maxsize = max(size(expanded), size(original));
        gaussPyramid{iter} = imresize(gaussPyramid{iter}, maxsize(1:2));
        
        difference = imresize(original, maxsize(1:2)) - ...
                     imresize(expanded, maxsize(1:2));
        
        gaussPyramid{iter+1} = reduced;
        
        laplacianPyramid{iter} = difference;
    end
end

