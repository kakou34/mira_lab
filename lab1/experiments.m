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
    [img_reg, ~] = affine_registration_2d(img_mov, img_fix, 'sd', 'r');
    times(1, i-1) = toc;
    resulting_errors(1, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(1, i-1) = mutual_information(img_fix, img_reg);

    figure(1)
    subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
    subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
    subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
    subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
end

% MSE + Affine
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, M] = affine_registration_2d(img_mov, img_fix, 'sd', 'a');
    times(2, i-1) = toc;
    resulting_errors(2, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(2, i-1) = mutual_information(img_fix, img_reg);

    figure(2)
    subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
    subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
    subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
    subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
end

% NNCC + Rigid
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, ~] = affine_registration_2d(img_mov, img_fix, 'nncc', 'r');
    times(3, i-1) = toc;
    resulting_errors(3, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(3, i-1) = mutual_information(img_fix, img_reg);

    figure(3)
    subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
    subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
    subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
    subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
end

% NNCC + Affine
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, ~, ~] = affine_registration_2d(img_mov, img_fix, 'nncc', 'a');
    times(4, i-1) = toc;
    resulting_errors(4, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(4, i-1) = mutual_information(img_fix, img_reg);

    figure(4)
    subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
    subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
    subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
    subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
end

% NNGCC + Rigid
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, ~] = affine_registration_2d(img_mov, img_fix, 'nngcc', 'r');
    times(5, i-1) = toc;
    resulting_errors(5, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(5, i-1) = mutual_information(img_fix, img_reg);

    figure(5)
    subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
    subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
    subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
    subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
end

% NNGCC + Affine
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));
    tic
    [img_reg, M] = affine_registration_2d(img_mov, img_fix, 'nngcc', 'a');
    times(6, i-1) = toc;
    resulting_errors(6, i-1) = sum(sum(abs(img_fix - img_reg)));
    resulting_mis(6, i-1) = mutual_information(img_fix, img_reg);

    figure(6)
    subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
    subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
    subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
    subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
end

times
resulting_errors
resulting_mis
