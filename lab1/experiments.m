% Clean environment
clear all; close all; clc;

% Read two imges 
img_fix = im2double(rgb2gray(imread('brain1.png'))); 
resulting_errors = zeros(6, 3);

% MSE + Rigid
% for i=2:4
%     img_mov = im2double(rgb2gray(imread(sprintf('brain%d.png', i))));
%     [img_reg, ~] = affine_registration_2d(img_mov, img_fix, 'sd', 'r');
%     figure(1)
%     resulting_errors(1, i-1) = sum(sum(abs(img_fix - img_reg)));
%     subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
%     subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
%     subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
%     subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
% end

% MSE + Affine
% for i=2:4
%     img_mov = im2double(rgb2gray(imread(sprintf('brain%d.png', i))));
%     [img_reg, M] = affine_registration_2d(img_mov, img_fix, 'sd', 'a');
%     figure(2)
%     resulting_errors(2, i-1) = sum(sum(abs(img_fix - img_reg)));
%     subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
%     subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
%     subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
%     subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
% end

% NNCC + Rigid
% for i=2:4
%     img_mov = im2double(rgb2gray(imread(sprintf('brain%d.png', i))));
%     [img_reg, ~] = affine_registration_2d(img_mov, img_fix, 'nncc', 'r');
%     figure(3)
%     resulting_errors(3, i-1) = sum(sum(abs(img_fix - img_reg)));
%     subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
%     subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
%     subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
%     subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
% end

% NNCC + Affine
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('brain%d.png', i))));
    [img_reg, ~, ~] = affine_registration_2d(img_mov, img_fix, 'nncc', 'a');
    figure(4)
    resulting_errors(4, i-1) = sum(sum(abs(img_fix - img_reg)));
    subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
    subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
    subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
    subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
end

% NNGCC + Rigid
% for i=2:4
%     img_mov = im2double(rgb2gray(imread(sprintf('brain%d.png', i))));
%     [img_reg, ~] = affine_registration_2d(img_mov, img_fix, 'nngcc', 'r');
%     figure(5)
%     resulting_errors(5, i-1) = sum(sum(abs(img_fix - img_reg)));
%     subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
%     subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
%     subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
%     subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
% end

% NNGCC + Affine
% for i=2:4
%     img_mov = im2double(rgb2gray(imread(sprintf('brain%d.png', i))));
%     [img_reg, M] = affine_registration_2d(img_mov, img_fix, 'nngcc', 'a');
%     figure(6)
%     resulting_errors(6, i-1) = sum(sum(abs(img_fix - img_reg)));
%     subplot(3, 4, 4*(i-2) + 1), imshow(img_fix), title('Fixed Image');
%     subplot(3, 4, 4*(i-2) + 2), imshow(img_mov), title('Moving Image');
%     subplot(3, 4, 4*(i-2) + 3), imshow(img_reg), title('Registered Image');
%     subplot(3, 4, 4*(i-2) + 4), imshow(abs(img_fix - img_reg)), title('Registration Error');
% end

resulting_errors