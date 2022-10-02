function [img_reg, M] = multiscale_affine_registration_2d(img_mov, img_fix, mtype, ttype, n_scales)
% This function estimates in a, multiscale fashion the parameters of a 2D affine ranformation
%
% img_reg, M = multiscale_affine_registration_2d(img_mov, img_fix, mtype, ttype, n_scales)
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

% Make sure the image has even dimentions
img_size = size(img_mov);
for i=1:2
    if mod(img_size(i), 2) ~= 0
        new_size = img_size;
        new_size(i) = img_size(i) - 1;
        img_mov = imresize(img_mov, new_size, 'bicubic');
        img_fix = imresize(img_fix, new_size, 'bicubic');
    end
end

% Scale, compute, recycle parameters, repeat
img_size = img_size / (2*n_scales);
for i=1:n_scales
    % Scale and recycle parameters
    if (i==1)
        img_mov_r = imresize(img_mov, img_size, 'bicubic');
        switch ttype
            case 'r'
                x = [0 0 0];
                scale = [1 1 0.1];
            case 'a'
                x = [0 0 0 0 0 0 0];
                scale = [0.1 0.1 0.1 0.1 0.1 0.1 0.1];
        end
    else
        img_size = img_size * 2;
        img_mov_r = imresize(img_mov, img_size*2, 'bicubic');
        switch ttype
            case 'r'
                x = [0 0 0];
                x(3) = acos(M(1,1));
                x(2) = M(2,3);
                x(1) = M(1,3);
                scale = [1 1 0.1];
            case 'a'
                x = [0 0 0 0 0 0 0];
                x(1) = M(1,3);
                x(2) = M(2,3);
                x(3) = asin(M(1,2));
                x(4) = M(1,1) / cos(x(3));
                x(5) = M(2,2) / cos(x(3));
                x(6) = M(3,1);
                x(7) = M(3,2);
                scale = [0.1 0.1 0.1 0.1 0.1 0.1 0.1];
        end
    end
    
    % Compute registration
    x = x./scale;
    
    [x] = fminsearch(...
        @(x)affine_registration_function(...
            x, scale, img_mov_r, img_fix, mtype, ttype), ...
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
        case 'a'
            M = [cos(x(3))*x(4) sin(x(3)) x(1);
                 -sin(x(3)) cos(x(3))*x(5) x(2);
                 x(6) x(7) 1];
    end
    
    % Transform the image 
    img_reg = affine_transform_2d_double(double(img_mov_r), double(M), 3);
end
end

