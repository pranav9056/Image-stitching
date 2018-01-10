function [cx,cy,rad] = blob(Img,iteration,sv,threshold_factor)
disp(['Runnig for Image:',Img]);
switch nargin
    case 3
        threshold_factor=1;
    case 2
        threshold_factor=1;
        sv=13;
    case 1
        iteration = 5;
        threshold_factor=1;
        sv=13;
    
end

img = imread(Img);
if size(img,3) ~= 1
    img = rgb2gray(img);
end
img1=img;
img=im2double(img);

scale=2;
scale_im = scale;
scale_space_n = cell(iteration,1);

row=size(img,1);
col=size(img,2);

for i = 1:iteration
    filter = fspecial('log',2*ceil(2.5*scale)+1,scale);
    temp = imfilter(img,filter,'same','replicate','conv');
    temp = temp.^2;
    
    scale_space_n{i} = temp;
    
    temp = imresize(temp,scale_im/2);
    temp1=ordfilt2(temp,sv^2,ones(sv,sv),'zeros');
    temp2 = (temp==temp1)&(temp>threshold_factor*mean(temp(:)));       % Find maxima. idea taken from harris.m
    temp = temp .* temp2;
    if exist('scale_col','var')
        scale_space = cat(3,scale_space,temp(1:row,1:col));
        scale_col=cat(2,scale_col,scale_im);
    else
        scale_col=scale_im;
        scale_space = temp;
    end
    scale_im = 2*scale_im;
    img=imresize(img,.5);
end

% new max extraction
[val_space,rad_space] =   max(scale_space,[],3);
rad_space = scale_col(rad_space)*(2^.5);
% end new max extraction

temp1=ordfilt2(val_space,sv^2,ones(sv,sv),'zeros');
temp2 = (val_space==temp1);       % Find maxima.
val_space = val_space .* temp2;
[cy,cx] = find(val_space);
for i = 1:size(cy)
    if exist('rad','var')
        rad=cat(1,rad,rad_space(cy(i),cx(i)));

    else
        rad = rad_space(cy(i),cx(i));
    end
        
end

close()
%show_all_circles(img1,cx,cy,rad,'r',1.5);

