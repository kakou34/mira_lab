function [e]=affine_registration_function(par, scale, img_mov, img_fix, mtype, ttype)
% This function affine_registration_image, uses affine transfomation of the
% 3D input volume and calculates the registration error after transformation.
%
% I = affine_registration_image(parameters, scale, img_mov, img_fix, type);
%
% Inputs:
%   parameters (in 2D) : 
%       Rigid vector of length 3: 
%           [translateX translateY rotate]
%       Affine vector of length 7:
%           [translateX translateY rotate resizeX resizeY shearXY shearYX]
%   parameters (in 3D) : 
%       Rigid vector of length 6:
%           [translateX translateY translateZ rotateX rotateY rotateZ]
%       Affine vector of length 15: 
%           [translateX translateY translateZ,
%            rotateX rotateY rotateZ resizeX resizeY resizeZ,
%            shearXY, shearXZ, shearYX, shearYZ, shearZX, shearZY]
%   scale: Vector with Scaling of the input parameters with the same lenght
%               as the parameter vector.
%   img_mov: The 2D/3D image which is affine transformed
%   img_fix: The second 2D/3D image which is used to calculate the
%       registration error
%   mtype: Metric type: 
%       s: sum of squared differences.
%       nncc: negative normalized cross correlation.
%       gncc: negative gradient cross correlation.
% Outputs:
%   img_reg: Registered image.
% Function adapted from a code done by D.Kroon University of Twente.
x=par.*scale;

% Obtain the affine transformation matrix
switch ttype
    case 'r'
        M = [ cos(x(3)) sin(x(3)) x(1);
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

% Compute the affine transformation
img_reg = affine_transform_2d_double(double(img_mov), double(M), 1);

% Compute the metric
switch mtype
    case 'sd' % squared differences
        e = sum((img_reg(:)-img_fix(:)).^2)/numel(img_reg);
    case 'nncc' % negative normalized cross correlation
        fixed_diff = img_fix - mean(img_fix(:));
        moving_diff = img_reg - mean(img_reg(:));
        num = fixed_diff(:)' * moving_diff(:);
        d1 = fixed_diff(:)' * fixed_diff(:);
        d2 = moving_diff(:)' * moving_diff(:);
        e = 1 - num/sqrt(d1*d2);
    case 'nngcc' % negative normalized gradient cross correlation
        [gx_fix, gy_fix] = imgradientxy(img_fix);
        [gx_reg, gy_reg] = imgradientxy(img_reg);
        p = abs((gx_fix(:) .* gx_reg(:)) + (gy_fix(:) .* gy_reg(:)));
        e1 = gx_fix(:).^2 + gy_fix(:).^2;
        e2 = gx_reg(:).^2 + gy_reg(:).^2;
        e = 1 - sum(p)/sqrt(sum(e1)*sum(e2));
    otherwise
        error('Unknown metric type');
end

