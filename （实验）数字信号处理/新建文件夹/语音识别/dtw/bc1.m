clear
%%%%%%%%���������%%%%%%%%
t=0.02;%ÿһ֡���Ե�ʱ��20ms
Ww=t*44100;
Ww=240;%���������882
%Nw=4999;%ʱ���ƶ���220500=441*4999.333+294
step=2*Ww/3;
step=80;%������ǰ������588,Ҳ����˵ÿһ֡��294�ظ�
%%%%%%%%%%%%%%%%%%%%%%%%%%
Tezheng1=[];%������
Tezheng2=[];%�������
zhenshu=[];
lable=zeros(1000,1);
    
    
    word=[{'zero'};{'one'};{'two'};{'three'};{'four'};{'five'};{'six'};{'seven'};{'eight'};{'nine'}];
   
for j=1:20
    for i=0:9
        [VX0,Fs]=audioread(['C:\Users\15pr\Desktop\����ʶ��\�߲�\',num2str(i),'\',word{i+1},num2str(j),'.wav']);
        VX=VX0(:,1);
        N=length(VX);%���ļ����ַ�����
        fps=ceil((N-160)/80);
        fps=fps-2;%��ȡ��֡��
        zhenshu=[zhenshu,fps];
        lable((j-1)*10+i+1)=i;
    end
end
fpsmax=max(zhenshu);
fpsmin=min(zhenshu);
fpsmid=(fpsmax+fpsmin)/2;
fpsmid=ceil(fpsmid);
fpsmid=600;
for j=1:20
    for i=0:9
        [VX0,Fs]=audioread(['C:\Users\15pr\Desktop\����ʶ��\�߲�\',num2str(i),'\',word{i+1},num2str(j),'.wav']);
        VX=VX0(:,1);
        ZZZ=(j-1)*10+i+1;
        XXX=zhenshu(ZZZ);
        [E,Z,E1]=tiqu2(VX,fpsmid,XXX);
        % Z=Z/abs(max(Z));
        Tezheng1=[Tezheng1;E];
        Tezheng2=[Tezheng2;Z];
        %Tezheng1��2�ֱ���ÿһ����������������Ϊ�е���������
    end
end

        







train_label=zeros(160,1);% ������
practise_label=zeros(40,1);

train_data0=zeros(160,fpsmid);% ����ÿ��һ��������ÿ��һ������
practise_data0=zeros(40,fpsmid);
train_data1=zeros(160,fpsmid);
practise_data1=zeros(40,fpsmid);
for i=1:1:160
    if(zhenshu(i)>=fpsmid)
        for j=1:1:fpsmid
            train_data0(i,j)=Tezheng1(i,j);
            train_data1(i,j)=Tezheng2(i,j);
        end
    else 
        for j=1:1:zhenshu(i)
            train_data0(i,j)=Tezheng1(i,j);
            train_data1(i,j)=Tezheng2(i,j);
        end
    end
    train_label(i)=lable(i);
end
for i=1:1:40
    if(zhenshu(i+160)>=fpsmid)
        for j=1:1:fpsmid
            practise_data0(i,j)=Tezheng1(i+160,j);
            practise_data1(i,j)=Tezheng2(i+160,j);
        end
    else 
        for j=1:1:zhenshu(i+160)
            practise_data0(i,j)=Tezheng1(i+160,j);
            practise_data1(i,j)=Tezheng2(i+160,j);
        end
    end
    practise_label(i)=lable(i+160);
end
%Z

train_data=[train_data1 train_data0];
practise_data=[practise_data1 practise_data0];
%{  
K���ڷ����� ��KNN��
Factor = ClassificationKNN.fit(train_data, train_label, 'NumNeighbors', 10);
predict_label   =       predict(Factor, practise_data);
accuracy         =       length(find(predict_label == practise_label))/length(practise_label)*100
               
 
���ɭ�ַ�������Random Forest��
B = TreeBagger(nTree,train_data0,train_label);
predict_label = predict(B,test_data);
 
 
���ر�Ҷ˹ ��Na?ve Bayes��
nb = NaiveBayes.fit(train_data0, train_label);
predict_label   =       predict(nb, practise_data0);
accuracy         =       length(find(predict_label == practise_label))/length(practise_label)*100;
 
 
����ѧϰ������Ensembles for Boosting, Bagging, or Random Subspace��
ens = fitensemble(train_data,train_label,'AdaBoostM1' ,100,'tree','type','classification');
predict_label   =       predict(ens, test_data);
 
 
���������������discriminant analysis classifier��
obj = ClassificationDiscriminant.fit(train_data, train_label);
predict_label   =       predict(obj, practise_data);
accuracy=length(find(predict_label ==practise_label))/length(practise_label)*100;

 
 

%}  

            
    
