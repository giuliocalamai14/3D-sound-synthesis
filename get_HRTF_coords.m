%% Get HRTF coordinates
function aziEleDist = get_HRTF_coords
% Get the HRTF coordinates used in the PKU&IOA HRTF database [1]
%
% [1] Qu, T., Xiao, Z., Gong, M., Huang, Y., Li, X., and Wu, X. (2009).
% "Distance-dependent head-related transfer functions measured with high
% spatial resolution using a spark gap", IEEE Audio, Speech, Language
% Process. 17, 1124?1132.

% Elevations measured
Elevations = -40:10:90;

% Azimuth steps from lowest to highest elevation
AzimuthStep = [repmat(5, 1, 10), 10, 15, 30, 360];

% Distances measured
Distances = [20:10:50, 75, 100, 130, 160];

% Total number of HRTFs in database
NumHRTFs = sum(360./AzimuthStep)*length(Distances);

% preallocate output array
aziEleDist = zeros(NumHRTFs,3);

% MAIN loop
n = 0;
for dist = Distances
    elei = 0;
    for ele = Elevations
        elei = elei+1;
        for azi = 0:AzimuthStep(elei):360
            n = n+1;
            aziEleDist(n,:) = [azi, ele, dist];
        end
    end
end

end