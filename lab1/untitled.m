% Read two imges 

clear all; close all; clc;
Imoving=im2double(rgb2gray(imread('brain1.png'))); 
Ifixed=im2double(rgb2gray(imread('brain2.png')));

[reg, m] = affineReg2D(Imoving, Ifixed);
