clc;
clear;
close all;
warning off;
global vlen vlenm vden sc;
D = '/home/rex/Desktop/TestData2';
S = dir(fullfile(D,'*.png'));
length(S);

fig = uifigure;

sldlm=uislider(fig);
sldlm.Limits=[0 1000];
sldlm.Position = [81,350,419,20];


txl = uilabel(fig);
txl.Text='Max Vector Length';
txl.FontSize=12;
txl.Position = [81,360,200,15];


sldl=uislider(fig);
sldl.Limits=[0 500];
sldl.Position = [81,250,419,20];


txlm = uilabel(fig);
txlm.Text='Min Vector Length';
txlm.FontSize=12;
txlm.Position = [81,260,200,15];


sldd=uislider(fig);
sldd.Limits=[1 31];
sldd.Position = [81,150,419,20];


txld = uilabel(fig);
txld.Text='Scale';
txld.FontSize=12;
txld.Position = [81,60,200,15];

sldsc=uislider(fig);
sldsc.Limits=[0 20];
sldsc.Position = [81,50,419,20];


txld = uilabel(fig);
txld.Text='Density';
txld.FontSize=12;
txld.Position = [81,160,200,15];

vlen=0;
vlenm=1000;
vden =1;
sc=0;
sldsc.Value=sc;
sldl.Value=vlen;
sldlm.Value=vlenm;
sldd.Value=vden;


for k = 1:numel(S)
    disp(k);
    F = fullfile(D,S(k).name);
    I = imread(F);
    I=rgb2gray(I);
%     I = medfilt2(I,[5,5]);
    [l,a,gx,gy]=getgradient(I);
    sldd.ValueChangedFcn = @(sldd,event) update(sldd,I,gx,gy,2);
    sldl.ValueChangedFcn = @(sldl,event) update(sldl,I,gx,gy,0);
    sldlm.ValueChangedFcn = @(sldlm,event) update(sldlm,I,gx,gy,1);
    sldsc.ValueChangedFcn = @(sldlm,event) update(sldsc,I,gx,gy,3);
    vector_display(I,gx,gy,vlen,vlenm,vden,sc);
    figure(4);
    imshow(I);
%     figure(4)
%     subplot(1,2,1);
%     [g,dir,gx,gy]=getgradient(I);
%     display_image(gx);
%     subplot(1,2,2)
%     display_image(gy);
    w = waitforbuttonpress;
    %S(k).data = I; % optional, save data.
end

function vector_display(I,Gx,Gy,len,lenm,step,sc)
    im=im2double(I);
    im=double(im);
    [nr,nc]=size(im);
    [x,y]=meshgrid(1:step:nc,1:step:nr);
    u=Gx(1:step:end,1:step:end);
    v=Gy(1:step:end,1:step:end);
    l=sqrt(u.^2+v.^2);
    figure(5)
    close;
    imshow(im);
    alpha(0.8);   
    hold on;
    quiver(x(l>len&l<lenm),y(l>len&l<lenm),u(l>len&l<lenm),v(l>len&l<lenm),sc)
    hold off;
end

function display_image(im)
    imshow(im, [min(im(:)) max(im(:))])
end


function [mag,dir,gx,gy] = getgradient(im)
    [gx,gy] = imgradientxy(im,"prewitt");
    [mag,dir] = imgradient(gx,gy);
end


function update(sldl,I,Gx,Gy,id)
global vlen vden vlenm sc;
if id==0
vlen=floor(sldl.Value);
sldl.Value=vlen;
end
if id==1
vlenm=floor(sldl.Value);
sldl.Value=vlenm;
end
if id==2
vden=floor(sldl.Value);
sldl.Value=vden;
end
if id==3
sc=floor(sldl.Value);
sldl.Value=sc;
end
vector_display(I,Gx,Gy,vlen,vlenm,vden,sc);
end