function [OT,T,X,N]=create_offline_info

USE_ADJACENCY_WALK = true;  % true:  use adjacency walk
                            % false: use brute-force search
binCapacity = 5;            % maximum number of points stored in each leaf 
                            % node of the octree
                                            
%%%% INITIALISATIONS %%%%
                            
% get HRTF measurement coordinates
disp('Retrieving HRTF measurement coordinates...');
aziEleDist = get_HRTF_coords;

% Generate tetrahedral mesh via Delaunay triangulation
disp('Generating tetrahedral mesh and adjacency map of measurement points...');
if str2double(datestr(datenum(version('-date')),'YYYY'))>=2013
    dt = delaunayTriangulation(aziEleDist);
    T = dt.ConnectivityList;    % contains the tetrahedral mesh
    X = dt.Points;              % contains the vertices of the tetrahedra
    N = neighbors(dt);          % contains the adjacency list
else
    % for older Matlab releases < 2013
    T = delaunay(aziEleDist(:,1), aziEleDist(:,2), aziEleDist(:,3));
    X = aziEleDist;
    N = dtNeighbours(T);
end

if ~USE_ADJACENCY_WALK
        warning('Octree search can only be used in conjunction with adjacency walk, otherwise the selection might not terminate...');
        USE_ADJACENCY_WALK = true;
end
    
% Generate octree
disp('Generating octree...'); 
OT = getOT(aziEleDist, binCapacity);
    
% get centres and one tetrahedron per octree leaf node
OT = getOTcentres(OT, T);

end