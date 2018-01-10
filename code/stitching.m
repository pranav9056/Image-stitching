function [canvas]=stitching(ImgFolder,name)
    listing = dir([ImgFolder,'/*.jpg']);
    img = cell(size(listing,1),1);
    feature_space = cell(size(listing,1),1);
    feature_space_val = cell(size(listing,1),1);
    imgstore=cell(size(listing,1),1);

    if(~strcmp(name,'hill'))
    %with blobs and SIFT
    for i= 1:size(listing,1)
        imgstore{i} = im2double(imread([listing(i).folder,'/',listing(i).name]));
        temp=double(rgb2gray(imread([listing(i).folder,'/',listing(i).name])));
        [x,y,rad] = blob([listing(i).folder,'/',listing(i).name]);
        feature_space{i} = find_sift(temp,cat(2,x,y,rad),1.5);
        feature_space_val{i} = cat(2,x,y);
        img{i} = temp;
       
    end


    else
    %with harris
    for i= 1:size(listing,1)
        imgstore{i} = im2double(imread([listing(i).folder,'/',listing(i).name]));
        temp=double(rgb2gray(imread([listing(i).folder,'/',listing(i).name])));
        [rad,x,y] = harris(temp,2,1000,2,0);
        %feature_space_val{i} = cat(2,x,y);
        feature_space_val{i} = cat(2,y,x);
        % adding points as row,column and not as x,y IMPORTANT
%         feature_space{i} = cell(1,size(x,1));
        temp1 = padarray(temp,[4,4],'replicate');
        origx = 4;
        origy = 4;
        for j = 1:size(x,1)
            xx = x(j);
            yy = y(j);
            r = 4;
            val = temp1(origx+xx-r:origx+xx+r,origy+yy-r:origy+yy+r);
            if j==1
                feature_space{i} = val(:)';
            else
                feature_space{i} = cat(1,feature_space{i},val(:)');
            end
            
            
        end
        img{i} = temp;

        
        
    end
    end
    %plotlines(imgstore{1},imgstore{2},feature_space_val{1},feature_space_val{2});

%%------ code till here can be put into another function as feature extraction --------------------     
     distMat = dist2(feature_space{1},feature_space{2});    
%     [tempval,idxval]= sort(distMat,2);
%     threshold = 2;
%     for i = 1:size(tempval,1)
%         if i==1
%             match1 = repmat(feature_space_val{1}(i,:),[threshold,1]);
%             match2 = feature_space_val{2}(idxval(i,1:threshold),:);
%         else
%             match1 = cat(1,match1,repmat(feature_space_val{1}(i,:),[threshold,1]));
%             match2 = cat(1,match2,feature_space_val{2}(idxval(i,1:threshold),:));
%         end
%         
%     end
    
    %%%%% compute matches diffently
    noMatches = 200;
    [tempval,idxval]= sort(distMat(:));
    tempval = tempval(1:noMatches);
    idxval = idxval(1:noMatches);
    [i,j] = ind2sub(size(distMat),idxval);
    match1 = feature_space_val{1}(i,:);
    match2 = feature_space_val{2}(j,:);
    %plotlines(imgstore{1},imgstore{2},match1,match2);


%     for k = 1:noMatches
%         [i,j]=ind2sub(size(distMat),idxval(k));
%         if k==1
%             match1 = feature_space_val{1}(i,:);
%             match2 = feature_space_val{2}(j,:);
%         else
%             match1 = cat(1,match1,repmat(feature_space_val{1}(i,:),[threshold,1]));
%             match2 = cat(1,match2,feature_space_val{2}(idxval(i,1:threshold),:));
%         end
% 
%         
%     end

    
    %%%%%

    
    
    [H,R,S,D]=ransac(match1,match2,200);
    tform = maketform('projective',S,D);
    [trans_image,xData,yData] = imtransform(imgstore{1},tform);
    minx = ceil(min(xData(1),1));
    maxx = ceil(max(xData(2),size(imgstore{2},2)));
    miny = ceil(min(yData(1),1));
    maxy = ceil(max(yData(2),size(imgstore{2},1)));
    m1=0;
    m2=0;
    if(miny<0)
        m1=1;
        miny=miny-1;
    end
    if(minx<0)
        m2=1;
        minx=minx-1;
    end
    panorama = zeros(maxy-miny*m1,maxx-minx*m2,3);
    canvas2 = panorama;

    panorama(1:size(trans_image,1),1:size(trans_image,2),:)=trans_image(1:size(trans_image,1),1:size(trans_image,2),:);
    tt=imgstore{2};
    canvas2(1+abs(miny):abs(miny)+size(tt,1),abs(minx)+1:abs(minx)+size(tt,2),:)=tt(1:size(tt,1),1:size(tt,2),:);
    canvas = panorama + canvas2;
    overlap = panorama & canvas2;
    canvas(overlap) = canvas(overlap)/2;



end


