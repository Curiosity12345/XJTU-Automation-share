path='E:\������\��ʵ�飩�����źŴ���\��һ��\������\';     %������洢·���������Լ����޸ļ���
samplenum=14;     %ʵ����������ÿ����������0~9 10��¼����

Character=zeros(samplenum*10,7); 
%������������7�������У�����ÿ�д���Ĳ���Ϊ��
%[
%��ʱ�������ֵ����ʱ������Сֵ����ʱ����ƽ��ֵ��
%��ʱ����������ֵ����ʱ���������Сֵ����ʱ�������ƽ��ֵ��������ǩ��0~9��
%]

for j=1:samplenum
    filename=dir([path,int2str(j),'\*.wav']);
    for i=1:size(filename)
        x=audioread([path,int2str(j),'\',filename(i).name]);
        Character((j-1)*10+i,:)=[vad(x),i-1];
    end
end
Character
%PS���ҷ��ֶ�ʱ���������Сֵ����0������˵��������������һ֡û�й���㣬����ʱ����ɾȥ��ά��
% for j=0:9
%     filename=dir([path,int2str(j),'\*.wav']);
%     s=0; %����������
%     for i=1:size(filename)
%         x=audioread([path,int2str(j),'\',filename(i).name]);
%         for j=1:size(itemchara,1)
%             Character(j*samplenum+i,:)=[vad(x),i];
%     end
%     fname=['Character2.xls'];
%     xlswrite(fname,Character);
% end