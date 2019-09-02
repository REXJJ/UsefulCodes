clc;
clear;
close all;
reference = imread('/home/rex/Desktop/reference.jpg');
imshow(reference)
w = waitforbuttonpress;
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
figure(3)
sp1=subplot(1,2,1);
imshow(reference);
fig = uifigure;
sld = uislider(fig);
sld.Limits = [1 21];
sld.Position = [81,154,419,23];
sldm = uislider(fig);
sldm.Limits = [0 100];
sldm.Position = [81,54,419,23];
slds = uislider(fig);
slds.Limits = [0 100];
slds.Position = [81,254,419,23];
ksize=9;
m_t=30;
s_t=30;
sld.Value=ksize;
sldm.Value=m_t;
slds.Value=s_t;
for k = 1:numel(S)
    h=0.075;
    w=0.075;
    disp(k);
    F = fullfile(D,S(k).name);
    I = imread(F);
    figure(3)
    sp1=subplot(1,2,2);
    imshow(I);
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

    sld.ValueChangedFcn = @(sld,event) updateKsize(sld,g,G,ksize,m_t,s_t);
    sldm.ValueChangedFcn = @(sldm,event) updatem(sldm,g,G,ksize,m_t,s_t);
    slds.ValueChangedFcn = @(slds,event) updates(slds,g,G,ksize,m_t,s_t);
    %process(g,G,ksize,m_t,s_t);
    w = waitforbuttonpress;
    %S(k).data = I; % optional, save data.
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

function process(im_ref,im_test,ksize,m_t,s_t)
    a = im_test;
    mean_ref = zeros(size(im_ref));
    std_ref = zeros(size(im_ref));
    mean_test = zeros(size(im_ref));
    std_ref = zeros(size(im_ref));
    step=floor(ksize/2);
    parfor r=step+1:size(im_ref,1)-step
        v=zeros(size(im_test(r,:)));
        for c=step+1:size(im_ref,2)-step
            mean_ref=mean2(im_ref(r-step:r+step,c-step:c+step));
            std_ref=std2(im_ref(r-step:r+step,c-step:c+step));
            mean_test=mean2(a(r-step:r+step,c-step:c+step));
            std_test=mean2(a(r-step:r+step,c-step:c+step));
            if abs(mean_ref-mean_test)>m_t&&abs(std_ref-std_test)>s_t
                v(c)=255;
            end
        end
        im_test(r,:)=v;
    end
    proc=im_test;
    figure(2)
    display_image(proc);
    title('Processed image');

end


function updateKsize(sld,im_ref,im_test,ksize,m_t,s_t)
ksize=floor(sld.Value);
process(im_ref,im_test,ksize,m_t,s_t);
end

function updatem(sldm,im_ref,im_test,ksize,m_t,s_t)
m_t=floor(sldm.Value);
process(im_ref,im_test,ksize,m_t,s_t);
end

function updates(slds,im_ref,im_test,ksize,m_t,s_t)
s_t=floor(slds.Value);
process(im_ref,im_test,ksize,m_t,s_t);
end
