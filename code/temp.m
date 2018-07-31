
image1 = imread('./input/left2.jpg');
image2 = imread('./input/right.jpg');

image1 = single(image1)/255;
image2 = single(image2)/255;

%make images smaller to speed up the algorithm. This parameter gets passed
%into the evaluation code so don't resize the images except by changing
%this parameter.
scale_factor = 0.5; 
image1 = imresize(image1, scale_factor, 'bilinear');
image2 = imresize(image2, scale_factor, 'bilinear');

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


% figure
% imshow(image1)
% 
% figure
% imshow(image2)
% 
% figure
% imshow(im)


% y_mid = floor(size(image1,1)/2);
% x_mid = floor(size(image1,2)/2);
% subImage1 = image1_bw(1:y_mid,1:x_mid);
% subImage2 = image1_bw(y_mid+1:size(image1,1),1:x_mid);
% subImage3 = image1_bw(1:y_mid,x_mid+1:size(image1,2));
% subImage4 = image1_bw(y_mid+1:size(image1,1),x_mid:size(image1,2));
% [x1, y1] = get_interest_points(subImage1, feature_width);
% [x2, y2] = get_interest_points(subImage2, feature_width);
% [x3, y3] = get_interest_points(subImage3, feature_width);
% [x4, y4] = get_interest_points(subImage4, feature_width);
% 
% % figure
% % imshow(subImage1),hold on
% % scatter(x1,y1,'r'), hold off
% % figure
% % imshow(subImage2),hold on
% % scatter(x2,y2,'r'), hold off
% % figure
% % imshow(subImage3),hold on
% % scatter(x3,y3,'r'), hold off
% % figure
% % imshow(subImage4),hold on
% % scatter(x4,y4,'r'), hold off
% 
% y2 = y2 + y_mid;
% x3 = x3 + x_mid;
% y4 = y4 + y_mid;
% x4 = x4 + x_mid;
% 
% x0 = [x1;x2;x3;x4];
% y0 = [y1;y2;y3;y4];
% 
% figure
% imshow(image1),hold on
% scatter(x0,y0,'r'), hold off




% [x1, y1] = get_interest_points(image1_bw, feature_width);
% 
% figure
% imshow(image1),hold on
% % scatter(x0,y0,'b'), hold on
% scatter(x1,y1,'r'), hold off

% 
% [x2, y2] = get_interest_points(image2_bw, feature_width);
% 
% figure
% imshow(image2),hold on
% % scatter(x0,y0,'b'), hold on
% scatter(x2,y2,'r'), hold off