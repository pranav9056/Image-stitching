function [F] = fit_fundamental(matches)
    src = matches(1:8,1:2);
    dest = matches(1:8,3:4);
    %[src,dest] = getStartingPoint(matches(:,1:2),matches(:,3:4),8);
    %A =  [src(:,1).*dest(:,1),src(:,1).*dest(:,2),src(:,1),src(:,2).*dest(:,1),src(:,2).*dest(:,2),src(:,2),dest(:,1),dest(:,2),ones([size(src,1),1])];
    A =  [dest(:,1).*src(:,1),dest(:,1).*src(:,2),dest(:,1),dest(:,2).*src(:,1),dest(:,2).*src(:,2),dest(:,2),src(:,1),src(:,2),ones([size(src,1),1])];
    [U,S,V] = svd(A,0);
    F = reshape(V(:,end), 3, 3)';
    T=F;
    [U,S,V] = svd(F);
    S(3,3) = 0;
    S = S/S(1,1);
    F = U*S*V';

end