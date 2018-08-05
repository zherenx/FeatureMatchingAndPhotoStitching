function [width, height, confidence, scale, orientation] = get_interest_points(image, feature_width)

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
    for y = shift+1:height-shift
        for x = shift+1:width-shift
            M11 = windowed_Ix_squared(y-shift:y+shift,x-shift:x+shift);
            M12 = windowed_IxIy(y-shift:y+shift,x-shift:x+shift);
            M21 = windowed_IxIy(y-shift:y+shift,x-shift:x+shift);
            M22 = windowed_Iy_squared(y-shift:y+shift,x-shift:x+shift);
            
            M = [mean(M11(:))  mean(M12(:));
                 mean(M21(:))  mean(M22(:))];
             
            eigenvalue = eig(M);
            
            R(y,x) = eigenvalue(1) * eigenvalue(2) - ...
                     k * (eigenvalue(1) + eigenvalue(2)) ^ 2;
        end
    end
    

%     threshold = max(R(:)) * 0.1;

%     avg_r = mean(mean(R))
%     threshold = abs(5 * avg_r)


    
    positiveR = R .* (R > 0);
    sum_pos = sum(positiveR(:));
    positiveR = R > 0;
    counter = sum(positiveR(:));
    
    threshold = sum_pos / counter * 1;

    
    ordfilt_winsize = 11;
    
    R1= ordfilt2(R, ordfilt_winsize^2, ones(ordfilt_winsize));

    suppressed = (R1==R) & (R > threshold);


    [height, width] = find(suppressed);
end

