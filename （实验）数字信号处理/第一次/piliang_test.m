path='E:\������\��ʵ�飩�����źŴ���\��һ��\������\';
filename=dir([path,'1\*.wav']);
Character=zeros(10,6);
% for j=1:14
    for i=1:size(filename)
        x=audioread(['E:\������\��ʵ�飩�����źŴ���\��һ��\������\1\',filename(i).name]);
%         Character(end+1)=[vad(x),i];
        Character(i,:)=vad(x);
    end
% end
Character
%matlabroot,'\toolbox\voicebox;', ...