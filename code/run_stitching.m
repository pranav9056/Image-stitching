function run_stitching()
    listing = dir('../data/part1/');
    if ~exist('../result','dir')
        mkdir('../result');
    end
    for i= 3:size(listing,1)
        [canvas]=stitching([listing(i).folder,'/',listing(i).name],listing(i).name);
        imshow(canvas);
        saveas(gcf,['../result/',listing(i).name,'.jpg']);
        disp('--------------------------------------------------------------');

    end

end