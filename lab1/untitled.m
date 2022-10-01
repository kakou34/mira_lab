% Read two imges 
clear all; close all; clc;
Imoving=im2double(rgb2gray(imread('brain1.png'))); 
Ifixed=im2double(rgb2gray(imread('brain2.png')));
[reg, m] = affineReg2D(Imoving, Ifixed, 'r');

figure,
subplot(2,2,1), imshow(Ifixed);
subplot(2,2,2), imshow(Imoving);
subplot(2,2,3), imshow(reg);
subplot(2,2,4), imshow(abs(Ifixed-reg));