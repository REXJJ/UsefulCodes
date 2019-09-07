clc;
clear;
close all;
warning off;

global ksize m_l m_a s_l s_a processed_image vlen vlenm vden reference sldlv;
vlen=0;
reference = imread('/home/rex/Desktop/reference.jpg');
figure(3)
subplot(1,2,1);
imshow(reference)
D = '/home/rex/Desktop/TestData';
S = dir(fullfile(D,'*.jpg'));
length(S);
figure(1)
[mag,dir,gx,gy]=getgradient(reference);
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
ksize=9;
m_a=30;
s_a=30;
m_l=30;
s_l=30;
vlen=0;
vlenm=1000;
vden =1;
f = figure(9);
fig = uifigure;
sldl= uicontrol('Parent',f,'Style','slider','Position',[81,410,419,23],...
             'min',0, 'max',500);
sldlv= uicontrol('Parent',f,'Style','text','Position',[120,435,419,23],...
             'String',vlen);
sldln= uicontrol('Parent',f,'Style','text','Position',[120,385,419,23],...
             'String','Vector Length Min');
sldlmin= uicontrol('Parent',f,'Style','text','Position',[70,410,23,23],...
             'String',0);
sldlmax= uicontrol('Parent',f,'Style','text','Position',[500,410,23,25],...
             'String',500);

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
sldma = uislider(fig);
sldma.Limits = [0 360];
sldma.Position = [81,170,419,23];
sldsa = uislider(fig);
sldsa.Limits = [0 360];
sldsa.Position = [81,130,419,23];

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
    [L,A,Gx,Gy]=getgradient(I);
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
    [l,a] = imgradient(gx,gy);
    %xlswrite('/home/rex/Desktop/test.csv',dir);
    figure(5)
    vector_display(I,Gx,Gy,vlen,vlenm,vden)
    sldd.ValueChangedFcn = @(sldd,event) updateDen(sldd,I,Gx,Gy);
    sldl.Callback = @(sldl,event) updateLength(sldl,I,Gx,Gy);
    sldlm.ValueChangedFcn = @(sldlm,event) updateLength(sldlm,I,Gx,Gy);
    
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
    w = waitforbuttonpress;
    %S(k).data = I; % optional, save data.
end

function update_display(I)
    global processed_image reference;
    BW=processed_image>0;
    figure(2)
    subplot(1,2,1);
    imshow(BW);
    title('Processed Image');
    subplot(1,2,2);
    B = labeloverlay(I,BW);
    imshow(B)
    title('Overlaid Image');
end

function [mag,dir,gx,gy] = getgradient(im)
    [gx,gy] = imgradientxy(im,"prewitt");
    [mag,dir] = imgradient(gx,gy);
end

function display_image(im)
    imshow(im , [min(im(:)) max(im(:))])
end

function process(L,l,A,a,ksize,m_l,s_l,m_a,s_a)
    a0 = l;
    a1 = a;
    ksize
    m_l
    s_l
    m_a
    s_a
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
    im=I;
    quiver(x(l>len&l<lenm),y(l>len&l<lenm),u(l>len&l<lenm),v(l>len&l<lenm))
    axis image %plot the quiver to see the dimensions of the plot
    hax = gca; %get the axis handle
    image(hax.XLim,hax.YLim,im); %plot the image within the axis limits
    hold on; %enable plotting overwrite
    quiver(x(l>len&l<lenm),y(l>len&l<lenm),u(l>len&l<lenm),v(l>len&l<lenm))

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
global vlen vden vlenm sldlv;
vlen=floor(sldl.Value);
% sldl.Value
sldlv.String = int2str(floor(sldl.Value));
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
