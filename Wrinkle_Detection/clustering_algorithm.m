clc;
clear;
close all;
warning off;
m=csvread('/home/rex/Desktop/cluster_points.csv');
global m_o;
m_o=zeros(size(m,1),1);
for i=1:size(m,1)
    m_o(i)=m(i,1)*10000+m(i,2);
end
global map;
map=zeros(1000,1000);
for i=1:size(m,1)
    map(m(i,1),m(i,2))=1;
end

c=cluster(m);


function t=find_neighbor(i,j)
global map;
if i>900||j>900||i<1||j<1
    t=[i,j];
    return;
end
if map(i,j)==0
    t=[i,j];
    return;
end
map(i,j)=0;
t=[i,j];
step=2;
for a=-step:step
    for b=-step:step
        if a==0&&b==0
            continue;
        end
        t=[t;find_neighbor(i+a,j+b)];
    end
end
end


function id=find_unclassified(unclassified)
for i=1:size(unclassified,1)
    if unclassified(i)==1
        id=i;
        return;
    end
end
id=0;
end


function c=cluster(m)
global map m_o;
unclassified=ones(size(m,1),1);
class=zeros(size(m,1),1);
class_no=1;
while sum(sum(map))~=0
    it=find_unclassified(unclassified);
    if it==0
        break;
    end
    i=m(it,1);
    j=m(it,2);
    t=find_neighbor(i,j);
    for i=1:size(t,1)
        id=find(m_o==t(i,1)*10000+t(i,2));
        unclassified(id)=0;
        if size(t,1)>100
          class(id)=class_no;
        end
    end
    if size(t,1)>50
      class_no=class_no+1
      size(t,1)
    end
end
c=class;
end

function cluster=get_cluster(c,id)
    ids=find(c==id);
    cluster=[m(id,1),m(id,2)]
end
    



    
    