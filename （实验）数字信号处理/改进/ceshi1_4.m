tic
load character1024.mat;
true=0;
% true2=0;
sample=20;
formnum=100;
for m=1:100
    num=round(rand*9);
    [k,fs]=audioread(['E:\������\��ʵ�飩�����źŴ���\�Ľ�\test\',int2str(num),'.wav']);
    cc=MFCC4(k);
    dist=ones(10,sample)*realmax;
    for k=1:10
        for i=1:sample
            j=randi(formnum);
            dist(k,i)=dtw1(cc, Character{k,j});
            while isnan(dist(k,i))
                j=randi(formnum);
                dist(k,i)=dtw1(cc, Character{k,j});
            end
        end
    end
 
for i=1:10
number(i)=min(dist(i,:));
end
    [~,j]=min(number);
    j=j-1;
    if j==num
        true=true+1;
    end
    fprintf('��ʵֵΪ%d����Сֵ��ʶ��Ϊ%d\n',num,j);
%     average=mean(dist,2);
%     [~,i]=min(average);
%     i=i-1;
%     if i==num
%         true2=true2+1;
%     end
%     fprintf('��ʵֵΪ%d��ƽ��ֵ��ʶ��Ϊ%d\n',num,j);
end

result=true/100
% result2=true2/100
toc