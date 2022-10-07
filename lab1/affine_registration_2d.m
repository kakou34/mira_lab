function [img_reg, M, x] = affine_registration_2d(img_mov, img_fix, mtype, ttype)
% This function estimates the parameters of a 2D affine ranformation
%
% img_reg, M = affine_registration_2d(img_mov, img_fix, mtype, ttype)
%
% inputs,
%   img_mov: The moving image
%   img_fix: The fixed image
%   mtype: metric type:
%       'sd': ssd 
%       'nncc': negative normalized cross-correlation
%       'nngcc': negative normalized gradient correlation
%   ttype: registration type, options:
%       'r': rigid
%       'a': affine
% output,
%   img_out: The transformed image

% Parameter scaling of the Translation and Rotation and initial parameters
% switch ttype
%     case 'r'
%         x = [0 0 0];
%         scale = [1 1 0.1];
%     case 'a'
%         x = [0 0 0 1 1 0 0];
%         scale = [1 1 1 1 1 1 1];
% end

x = [1 0 0 0 1 0];
scale = [1 1 0.1 1 1 1];
x = x./scale;

[x] = fminsearch(...
    @(x)affine_registration_function(...
        x, scale, img_mov, img_fix, mtype, ttype), ...
    x, optimset('Display', 'iter', 'MaxIter', 100000, ...
        'TolFun', 1.000000e-10, 'TolX', 1.000000e-10, ...
        'MaxFunEvals', 1000*length(x)));

x = x.*scale;

x

% Obtain the affine transformation matrix
switch ttype
    case 'r'
        M = [cos(x(3)) sin(x(3)) x(1);
             -sin(x(3)) cos(x(3)) x(2);
             0 0 1];
        M = inv(M);
    case 'a'
             T = [1     0       x(1);
                  0     1      x(2);
                  0     0       1];

             S = [x(4)     0      0;
                  0        x(5)    0;
                  0         0      1];


             R = [cos(x(3))      sin(x(3))          0;
                 -sin(x(3))        cos(x(3))          0;
                 0                 0                 1];

    
           Sh = [1     x(6)       0;
                 x(7)   1         0;
                 0      0         1];

           M = T * S * R * Sh;
        M = inv(M);

end

% M = [x(1) x(2) x(3); 
%      x(4) x(5) x(6); 
%       0    0    1];

% Transform the image 
img_reg = affine_transform_2d_double(double(img_mov), double(M), 1);
end

