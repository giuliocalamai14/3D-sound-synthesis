function hrir = readhrir(filepath, dist, elev, azi, lr, dim_sampling)

if nargin ~= 6
    error('Wrong number of input arguments');
end
if dim_sampling == 128
    filename = [filepath, 'azi', int2str(azi), '_elev', int2str(elev), '_dist', int2str(dist), '.dat'];
else
    filename = [filepath, 'dist',int2str(dist),'/elev', int2str(elev),'/azi', int2str(azi), '_elev',int2str(elev), '_dist', int2str(dist), '.dat'];
end
p = fopen(filename,'r');

if lr == 'l'
    hrir = fread(p, dim_sampling, 'double');
end    
if lr == 'r'
    fseek(p,dim_sampling*8,'bof');
    hrir = fread(p, dim_sampling, 'double');
end
if lr == 'lr'
    hrir = fread(p, 'double');
    hrir = reshape(hrir, dim_sampling, 2);   
end

fclose(p);
end