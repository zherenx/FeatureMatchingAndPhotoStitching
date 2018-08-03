close all

profile on

filename = 'U:/469/IMG_2286.MOV';

v = VideoReader(filename);

num_of_frame = ceil(v.Duration);
% frames = zeros(v.Height, v.Width,3, num_of_frame);

images = {};
results = {};

frame_num = 0;
num_of_frame = 0;

for i = 1:9
    
    while hasFrame(v)
        frame_num = frame_num + 1;
        readFrame(v);
        if rem(frame_num, 50) == 1 && hasFrame(v)
            num_of_frame = num_of_frame + 1;
            frame_num = frame_num + 1;
            images{end+1} = single(imresize(readFrame(v),1,'bilinear'))/255;
            image = images{end};
            break;
        end
    end
    
    
%     if i == 1
%         results{end+1} = image;
%         continue;
%     end
%     
%     im = do_pipeline(results{end}, image);
%     results{end+1} = im;
end

for i = 5:9
    
    image = images{i};
    
    if i == 5
        results{end+1} = image;
        continue;
    end
    
    im = do_pipeline(results{end}, image);
    results{end+1} = im;    
end

for i = 4:-1:1
    image = images{i};
    im = do_pipeline(results{end}, image);
    results{end+1} = im;
end




profile off