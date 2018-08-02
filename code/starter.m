
image_codes = 2326:2331;

images = {};
results = {};
for i = 1:numel(image_codes)
    id = image_codes(i);
    image = do_reading(id);
    images{end+1} = image;
    
    if i == 1
        results{end+1} = image;
        continue;
    end
    
    im = do_pipeline(results{end}, image);
    results{end+1} = im;
end

num_pts_to_visualize = size(matches,1);
show_correspondence(image, results{end}, x2(matches(1:num_pts_to_visualize,1)), ...
                               y2(matches(1:num_pts_to_visualize,1)), ...
                               x1(matches(1:num_pts_to_visualize,2)), ...
                               y1(matches(1:num_pts_to_visualize,2)));
                                 
show_correspondence2(image, results{end}, x2(matches(1:num_pts_to_visualize,1)), ...
                                y2(matches(1:num_pts_to_visualize,1)), ...
                                x1(matches(1:num_pts_to_visualize,2)), ...
                                y1(matches(1:num_pts_to_visualize,2)));

