clc;
clear;
close all;
warning off;
D = '/home/rex/Desktop/TestData2';
S = dir(fullfile(D,'*.png'));
length(S);
fig = uifigure;
sldl=uislider(fig);
sldl.Limits=[1 100];
sldl.Position = [81,350,419,20];
txl = uilabel(fig);
txl.Text='K';
txl.FontSize=12;
txl.Position = [81,360,200,15];
global k im;
k=2;
sldl.Value=k;
figure(2)
for i = 1:numel(S)
    disp(i);
    F = fullfile(D,S(i).name);
    I = imread(F);
    I=rgb2gray(I);
    I = medfilt2(I,[5,5]);
    im=I;
    sldl.ValueChangedFcn = @(sldl,event) update(sldl);
    cluster();
    figure(2)
    imshow(I);
    w = waitforbuttonpress;

end




function cluster()
global k im;
m=[];
for i=1:2:size(im,1)
    for j=1:2:size(im,2)
        m=[m;[double(i),double(j),double(im(i,j))]];
    end
end
clustered=kmeans(m,k,'MaxIter',3);
figure(1)
imshow(im);
alpha(0.8);
hold on;
for i=1:k
    ids=find(clustered==i);
    xt=m(ids,1);
    yt=m(ids,2);
    scatter(yt,xt,'.');
end
hold off;
size(clustered)
end

function update(sldl)
global k;
k=floor(sldl.Value);
disp("Here");
sldl.Value=k;
cluster();
end


    


