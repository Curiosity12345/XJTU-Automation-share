x=audioread('E:\������\��ʵ�飩�����źŴ���\��һ��\������2\0\0-12.wav');
%���ȹ�һ����[-1,1]
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

%  MFCC������ȡ
M=24;              %Mel�˲�������
fs=8000;           %������8000Hz
fh=fs/2;
fl=0;              %Mel�˲�����ߡ����Ƶ��
tmp=tmp1(x1:x2,:); %��ȡ��Ч��
TMP=fft(tmp);      %���ٸ���Ҷ�任�����滻Ϊ�Լ���д�ĺ�����
E=abs(TMP).^2;     %����ÿ֡�������ߵ�����
f=zeros(M+1,1);    %Mel�˲�������Ƶ��
N=fix(x2-x1+1);         %��������
nmax=15;           %MFCCϵ���Ľ���
for m=1:M+1
    f(m,1)=N/fs*Fmel_(Fmel(fl)+m*(Fmel(fh)-Fmel(fl))/(M+1));
end
S=zeros(N,M);          %Mel�˲�������
for i=1:N              
    x=0;
    for k=1:floor(f(1))
        x=x+E(i,k)*(k-0)/(f(1)-0);
    end
    for k=floor(f(1))+1:floor(f(2))
        x=x+E(i,k)*(f(2)-k)/(f(2)-f(1));
    end
    S(i,1)=x;
    for m=2:M
        x=0;
        for k=floor(f(m-1))+1:floor(f(m))
            x=x+E(i,k)*(k-f(m-1))/(f(m)-f(m-1));
        end
        for k=floor(f(m))+1:floor(f(m+1))
            x=x+E(i,k)*(f(m+1)-k)/(f(m+1)-f(m));
        end
        S(i,m)=x;
    end
end
mfcc=zeros(N,nmax);
for i=1:N
    for n=1:nmax
        x=0;
        for m=1:M
            x=x+log(S(i,m))*cos(pi*n*(2*m-1)/(2*M));
        mfcc(i,n)=sqrt(2/M)*x;
        end
    end
end
function x=Fmel(f)
x=1125*log(1+f/700);
end
function x=Fmel_(f)
x=700*(exp(f/1125)-1);
end