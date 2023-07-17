function dist = dtw(test, ref)
global x y_min y_max
global t r
global D d
global m n

t = test;
r = ref;
n = size(t,1);
m = size(r,1);

d = zeros(m,1);
D =  ones(m,1) * realmax;
D(1) = 0;

% �������ģ�峤�������࣬ƥ��ʧ��
if (2*m-n<3) || (2*n-m<2)
	dist = realmax;
	return
end

% ����ƥ������
xa = round((2*m-n)/3);
xb = round((2*n-m)*2/3);

if xb>xa
	%xb>xa, ��������������ƥ��
	%        1   :xa
	%        xa+1:xb
	%        xb+1:N
	for x = 1:xa
		y_max = 2*x;
		y_min = round(0.5*x);
		warp
	end
	for x = (xa+1):xb
		y_max = round(0.5*(x-n)+m);
		y_min = round(0.5*x);
		warp
	end
	for x = (xb+1):n
		y_max = round(0.5*(x-n)+m);
		y_min = round(2*(x-n)+m);
		warp
	end
elseif xa>xb
	%xa>xb, ��������������ƥ��
	%        0   :xb
	%        xb+1:xa
	%        xa+1:N
	for x = 1:xb
		y_max = 2*x;
		y_min = round(0.5*x);
		warp
	end
	for x = (xb+1):xa
		y_max = 2*x;
		y_min = round(2*(x-n)+m);
		warp
	end
	for x = (xa+1):n
		y_max = round(0.5*(x-n)+m);
		y_min = round(2*(x-n)+m);
		warp
	end
elseif xa==xb
	%xa=xb, ��������������ƥ��
	%        0   :xa
	%        xa+1:N
	for x = 1:xa
		y_max = 2*x;
		y_min = round(0.5*x);
		warp
	end
	for x = (xa+1):n
		y_max = round(0.5*(x-n)+m);
		y_min = round(2*(x-n)+m);
		warp
	end
end

%����ƥ�����
dist = D(m);

function warp
global x y_min y_max
global t r
global D d
global m n

d = D;
for y = y_min:y_max
	D1 = D(y);
	if y>1
		D2 = D(y-1);
	else
        D2 = realmax;
	end
	if y>2
		D3 = D(y-2);
	else
        D3 = realmax;
	end
    d(y) = sum((t(x,:)-r(y,:)).^2) + min([D1,D2,D3]);
end

D = d;
function [cost] = myDTW(featureMatrix,RefMatrix)
F = featureMatrix;
R = RefMatrix;
[r1,c1]=size(F);        
[r2,c2]=size(R);        
localDistance = zeros(r1,r2);
%�ֲ��������������ʾ
for n=1:r1
    for m=1:r2
        FR=F(n,:)-R(m,:);
        FR=FR.^2;
        localDistance(n,m)=sqrt(sum(FR));
    end
end

D = zeros(r1+1,r2+1);   
D(1,:) = inf;           
D(:,1) = inf;           
D(1,1) = 0;
D(2:(r1+1), 2:(r2+1)) = localDistance;



%���ѭ��ͨ�������������õ�ȫ�ֵ����¾���
for i = 1:r1
 for j = 1:r2
   [dmin] = min([D(i, j), D(i, j+1), D(i+1, j)]);
   D(i+1,j+1) = D(i+1,j+1)+dmin;
 end
end

cost = D(r1+1,r2+1);    %����ȫ����С�÷�
