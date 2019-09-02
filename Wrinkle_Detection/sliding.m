clc;
clear;
close all;
figure(2)
reference = imread('/home/rex/Desktop/reference.jpg');
imshow(reference)
fig = uifigure;
sld = uislider(fig,...
    'ValueChangedFcn',@(sld,event) updateGauge(sld,reference));

sld.Limits = [0 255];
figure(1)

function updateGauge(sld,image)
    disp(sld.Value)
    thresh=floor(sld.Value);
    image=image>thresh;
    figure(1)
    imshow(image);    
end