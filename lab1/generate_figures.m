% Clean environment
clear all; close all; clc;

% Read two imges 
img_fix = im2double(rgb2gray(imread('images/brain1.png'))); 
resulting_errors = zeros(6, 3);
resulting_mis = zeros(6, 3);
times = zeros(6, 3);

figure(1)
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));

    [img_reg_sd_r, ~] = affine_registration_2d(img_mov, img_fix, 'sd', 'r');
    [img_reg_nncc_r, ~] = affine_registration_2d(img_mov, img_fix, 'nncc', 'r');
    [img_reg_nngcc_r, ~] = affine_registration_2d(img_mov, img_fix, 'nngcc', 'r');

     % rigid
    subplot(3, 5, 5*(i-2) + 1), imshow(img_fix);
    title('Fixed Image');
    if(i==2)
        ylabel('Rigid');
    elseif(i==3)
        ylabel('Affine');
    else
        ylabel('Affine + Intensity');
    end

    subplot(3, 5, 5*(i-2) + 2), imshow(img_mov);
    if(i==2)
     title('Moving Image');
    end

    subplot(3, 5, 5*(i-2) + 3), imshow(img_reg_sd_r);
    if(i==2)
        title('SD');  
    end

    subplot(3, 5, 5*(i-2) + 4), imshow(img_reg_nncc_r);
    if(i==2)
        title('NNCC');
    end

    subplot(3, 5, 5*(i-2) + 5), imshow(img_reg_nngcc_r);
    if(i==2)
        title('NNGCC');
    end
        
    exportgraphics(gcf,"rigid_single_resolution.png")
end

figure(2)
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));

    [img_reg_sd_a, ~] = affine_registration_2d(img_mov, img_fix, 'sd', 'a');
    [img_reg_nncc_a, ~, ~] = affine_registration_2d(img_mov, img_fix, 'nncc', 'a');
    [img_reg_nngcc_a, ~] = affine_registration_2d(img_mov, img_fix, 'nngcc', 'a');

     % Affine
    subplot(3, 5, 5*(i-2) + 1), imshow(img_fix);
    title('Fixed Image');
    if(i==2)
        ylabel('Rigid');
    elseif(i==3)
        ylabel('Affine');
    else
        ylabel('Affine + Intensity');
    end
    subplot(3, 5, 5*(i-2) + 2), imshow(img_mov);
    if(i==2)
     title('Moving Image');
    end
    subplot(3, 5, 5*(i-2) + 3), imshow( img_reg_sd_a);
    if(i==2)
        title('SD');  
    end
    subplot(3, 5, 5*(i-2) + 4), imshow(img_reg_nncc_a);
    if(i==2)
        title('NNCC');
    end
    subplot(3, 5, 5*(i-2) + 5), imshow(img_reg_nngcc_a);
    if(i==2)
        title('NNGCC');
    end
    exportgraphics(gcf,"affine_single_resolution.png")
end

