function [img,feature_space,distMat,feature_space_val,match1,match2]=stitching(ImgFolder)
    listing = dir([ImgFolder,'/*.jpg']);
    img = cell(size(listing,1),1);
    feature_space = cell(size(listing,1),1);
    feature_space_val = cell(size(listing,1),1);
    %with blobs
%     for i= 1:size(listing,1)
%         temp=double(rgb2gray(imread([listing(i).folder,'/',listing(i).name])));
%         [x,y,rad] = blob([listing(i).folder,'/',listing(i).name]);
%         feature_space{i} = cell(1,size(x,1));
%         temp1 = padarray(temp,[floor(max(rad)),floor(max(rad))],'replicate');
%         origx = floor(max(rad));
%         origy = origx;
%         for j = 1:size(x,1)
%             xx = y(j);
%             yy = x(j);
%             r = floor(rad(j));
%             val = temp1(origx+xx-r:origx+xx+r,origy+yy-r:origy+yy+r);
%             feature_space{i}{j} = val(:);
%             
%             
%         end
%         img{i} = temp;
% 
%         
%         
%     end

    %with harris
    for i= 1:size(listing,1)
        temp=double(rgb2gray(imread([listing(i).folder,'/',listing(i).name])));
        [rad,x,y] = harris(temp,2,1000,2,1);
        feature_space_val{i} = cat(2,x,y);
%         feature_space{i} = cell(1,size(x,1));
        temp1 = padarray(temp,[2,2],'replicate');
        origx = 2;
        origy = 2;
        for j = 1:size(x,1)
            xx = x(j);
            yy = y(j);
            r = 2;
            val = temp1(origx+xx-r:origx+xx+r,origy+yy-r:origy+yy+r);
            if j==1
                feature_space{i} = val(:)';
            else
                feature_space{i} = cat(1,feature_space{i},val(:)');
            end
            
            
        end
        img{i} = temp;

        
        
    end
%%------ code till here can be put into another function as feature extraction --------------------     
    distMat = dist2(feature_space{1},feature_space{2});
    [tempval,idxval]= sort(distMat,2);
    threshold = 10;
    for i = 1:size(tempval,1)
        if i==1
            match1 = repmat(feature_space_val{1}(i,:),[threshold,1]);
            match2 = feature_space_val{2}(idxval(i,1:threshold),:);
        else
            match1 = cat(1,match1,repmat(feature_space_val{1}(i,:),[threshold,1]));
            match2 = cat(1,match2,feature_space_val{2}(idxval(i,1:threshold),:));
        end
        
    end



end