function [best_fund_matrix,best_ratio,min_src,min_dest]=ransac_find(match1,match2,iteration,sizeI)
    best_ratio =0;
    treshhold = 5;
    best_fund_matrix=1;
    min_src = 0;
    min_dest = 0;
    match1_temp=0;
    match2_temp=0;
    best_residual=0;
    t=1;
    while (t) 
        for i  = 1:iteration
            residual = 0;
            clearvars match1_temp match2_temp;
            [src,dest] = getStartingPoint(match1,match2,8);
            F=fit_fundamental_norm([src,dest],sizeI);
            
            inlier = 0;
            outlier = 0;
%             for j = 1:size(match1,1)
%                 temp = [match2(j,:),1]*F*[match1(j,:),1]';
%                 if(abs(temp)<=treshhold)
%                     inlier = inlier+1;
%                     if exist('match1_temp','var')
%                         match1_temp = cat(1,match1_temp, match1(j,:));
%                         match2_temp = cat(1,match2_temp,match2(j,:));
%                     else
%                         match1_temp = match1(j,:);
%                         match2_temp = match2(j,:);
%                     end
%                 else
%                     outlier = outlier+1;
%                 end
%             end
%             
            
            L = (F * [match1(:,1:2) ones(size(match1,1),1)]')'; % transform points from 
            % the first image to get epipolar lines in the second image

            % find points on epipolar lines L closest to matches(:,3:4)
            L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
            pt_line_dist = sum(L .* [match2(:,1:2) ones(size(match1,1),1)],2);
            inlier=sum(abs(pt_line_dist)<=treshhold);
            outlier=sum(abs(pt_line_dist)>treshhold);
            match1_temp=match1(find(abs(pt_line_dist)<=treshhold),:);
            match2_temp=match2(find(abs(pt_line_dist)<=treshhold),:);
            residual = pt_line_dist(find(abs(pt_line_dist)<=treshhold));
            residual = residual.^2;
            residual = sum(residual)/size(residual,1);
            

            
%            prevmultiplier = [0 0 0];
%             for j = 1:size(match1,1)
%                 multiplier = [match1(j,:), 1]';
%                 if(sum(prevmultiplier == multiplier)~=3)
%                     res = X * multiplier;
%                     res = res ./ res(3);
%                     res = res';
%                 end
%                 dist = pdist2(res,[match2(j,:),1]);
%                 residual = residual + dist^2;
%                 prevmultiplier = multiplier;
%                 if(dist>treshhold)
%                     outlier= outlier+1;
%                 else
%                     inlier = inlier+1;
%                 end
%             end
            ratio = inlier/(inlier+outlier);
            if(ratio>best_ratio)
                best_ratio = ratio;
                best_fund_matrix = F;
                min_src = match1_temp;
                min_dest = match2_temp;
                best_residual = residual;
                best_inlier  = inlier;
            end
        end
        if(best_ratio >.3)
                t=0;
                disp('Residual');
                disp(best_residual);
                disp('Inliers');
                disp(best_inlier);
                disp('Ratio');
                disp(best_ratio);
        end
    end
end


