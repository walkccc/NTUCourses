function feature = addFeature(x, y, feature)
    if x >= 0 && y >= 0                                     % (I)
        if x <= y feature(1) = feature(1) + 1; end
        if x >= y feature(2) = feature(2) + 1; end
        
    elseif x >= 0 && y <= 0                                 % (VI)
        if x >= abs(y) feature(3) = feature(3) + 1; end
        if x <= abs(y) feature(4) = feature(4) + 1; end
        
    elseif x <= 0 && y <= 0                                 % (III)
        if abs(x) <= abs(y) feature(5) = feature(5) + 1; end
        if abs(x) >= abs(y) feature(6) = feature(6) + 1; end
        
    elseif x <= 0 && y >= 0                                 % (II)
        if abs(x) >= y feature(7) = feature(7) + 1; end
        if abs(x) <= y feature(8) = feature(8) + 1; end
        
    end
end