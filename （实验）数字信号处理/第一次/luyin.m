
% ¼��¼2����
recObj = audiorecorder(44100, 16 ,1);
disp('Start speaking.')
recordblocking(recObj, 2);
disp('End of Recording.');
myRecording = getaudiodata(recObj);
%�洢�����ź�
filename = 'E:\������\��ʵ�飩�����źŴ���\�Ľ�\test\9.wav'; 
audiowrite(filename,myRecording,44100);
