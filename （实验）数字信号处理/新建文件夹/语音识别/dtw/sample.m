clear
[VX,Fs]=audioread('1.wav');
% audiowrite(filename,y,Fs);
%%�����ҵ�wav��Ϊ���ֻ���¼����˫���������к�����һ�����е������������Ǹ�һ��
t=1/Fs;%����ʱ��

%%%%%%%%���������%%%%%%%%
Ww=1200;%���������
Nw=4000;%ʱ���ƶ���
step=900;%������ǰ������
%%%%%%%%%%%%%%%%%%%%%%%%%%

T=(Nw-1)*step+Ww;%��ȡ������
w=ones(Ww,1);%������

VX=[VX;zeros(Nw-step,2)];
VX1=VX(:,1);
VX2=VX(:,2);
XF1=zeros(size(VX1));
XF2=zeros(size(VX1));
if T>=length(VX1)
    VX1=[VX1;zeros(T-length(VX1),1)];
else
    VX1=VX1(1:T);
end
X1=zeros(Ww,Nw);
for i=1:Nw
    X1(:,i)=VX1((i-1)*step+1:(i-1)*step+Ww);
end

%%%%%%X1Ϊ��� һ����һ֡%%%%%%

