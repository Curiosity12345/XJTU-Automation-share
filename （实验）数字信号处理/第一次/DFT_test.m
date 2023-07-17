x=audioread('E:\������\��ʵ�飩�����źŴ���\��һ��\������\1\0.wav');
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
tmp1  = enframe(x(1:end-1), FrameLen, FrameInc);
% tmp1  = enframe(x(1:end-1), hanning(FrameLen), FrameInc);%�人����
tmp2  = enframe(x(2:end)  , FrameLen, FrameInc);
% tmp2  = enframe(x(2:end), hanning(FrameLen), FrameInc);%�人����
signs = (tmp1.*tmp2)<0;
diffs = (tmp1 -tmp2)>0.02;
zcr   = sum(signs.*diffs, 2);

%�����ʱ����
amp = sum(abs(enframe(filter([1 -0.9375], 1, x), FrameLen, FrameInc)), 2);
% amp = sum(abs(enframe(filter([1 -0.9375], 1, x), hanning(FrameLen), FrameInc)), 2);%�人����
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

tmp=tmp1(x1:x2,:);

TMP1=zeros(x2-x1,1);
for k=1:x2-x1
    s=0;
    for m=1:FrameLen
        s=s+tmp(k,m)*exp(-2i*pi*k*m/FrameLen);
    end
    TMP1(k,1)=s;
end
TMP_abs=abs(TMP1);