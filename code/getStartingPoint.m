function [m1,m2] = getStartingPoint(match1,match2,number)
    flag=1;
    while(flag==1)
        perm = randperm(size(match1,1),number);
        m1 = match1(perm,:);
        m2 = match2(perm,:);
        m1 = unique(m1,'rows');
        m2 = unique(m2,'rows');
        if( size(m1,1)==number && size(m2,1)==number )
            flag=0;
        end
    end
end