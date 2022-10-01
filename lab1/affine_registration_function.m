function [e]=affine_registration_function(par,scale,img_mov,img_fix,mtype,ttype)
% This function affine_registration_image, uses affine transfomation of the
% 3D input volume and calculates the registration error after transformation.
%
% I=affine_registration_image(parameters,scale,img_mov,img_fix,type);
%
% input,
%   parameters (in 2D) : Rigid vector of length 3 -> [translateX translateY rotate]
%                        or Affine vector of length 7 -> [translateX translateY  
%                                           rotate resizeX resizeY shearXY shearYX]
%
%   parameters (in 3D) : Rigid vector of length 6 : [translateX translateY translateZ
%                                           rotateX rotateY rotateZ]
%                       or Affine vector of length 15 : [translateX translateY translateZ,
%                             rotateX rotateY rotateZ resizeX resizeY resizeZ, 
%                             shearXY, shearXZ, shearYX, shearYZ, shearZX, shearZY]
%   
%   scale: Vector with Scaling of the input parameters with the same lenght
%               as the parameter vector.
%   img_mov: The 2D/3D image which is affine transformed
%   img_fix: The second 2D/3D image which is used to calculate the
%       registration error
%   mtype: Metric type: s: sum of squared differences.
%
% outputs,
%   I: An volume image with the registration error between img_mov and img_fix
%
% example,
%
% Function is written by D.Kroon University of Twente (July 2008)
x=par.*scale;

switch ttype
    case 'r'
        % Make the affine transformation matrix
        M = [ cos(x(3)) sin(x(3)) x(1);
            -sin(x(3)) cos(x(3)) x(2);
            0 0 1];
    case 'a'
        M = [ cos(x(3))*x(4) sin(x(3)) x(1);
             -sin(x(3)) cos(x(3))*x(5) x(2);
              x(6) x(7) 1];
end

img_reg = affine_transform_2d_double(double(img_mov), double(M), 0);

% metric computation
switch mtype
    case 'sd' % squared differences
        e=sum((img_reg(:)-img_fix(:)).^2)/numel(img_reg);
    case 'cc' % negative cross correlation
        fixed_diff = img_fix - mean(img_fix(:));
        moving_diff = img_reg - mean(img_reg(:));
        num = sum(sum(fixed_diff .* moving_diff));
        denom = sqrt(sum(sum(fixed_diff.^2)) * sum(sum(moving_diff.^2)));
        e = -num/denom;
    case 'gcc'

    otherwise
        error('Unknown metric type');
end

