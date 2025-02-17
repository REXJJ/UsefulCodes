clc;
clear;
close all;
warning off;
global ksize m_l m_a s_l s_a processed_image vlen vlenm vden reference;
vlen=0;
reference = imread('/home/rex/Desktop/ICRA/ref_image.jpg');
figure(3)
subplot(1,2,1);
imshow(reference)
D = '/home/rex/Desktop/ICRA';
S = dir(fullfile(D,'*.jpg'));
length(S);
figure(1)
[L,A,Gx,Gy]=getgradient(reference);
h=0.075;
w=0.075;
figure(1)
sp1=subplot(2,2,1);
display_image(Gx);
title('X gradient Reference Image') 
sp1.Position = sp1.Position + [0 0 h w];
figure(1)
sp2=subplot(2,2,2);
display_image(Gy);
sp2.Position = sp2.Position + [0 0 h w];
title('Y gradient Reference Image')
figure(2)
fig = uifigure;

sldlm=uislider(fig);
sldlm.Limits=[0 1000];
sldlm.Position = [81,400,419,20];


txl = uilabel(fig);
txl.Text='Max Vector Length';
txl.FontSize=12;
txl.Position = [81,410,200,15];


sldl=uislider(fig);
sldl.Limits=[0 500];
sldl.Position = [81,350,419,20];


txlm = uilabel(fig);
txlm.Text='Min Vector Length';
txlm.FontSize=12;
txlm.Position = [81,360,200,15];


sldd=uislider(fig);
sldd.Limits=[1 31];
sldd.Position = [81,300,419,20];


txld = uilabel(fig);
txld.Text='Density';
txld.FontSize=12;
txld.Position = [81,310,200,15];

sld = uislider(fig);
sld.Limits = [1 21];
sld.Position = [81,250,419,20];



txlk = uilabel(fig);
txlk.Text='k size';
txlk.FontSize=12;
txlk.Position = [81,260,200,15];

sldm = uislider(fig);
sldm.Limits = [0 100];
sldm.Position = [81,200,419,20];

txlkdd = uilabel(fig);
txlkdd.Text='Magnitude Mean';
txlkdd.FontSize=12;
txlkdd.Position = [81,210,200,15];

slds = uislider(fig);
slds.Limits = [0 100];
slds.Position = [81,150,419,20];

txlkdds = uilabel(fig);
txlkdds.Text='Magnitude SD';
txlkdds.FontSize=12;
txlkdds.Position = [81,160,200,15];

sldma = uislider(fig);
sldma.Limits = [0 360];
sldma.Position = [81,100,419,20];

txlkddw = uilabel(fig);
txlkddw.Text='Angle Mean';
txlkddw.FontSize=12;
txlkddw.Position = [81,110,200,15];

sldsa = uislider(fig);
sldsa.Limits = [0 360];
sldsa.Position = [81,50,419,20];

txlkddws = uilabel(fig);
txlkddws.Text='Angle SD';
txlkddws.FontSize=12;
txlkddws.Position = [81,60,200,15];


ksize=9;
m_a=30;
s_a=30;
m_l=30;
s_l=30;
vlen=0;
vlenm=1000;
vden =1;
sld.Value=ksize;
sldm.Value=m_l;
slds.Value=s_l;
sldma.Value=m_a;
sldsa.Value=s_a;
sldlm.Value=vlenm;
for k = 1:numel(S)
    h=0.075;
    w=0.075;
    disp(k);
    F = fullfile(D,S(k).name);
    I = imread(F);
    [l,a,gx,gy]=getgradient(I);
    figure(1)
    sp3=subplot(2,2,3);
    display_image(gx);
    sp3.Position = sp3.Position + [0 0 h w];
    title('X gradient Test Image')  
    figure(1)
    sp4=subplot(2,2,4);
    display_image(gy);
    sp4.Position = sp4.Position + [0 0 h w];
    title('Y gradient Test Image') 
    %xlswrite('/home/rex/Desktop/test.csv',dir);
    figure(5)
    vector_display(I,gx,gy,vlen,vlenm,vden)
    sldd.ValueChangedFcn = @(sldd,event) updateDen(sldd,I,gx,gy);
    sldl.ValueChangedFcn = @(sldl,event) updateLength(sldl,I,gx,gy);
    sldlm.ValueChangedFcn = @(sldlm,event) updateLengthm(sldlm,I,gx,gy);
    
    sld.ValueChangedFcn = @(sld,event) update(sld,I,L,l,A,a,4);
    sldm.ValueChangedFcn = @(sldm,event) update(sldm,I,L,l,A,a,0);
    slds.ValueChangedFcn = @(slds,event) update(slds,I,L,l,A,a,1);
    sldma.ValueChangedFcn = @(sldma,event) update(sldma,I,L,l,A,a,2);
    sldsa.ValueChangedFcn = @(sldsa,event) update(sldsa,I,L,l,A,a,3);
    
    process(L,l,A,a,ksize,m_l,s_l,m_a,s_a)
    update_display(I);
    figure(3);
    subplot(1,2,2);
    imshow(I);
    figure(4);
    subplot(1,2,1);
    imcontour(reference);
    subplot(1,2,2);
    imcontour(I);
    w = waitforbuttonpress;
    %S(k).data = I; % optional, save data.
end

function update_display(I)
    global processed_image reference;
    for i=1:size(processed_image,1)
        for j=1:size(processed_image,2)
            if j<400||i<130||i>631||j<130||j>834
                processed_image(i,j)=0;
            end
        end
    end
    BW=processed_image>0;
    CW = bwconvhull(BW);

    figure(2)
    subplot(1,2,1);
    imshow(BW);
    title('Processed Image');
    subplot(1,2,2);
    B = labeloverlay(I,CW);
    imshow(B)
    title('Overlaid Image');
end

function out = scale(im)
    out = (im - min(im(:))) / (max(im(:)) - min(im(:)));
end

function [mag,dir,gx,gy] = getgradient(im)
    [gx,gy] = imgradientxy(im,"prewitt");
    [mag,dir] = imgradient(gx,gy);
    %[mag,dir,gx,gy]=[scale(mag),dir,scale(gx),scale(gy)]
end

function display_image(im)
    imshow(im, [min(im(:)) max(im(:))])
end

function process(L,l,A,a,ksize,m_l,s_l,m_a,s_a)
    a0 = l;
    a1 = a;
    step=floor(ksize/2);
    parfor r=step+1:size(L,1)-step
        v0=zeros(size(l(r,:)));
        for c=step+1:size(L,2)-step
            mean_L=mean2(L(r-step:r+step,c-step:c+step));
            std_L=std2(L(r-step:r+step,c-step:c+step));
            mean_l=mean2(a0(r-step:r+step,c-step:c+step));
            std_l=mean2(a0(r-step:r+step,c-step:c+step));
            
            mean_A=mean2(A(r-step:r+step,c-step:c+step));
            std_A=std2(A(r-step:r+step,c-step:c+step));
            mean_a=mean2(a1(r-step:r+step,c-step:c+step));
            std_a=mean2(a1(r-step:r+step,c-step:c+step));

            if abs(mean_L-mean_l)>m_l&&abs(std_L-std_l)>s_l&&abs(mean_A-mean_a)>m_a&&abs(std_A-std_a)>s_a
                v0(c)=255;
            end         
        end
        l(r,:)=v0;
    end
    global processed_image;
    processed_image=l;
end

function vector_display(I,Gx,Gy,len,lenm,step)
    im=im2double(I);
    im=double(im);
    [nr,nc]=size(im);
    [x,y]=meshgrid(1:step:nc,1:step:nr);
    u=Gx(1:step:end,1:step:end);
    v=Gy(1:step:end,1:step:end);
    l=sqrt(u.^2+v.^2);
    figure(5)
    imshow(im);
    alpha(0.8);   
    hold on;
    quiver(x(l>len&l<lenm),y(l>len&l<lenm),u(l>len&l<lenm),v(l>len&l<lenm),20)
end
 

function update(sldm,I,L,l,A,a,id)
global ksize m_l s_l m_a s_a;
if id==0
m_l=floor(sldm.Value);
end
if id==1
s_l=floor(sldm.Value);
end
if id==2
m_a=floor(sldm.Value);
end
if id==3
s_a=floor(sldm.Value);
end
if id==4
ksize=floor(sldm.Value);
end
process(L,l,A,a,ksize,m_l,s_l,m_a,s_a);
update_display(I);
end

function updateLength(sldl,I,Gx,Gy)
global vlen vden vlenm;
vlen=floor(sldl.Value);
vector_display(I,Gx,Gy,vlen,vlenm,vden);
end

function updateDen(sldd,I,Gx,Gy)
global vlen vden vlenm;
vden=floor(sldd.Value);
vector_display(I,Gx,Gy,vlen,vlenm,vden);
end

function updateLengthm(sldl,I,Gx,Gy)
global vlen vden vlenm;
vlenm=floor(sldl.Value);
vector_display(I,Gx,Gy,vlen,vlenm,vden);
end
