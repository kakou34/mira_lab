function plot_imgs(fig_n, img_n, img_fix, img_mov, img_reg)
%PLOT_IMGS: Plot the resulting figures.
figure(fig_n)
subplot(3, 4, 4*(img_n-2) + 1), imshow(img_fix);
if (4*(img_n-2) + 1) == 1
    title('Fixed Image');
    ylabel('Rigid');
elseif (4*(img_n-2) + 1) == 5
    ylabel('Affine');
elseif (4*(img_n-2) + 1) == 9
    ylabel('Affine + Intensity');
end

subplot(3, 4, 4*(img_n-2) + 2), imshow(img_mov);
if (4*(img_n-2) + 2) == 2
    title('Moving Image');
end

subplot(3, 4, 4*(img_n-2) + 3), imshow(img_reg);
if (4*(img_n-2) + 3) == 3
    title('Registered Image');
end

subplot(3, 4, 4*(img_n-2) + 4), imshow(abs(img_fix - img_reg));
if (4*(img_n-2) + 4) == 4
    title('Registration Error');
end

set(gcf, 'Position', [10 10 800 600]);

end

