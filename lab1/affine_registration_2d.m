function [Icor, M] = affine_registration_2d(Im, If, mtype, ttype)
%Example of 2D affine registration
%   Robert Martí  (robert.marti@udg.edu)
%   Based on the files from  D.Kroon University of Twente 
% mtype = 'cc'; % metric type: sd: ssd gcc: gradient correlation; cc: cross-correlation
% ttype = 'r'; % rigid registration, options: r: rigid, a: affine

% Parameter scaling of the Translation and Rotation
% and initial parameters
switch ttype
    case 'r'
        x=[0 0 0];
        scale = [1 1 0.1];
    case 'a'
        x=[0 0 0 0 0 0 0];
        scale = [1 1 0.1 1 1 1 1];
end

x=x./scale;

[x]=fminsearch(@(x)affine_registration_function(x,scale,Im,If,mtype,ttype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-10,'TolX',1.000000e-10, 'MaxFunEvals', 1000*length(x)));

x=x.*scale;
disp(x)
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

 % Transform the image 
Icor=affine_transform_2d_double(double(Im),double(M),0); % 3 stands for cubic interpolation

% Show the registration results
% figure,
% subplot(2,2,1), imshow(If);
% subplot(2,2,2), imshow(Im);
% subplot(2,2,3), imshow(Icor);
% subplot(2,2,4), imshow(abs(If-Icor));
end

