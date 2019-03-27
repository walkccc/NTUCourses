function cluster = kmeans(k, M)
    fprintf('Computing k-means\n');
    % Randomly initialize 3 centroids
    rands = zeros(k, 2);
    for i = 1: k * 2
        rands(i) = uint8(rand * 512);
    end
    
    rands(1, 1) = 128; rands(1, 2) = 128;
    rands(2, 1) = 256; rands(2, 2) = 256;
    rands(3, 1) = 384; rands(3, 2) = 384;
    
    % Initialize 3 * 9 (cx, cy)
    c = zeros(k, 9);
    for i = 1: k
        for j = 1: 9
            c(i, j) = M(rands(i, 1), rands(i, 2), j);
        end
    end
 
    % Initialize cluster array 
    cluster = zeros(512, 512);
    prevCluster = ones(512, 512);
    
    cnt = 0;
    while ~isequal(cluster, prevCluster)
        prevCluster = cluster;
        fprintf('iter %d: ', cnt);
        cnt = cnt + 1;
        fprintf('(%d, %d), (%d, %d), (%d, %d)\n', c(1, 1), c(1, 8), c(2, 1), c(2, 8), c(3, 1), c(3, 8));
     
        for i = 1: 512
            for j = 1: 512
                d = zeros(3, 1);
                for idx = 1: 9
                    if idx == 2 || idx == 3 || idx == 8 || idx == 6 || idx == 7 || idx == 9
                        continue
                    end
                    for k = 1: 3
                        d(k) = d(k) + (M(i, j, idx) - c(k, idx))^2;
                    end
                end
               
                % Label the cluster(i, j)
                if d(1) <= d(2) && d(1) <= d(3)
                    cluster(i, j) = 1; 
                elseif d(2) <= d(1) && d(2) <= d(3)
                    cluster(i, j) = 2;
                else
                    cluster(i, j) = 3;
                end
            end
        end
        
        c = zeros(k, 9);
        one = 0;
        two = 0;
        thr = 0;
        for i = 1: 512
            for j = 1: 512
                for idx = 1: 9
                    if cluster(i, j) == 1
                        c(1, idx) = c(1, idx) + M(i, j, idx);
                        one = one + 1;
                    elseif cluster(i,j) == 2
                        c(2, idx) = c(2, idx) + M(i, j, idx);
                        two = two + 1;
                    else
                        c(3, idx) = c(3, idx) + M(i, j, idx);
                        thr = thr + 1;
                    end
                end
            end
        end

        c(1, :) = c(1, :) / one;
        c(2, :) = c(2, :) / two;
        c(3, :) = c(3, :) / thr;
    end
    
    cluster = uint8(cluster * 80);
end