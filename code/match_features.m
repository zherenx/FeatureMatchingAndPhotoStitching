% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the interest points as additional features.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

[n1, ~] = size(features1);
[n2, ~] = size(features2);

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
    matches = [matches; [i j_best];];
    ratio = ssd_best / ssd_2ndBest;
    confidences = [confidences; ratio;];
end

% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);