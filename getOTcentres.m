% get OT bin centres
function OT = getOTcentres(OT, T)
NPoints = size(OT.Points,1);
NBins = OT.BinCount;
OT.BinCentres = zeros(NBins,3);
OT.BinChildren = zeros(NBins,8);
for bi = 1:NBins
    bin_children = find(OT.BinParents==bi);
    if isempty(bin_children)
        % leaf node: insert a random point as a "child"
        pt = find(OT.PointBins==bi,1);
        if isempty(pt)
            % bin contains no point -> find closest point to bin centre
            binb = OT.BinBoundaries(bi,:);
            binc = (binb(1:3)+binb(4:6))./2;
            binn = sqrt(sum( (OT.Points-repmat(binc, NPoints,1)).^2,2 ));
            [tmp, pt] = min(binn);
        end
        
        % find a tetrahedron containing pt
        Tind = find(T==pt,1);
        Tind = bmod(Tind, size(T,1));
        
        OT.BinChildren(bi,2) = Tind;
        continue;
    end
    boundaries = OT.BinBoundaries(bin_children,:);
    
    % find centre
    x = unique(boundaries(:,[1,4]));
    y = unique(boundaries(:,[2,5]));
    z = unique(boundaries(:,[3,6]));
    OT.BinCentres(bi,:) = [x(2),y(2),z(2)];
    
    % store children in order
    for bch = 1:8
        chb = OT.BinBoundaries(bin_children(bch),:);
        chc = (chb(1:3)+chb(4:6))./2;
        chind = 0;
        for j = 1:3
            if chc(j) >= OT.BinCentres(bi,j)
                chind = chind + 2^(j-1);
            end
        end
        OT.BinChildren(bi,chind+1) = bin_children(bch);
    end
end
end

%% alternative modulus function
% mod(N,N) returns N (instead of 0)
% useful for indexing in Matlab
function y = bmod(x,a)
y = mod(x-1,a)+1;
end
