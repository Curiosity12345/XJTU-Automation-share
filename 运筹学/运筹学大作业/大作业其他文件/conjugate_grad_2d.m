function f=conjugate_grad_2d(x0,t)
%�ù����ݶȷ�����֪����f(x1,x2)=x1^2+2*x2^2-4*x1-2*x1*x2�ļ�ֵ��?
%��֪��ʼ�����꣺x0?
%��֪�������ȣ�t?
%�����֪�����ļ�ֵ��f?
x=x0;
syms xi yi a; %�����Ա���������Ϊ���ű���?
f=xi^2+2*yi^2-4*xi-2*xi*yi; %�������ű��ʽf?
fx=diff(f,xi); %����ʽf��xi��һ����
fy=diff(f,yi); %����ʽf��yi��һ����?
fx=subs(fx,{xi,yi},x0); %�����ʼ����������xi��һ����ʵֵ
fy=subs(fy,{xi,yi},x0); %�����ʼ����������yi��һ����ʵֵ?
fi=[fx,fy]; %��ʼ���ݶ�����
count=0; %����������ʼΪ0?
while double(sqrt(fx^2+fy^2))>t %�������Ȳ�������֪����
    s=-fi; %��һ�������ķ���Ϊ���ݶȷ���?????
    if count<=0
        s=-fi;
    else
        s=s1;
    end
    x=x+a*s; %����һ��������ĵ�����?
    f=subs(f,{xi,yi},x); %����һԪ������һԪ������(a)?????
    f1=diff(f); %�Ժ�����(a)������
    f1=solve(f1); %�õ���Ѳ���a?????
    if f1~=0 
        ai=double(f1); %ǿ��ת����������Ϊ˫������ֵ?????
    else
        break %��a=0����ֱ������ѭ�����˵㼴Ϊ��ֵ��?????
    end
    x=subs(x,a,ai);%�õ�һ�������������ֵ
    f=xi^2+2*yi^2-4*xi-2*xi*yi;
    fxi=diff(f,xi);
    fyi=diff(f,yi);
    fxi=subs(fxi,{xi,yi},x);
    fyi=subs(fyi,{xi,yi},x);
    fii=[fxi,fyi];%��һ���ݶ�����
    d=(fxi^2+fyi^2)/(fx^2+fy^2);
    s1=-fii+d*s;%��һ�������ķ�������
    count=count+1;%����������һ
    fx=fxi;
    fy=fyi;%�������յ������Ϊ��һ��������ʼ������
end
x,f=subs(f,{xi,yi},x),count %�����ֵ�㣬��Сֵ����������
    