function[E,E1,Z]=tiqu(VX,mid,fpsl)
%%%%%%%%���������%%%%%%%%
t=0.02;%ÿһ֡���Ե�ʱ��20ms
Ww=t*44100;%���������882
%Nw=4999;%ʱ���ƶ���220500=441*4999.333+294
step=2*Ww/3;%������ǰ������588,Ҳ����˵ÿһ֡��294�ظ�
%%%%%%%%%%%%%%%%%%%%%%%%%%

    data=zeros(Ww,fpsl);%ÿһ��Ϊһ֡�����ݣ�Ww=882,fpsΪ���֡��
    E=zeros(1,mid);
    E1=zeros(1,mid);
    Z=zeros(1,mid);%����֡�����������͹��������鲢��ʼ��,������
    for j=1:1:min(fpsl,mid) %���ѭ���Ƿ�֡������ÿһ֡��E��Z
        for i=1:1:Ww
            %data(i,j)=VX(i+(j-1)*step)*w;
            data(i,j)=VX(i+(j-1)*step);
            E(j)=data(i,j)^2+E(j);
            E1(j)=abs(data(i,j))+E1(j);
            if(i==Ww)
                break
            end 
            Z(j)=Z(j)+abs(sign(data(i,j))-sign(data(i+1,j)))/2;
        end
        %������E(j) and Z(j)�ֱ�Ϊ�ö�����ÿ֡��������ƽ��������
    end
    E1=E1/max(E1);