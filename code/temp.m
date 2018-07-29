
[x1, y1] = get_interest_points(image1_bw, feature_width);

figure
imshow(image1),hold on
% scatter(x0,y0,'b'), hold on
scatter(x1,y1,'r'), hold off

% 
% [x2, y2] = get_interest_points(image2_bw, feature_width);
% 
% figure
% imshow(image2),hold on
% % scatter(x0,y0,'b'), hold on
% scatter(x2,y2,'r'), hold off