clear;
close all;
warning off;
global an;
m=csvread('/home/rex/Desktop/cluster_points.csv');
global m_o;
global ref;
global map ind;
map=zeros(1000,1000);
an=zeros(1000,1000);
ind=zeros(1000,1000);
for i=1:size(m,1)
    map(m(i,1),m(i,2))=1;
    an(m(i,1),m(i,2))=m(i,6);
    ind(m(i,1),m(i,2))=i;
end


c=cluster(m);


function t=find_neighbor(i,j,A)
global map an;
  if i>900||j>900||i<1||j<1||abs(an(i,j)-A)>10
% if i>900||j>900||i<1||j<1
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
        t=[t;find_neighbor(i+a,j+b,an(i,j))];
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
global map m_o ref ind;
unclassified=ones(size(m,1),1);
class=zeros(size(m,1),1);
class_no=1;
while sum(sum(map))~=0
    csf=0;
    it=find_unclassified(unclassified);
    if it==0
        break;
    end
    i=m(it,1);
    j=m(it,2);
    A=m(it,6);

    t=find_neighbor(i,j,A);
    temp=unique(t(:,1)*10000+t(:,2));
    z=zeros(size(temp,1),2);
    z(:,1)=floor(temp/10000);
    z(:,2)=mod(temp,10000);
    t=z;
    points=0;
    for i=1:size(t,1)
        id=ind(t(i,1),t(i,2));
        if id>0
         unclassified(id)=0;
         points=points+1;
        end;
        if points>100 && id>0
          class(id)=class_no;
          csf=1;
        end
     if class_no==2
         ref=t;
             end
    end

    if csf==1
      class_no=class_no+1
    end
end
c=class;
end

% function cluster=get_cluster(c,id)
%     ids=find(c==id);
%     cluster=[m(id,1),m(id,2)]
% end
    



    
    