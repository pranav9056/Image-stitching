function [F] = fit_fundamental_norm(matches,sImage)
    src = matches(:,1:2);
    dest = matches(:,3:4);
    %[src,dest] = getStartingPoint(matches(:,1:2),matches(:,3:4),8);
    norm = [2/sImage(2),0,-1;0,2/sImage(1),-1;0,0,1];
    newSrc = zeros(size(src));
    newDest  = zeros(size(dest));
    for i = 1:size(src,1)
       temp = norm*[src(i,:),1]';
       newSrc(i,:) = temp(1:2)';
       temp = norm*[dest(i,:),1]';
       newDest(i,:) = temp(1:2)';
    end
    %A =  [newSrc(:,1).*newDest(:,1),newSrc(:,1).*newDest(:,2),newSrc(:,1),newSrc(:,2).*newDest(:,1),newSrc(:,2).*newDest(:,2),newSrc(:,2),newDest(:,1),newDest(:,2),ones([size(src,1),1])];
    A =  [newDest(:,1).*newSrc(:,1),newDest(:,1).*newSrc(:,2),newDest(:,1),newDest(:,2).*newSrc(:,1),newDest(:,2).*newSrc(:,2),newDest(:,2),newSrc(:,1),newSrc(:,2),ones([size(src,1),1])];
    [U,S,V] = svd(A,0);
    F = reshape(V(:,end), 3, 3)';
    T=F;
    [U,S,V] = svd(F);
    S(3,3) = 0;
    S = S/S(1,1);
    F = U*S*V';
    F = norm'*F*norm;

end
