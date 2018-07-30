function [x0, y0, confidence, scale, orientation] = get_interest_points_modified(image, feature_width)

y_mid = floor(size(image,1)/2);
x_mid = floor(size(image,2)/2);
subImage1 = image(1:y_mid,1:x_mid);
subImage2 = image(y_mid+1:size(image,1),1:x_mid);
subImage3 = image(1:y_mid,x_mid+1:size(image,2));
subImage4 = image(y_mid+1:size(image,1),x_mid:size(image,2));
[x1, y1] = get_interest_points(subImage1, feature_width);
[x2, y2] = get_interest_points(subImage2, feature_width);
[x3, y3] = get_interest_points(subImage3, feature_width);
[x4, y4] = get_interest_points(subImage4, feature_width);

y2 = y2 + y_mid;
x3 = x3 + x_mid;
y4 = y4 + y_mid;
x4 = x4 + x_mid;

x0 = [x1;x2;x3;x4];
y0 = [y1;y2;y3;y4];