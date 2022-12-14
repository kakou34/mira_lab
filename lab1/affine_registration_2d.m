function [img_reg, M] = affine_registration_2d(img_mov, img_fix, mtype, ttype)
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
switch ttype
    case 'r'
        x = [0 0 0];
        scale = [1 1 1];
    case 'a'
        x = [0 0 0 1 1 0 0];
        scale = [1 1 1 1 1 1 1];
end
x = x./scale;

% Optimize the parameters 
[x] = fminsearch(...
    @(x)affine_registration_function(...
        x, scale, img_mov, img_fix, mtype, ttype), ...
    x, optimset('Display', 'iter', 'MaxIter', 1000, ...
        'TolFun', 1.000000e-10, 'TolX', 1.000000e-10, ...
        'MaxFunEvals', 1000*length(x)));

x = x.*scale;


% Obtain the affine transformation matrix
switch ttype
    case 'r'
        M = [cos(x(3)) sin(x(3)) x(1);
             -sin(x(3)) cos(x(3)) x(2);
             0 0 1];
        M = inv(M);
    case 'a'
            % Translation Matrix
            T = [1     0      x(1);
                 0     1      x(2);
                 0     0      1  ];
            % Scaling matrix
            S = [x(4)     0      0;
                 0        x(5)   0;
                 0        0      1];
            % Rotation Matrix
            R = [cos(x(3))      sin(x(3))   0;
                 -sin(x(3))     cos(x(3))   0;
                 0              0           1];
            % Shearing Matrix   
            Sh = [1    x(6)    0;
                 x(7)   1      0;
                 0      0      1];
            % Affine Transformation Matrix
            M = T * S * R * Sh;
            % Inverse Transformation Matrix
            M = inv(M);

end

% Transform the image 
img_reg = affine_transform_2d_double(double(img_mov), double(M), 1);
end

