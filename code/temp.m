
% image1 = imread('./input/left3.jpg');
% image2 = imread('./input/right4.jpg');

image1 = imread('U:/469/0006.jpg');
image2 = imread('U:/469/0007.jpg');

% image1 = imread('./output/01.jpg');
% image2 = imread('U:/469/IMG_2305.jpg');


image1 = single(image1)/255;
image2 = single(image2)/255;

%make images smaller to speed up the algorithm. This parameter gets passed
%into the evaluation code so don't resize the images except by changing
%this parameter.
scale_factor = 0.2;
image1 = imresize(image1, scale_factor, 'bilinear');
image2 = imresize(image2, scale_factor, 'bilinear');

image1 = imrotate(image1,-90);
image2 = imrotate(image2,-90);

% You don't have to work with grayscale images. Matching with color
% information might be helpful.
image1_bw = rgb2gray(image1);
image2_bw = rgb2gray(image2);

feature_width = 16; %width and height of each local feature, in pixels. 

%% B) Find distinctive points in each image. Szeliski 4.1.1
% % !!! You will need to implement get_interest_points. !!!
% [x1, y1] = get_interest_points(image1_bw, feature_width);
% [x2, y2] = get_interest_points(image2_bw, feature_width);
[x1, y1] = get_interest_points_modified(image1_bw, feature_width);
[x2, y2] = get_interest_points_modified(image2_bw, feature_width);


%% C) Create feature vectors at each interest point. Szeliski 4.1.2
% !!! You will need to implement get_features. !!!
[image1_features] = get_features(image1_bw, x1, y1, feature_width);
[image2_features] = get_features(image2_bw, x2, y2, feature_width);


%% D) Match features. Szeliski 4.1.3
% !!! You will need to implement get_features. !!!
% [matches, confidences] = match_features(image1_features, image2_features);
[matches, confidences] = match_features(image2_features, image1_features);

% matchedPoint1 = [];
% matchedPoint2 = [];
% for i = 1:100
%     p1 = matches(i, 1);
%     p2 = matches(i, 2);
%     matchedPoint1 = [matchedPoint1; [x1(p1) y1(p1)]];
%     matchedPoint2 = [matchedPoint2; [x2(p2) y2(p2)]];
% end 




homography = get_homography(matches, x2, y2, x1, y1);
im = stitch_images(image1, image2, homography);


num_pts_to_visualize = size(matches,1);
show_correspondence(image2, image1, x2(matches(1:num_pts_to_visualize,1)), ...
                               y2(matches(1:num_pts_to_visualize,1)), ...
                               x1(matches(1:num_pts_to_visualize,2)), ...
                               y1(matches(1:num_pts_to_visualize,2)));
                                 
show_correspondence2(image2, image1, x2(matches(1:num_pts_to_visualize,1)), ...
                                y2(matches(1:num_pts_to_visualize,1)), ...
                                x1(matches(1:num_pts_to_visualize,2)), ...
                                y1(matches(1:num_pts_to_visualize,2)));