tic
load character3.mat;
true=0;
% for m=1:100
    num=round(rand*9);
    k=audioread(['E:\������\��ʵ�飩�����źŴ���\��һ��\������\6\',int2str(num),'.wav']);
    cc=Mfcc1(k);
    dist=ones(10,1)*realmax;
    update=zeros(10,1);
    for k=1:10
        for i=1:18
            j=randi(100);
            small = min(dist(k),dtw1(cc, p{k,j}));
            if small<dist(k)
                dist(k)=small;
                update(k)=update(k)+1;
            end
        end
    end
    final=1./dist.*update;
        [~,j] = max(final);
        j=j-1;
        if j==num
            true=true+1;
        end

function target = KNN(trainData, trainlabel, testData,k)
classlabel = unique(trainlabel);%�õ�������ǩ(���ļ��ֱ�ǩ)
c= length(classlabel); %�õ���ǩ����(�������ǩ)
n= size(trainData, 1); %�õ�ѵ����������
dist = zeros(n,1); %�洢һ����������������ѵ�������ľ���
for j=1:size(testData,1); %�������Լ��е�ÿһ������
    cnt = zeros(c,1);%�洢ǰk�������������ֵ�Ƶ��(����)
    for i=1:n %����ѵ�����е�ÿһ����
        t=trainData{i};
        r=testData{j};
        dist(i)=DTW(t,r); %����һ�����Ե������б������ݾ��롣
    end
    [d,index] = sort(dist); %��������d��������ֵindexΪd�����Ӧֵ��ԭdist�е�����
    for i=1:k
        ind = find(classlabel == trainlabel(index(i))); %����ǰk������������Ӧ�ı�ǩ���ص�indֵΪ1
        cnt(ind) = cnt(ind)+1;%��ǩ����һ�����Ӧ��cntλ�ü�1.�൱�ڼ���ǰk������������ֵ�Ƶ��
    end
end
end

%��������ȡtarget
% trainData= (trainData)';
% testData=(testData)';
% trainlabel=(trainlabel)';
% target = KNN(trainData, trainlabel, testData, 15):
total=sum(testlabel ==target);
totalrate = total/ length(target);
totalstrOut = ['ʶ����Ϊ'��num2str(totalrate*100), '%']
for i=1:10
    left=80*(i-1)+1;
    right=80*i;
    correct(i)=sum(testlabel (1,left:right)==target(1,left:right));
    rate(i) = correct(i)/ 80;
    strOut=[' ��������',num2str(i),'ʶ����Ϊ',num2str(rate(i)*100),'%']
end

% end
% result=true/100
toc