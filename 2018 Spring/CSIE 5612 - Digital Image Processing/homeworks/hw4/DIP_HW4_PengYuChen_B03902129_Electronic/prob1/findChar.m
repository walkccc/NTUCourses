function [diff, matchIndex] = findChar(input_feature, training_features)
    diff = zeros(70, 1);        % difference between input_feature and training_features
    for i = 1: 70
        diff(i) = sqrt(sum(abs(training_features(i, :) - input_feature) .^ 2));
    end
    minCount = 10000;
    matchIndex = 0;
    
    for i = 1: 70
        if diff(i) < minCount
            
            minCount = diff(i);
            fprintf('diff(%d) = %f\n', i, diff(i));
            matchIndex = i;
        end
    end
    fprintf('-------------\n');
end