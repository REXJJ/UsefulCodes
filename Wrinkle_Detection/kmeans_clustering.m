clc;
clear;
close all;
warning off;
D = '/home/rex/Desktop/TestData2';
S = dir(fullfile(D,'*.png'));
length(S);
fig = uifigure;
sldl=uislider(fig);
sldl.Limits=[1 50];
sldl.Position = [81,350,419,20];
txl = uilabel(fig);
txl.Text='K';
txl.FontSize=12;
txl.Position = [81,360,200,15];
global k im;
k=2;
sldl.Value=k;
figure(1)
figure(2)
for i = 1:numel(S)
    disp(i);
    F = fullfile(D,S(i).name);
    I = imread(F);
    I=rgb2gray(I);
    I=I(72:688,141:893);
%   I = medfilt2(I,[5,5]);
    im=I;
    sldl.ValueChangedFcn = @(sldl,event) update(sldl);
    figure(1)
    cluster();
    figure(2)
    imshow(I);
    w = waitforbuttonpress;

end




function cluster()
global k im;
k
clustered=imsegkmeans(im,k,'NumAttempts',3);
imshow(clustered,[]);
end

function update(sldl)
global k;
k=floor(sldl.Value);
disp("Here");
sldl.Value=k;
cluster();
end


    


