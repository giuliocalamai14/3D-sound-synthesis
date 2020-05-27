function Main_program (w,function_type,y,Fsout,dim_sampling,OT,T,X,N)


if dim_sampling == 1024
    y=resample(y,65536,8192);
end

filename1 = 'normal_audio.wav';
y = y / (max(abs(y))*10);
audiowrite(filename1,y,Fsout);
[y,Fs] = audioread(filename1);

if function_type == 1
    freq_agg = Fsout/256;
    mblock = Fsout/freq_agg;
    w = create_matrix_circumference(y,mblock);
end
if function_type == 2
    freq_agg = Fsout/256;
    mblock = Fsout/freq_agg;
    w = create_matrix_helix(y,mblock);       
end
if function_type == 3
    mblock = floor(length(y)/length(w));
    
    [theta,rho] = cart2pol(w(:,1),w(:,2));
    
    theta = rad2deg(theta);
    
    theta = mod((90-theta),360);
    
    w(:,1) = theta;
    w(:,2) = w(:,3);
    w(:,3) = rho;
    
end

w = check_matrix_value(w);

tic
[yL,yR] = Multiple_point_interpolation(w,mblock,y,OT,T,X,N,dim_sampling);
fvtool(y,1,yL,1,'Fs',Fsout)
sinad(yL,Fsout)

toc

clear y

if max(abs(yL)) > 1 || max(abs(yR)) > 1
    warning('Clipped audio channel');
end
yL = yL * 8;
yR = yR * 8;
binaural_audio = horzcat(yL,yR);
filename3 = 'binaural_audio.wav';
audiowrite(filename3,binaural_audio,Fsout);

final_audio = audioread(filename3);

sound (final_audio,Fsout);

end

function w = create_matrix_circumference(aud,mblock)

    
    max_length = floor(length(aud)/mblock);
    w = zeros(max_length,3);
    step = 360/max_length;
    value = 0;
    for i = 1:max_length
        
        w(i,1) = value;
        w(i,2) = 0;
        w(i,3) = 20;
        
        value = value + step;
    end
      
end

function w = create_matrix_helix(aud,mblock)
    disp('Creating matrix helix...');
    max_length = floor(length(aud)/mblock);
    w = zeros(max_length,3);
    step_grades = 720/max_length;
    step_ele = 130/max_length;
    
    azi = (0:step_grades:720)';
    elev = (-40:step_ele:90)';
    
    azi(end) = [];
    elev(end) = [];
  
    w(:,1) = azi;
    w(:,2) = elev;
    w(:,3) = 30;       
end

function w = check_matrix_value(w)

    for i = 1:length(w)
        
        if w(i,1) < 0
            w(i,1) = 360 + w(i,1);
        end
        if w(i,1) > 360 && w(i,1) < 720
            w(i,1) = w(i,1) - 360;
        end
        if w(i,1) > 720 && w(i,1) < 1080
            w(i,1) = w(i,1) - 720;
        end
         if w(i,1) > 1080 && w(i,1) < 1440
            w(i,1) = w(i,1) - 1080;
        end
        if w(i,2) < -40
            w(i,2) = -40;
        end
        if w(i,2) > 90
            w(i,2) = 90;
        end
        if w(i,3) < 20
            w(i,3) = 20;
        end
        
    end

end
