function [k,fs] = luyin1()
% ¼��¼2����
recObj = audiorecorder(44100, 16 ,1);
disp('Start speaking.')
recordblocking(recObj, 2);
disp('End of Recording.');
myRecording = getaudiodata(recObj);
%�洢�����ź�
filename = 'D:\������\��ʵ�飩�����źŴ���\test\test.wav'; 
audiowrite(filename,myRecording,44100);
[k,fs]=audioread(filename);
end