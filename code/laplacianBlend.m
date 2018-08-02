function im = laplacianBlend(im1, im2, mask)
    numLevels = 2;
    
    [gauss1, laplace1] = getPyramids(im1, numLevels);
    [gauss2, laplace2] = getPyramids(im2, numLevels);
    
    
end


function [gaussPyramid, laplacianPyramid] = getPyramids(im, numLevels)
    gaussPyramid = cell(1, numLevels);
    laplacianPyramid = cell(1, numLevels);

    gaussPyramid{1} = im;
    for iter = 1:numLevels
        original = gaussPyramid{iter};
        reduced = impyramid(original, 'reduce');
        expanded = impyramid(reduced, 'expand');
        
        minsize = min(size(expanded), size(original));
        gaussPyramid{iter} = imresize(gaussPyramid{iter}, [minsize(1) minsize(2)]);
        
        difference = original(1:minsize(1), 1:minsize(2), :) - ...
                     expanded(1:minsize(1), 1:minsize(2), :);
        
        if iter ~= numLevels
            gaussPyramid{iter+1} = reduced;
        end
        
        laplacianPyramid{iter} = difference;
    end
end

