s = abs(matrix_lv2 - matrix_lv3);
figure;
image(s*255/max(s(:)));
colormap(cool(255));