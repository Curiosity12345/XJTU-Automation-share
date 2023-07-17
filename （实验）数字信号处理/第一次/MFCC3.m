function getmfcc= MFCC3(x,fs)
 %=========================================================
 % ��ȡMFCC��������
 % ��ȥ�뼰�˵���
 % Input:��Ƶ����x,������fs
 % Output��(N,M)��С��������������  ����NΪ��֡������MΪ����ά��
 % ����������M=24 ����ϵ��12ά��һ�ײ��12ά
 %=========================================================
tic
x = double(x);
x = x / max(abs(x));

%��������
FrameLen = 256;
FrameInc = 80;

amp1 = 10;
amp2 = 2;
zcr1 = 10;
zcr2 = 5;

maxsilence = 8;  % 8*10ms  = 80ms
minlen  = 15;    % 15*10ms = 150ms
status  = 0;
count   = 0;
silence = 0;


%���������
tmp1  = enframe(x(1:end-1), hamming(FrameLen), FrameInc);%�人����
tmp2  = enframe(x(2:end), hamming(FrameLen), FrameInc);%�人����
signs = (tmp1.*tmp2)<0;
diffs = (tmp1 -tmp2)>0.02;
zcr   = sum(signs.*diffs, 2);

%�����ʱ����
amp = sum(abs(enframe(filter([1 -0.9375], 1, x), hamming(FrameLen), FrameInc)), 2);%�人����
%������������
amp1 = min(amp1, max(amp)/4);
amp2 = min(amp2, max(amp)/8);

%��ʼ�˵���
x1 = 0; 
% x2 = 0;
for n=1:length(zcr)
%    goto = 0;
   switch status
   case {0,1}                   % 0 = ����, 1 = ���ܿ�ʼ
      if amp(n) > amp1          % ȷ�Ž���������
         x1 = max(n-count-1,1);
         status  = 2;
         silence = 0;
         count   = count + 1;
      elseif amp(n) > amp2 || ... % ���ܴ���������
             zcr(n) > zcr2
         status = 1;
         count  = count + 1;
      else                       % ����״̬
         status  = 0;
         count   = 0;
      end
   case 2                       % 2 = ������
      if amp(n) > amp2 || ...     % ������������
         zcr(n) > zcr2
         count = count + 1;
      else                       % ����������
         silence = silence+1;
         if silence < maxsilence % ����������������δ����
            count  = count + 1;
         elseif count < minlen   % ��������̫�̣���Ϊ������
            status  = 0;
            silence = 0;
            count   = 0;
         else                    % ��������
            status  = 3;
         end
      end
   case 3
      break;
   end
end

count = count-silence/2;
x2 = x1 + count -1;

xx=tmp1(x1:x2,:); %��ȡ��Ч��
%��һ��mel�˲�����ϵ��

bank=melbankm(24,256,fs,0,0.5,'m');%Mel�˲����Ľ���Ϊ24��fft�任�ĳ���Ϊ256������Ƶ��Ϊ8000Hz  

bank=full(bank);

bank=bank/max(bank(:));%[24*129]

 %�趨DCTϵ��
 
for k=1:12

n=0:23;

dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));

end

%��һ��������������

w=1+6*sin(pi*[1:12]./12);

w=w/max(w);



%����ÿ֡��MFCC����

for i=1:size(xx,1)

y=xx(i,:);%ȡһ֡����

s=y'.*hamming(256);

t=abs(fft(s));%fft���ٸ���Ҷ�任  ������

t=t.^2; %������

%��fft��������mel�˲�ȡ�����ټ��㵹��
c1=dctcoef*log(bank*t(1:129));%���������˲���DCT %t(1:129)��һ֡��ǰ128������֡��Ϊ128��

c2=c1.*w';%��һ������

%mfcc����

m(i,:)=c2';

end

%��ȡһ�ײ��ϵ��

dtm=zeros(size(m));

for i=3:size(m,1)-2

dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);

end

dtm=dtm/3;
%��ȡ���ײ��ϵ��

dtm2=zeros(size(dtm));

for i=3:size(dtm,1)-2

dtm2(i,:)=-2*dtm(i-2,:)-dtm(i-1,:)+dtm(i+1,:)+2*dtm(i+2,:);

end

dtm2=dtm2/3;

%�ϲ�mfcc������һ�ײ��mfcc����

ccc=[m dtm dtm2];

%ȥ����β��֡����Ϊ����֡��һ�ײ�ֲ���Ϊ0
ccc=ccc(3:size(m,1)-2,:);

getmfcc=ccc;%��������ֵ
%'MFCC����������ȡʱ��'
toc

% subplot(2,1,1)
% plot(ccc(100,:));
% hold on
% plot(ccc(200,:),'r');
% plot(ccc(300,:),'g');
% plot(ccc(400,:),'y');
% plot(ccc(500,:),'b');
% xlabel('ά��');
% ylabel('��ֵ');
% title('֡��100->500');
% subplot(2,1,2)
% plot(ccc(:,1));
% hold on
% plot(ccc(:,2),'r');
% plot(ccc(:,3),'g');
% plot(ccc(:,5),'y');
% plot(ccc(:,7),'b');
% xlabel('֡��');
% ylabel('��ֵ');
% title('ά��1->7')

% subplot(2,1,1)
% ccc_1=ccc(:,1);
% plot(ccc_1);title('MFCC');ylabel('��ֵ');
% [h,w]=size(ccc);
% A=size(ccc);
% subplot(212) 
% plot([1,w],A);
% xlabel('ά��');
% ylabel('��ֵ');
% title('ά�����ֵ�Ĺ�ϵ')
end