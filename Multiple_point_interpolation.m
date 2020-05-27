

function [yL,yR] = Multiple_point_interpolation (w,mblock,y,OT,T,X,N,dim_sampling)

yL = zeros(length(y),1);
yR = zeros(length(y),1);

yL_app = zeros((length(y)+dim_sampling),1);
yR_app = zeros((length(y)+dim_sampling),1);
I = 1;
for i = 1:length(w)
    
 [HRIRL,HRIRR] = HRIR_interpolation(w(i,1),w(i,2),w(i,3),OT,T,X,N,dim_sampling);
  
        
   for n = I:(I+ mblock-1)
        
      tempL = HRIRL*y(n);
      tempR = HRIRR*y(n);
        
      yL_app(n:(n+dim_sampling-1)) = yL_app(n:(n+dim_sampling-1)) + tempL;
      yR_app(n:(n+dim_sampling-1)) = yR_app(n:(n+dim_sampling-1)) + tempR;
            
   end
    I = I + mblock;
end
yL(1:length(y)) = yL_app(1:length(y));
yR(1:length(y)) = yR_app(1:length(y));
end

