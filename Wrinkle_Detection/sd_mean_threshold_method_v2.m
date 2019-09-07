clc;
clear;
close all;

global ksize m_t s_t processed_image m_t1 s_t1 processed_image1 m_t2 s_t2 processed_image2 vlen vlenm vden reference;
vlen=0;
reference = imread('/home/rex/Desktop/reference.jpg');
figure(3)
subplot(1,2,1);
imshow(reference)
D = '/home/rex/Desktop/TestData';
S = dir(fullfile(D,'*.jpg'));
length(S);
figure(1)
[g,gx,gy]=getgradient(reference);
h=0.075;
w=0.075;
figure(1)
sp1=subplot(2,2,1);
display_image(gx);
title('X gradient Reference Image') 
sp1.Position = sp1.Position + [0 0 h w];
figure(1)
sp2=subplot(2,2,2);
display_image(gy);
sp2.Position = sp2.Position + [0 0 h w];
title('Y gradient Reference Image')
figure(2)
fig = uifigure;
sldl=uislider(fig);
sldl.Limits=[0 500];
sldl.Position = [81,410,419,23];
sldlm=uislider(fig);
sldlm.Limits=[0 1000];
sldlm.Position = [81,450,419,23];
sldd=uislider(fig);
sldd.Limits=[1 31];
sldd.Position = [81,370,419,23];
sld = uislider(fig);
sld.Limits = [1 21];
sld.Position = [81,310,419,23];
sldm = uislider(fig);
sldm.Limits = [0 100];
sldm.Position = [81,260,419,23];
slds = uislider(fig);
slds.Limits = [0 100];
slds.Position = [81,220,419,23];
sldm1 = uislider(fig);
sldm1.Limits = [0 100];
sldm1.Position = [81,170,419,23];
slds1 = uislider(fig);
slds1.Limits = [0 100];
slds1.Position = [81,130,419,23];
sldm2 = uislider(fig);
sldm2.Limits = [0 100];
sldm2.Position = [81,80,419,23];
slds2 = uislider(fig);
slds2.Limits = [0 100];
slds2.Position = [81,40,419,23];
ksize=9;
m_t=30;
s_t=30;
m_t1=30;
s_t1=30;
m_t2=30;
s_t2=30;
vlen=0;
vlenm=1000;
vden =1;
sld.Value=ksize;
sldm.Value=m_t;
slds.Value=s_t;
sldm1.Value=m_t1;
slds1.Value=s_t1;
sldm2.Value=m_t2;
slds2.Value=s_t2;
sldlm.Value=vlenm;
for k = 1:numel(S)
    h=0.075;
    w=0.075;
    disp(k);
    F = fullfile(D,S(k).name);
    I = imread(F);
    [G,Gx,Gy]=getgradient(I);
    figure(1)
    sp3=subplot(2,2,3);
    display_image(Gx);
    sp3.Position = sp3.Position + [0 0 h w];
    title('X gradient Test Image')  
    figure(1)
    sp4=subplot(2,2,4);
    display_image(Gy);
    sp4.Position = sp4.Position + [0 0 h w];
    title('Y gradient Test Image')  
     %xlswrite('/home/rex/Desktop/test.csv',gx);
    figure(5)
    vector_display(I,Gx,Gy,vlen,vlenm,vden)
    sldd.ValueChangedFcn = @(sldd,event) updateDen(sldd,I,Gx,Gy);
    sldl.ValueChangedFcn = @(sldl,event) updateLength(sldl,I,Gx,Gy);
    sldlm.ValueChangedFcn = @(sldlm,event) updateLengthm(sldlm,I,Gx,Gy);
    sld.ValueChangedFcn = @(sld,event) updateKsize(sld,I,g,G,abs(gx),abs(Gx),abs(gy),abs(Gy));
    sldm.ValueChangedFcn = @(sldm,event) updatem(sldm,I,g,G,abs(gx),abs(Gx),abs(gy),abs(Gy),0);
    slds.ValueChangedFcn = @(slds,event) updates(slds,I,g,G,abs(gx),abs(Gx),abs(gy),abs(Gy),0);
    sldm1.ValueChangedFcn = @(sldm1,event) updatem(sldm1,I,g,G,abs(gx),abs(Gx),abs(gy),abs(Gy),1);
    slds1.ValueChangedFcn = @(slds1,event) updates(slds1,I,g,G,abs(gx),abs(Gx),abs(gy),abs(Gy),1);
    sldm2.ValueChangedFcn = @(sldm2,event) updatem(sldm2,I,g,G,abs(gx),abs(Gx),abs(gy),abs(Gy),2);
    slds2.ValueChangedFcn = @(slds2,event) updates(slds2,I,g,G,abs(gx),abs(Gx),abs(gy),abs(Gy),2);
    process(g,G,abs(gx),abs(Gx),abs(gy),abs(Gy),ksize,m_t,s_t,m_t1,s_t1,m_t2,s_t2,4);
    update_display(I,4);
    figure(3);
    subplot(1,2,2);
    imshow(I);
    w = waitforbuttonpress;
    %S(k).data = I; % optional, save data.
end

function update_display(I,id)
    if id==0 || id ==4
    update_display0(I);
    end
    if id==1 || id ==4
    update_display1(I);
    end
    if id==2 || id ==4
    update_display2(I);
    end
end

function update_display0(I)
    global processed_image reference;
    BW=processed_image>0;
    figure(2)
    subplot(1,2,1);
    imshow(BW);
    title('Processed Image');
    subplot(1,2,2);
    B = labeloverlay(reference,BW);
    imshow(B)
    title('Overlaid Image - Resultant');
end

function update_display1(I)
    figure(6)
    sp1=subplot(1,2,1);
    global processed_image1 reference;
    BW1=processed_image1>0;
    imshow(BW1);
    title('Processed Image');
    subplot(1,2,2);
    B = labeloverlay(I,BW1);
    imshow(B)
    title('Overlaid Image - X gradient');  
end

function update_display2(I)
    figure(7)
    global processed_image2 reference;
    BW2=processed_image2>0;
    sp2=subplot(1,2,1);
    imshow(BW2);
    title('Processed Image');
    subplot(1,2,2);
    B = labeloverlay(I,BW2);
    imshow(B)
    title('Overlaid Image - Y gradient');
end

function image = preprocess(im)
    image=rgb2gray(im);
end

function [g,gx,gy] = getgradient(im)
    [gx,gy] = imgradientxy(im,"prewitt");
    [Gmag,Gdir] = imgradient(gx,gy);
    g=Gmag;
end

function display_image(im)
    imshow(im , [min(im(:)) max(im(:))])
end

function process(im_ref0,im_test0,im_ref1,im_test1,im_ref2,im_test2,ksize,m_t,s_t,m_t1,s_t1,m_t2,s_t2,id)
    a0 = im_test0;
    a1 = im_test1;
    a2 = im_test2;
    if id==0 || id==4
    mean_ref0 = zeros(size(im_ref0));
    std_ref0 = zeros(size(im_ref0));
    mean_test0 = zeros(size(im_ref0));
    std_test0 = zeros(size(im_ref0));
    end
    if id==1||id==4
    mean_ref1 = zeros(size(im_ref1));
    std_ref1 = zeros(size(im_ref1));
    mean_test1 = zeros(size(im_ref1));
    std_test1 = zeros(size(im_ref1));
    end
    if id==2||id==4
    mean_ref2 = zeros(size(im_ref2));
    std_ref2 = zeros(size(im_ref2));
    mean_test2 = zeros(size(im_ref2));
    std_test2 = zeros(size(im_ref2));
    end 
    
    step=floor(ksize/2);
    parfor r=step+1:size(im_ref0,1)-step
        v0=zeros(size(im_test0(r,:)));
        v1=zeros(size(im_test1(r,:)));
        v2=zeros(size(im_test2(r,:)));
        for c=step+1:size(im_ref0,2)-step
            if id==0||id==4
            mean_ref0=mean2(im_ref0(r-step:r+step,c-step:c+step));
            std_ref0=std2(im_ref0(r-step:r+step,c-step:c+step));
            mean_test0=mean2(a0(r-step:r+step,c-step:c+step));
            std_test0=mean2(a0(r-step:r+step,c-step:c+step));
            if abs(mean_ref0-mean_test0)>m_t&&abs(std_ref0-std_test0)>s_t
                v0(c)=255;
            end
            end
            
            if id==1||id==4 
            mean_ref1=mean2(im_ref1(r-step:r+step,c-step:c+step));
            std_ref1=std2(im_ref1(r-step:r+step,c-step:c+step));
            mean_test1=mean2(a1(r-step:r+step,c-step:c+step));
            std_test1=mean2(a1(r-step:r+step,c-step:c+step));
            if abs(mean_ref1-mean_test1)>m_t1&&abs(std_ref1-std_test1)>s_t1
                v1(c)=255;
            end
            end
            if id==2||id==4
            mean_ref2=mean2(im_ref2(r-step:r+step,c-step:c+step));
            std_ref2=std2(im_ref2(r-step:r+step,c-step:c+step));
            mean_test2=mean2(a2(r-step:r+step,c-step:c+step));
            std_test2=mean2(a2(r-step:r+step,c-step:c+step));
            if abs(mean_ref2-mean_test2)>m_t2&&abs(std_ref2-std_test2)>s_t2
                v2(c)=255;
            end
            end

        end
        im_test0(r,:)=v0;
        im_test1(r,:)=v1;
        im_test2(r,:)=v2;
        
    end
    global processed_image processed_image1 processed_image2;
    if id==0||id==4
    processed_image=im_test0;
    end
    if id==1||id==4
    processed_image1=im_test1;
    end
    if id==2||id==4
    processed_image2=im_test2;
    end
end

function vector_display(I,Gx,Gy,len,lenm,step)
    im=im2double(I);
    im=double(im);
    [nr,nc]=size(im);
    [x y]=meshgrid(1:step:nc,1:step:nr);
    u=Gx(1:step:end,1:step:end);
    v=Gy(1:step:end,1:step:end);
    l=sqrt(u.^2+v.^2);
    figure(5)
    quiver(x(l>len&l<lenm),y(l>len&l<lenm),u(l>len&l<lenm),v(l>len&l<lenm))
end

function updateKsize(sld,I,im_ref0,im_test0,im_ref1,im_test1,im_ref2,im_test2)
global ksize m_t s_t m_t1 s_t1 m_t2 s_t2;
ksize=floor(sld.Value);
process(im_ref0,im_test0,im_ref1,im_test1,im_ref2,im_test2,ksize,m_t,s_t,m_t1,s_t1,m_t2,s_t2,4);
update_display(I,4);
end

function updatem(sldm,I,im_ref0,im_test0,im_ref1,im_test1,im_ref2,im_test2,id)
global ksize m_t s_t m_t1 s_t1 m_t2 s_t2;
if id==0
m_t=floor(sldm.Value);
end
if id==1
m_t1=floor(sldm.Value);
end
if id==2
m_t2=floor(sldm.Value);
end
process(im_ref0,im_test0,im_ref1,im_test1,im_ref2,im_test2,ksize,m_t,s_t,m_t1,s_t1,m_t2,s_t2,id);
update_display(I,id);
end

function updates(slds,I,im_ref0,im_test0,im_ref1,im_test1,im_ref2,im_test2,id)
global ksize m_t s_t m_t1 s_t1 m_t2 s_t2;
if id==0
s_t=floor(slds.Value);
end
if id==1
s_t1=floor(slds.Value);
end
if id==2
s_t2=floor(slds.Value);
end
process(im_ref0,im_test0,im_ref1,im_test1,im_ref2,im_test2,ksize,m_t,s_t,m_t1,s_t1,m_t2,s_t2,id);
update_display(I,id);
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
