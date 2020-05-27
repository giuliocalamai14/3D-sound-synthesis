%% get OCTREE
% Organise 3-D points pts into an octree data structure
% 
% binCapacity: maximum number of points per leaf node

function OT = getOT(pts, binCapacity)
% inits
OT = struct;

% start with root
OT.Points = pts;
OT.PointBins = ones(size(pts,1),1);
OT.BinBoundaries = [min(pts), max(pts)];
OT.BinParents = 0;
OT.BinDepths = 0;

% MAIN LOOP
OT = getChildren(OT,1,binCapacity);
OT.BinCount = size(OT.BinParents,1);

end