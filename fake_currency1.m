A = imread('real_1_changed.jpg');
P = imread('dupe_1_changed.jpg');

a = rgb2gray(A);
p = rgb2gray(P);

a2_tr = imcrop(a, [2218.5 204.5 535 521]);  %transparent gandhi 1
b2_tr = imcrop(p, [2218.5 204.5 535 521]);  %transparent gandhi 2

a2_str = imcrop(a, [1766.5 4.5 63 1096]);   %thin strip 1
p2_str = imcrop(p, [1666.5 4.5 63 1096]);   %thin strip 2

hsvImageReal = rgb2hsv(A);
hsvImageFake = rgb2hsv(P);

croppedImageReal = imcrop(hsvImageReal, [1778.5 13.5 57 963]);
croppedImageFake = imcrop(hsvImageFake, [1673.5 4.5 96 1096]);

satThresh = 0.3;
valThresh = 0.9;
BWImageReal = (croppedImageReal(:, :, 2) > satThresh & croppedImageReal(:, :, 3) < valThresh);
BWImageFake = (croppedImageFake(:, :, 2) > satThresh & croppedImageFake(:, :, 3) < valThresh);

se = strel('line', 200, 90);
BWImageCloseReal = imclose(BWImageReal, se);
BWImageCloseFake = imclose(BWImageFake, se);

areaopenReal = bwareaopen(BWImageCloseReal, 15);
areaopenFake = bwareaopen(BWImageCloseFake, 15);

[~, countReal] = bwlabel(areaopenReal);
[~, countFake] = bwlabel(areaopenFake);

co = corr2(a2_str, p2_str);

figure('Name', 'Image Analysis');
subplot(2, 4, 1);
imshow(A);
title('Real Image');

subplot(2, 4, 2);
imshow(P);
title('Fake Image');

subplot(2, 4, 3);
imshow(a2_tr);
title('Transparent Gandhi 1');

subplot(2, 4, 4);
imshow(b2_tr);
title('Transparent Gandhi 2');

subplot(2, 4, 5);
imshow(a2_str);
title('Thin Strip 1');

subplot(2, 4, 6);
imshow(p2_str);
title('Thin Strip 2');

subplot(2, 4, 7);
imshow(hsvImageReal(:, :, 1));
title('Hue (Real)');

subplot(2, 4, 8);
imshow(hsvImageFake(:, :, 1));
title('Hue (Fake)');

figure('Name', 'HSV Analysis');
subplot(2, 3, 1);
imshow(hsvImageReal(:, :, 2));
title('Saturation (Real)');

subplot(2, 3, 2);
imshow(hsvImageFake(:, :, 2));
title('Saturation (Fake)');

subplot(2, 3, 3);
imshow(hsvImageReal(:, :, 3));
title('Value (Real)');

subplot(2, 3, 4);
imshow(hsvImageFake(:, :, 3));
title('Value (Fake)');

figure('Name', 'Green Strip Analysis');
subplot(1, 3, 1);
imshow(BWImageReal);
title('Green Strip (Real)');

subplot(1, 3, 2);
imshow(BWImageFake);
title('Green Strip (Fake)');

subplot(1, 3, 3);
imshow(areaopenReal);
title('Cleaned Green Strip (Real)');

disp(['The total number of black lines for the real note is: ' num2str(countReal)]);
disp(['The total number of black lines for the fake note is: ' num2str(countFake)]);
disp(['Correlation of transparent Gandhi: ' num2str(co)]);

if (co >= 0.5 && countReal == 1 && countFake ~= 1)
    disp('Correlation of transparent Gandhi > 0.5');
    if (countReal == 1 && countFake ~= 1)
        disp('Currency is legitimate');
    else
        disp('Green strip is fake');
    end
else
    disp('Correlation of transparent Gandhi < 0.5');
    disp('Currency is fake');
end
