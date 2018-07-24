[x1, y1] = get_interest_points(image1_bw, feature_width);
imshow(image1),hold on
scatter(x0,y0,'b'), hold on
scatter(x1,y1,'r'), hold off