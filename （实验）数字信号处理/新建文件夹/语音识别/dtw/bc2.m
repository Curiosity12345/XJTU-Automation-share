clear

%  for framelenth=245:49:1323
    framelenth=600;
% LL=1;
% for frameinc=0:(1/12*framelenth):ceil(2/3*framelenth)
 
 frameinc=200;
frameoverlaped=400;
 Tezheng1=[];%������
Tezheng2=[];%�������
zhenshu=[];
lable=zeros(1000,1);   
    word=[{'zero'};{'one'};{'two'};{'three'};{'four'};{'five'};{'six'};{'seven'};{'eight'};{'nine'}];
   
for j=1:100
    for i=0:9
        [VX0,Fs]=audioread(['C:\Users\15pr\Desktop\����ʶ��\�߲�\',num2str(i),'\',word{i+1},num2str(j),'.wav']);
        VX=VX0(:,1);
        N=length(VX);%���ļ����ַ�����
        fps=ceil((N-frameoverlaped)/frameinc);
        fps=fps-1;%��ȡ��֡��
        zhenshu=[zhenshu,fps];
        lable(10*(j-1)+i+1)=i;
    end
end
fpsmid=max(zhenshu);
for j=1:100
    for i=0:9
        [VX0,Fs]=audioread(['C:\Users\15pr\Desktop\����ʶ��\�߲�\',num2str(i),'\',word{i+1},num2str(j),'.wav']);
        VX=VX0(:,1);
        XXX=zhenshu(10*(j-1)+i+1);
        [E,Z,E1]=tiqu2(VX,fpsmid,XXX,framelenth,frameinc);
        % Z=Z/abs(max(Z));
        Tezheng1=[Tezheng1;E];
        Tezheng2=[Tezheng2;Z];
        %Tezheng1��2�ֱ���ÿһ����������������Ϊ�е���������
    end
end

        







train_label=zeros(900,1);% ������
practise_label=zeros(100,1);

train_data0=zeros(900,fpsmid);% ����ÿ��һ��������ÿ��һ������
practise_data0=zeros(100,fpsmid);
train_data1=zeros(900,fpsmid);
practise_data1=zeros(100,fpsmid);
k1=1;
k2=1;
for i=1:1:1000
    l=mod(i,200);
    if(l<180)
        if(zhenshu(i)>=fpsmid)
            %for j=1:1:fpsmid
                train_data0(k1,1:fpsmid)=Tezheng1(i,1:fpsmid);
                train_data1(k1,1:fpsmid)=Tezheng2(i,1:fpsmid);
            %end
        else 
           % for j=1:1:zhenshu(i)
                train_data0(k1,1:zhenshu(i))=Tezheng1(i,1:zhenshu(i));
                train_data1(k1,1:zhenshu(i))=Tezheng2(i,1:zhenshu(i));
            %end
        end
    train_label(k1)=lable(i);
    k1=k1+1;
    end
    if(l>=180)
        if(zhenshu(i)>=fpsmid)
           % for j=1:1:fpsmid
                practise_data0(k2,1:fpsmid)=Tezheng1(i,1:fpsmid);
                practise_data1(k2,1:fpsmid)=Tezheng2(i,1:fpsmid);
            %end
        else 
           % for j=1:1:zhenshu(i)
                practise_data0(k2,1:zhenshu(i))=Tezheng1(i,1:zhenshu(i));
                practise_data1(k2,1:zhenshu(i))=Tezheng2(i,1:zhenshu(i));
            %end
        end
    practise_label(k2)=lable(i);
    k2=k2+1;
    end
    
end
train_data=[train_data0,train_data1];
practise_data=[practise_data0,practise_data1];

Factor = ClassificationKNN.fit(train_data, train_label, 'NumNeighbors', 1);
predict_label= predict(Factor, practise_data);
accuracy=       length(find(predict_label == practise_label))/length(practise_label)*100;
% LL=LL+1;
% ((framelenth-245)/49+1)

% end
% plot(441:49:1323,accuracy);
%Z

% nTree=50
% B = TreeBagger(nTree,train_data,train_label);
% predict_label = predict(B,practise_data);
% accuracy         =       length(find(str2num(char(predict_label)) == practise_label))/length(practise_label)*100
%  
% 
%{  
K���ڷ����� ��KNN��
Factor = ClassificationKNN.fit(train_data, train_label, 'NumNeighbors', 10);
predict_label   =       predict(Factor, practise_data);
accuracy         =       length(find(predict_label == practise_label))/length(practise_label)*100
  'BucketSize',40             
 'CategoricalPredictors','all'
���ɭ�ַ�������Random Forest��
nTree=5:5:50
B = TreeBagger(nTree,train_data,train_label);
predict_label = predict(B,test_data);
 for Knn=1:1:50
Factor = ClassificationKNN.fit(train_data, train_label, 'NumNeighbors', Knn);
predict_label   =       predict(Factor, practise_data);
accuracyl(Knn)         =       length(find(predict_label == practise_label))/length(practise_label)*100;
 end
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

            
    
