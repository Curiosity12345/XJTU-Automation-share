%��һ���ļ����еĶ��wav�ļ���Ȼ��ƴ����һ��

folder = 'E:/wecsb/';

files = dir([folder '*.wav']);%��ȡ�ļ����µ�����wav�ļ�

%files = dir(folder);

%length(files)

for i=1:length(files)

file = [folder files(i).name];

    try
   
     [Y,Fs,bits] = audioread(file);%����ֵ�ֱ�ΪY��ȡƬ�Σ�Fs������Ĭ��Ϊ44100��bits����λ��һ��Ϊ16λ

    catch
      
  warning(['��ȡ�ļ� ' file ' �������ܲ�֧�ָ��ļ���ʽ��']);

    end
   
 try
     
   sec1=10;
     
   sec2=15;
      
  sec3=20;
      
  sec4=25;    
    
    %addPoint=2*Fs;
   
     Y_cut1=Y(((Fs*sec1+1):Fs*sec2),:); %�������ʽ��ȡ
 
       Y_cut2=Y(((Fs*sec3+1):Fs*sec4),:);
    
    Y_cutall=[Y_cut1;Y_cut2];%�������ʽƴ����Ҫ����ƴ��
    
    audiowrite(Y_cutall,Fs,bits,['E:/wecsb/' 'newname' num2str(i) '.wav']);


    catch
        
warning(['д���ļ� ' file ' ����д����ַ����']);
  
  end

end
