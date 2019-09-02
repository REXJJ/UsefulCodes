RGB = imread('/home/rex/Desktop/test_new1.jpg');
BW = rgb2gray(RGB);
[H,T,R] = hough(BW,'RhoResolution',0.75,'Theta',-90:0.5:89);
subplot(2,1,1);
imshow(BW);
title('Image');
subplot(2,1,2);
imshow(H,'XData',T,'YData',R,...
'InitialMagnification','fit');
title('Hough transform');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);
