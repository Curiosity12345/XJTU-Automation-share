tic
load character100_36.mat;
true=0;
sample=20;
formnum=100;
mistake=zeros(10);
for m=1:20
    for n=0:9
        [k,fs]=audioread(['E:\������\��ʵ�飩�����źŴ���\��һ��\������\',int2str(m),'\',int2str(n),'.wav']);
        cc=MFCC3(k,fs);
        for o=1:5
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
        number=zeros(10,1);
        for i=1:10
            for j=1:20
                if dist(i,j)<2e+05
                    number(i)=number(i)+1;
                end
            end
        end
            [~,j]=max(number);
            j=j-1;
            if j==n
                true=true+1;
            else
                mistake(n+1,j+1)=mistake(n+1,j+1)+1;
            end
            fprintf('��ʵֵΪ%d��ʶ��Ϊ%d\n',n,j);
        end
    end
end

result=true/1000
toc