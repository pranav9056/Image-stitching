function fundamental_matrix(name)
    %%
    %% load images and match files for the first example
    %%

    I1 = imread(['../data/part2/',name,'1.jpg']);
    I2 = imread(['../data/part2/',name,'2.jpg']);
    matches = load(['../data/part2/',name,'_matches.txt']); 
    % this is a N x 4 file where the first two numbers of each row
    % are coordinates of corners in the first image and the last two
    % are coordinates of corresponding corners in the second image: 
    % matches(i,1:2) is a point in the first image
    % matches(i,3:4) is a corresponding point in the second image

    N = size(matches,1);

    %%
    %% display two images side-by-side with matches
    %% this code is to help you visualize the matches, you don't need
    %% to use it to produce the results for the assignment
    %%
    imshow([I1 I2]); hold on;
    plot(matches(:,1), matches(:,2), '+r');
    plot(matches(:,3)+size(I1,2), matches(:,4), '+r');
    line([matches(:,1) matches(:,3) + size(I1,2)]', matches(:,[2 4])', 'Color', 'r');
    pause;
    % 
    % %%
    % %% display second image with epipolar lines reprojected 
    % %% from the first image
    % %%
    % 
    % % first, fit fundamental matrix to the matches
    
    
    F = fit_fundamental_norm(matches,size(I1)); % this is a function that you should write
    %[src,dest] = getStartingPoint(matches(:,1:2),matches(:,3:4),8);

    %F = estimateFundamentalMatrix(typecast(src,int32),typecast(dest,int32));
    %F = estimateFundamentalMatrix(matches(:,1:2),matches(:,3:4))
    %F = fit_fundamental(matches); % this is a function that you should write
    
    
    %[F,R,match1,match2] = ransac_find(matches(:,1:2),matches(:,3:4),200,size(I1));
    L = (F * [matches(:,1:2) ones(N,1)]')'; % transform points from 
    % the first image to get epipolar lines in the second image
    
    % find points on epipolar lines L closest to matches(:,3:4)
    L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
    pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
    closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
    
    % find endpoints of segment on epipolar line (for display purposes)
    pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
    pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;
    
    % display points and segments of corresponding epipolar lines
    residual = pt_line_dist.^2;
    residual = sum(residual)/size(residual,1);
    disp(['Residual for Groundtrith  -',name])
    disp(residual);
    
    clf;
    close all;
    imshow(I2); hold on;
    title('Fundamental Matrix using Normalized Algo')
    plot(matches(:,3), matches(:,4), '+r');
    line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
    line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
    
    saveas(gcf,['../result/',name,'_normalized.jpg']);
%     %%% adding for matrix estimation

    F = F';
    L = (F * [matches(:,3:4) ones(N,1)]')'; % transform points from 
    % the first image to get epipolar lines in the second image
    
    % find points on epipolar lines L closest to matches(:,3:4)
    L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
    pt_line_dist = sum(L .* [matches(:,1:2) ones(N,1)],2);
    closest_pt = matches(:,1:2) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
    
    % find endpoints of segment on epipolar line (for display purposes)
    pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
    pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;
    
    close all;
    imshow(I1); hold on;
    title('Fundamental Matrix using Normalized Algo')
    plot(matches(:,1), matches(:,2), '+r');
    line([matches(:,1) closest_pt(:,1)]', [matches(:,2) closest_pt(:,2)]', 'Color', 'r');
    line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
    
    saveas(gcf,['../result/',name,'_1_normalized.jpg']);
    residual = pt_line_dist.^2;
    residual = sum(residual)/size(residual,1);
    disp(['Residual for Groundtrith  -',name])
    disp(residual);

    


    img = cell(2,1);
    feature_space = cell(2,1);
    feature_space_val = cell(2,1);
    imgstore=cell(2,1);
%     imgstore{1} = im2double(imread(['../data/part2/',name,'1.jpg']));
%     temp=double(rgb2gray(imread(['../data/part2/',name,'1.jpg'])));
%     [x,y,rad] = blob('../data/part2/house1.jpg');
%     feature_space{1} = find_sift(temp,cat(2,x,y,rad),1.5);
%     feature_space_val{1} = cat(2,x,y);
%     img{1} = temp;
%     imgstore{2} = im2double(imread(['../data/part2/',name,'2.jpg']));
%     temp=double(rgb2gray(imread(['../data/part2/',name,'2.jpg'])));
%     [x,y,rad] = blob('../data/part2/house2.jpg');
%     feature_space{2} = find_sift(temp,cat(2,x,y,rad),1.5);
%     feature_space_val{2} = cat(2,x,y);
%     img{2} = temp;
    
    
    imgstore{1} = im2double(imread(['../data/part2/',name,'1.jpg']));
    temp=im2double(rgb2gray(imread(['../data/part2/',name,'1.jpg'])));
    [rad,x,y] = harris(temp,3,.01000,3,0);
    %feature_space_val{i} = cat(2,x,y);
    feature_space_val{1} = cat(2,y,x);
    % adding points as row,column and not as x,y IMPORTANT
    %         feature_space{i} = cell(1,size(x,1));
    temp1 = padarray(temp,[12,12],'replicate');
    origx = 12;
    origy = 12;
    for j = 1:size(x,1)
        xx = x(j);
        yy = y(j);
        r = 12;
        val = temp1(origx+xx-r:origx+xx+r,origy+yy-r:origy+yy+r);
        if j==1
            feature_space{1} = val(:)';
        else
            feature_space{1} = cat(1,feature_space{1},val(:)');
        end


    end
    img{1} = temp;
    
    imgstore{2} = im2double(imread(['../data/part2/',name,'2.jpg']));
    temp=im2double(rgb2gray(imread(['../data/part2/',name,'2.jpg'])));
    [rad,x,y] = harris(temp,3,.01000,3,0);
    %feature_space_val{i} = cat(2,x,y);
    feature_space_val{2} = cat(2,y,x);
    % adding points as row,column and not as x,y IMPORTANT
    %         feature_space{i} = cell(1,size(x,1));
    temp1 = padarray(temp,[12,12],'replicate');
    origx = 12;
    origy = 12;
    for j = 1:size(x,1)
        xx = x(j);
        yy = y(j);
        r = 12;
        val = temp1(origx+xx-r:origx+xx+r,origy+yy-r:origy+yy+r);
        if j==1
            feature_space{2} = val(:)';
        else
            feature_space{2} = cat(1,feature_space{2},val(:)');
        end


    end
    img{2} = temp;

    
    distMat = dist2(feature_space{1},feature_space{2});    
    noMatches = 70;
    [tempval,idxval]= sort(distMat(:));
    tempval = tempval(1:noMatches);
    idxval = idxval(1:noMatches);
    [i,j] = ind2sub(size(distMat),idxval);
    match1 = feature_space_val{1}(i,:);
    match2 = feature_space_val{2}(j,:);
    

    
    close all;
    matches1 = [match1,match2];
    imshow([I1 I2]); hold on;
    plot(matches1(:,1), matches1(:,2), '+r');
    plot(matches1(:,3)+size(I1,2), matches1(:,4), '+r');
    line([matches1(:,1) matches1(:,3) + size(I1,2)]', matches1(:,[2 4])', 'Color', 'r');
    pause;
    %match1 = cat(1,matches(1:100,1:2),match1(1:100,:));
    %match2 = cat(1,matches(1:100,3:4),match2(1:100,:));
    
    
    
    
    [F,R,match1,match2] = ransac_find(match1,match2,200,size(I1));
    %F = estimateFundamentalMatrix(matches(:,1:2),matches(:,3:4))
    F = fit_fundamental_norm([match1,match2],size(I1)); % this is a function that you should write
    L = (F * [match1(:,1:2) ones(size(match1,1),1)]')'; % transform points from 
    % the first image to get epipolar lines in the second image
    
    % find points on epipolar lines L closest to matches(:,3:4)
    L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
    pt_line_dist = sum(L .* [match2(:,1:2) ones(size(match2,1),1)],2);
    closest_pt = match2(:,1:2) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
    
    % find endpoints of segment on epipolar line (for display purposes)
    pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
    pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;
    
    % display points and segments of corresponding epipolar lines
    clf;
    close all;
    imshow(I2); hold on;
    title('Fundamental Matrix using RANSAC Algo')
    plot(match2(:,1), match2(:,2), '+r');
    line([match2(:,1) closest_pt(:,1)]', [match2(:,2) closest_pt(:,2)]', 'Color', 'r');
    line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
    saveas(gcf,['../result/',name,'_ransac.jpg']);


    
    
    P1 = load(['../data/part2/',name,'1_camera.txt']);
    P2 = load(['../data/part2/',name,'2_camera.txt']);
    [U,S,V] = svd(P1);
    T1 = V(:,end);
    T1 = T1/T1(4);
    [U,S,V] = svd(P2);
    T2 = V(:,end);
    T2 = T2/T2(4);
    disp('Camera 1 Coordinates')
    disp(T1)
    disp('Camera 2 Coordinates')
    disp(T2)

    match1 = matches(:,1:2);
    match2 = matches(:,3:4);
    residual = 0;
    for i = 1:size(matches,1)
        m1 = match1(i,:);
        m2 = match2(i,:);
        A = [m1(2)*P1(3,:)-P1(2,:);P1(1,:)-m1(1)*P1(3,:);m2(2)*P2(3,:)-P2(2,:);P2(1,:)-m2(1)*P2(3,:)];
        [U,S,V] = svd(A);
        X = V(:,end);
        X = X/X(4);
        temp=P1*X;
        temp=temp/temp(3);
        temp=temp(1:2)';
        temp=temp-m1;
        temp=temp.^2;
        temp=sum(temp);
        temp1=P2*X;
        temp1=temp1/temp1(3);
        temp1=temp1(1:2)';
        temp1=temp1-m2;
        temp1=temp1.^2;
        temp1=sum(temp1);
        residual = residual+ (temp1+temp)/2;
        if (i==1)
            points = X';
        else
            points = cat(1,points,X');
        end
        
    end
    residual = residual/size(matches,1);
    disp(['Residual between 2D and 3D point for ',name]);
    disp(residual);
    close all;
    figure;
    scatter3(T1(1),T1(2),T1(3));
    hold on;
    scatter3(T2(1),T2(2),T2(3));
    scatter3(points(:,1)',points(:,2)',points(:,3)');
    title(['Visualization of 3D Points ' ,name]);
    legend('camera1','camera2','points')
    saveas(gcf,['../result/',name,'_3dplot.jpg']);
    close all;


    
end