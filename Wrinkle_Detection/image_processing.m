clc;
clear;
close all;
reference = imread('/home/rex/Desktop/reference.jpg');
imshow(reference)
w = waitforbuttonpress;
D = '/home/rex/Desktop/TestData';
S = dir(fullfile(D,'*.jpg')); % pattern to match filenames.
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
[m,s]=calculate_sd(g);
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
    figure(2)
    proc=process(G,m,s);
    display_image(proc);
    title('Processed image');
    w = waitforbuttonpress;
    %S(k).data = I; % optional, save data.
end

function image = preprocess(im)
    image=rgb2gray(im)
end

function [g,gx,gy] = getgradient(im)
    [gx,gy] = imgradientxy(im,"prewitt");
    [Gmag,Gdir] = imgradient(gx,gy);
    g=Gmag;
end

function display_image(im)
    imshow(im , [min(im(:)) max(im(:))])
end

function [mean_ref,std_ref]= calculate_sd(im)
    ksize=5;
    mean_ref = zeros(size(im));
    size(mean_ref)
    std_ref = zeros(size(im));
    step=floor(ksize/2);
    for r=step+1:size(im,1)-step
        for c=step+1:size(im,2)-step
            mean_ref(r-step:r+step,c-step:c+step)=mean2(im(r-step:r+step,c-step:c+step));
            std_ref(r-step:r+step,c-step:c+step)=std2(im(r-step:r+step,c-step:c+step));
        end
    end           
end

function proc=process(image,m,s)
for i=1:size(image,1)
    for j=1:size(image,2)
        if abs(image(i,j)-m(i,j))<7*s(i,j)
            image(i,j)=0;
        end
    end
end
proc=image;
end
    
