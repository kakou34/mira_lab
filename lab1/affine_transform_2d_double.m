function img_out = affine_transform_2d_double(img_in, M, mode, img_size)
% Affine transformation function (Rotation, Translation, Resize)
% This function transforms a volume with a 3x3 transformation matrix 
%
% img_out = affine_transform_2d_double(img_in, M, mode, img_size)
%
% inputs,
%   img_in: The input image
%   M: The (inverse) 3x3 transformation matrix
%   mode: If 0: linear interpolation and outside pixels set to nearest pixel
%            1: linear interpolation and outside pixels set to zero
%            (cubic interpolation only support by compiled mex file)
%            2: cubic interpolation and outsite pixels set to nearest pixel
%            3: cubic interpolation and outside pixels set to zero
%            4: nearest interpolation and outsite pixels set to nearest pixel
%            5: nearest interpolation and outside pixels set to zero
%   (optional) 
%	img_size: Size of output imgage
%
% output,
%   img_out: The transformed image
%
% Function based on one by D.Kroon University of Twente (February 2009)

% Set output image size
if(nargin<4), img_size = [size(img_in, 1) size(img_in, 2)]; end  

% Make all x,y indices
[x, y] = ndgrid(0:img_size(1)-1, 0:img_size(2)-1);

% Calculate center of the output image
mean_out = img_size/2;

% Calculate center of the input image
mean_in = size(img_in)/2;

% Make center of the image coordinates 0,0
xd = x - mean_out(1);
yd = y - mean_out(2);

% Calculate the Transformed coordinates
t_localx = mean_in(1) + M(1,1) * xd + M(1,2) *yd + M(1,3) * 1;
t_localy = mean_in(2) + M(2,1) * xd + M(2,2) *yd + M(2,3) * 1;

switch(mode)
	case 0
		interpolation = 'bilinear';
		boundary = 'replicate';
	case 1
		interpolation='bilinear';
		boundary = 'zero';
	case 2
		interpolation='bicubic';
		boundary = 'replicate';
	case 3
		interpolation='bicubic';
		boundary = 'zero';
	case 4
		interpolation='nearest';
		boundary = 'replicate';
	case 5
		interpolation='nearest';
		boundary = 'zero';		
end

img_out = image_interpolation( ...
    img_in, t_localx, t_localy, interpolation, boundary, img_size);
