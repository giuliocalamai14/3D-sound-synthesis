%% Get adjacency list for delaunay triangulation
% T: connectivity list (tetrahedral mesh) of delaunay triangulation 
function N = dtNeighbours(T)

% create matrix containing all edges/faces
NT = size(T,1);
Tdim = size(T,2);
face = zeros(Tdim*NT,Tdim-1);
vinds = zeros(Tdim*NT,1);
Tinds = zeros(Tdim*NT,1);
ptr1 = 1;
ptr2 = NT;

for fi = 1:Tdim
    inds = 1:Tdim;
    inds(fi) = [];
    face(ptr1:ptr2,:) = T(:,inds);
    face(ptr1:ptr2,:) = sort(face(ptr1:ptr2,:), 2);
    vinds(ptr1:ptr2) = fi;
    Tinds(ptr1:ptr2) = 1:NT;
    ptr1 = ptr1+NT;
    ptr2 = ptr2+NT;
end
[faceS, indS] = sortrows(face);
vindsS = vinds(indS);
TindsS = Tinds(indS);

N = -ones(size(T));

n = 0;
while n<size(faceS,1)-1
    n = n+1;
    f1 = faceS(n,:);
    f2 = faceS(n+1,:);
    if sum(f1==f2)==(Tdim-1)
        % found matching edge/face!
        t1 = TindsS(n);
        t2 = TindsS(n+1);
        vi1 = vindsS(n);
        vi2 = vindsS(n+1);
        N(t1,vi1) = t2;
        N(t2,vi2) = t1;
        n = n+1;
    end
end

end
