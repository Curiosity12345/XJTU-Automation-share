path='E:\������\��ʵ�飩�����źŴ���\��һ��\������2\';     %������洢·���������Լ����޸ļ���
samplenum=100;     %ʵ����������ÿ����������0~9 10��¼����

%Character=zeros(samplenum*10,6); 
%������������16�������У�����ǰ15�д���mfcc�������������һ���������ֲ�ͬ�������ļ���

for j=0:9
    filename=dir([path,int2str(j),'\*.wav']);
    s=0; %����������
    for i=1:samplenum
        x=audioread([path,int2str(j),'\',filename(i).name]);
        itemchara=Mfcc(x);
        for k=1:size(itemchara,1)
            Character(s+k,:)=[itemchara(k,:),i];
        end
        s=s+size(itemchara,1);
    end
    fname=['MFCC',num2str(j), '.xls'];
    xlswrite(fname,Character);
    clear Character
end

