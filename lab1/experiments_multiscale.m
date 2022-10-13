% Clean environment
clear all; close all; clc;

% Read two imges 
img_fix = im2double(rgb2gray(imread('images/brain1.png'))); 
resulting_errors = zeros(6, 3);
resulting_mis = zeros(6, 3);
times = zeros(6, 3);

% MSE + Rigid
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, M] = multiscale_affine_registration_2d(img_mov, img_fix, 'sd', 'r', 4);
    times(1, i-1) = toc;
    resulting_errors(1, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(1, i-1) = mutual_information(img_fix, img_reg);
    
    plot_imgs(1, i, img_fix, img_mov, img_reg)
    file_n = "images\rigid_mse_mr.png";
    exportgraphics(gcf,file_n)
end

% MSE + Affine
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'sd', 'a', 4);
    times(2, i-1) = toc;
    resulting_errors(2, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(2, i-1) = mutual_information(img_fix, img_reg);

    plot_imgs(2, i, img_fix, img_mov, img_reg)
    file_n = "images\affine_mse_mr.png";
    exportgraphics(gcf,file_n)
end

% NNCC + Rigid 
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'nncc', 'r', 4);
    times(3, i-1) = toc;
    resulting_errors(3, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(3, i-1) = mutual_information(img_fix, img_reg);

    plot_imgs(3, i, img_fix, img_mov, img_reg)
    file_n = "images\rigid_nncc_mr.png";
    exportgraphics(gcf,file_n)
end

% NNCC + Affine
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'nncc', 'a', 4);
    times(4, i-1) = toc;
    resulting_errors(4, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(4, i-1) = mutual_information(img_fix, img_reg);

    plot_imgs(4, i, img_fix, img_mov, img_reg)
    file_n = "images\affine_nncc_mr.png";
    exportgraphics(gcf,file_n)
end

% NNGCC + Rigid
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'nngcc', 'r', 4);
    times(5, i-1) = toc;
    resulting_errors(5, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(5, i-1) = mutual_information(img_fix, img_reg);

    plot_imgs(5, i, img_fix, img_mov, img_reg)
    file_n = "images\rigid_nngcc_mr.png";
    exportgraphics(gcf,file_n)
end

% NNGCC + Affine
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'nngcc', 'a', 4);
    times(6, i-1) = toc;
    resulting_errors(6, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(6, i-1) = mutual_information(img_fix, img_reg);

    plot_imgs(6, i, img_fix, img_mov, img_reg)
    file_n = "images\affine_nngcc_mr.png";
    exportgraphics(gcf,file_n)
end

times
resulting_errors
resulting_mis
