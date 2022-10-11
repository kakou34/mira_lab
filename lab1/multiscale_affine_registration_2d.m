function [img_reg, M] = multiscale_affine_registration_2d(img_mov, img_fix, mtype, ttype, n_resolutions)
% This function estimates in a, multiscale fashion the parameters of a 2D affine ranformation
%
% img_reg, M = multiscale_affine_registration_2d(img_mov, img_fix, mtype, ttype, n_resolutions)
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
%   n_resolutions: the number of resolutions to be used in the registration
%   pyramid
% output,
%   img_out: The transformed image

% Make sure the image has even dimentions
img_size = size(img_mov);
% for i=1:2
%     if mod(img_size(i), 2) ~= 0
%         new_size = img_size;
%         new_size(i) = img_size(i) - 1;
%         img_mov = imresize(img_mov, new_size, 'bicubic');
%         img_fix = imresize(img_fix, new_size, 'bicubic');
%     end
% end

% Scale, compute, recycle parameters, repeat
img_size = img_size / (2*n_resolutions);
for i=1:n_resolutions
    
    % Scale and recycle parameters
    if (i==1)
        img_mov_r = imresize(img_mov, img_size, 'bicubic');
        img_fix_r = imresize(img_fix, img_size, 'bicubic');
        switch ttype
            case 'r'
                x = [0 0 0];
                scale = [1 1 1];
            case 'a'
                x = [0 0 0 1 1 0 0];
                scale = [1 1 1 1 1 1 1]; 

        end
    else
        img_size = img_size * 2;
        img_mov_r = imresize(img_mov, img_size, 'bicubic');
        img_fix_r = imresize(img_fix, img_size, 'bicubic');
    end
    
    % Compute registration
    x = x./scale;
    
    [x] = fminsearch(...
        @(x)affine_registration_function(...
            x, scale, img_mov_r, img_fix_r, mtype, ttype), ...
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

            T = [1     0      x(1);
                 0     1      x(2);
                 0     0      1  ];
            
            S = [x(4)     0      0;
                 0        x(5)   0;
                 0        0      1];
            
            
            R = [cos(x(3))      sin(x(3))   0;
                 -sin(x(3))     cos(x(3))   0;
                 0              0           1];
            
                
            Sh = [1      x(6)      0;
                 x(7)   1         0;
                 0      0         1];

            M = T * S * R * Sh;

            M = inv(M);
    end

    %rescale translation parameters for the next iteration 
    switch ttype
        case 'r'
           x = x .* [2 2 1];
          
        case 'a'
           x = x .* [2 2 1 1 1 1 1];
   end
end

    % Transform the original moving image with the final transformation matrix obtained 
    img_reg = affine_transform_2d_double(double(img_mov), double(M), 3);
end

