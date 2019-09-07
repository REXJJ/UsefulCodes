clc;
clear;
close all;
warning off;
global ksize nl processed_image emin emax;
D = '/home/rex/Desktop/TestData2';
S = dir(fullfile(D,'*.png'));
length(S);
fig = uifigure;

sld = uislider(fig);
sld.Limits = [1 31];
sld.Position = [81,350,419,20];

txlk = uilabel(fig);
txlk.Text='k size';
txlk.FontSize=12;
txlk.Position = [81,360,200,15];

sldm = uislider(fig);
sldm.Limits = [0 12];
sldm.Position = [81,250,419,20];

txlkdd = uilabel(fig);
txlkdd.Text='Magnitude';
txlkdd.FontSize=12;
txlkdd.Position = [81,260,200,15];

sldee = uislider(fig);
sldee.Limits = [0 10];
sldee.Position = [81,150,419,20];

txlkdde = uilabel(fig);
txlkdde.Text='emin';
txlkdde.FontSize=12;
txlkdde.Position = [81,160,200,15];

sldme = uislider(fig);
sldme.Limits = [0 10];
sldme.Position = [81,50,419,20];

txlkddee = uilabel(fig);
txlkddee.Text='emax';
txlkddee.FontSize=12;
txlkddee.Position = [81,60,200,15];



ksize=9;
nl=0.5;
emin=0.5;
emax=1.0;
sld.Value=ksize;
sldm.Value=nl;
sldee.Value=emin;
sldme.Value=emax;
for k = 1:numel(S)
    disp(k);
    F = fullfile(D,S(k).name);
    I = imread(F);
    I=rgb2gray(I);
    sld.ValueChangedFcn = @(sld,event) update(sld,I,2);
    sldm.ValueChangedFcn = @(sldm,event) update(sldm,I,0);
    sldme.ValueChangedFcn = @(sldme,event) update(sldme,I,1);
    sldee.ValueChangedFcn = @(sldee,event) update(sldee,I,3);

    process(I,ksize,nl,emin,emax)
    update_display(I);
    figure(3);
    imshow(I);
%     figure(4)
%     subplot(1,2,1);
%     [g,dir,gx,gy]=getgradient(I);
%     display_image(gx);
%     subplot(1,2,2)
%     display_image(gy);
%     vector_display(I,gx,gy,0,100,1);
    w = waitforbuttonpress;
    %S(k).data = I; % optional, save data.
end

function update_display(I)
    global processed_image;
    BW=processed_image>0;
    figure(2)
    subplot(1,2,1);
    imshow(processed_image);
    title('Processed Image');
    subplot(1,2,2);
    B = labeloverlay(I,BW);
    imshow(B)
    title('Overlaid Image');
end

function display_image(im)
    imshow(im, [min(im(:)) max(im(:))])
end

function eim=ent_pro(l,emin,emax)
a0=l;
step=9;
    parfor r=step+1:size(a0,1)-step
        v0=zeros(size(a0(r,:)));
        for c=step+1:size(a0,2)-step
            e=(entropy(a0(r-step:r+step,c-step:c+step)))
             if e>=emin&&e<=emax
                v0(c)=255;
            end         
        end
        l(r,:)=v0;
    end
    eim=l;
end

function process(l,ksize,nl,emin,emax)
    a0 = l;
    n=ksize*ksize;
    step=floor(ksize/2);
    parfor r=step+1:size(a0,1)-step
        v0=zeros(size(a0(r,:)));
        for c=step+1:size(a0,2)-step
            mean_l=mean2(a0(r-step:r+step,c-step:c+step));
            mean_l=((mean_l*n)-a0(r,c))/n-1;
            std_l=std2(a0(r-step:r+step,c-step:c+step));   
            V=std_l*std_l;
            V=(V*n-(a0(r,c)-mean_l)*(a0(r,c)-mean_l))/n-1;
            std_l=sqrt(double(V));
            if floor(std_l*10.0)>0&&abs(a0(r,c)-mean_l)>abs(nl*std_l)
                v0(c)=255;
            end         
        end
        l(r,:)=v0;
    end
    global processed_image;
    processed_image=ent_pro(l,emin,emax);
end

function update(sldm,I,id)
global ksize nl emin emax;
if id==0
nl=sldm.Value;
end
if id==2
ksize=floor(sldm.Value);
end
if id==1
emax=sldm.Value;
end
if id==3
emin=(sldm.Value);
end
process(I,ksize,nl,emin,emax)
update_display(I);
end