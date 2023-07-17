function Cn=mfccshen(X)
% [X Fs]=audioread('handel.wav');
Fs=44100;
xn=enframe(filter([1 -0.97],1,X),512,341);
% Xk=rand(1000,1024);%����Ƶ�� ��ΧΪ0~2pi
% Fs=44100;%����Ƶ��
Xk=fft(xn,512,2);
M=40;%�˲�������
[N,L]=size(Xk);
Xk=Xk(:,1:L/2);   
L=L/2;
FS=Fs/2;
df=Fs/L;
% Xk=fftshift(Xk);%��Χ-pi~pi

% f=(0:L-1)*2*pi*Fs;%Ƶ��Ƶ�ʷֲ�


Hm=zeros(L,M);
m=0:M-1;
f=L/FS*iMel(Mel(0)+m*(Mel(FS)-Mel(0))/(M+1));
for i=2:M-1%m=0��m=Mʱ��m-1��m+1δ���
    fp=fix(f(i-1));%previous
    fc=fix(f(i));%current
    fn=fix(f(i+1));%next
    Hm(:,i)=[zeros(fp,1);((fp:fc)'-fp)/(fc-fp);(fn-(fc+1:fn)')/(fn-fc);zeros(L-fn-1,1)];
%     plot(Hm(:,i))
%     hold on
end
Hm(1,2)=0;
Sm=log10((Xk.*conj(Xk))*Hm+1e-6);
n=16;%MFCCϵ������
CF=cos(pi*(m+0.5)'*(0:n-1)/M);
Cn=Sm*CF;
%%ÿ��Ϊһ֡


% function FM=fm(m,N,M,Fs,fl,fh)
% FM=N/Fs*iMel(Mel(fl)+m*(Mel(fh)-Mel(fl))/(M+1));
% end

function MF=Mel(f)
MF=2595*log10(1+f/700);
end

function IMF=iMel(b)
IMF=700*(exp(b/1125)-1);
end
end

% function FFT()
