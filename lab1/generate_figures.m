% Clean environment
clear all; close all; clc;

% Read two imges 
img_fix = im2double(rgb2gray(imread('images/brain1.png'))); 

% RIGID TRANSFORMATION
t = tiledlayout(3,5);
t.TileSpacing = 'compact';
t.Padding = 'compact';
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));

    [img_reg_sd_r, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'sd', 'r', 4);
    [img_reg_nncc_r, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'nncc', 'r', 4);
    [img_reg_nngcc_r, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'nngcc', 'r', 4);

     % rigid
    nexttile, imshow(img_fix);
    if(i==2)
        ylabel('Rigid');
        title('Fixed');
    elseif(i==3)
        ylabel('Affine');
    else
        ylabel('Affine + Intensity');
    end

    nexttile, imshow(img_mov);
    if(i==2)
     title('Moving');
    end

    nexttile, imshow(img_reg_sd_r);
    if(i==2)
        title('SD');  
    end

    nexttile, imshow(img_reg_nncc_r);
    if(i==2)
        title('NNCC');
    end

    nexttile, imshow(img_reg_nngcc_r);
    if(i==2)
        title('NNGCC');
    end
        
     exportgraphics(t,"rigid_multi_resolution_.png")
end


% AFFINE TRANSFORMATION
t = tiledlayout(3,5);
t.TileSpacing = 'compact';
t.Padding = 'compact';
for i=2:4
    img_mov = im2double(rgb2gray(imread(sprintf('images/brain%d.png', i))));

    [img_reg_sd_a, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'sd', 'a', 4);
    [img_reg_nncc_a, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'nncc', 'a', 4);
    [img_reg_nngcc_a, ~] = multiscale_affine_registration_2d(img_mov, img_fix, 'nngcc', 'a', 4);

    nexttile, imshow(img_fix);
    if(i==2)
        ylabel('Rigid');
        title('Fixed');
    elseif(i==3)
        ylabel('Affine');
    else
        ylabel('Affine + Intensity');
    end

    nexttile, imshow(img_mov);
    if(i==2)
     title('Moving');
    end

    nexttile, imshow(img_reg_sd_r);
    if(i==2)
        title('SD');  
    end

    nexttile, imshow(img_reg_nncc_r);
    if(i==2)
        title('NNCC');
    end

    nexttile, imshow(img_reg_nngcc_r);
    if(i==2)
        title('NNGCC');
    end
        
     exportgraphics(t,"affine_multi_resolution_.png")
end
