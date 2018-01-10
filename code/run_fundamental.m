function run_fundamental()
    listing = dir('../data/part2/');
    if ~exist('../result','dir')
        mkdir('../result');
    end
    fundamental_matrix('house');
    fundamental_matrix('library');

end

