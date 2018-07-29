
y_mid = floor(size(image1,1)/2);
x_mid = floor(size(image1,2)/2);
subImage1 = image1_bw(1:y_mid,1:x_mid);
subImage2 = image1_bw(y_mid+1:size(image1,1),1:x_mid);
subImage3 = image1_bw(1:y_mid,x_mid+1:size(image1,2));
subImage4 = image1_bw(y_mid+1:size(image1,1),x_mid:size(image1,2));
[x1, y1] = get_interest_points(subImage1, feature_width);
[x2, y2] = get_interest_points(subImage2, feature_width);
[x3, y3] = get_interest_points(subImage3, feature_width);
[x4, y4] = get_interest_points(subImage4, feature_width);

% figure
% imshow(subImage1),hold on
% scatter(x1,y1,'r'), hold off
% figure
% imshow(subImage2),hold on
% scatter(x2,y2,'r'), hold off
% figure
% imshow(subImage3),hold on
% scatter(x3,y3,'r'), hold off
% figure
% imshow(subImage4),hold on
% scatter(x4,y4,'r'), hold off

y2 = y2 + y_mid;
x3 = x3 + x_mid;
y4 = y4 + y_mid;
x4 = x4 + x_mid;

x0 = [x1;x2;x3;x4];
y0 = [y1;y2;y3;y4];

figure
imshow(image1),hold on
scatter(x0,y0,'r'), hold off




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