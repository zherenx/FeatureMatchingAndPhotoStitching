function [im, matches] = do_pipeline(im_ding, im_dong)
    feature_width = 16; %width and height of each local feature, in pixels.

    im_ding_bw = rgb2gray(im_ding);
    im_dong_bw = rgb2gray(im_dong);
    
    [x1, y1] = get_interest_points_modified(im_ding_bw, feature_width);
    [x2, y2] = get_interest_points_modified(im_dong_bw, feature_width);
    
    [im_ding_features] = get_features(im_ding_bw, x1, y1, feature_width);
    [im_dong_features] = get_features(im_dong_bw, x2, y2, feature_width);
    
    [matches, confidences] = match_features(im_dong_features, im_ding_features);
    homography = get_homography(matches, x2, y2, x1, y1);
    
    im = stitch_images_2(im_ding, im_dong, homography);
end