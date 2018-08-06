

image_codes = 3:-1:1;

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
    
    [im, matches] = do_pipeline(results{end}, image);
    results{end+1} = im;
end

image_codes = 4:5;

for i = 1:numel(image_codes)
    id = image_codes(i);
    image = do_reading(id);
    images{end+1} = image;
    
    % if i == 1
    %     results{end+1} = image;
    %     continue;
    % end
    
    [im, matches] = do_pipeline(results{end}, image);
    results{end+1} = im;
end

