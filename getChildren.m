% Recursive call to split bin into octants
function OT = getChildren(OT, parent, binCapacity)
parentBoundaries = OT.BinBoundaries(parent,:);
for bini = 1:8
    binBoundaries = zeros(1, 6);
    rng = range(reshape(parentBoundaries,3,2),2)';
    binBoundaries(1:3) = bitget(bini-1,1:3).*rng/2 + parentBoundaries(1:3);
    binBoundaries(4:6) = binBoundaries(1:3) + rng/2;
    
    % add bin to list of bins
    OT.BinBoundaries = [OT.BinBoundaries; binBoundaries];
    OT.BinParents = [OT.BinParents; parent];
    OT.BinDepths = [OT.BinDepths; OT.BinDepths(parent)+1];
    currBin = size(OT.BinParents,1);
    
    % check if bin contains any points
    ptinds = (1:size(OT.Points,1))';
    ptinds = ptinds(OT.PointBins==parent);
    
    binPoints = inBin(OT.Points(ptinds,:), binBoundaries);
    binPoints = ptinds(binPoints);
    if ~isempty(binPoints)
        OT.PointBins(binPoints) = currBin;
        if length(binPoints)>binCapacity
            % keep dividing
            OT = getChildren(OT, currBin, binCapacity);
        end
    end
end
end

% Determine which points pts are contained in bin
function inds = inBin(pts, binBoundaries)
N = size(pts,1);
lpts = pts-repmat(binBoundaries(1:3),N,1);
upts = pts-repmat(binBoundaries(4:6),N,1);
inds = find(sum(lpts>=0 & upts<=0,2)==3);
end
