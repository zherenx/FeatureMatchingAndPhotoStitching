close all

profile on

filename = 'U:/469/IMG_2352.MOV';

v = VideoReader(filename);

num_of_frame = ceil(v.Duration);
% frames = zeros(v.Height, v.Width,3, num_of_frame);

images = {};
results = {};
for i = 1:5
    
    frame_num = 0;
%     num_of_frame = 0;
    while hasFrame(v)
        frame_num = frame_num + 1;
        readFrame(v);
        if rem(frame_num, 50) == 1
            num_of_frame = num_of_frame + 1;
            images{end+1} = single(imresize(readFrame(v),1,'bilinear'))/255;
            break;
        end
    end
    
    image = images{end};
    
    if i == 1
        results{end+1} = image;
        continue;
    end
    
    im = do_pipeline(results{end}, image);
    results{end+1} = im;
end




mid_index = floor(num_of_frame / 2);

for i = mid_index:num_of_frame
    
end


profile off