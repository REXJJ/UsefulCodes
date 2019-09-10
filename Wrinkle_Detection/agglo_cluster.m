clc;
clear;
close all;
warning off;
m=csvread('/home/rex/Desktop/cluster_points.csv');

pts=zeros(size(m,1),2);
pts(:,1)=m(:,1);
pts(:,2)=m(:,2);
% pts(:,3)=m(:,6);

Z=linkage(pts,'single',@distfun);
z=linkage(pts,'single','cityblock');
dendrogram(z)
T=cluster(z,'cutoff',4,'Criterion','distance');
gscatter(pts(:,2),pts(:,1),T)

function D=distfun(ZI,ZJ)
m=size(ZJ,1);
D=zeros(m,1);
for i=1:m
    d=abs(ZI(1)-ZJ(i,1))+abs(ZI(2)-ZJ(i,2));
%     if d>4
%         D(i)=1000;
%         continue;
%     end
%     D(i)=d+abs(ZI(3)-ZJ(i,3));
D(i)=d;
end
end

