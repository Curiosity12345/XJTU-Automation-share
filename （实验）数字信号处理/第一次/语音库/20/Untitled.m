% ����ƽ̨��Windows 7 64bit��MATLAB R2014a
% ¼��¼2����
recObj = audiorecorder(44100,16,1);
disp('Start speaking.')
recordblocking(recObj, 2);
disp('End of Recording.');
% �ط�¼������
play(recObj);
% ��ȡ¼������
myRecording = getaudiodata(recObj);
% ����¼�����ݲ���
plot(myRecording);
%�洢�����ź�
filename = 'E:\wcrsb\data9.wav';
audiowrite(filename,myRecording,44100);




