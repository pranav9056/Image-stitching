function [X] =  homographyEstimation(src,dest)
        a_end = dest';
        a_end = -a_end(:);
        for j = 1:size(src,1)
            if(j==1)
                l_temp = [src(j,:) 1;[0 0 0]];
            else
                l_temp = [l_temp ; src(j,:) 1;[0 0 0]];
            end
        end
        A = [l_temp , circshift(l_temp,1)];
        xtemp = repmat(src(:,1)',[2,1]);
        xtemp = xtemp(:) .* a_end;
        ytemp = repmat(src(:,2)',[2,1]);
        ytemp = ytemp(:) .* a_end;
        A = [A, xtemp,ytemp,a_end];
        [U,S,V] = svd(A);
        X = V(:,end);
        X=reshape(X,[3 3])';
        X = X./X(3,3)';

end