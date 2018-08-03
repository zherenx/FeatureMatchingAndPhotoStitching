function [im] = do_reading(id)
    image_directory = 'U:\469\469 photos';
    scale_factor = 0.2; 
    
    filename = strcat(image_directory, '\', '', int2str(id), '.JPG');
    im = imread(filename);
    im = single(im)/255;
    im = imresize(im, scale_factor, 'bilinear');
end