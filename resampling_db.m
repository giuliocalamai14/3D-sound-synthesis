function resampling_db

Elevations = -40:10:90;

AzimuthStep = [repmat(5, 1, 10), 10, 15, 30, 360];

Distances = [20:10:50, 75, 100, 130, 160];

filepath='/Users/giuliocalamai/Documents/MATLAB/HRTF_interpolation_convolution/PKU-IOA HRTF database/';
% MAIN loop
n = 0;

for dist = Distances
    elei = 0;
    for elev = Elevations
        elei = elei+1;
        for azi = 0:AzimuthStep(elei):360
            n = n+1;
            filename = [filepath, 'dist', int2str(dist), '/elev', int2str(elev), '/azi', int2str(azi), '_elev', int2str(elev), '_dist', int2str(dist), '.dat'];
            
            %Prelevo dal file .dat del database le hrirl e hrirr e le salvo
            %in hrir
            p = fopen(filename,'r');
            hrirl = fread(p, 1024, 'double');
            fclose(p);
            p = fopen(filename,'r');
            fseek(p,1024*8,'bof');
            hrirr = fread(p, 1024, 'double');
            fclose(p);
            
           
            %eseguo resampling da 65536 --> 8192 del file hrir
            hrirl = resample (hrirl,8192,65536);
            hrirr = resample (hrirr,8192,65536);
            hrir = vertcat(hrirl,hrirr);
           
            %creo un nuovo file e ci scrivo quello che ho preso
            %precedentemente
            filenew = ['azi', int2str(azi), '_elev', int2str(elev), '_dist', int2str(dist), '.dat'];
            p = fopen(filenew,'w');
            fwrite(p,hrir,'double');
            fclose(p);   
        end
    end
end

end
