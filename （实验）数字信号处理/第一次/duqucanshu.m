path='E:\������\��ʵ�飩�����źŴ���\��һ��\������2\';     %������洢·���������Լ����޸ļ���

%Character=zeros(samplenum*10,6); 
%������������16�������У�����ǰ15�д���mfcc�������������һ���������ֲ�ͬ�������ļ���

for j=0:9
    filename=dir([path,int2str(j),'\*.wav']);
    for i=1:100
        [x,fs]=audioread([path,int2str(j),'\',filename(i).name]);
        itemchara=MFCC4(x);
        Character{j+1,i}=itemchara;
    end
end

