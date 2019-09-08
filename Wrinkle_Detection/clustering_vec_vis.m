clc;
clear;
close all;
warning off;
global vlen vlenm vden sc clus;
D = '/home/rex/Desktop/TestData2';
S = dir(fullfile(D,'*.png'));
length(S);
global u tot per;
fig = uifigure;

sldlm=uislider(fig);
sldlm.Limits=[0 100];
sldlm.Position = [81,350,419,20];


txl = uilabel(fig);
txl.Text='Max';
txl.FontSize=12;
txl.Position = [81,360,200,15];


sldl=uislider(fig);
sldl.Limits=[0 100];
sldl.Position = [81,250,419,20];


txlm = uilabel(fig);
txlm.Text='Min';
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

vlen=90;
vlenm=95;
vden =1;
sc=1;
sldsc.Value=sc;
sldl.Value=vlen;
sldlm.Value=vlenm;
sldd.Value=vden;


for k = 1:numel(S)
    disp(k);
    F = fullfile(D,S(k).name);
    I = imread(F);
    I=rgb2gray(I);
     I = medfilt2(I,[5,5]);
    [l,a,gx,gy]=getgradient(I);
    sldd.ValueChangedFcn = @(sldd,event) update(sldd,I,gx,gy,2);
    sldl.ValueChangedFcn = @(sldl,event) update(sldl,I,gx,gy,0);
    sldlm.ValueChangedFcn = @(sldlm,event) update(sldlm,I,gx,gy,1);
    sldsc.ValueChangedFcn = @(sldlm,event) update(sldsc,I,gx,gy,3);
    ll=floor(l*100);
    u=unique(ll);
    u=sort(u);
    tot=zeros(size(u));
    parfor i=1:length(u)
        for j=1:size(l,1)
            for k=1:size(l,2)
                tot(i)=tot(i)+(ll(j,k)==u(i));
            end
        end
    end
    per=zeros(size(u));
    for i=1:length(u)
        per(i)=percentage(u(i));
    end
    vector_display(I,gx,gy,vlen,vlenm,vden,sc);
    
%     figure(4);
%     imshow(I);
%     figure(4)
%     subplot(1,2,1);
%     [g,dir,gx,gy]=getgradient(I);
%     display_image(gx);
%     subplot(1,2,2)
%     display_image(gy);
    figure(6);
    display_image(l);
    w = waitforbuttonpress;
    %S(k).data = I; % optional, save data.
end


function p=percentage(pt)
global u tot;
index=find(u==pt);
if length(index)==0
    p=0;
else
p=(tot(index)*100000.0/sum(tot))/1000.0;
end
end

function p=percentile(pt)
pt=floor(pt*100);
global u per;
sum=0;
i=1;
while i<length(u) && u(i) <=pt
    sum=sum+per(i);
    i=i+1;
end
p=sum;
end

function vector_display(I,Gx,Gy,len,lenm,step,sc)
    len
    lenm
    im=im2double(I);
    im=double(im);
    [nr,nc]=size(im);
    [mag,dir] = imgradient(Gx,Gy);
    [x,y]=meshgrid(1:step:nc,1:step:nr);
    u=Gx(1:step:end,1:step:end);
    v=Gy(1:step:end,1:step:end);
    l=sqrt(u.^2+v.^2);
    count=1;
    global clus;
    clus=zeros(size(l,1),2);
    for i=1:size(l,1)
        for j=1:size(l,2)
            p=percentile(mag(i,j));
            if p>lenm || p<len
                 l(i,j)=0;
            else
                clus(count,:)=[i,j];
                count=count+1;
            end
        end
    end

    figure(5)
    close;
    imshow(im);
    alpha(0.8);   
    hold on;
    quiver(x(l>0),y(l>0),u(l>0),v(l>0),sc)
    hold off;
    disp("Processed");
end

function display_image(im)
    imshow(im, [min(im(:)) max(im(:))])
end

function [x,y]=calc_gradient_cell(a,ksize)
sumx1=mean2(a(:,1:floor(ksize/2)));
sumx2=mean2(a(:,ceil(ksize/2)+1:ksize));
sumy1=mean2(a(1:floor(ksize/2),:));
sumy2=mean2(a(ceil(ksize/2)+1:ksize,:));
x=(sumx2-sumx1);
y=(sumy2-sumy1);
end


function [gx,gy]=calc_gradient(im,ksize)
    a0 = im;
    gx=zeros(size(im));
    gy=zeros(size(im));
    n=ksize*ksize;
    step=floor(ksize/2);
    parfor r=step+1:size(a0,1)-step
        v0=zeros(size(a0(r,:)));
        v1=zeros(size(a0(r,:)));
        for c=step+1:size(a0,2)-step
            [lx,ly]=calc_gradient_cell((a0(r-step:r+step,c-step:c+step)),5);
            v0(c)=lx;
            v1(c)=ly;           
        end
        gx(r,:)=v0;
        gy(r,:)=v1;
   end
end


function [mag,dir,gx,gy] = getgradient(im)
    [gx,gy] = calc_gradient(im,5);
    %[gx,gy] = imgradientxy(im,"prewitt");
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