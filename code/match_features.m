function [matches, confidences] = match_features(features1, features2)

[n1, ~] = size(features1);
[n2, ~] = size(features2);

ssd_best_threshold = 1000;
ratio_threshold = 0.6;

matches = [];
confidences = [];


for i = 1:n1
    ssd_best = Inf;
    ssd_2ndBest = Inf;
    j_best = 0;
    for j = 1:n2
        feature1 = features1(i, :);
        feature2 = features2(j, :);
        
        sd = (feature1 - feature2) .^ 2;
        ssd = sum(sd(:));
        
        if ssd < ssd_best
            ssd_2ndBest = ssd_best;
            ssd_best = ssd;
            j_best = j;
        elseif ssd < ssd_2ndBest
            ssd_2ndBest = ssd;
        end
    end
    

    ratio = ssd_best / ssd_2ndBest;
    if ssd_best < ssd_best_threshold && ratio < ratio_threshold
        matches = [matches; [i j_best];];
        confidences = [confidences; (1-ratio);];
    end
end

[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);