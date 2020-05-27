function [HRIRL,HRIRR]=HRIR_interpolation(azi, ele, dist, OT, T, X, N,dim_sampling)
                            
USE_OCTREE = true;          % true:  use Octree query to find starting 
                            %        tetrahedron for adjacency walk
USE_ADJACENCY_WALK = true;  % false: use random starting tetrahedron for
                            %        adjacency walk

if dist>160
    dist=160;
end

source_pos = [azi, ele, dist]; % desired source position (azimuth [deg], elevation [deg], radius [cm])

if USE_OCTREE 
    % find close tetrahedron
    disp('Querying octree...');
    ti = queryOT(source_pos, OT);
    disp(['Using tetrahedron ', num2str(ti), ' as starting point for adjacency walk']);
else
    ti = 1;
end

% variable initialisations
Niter = 0;
tetra_indices = zeros(size(T,1),1);
MIN_GAIN = -0.00001;        % due to numerical issues, very small negative 
                            % gains are considered 0

%%%% MAIN LOOP %%%%

% iterate through mesh to find tetrahedron for interpolation
disp(['Iterating through ', num2str(size(T,1)), ' tetrahedra...']);
for t = 1:size(T,1)
    % count iterations
    Niter = Niter+1;
    
    % vertices of tetrahedron
    HM = X(T(ti,:),:);
    v4 = HM(4,:);
    H = HM(1:3,:) - repmat(v4,3,1);
    tetra_indices(t) = ti;
    
    % calculate barycentric coordinates
    bary_gains = [(source_pos-v4)*(H^-1), 0];
    bary_gains(4) = 1-sum(bary_gains);
    
    % check barycentric coordinates
    if all(bary_gains>=MIN_GAIN)
        bary_gains = max(bary_gains, 0);
        disp('Success!');
        disp(['Tetrahedron ID: ', num2str(ti), ', iterations: ', num2str(Niter)]);
        tetra_indices = tetra_indices(1:Niter);
        break;
    end
    
    if USE_ADJACENCY_WALK
        % move to adjacent tetrahedron
        [tmp, bi] = min(bary_gains);
        ti = N(ti,bi);
    else
        % BRUTE-FORCE: move to next tetrahedron in list
        ti = ti+1;
    end
end

if tetra_indices(end)==0
    error('No tetrahedron found. Exiting...');
end


% HRIR model from database
HM = X(T(tetra_indices(end),:),:);
if dim_sampling == 128
    pathname='/YOUR_PATH/HRTF_interpolation_convolution/PKU-IOA HRTF database (8192 Hz)/';
else
    pathname='/YOUR_PATH/HRTF_interpolation_convolution/PKU-IOA HRTF database (65536 Hz)/';
end

hrirl = zeros(dim_sampling,4);
hrirr = zeros(dim_sampling,4);

for hi = 1:4
    
    azi = HM(hi,1);
    ele = HM(hi,2);
    dist = HM(hi,3);
   
    hrirl(:,hi) = readhrir(pathname, dist, ele, azi, 'l', dim_sampling);
    hrirr(:,hi) = readhrir(pathname, dist, ele, azi, 'r', dim_sampling);
    
end

%%%% INTERPOLATE %%%%
disp('>>> Interpolation: <<<');
disp('bary_gains * abs(HRTF)');

%HRIRL = ((bary_gains*abs(hrirl'))');
%HRIRR = ((bary_gains*abs(hrirr'))');

HRIRL = ((bary_gains*hrirl')');
HRIRR = ((bary_gains*hrirr')');

end

