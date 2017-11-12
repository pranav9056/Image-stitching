function [best_homography,best_ratio,min_src,min_dest]=ransac(match1,match2,iteration)
    best_ratio =0;
    treshhold = 10;
    best_homography=1;
    min_src = 0;
    min_dest = 0;
    t=1;
    while (t) 
        for i  = 1:iteration
            [src,dest]=getStartingPoint(match1,match2,4);
            X=homographyEstimation(src,dest);
            inlier = 0;
            outlier = 0;
            prevmultiplier = [0 0 0];
            for j = 1:size(match1,1)
                multiplier = [match1(j,:), 1]';
                if(sum(prevmultiplier == multiplier)~=3)
                    res = X * multiplier;
                    res = res ./ res(3);
                    res = res';
                end
                dist = pdist2(res,[match2(j,:),1]);
                prevmultiplier = multiplier;
                if(dist>treshhold)
                    outlier= outlier+1;
                else
                    inlier = inlier+1;
                end
            end
            ratio = inlier/(inlier+outlier);
            if(ratio>best_ratio)
                best_ratio = ratio;
                best_homography = X;
                min_src = src;
                min_dest = dest;
            end
        end
        if(best_ratio >.3)
                t=0;
        end
    end
end