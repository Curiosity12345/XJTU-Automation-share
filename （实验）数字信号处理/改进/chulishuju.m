a=xlsread('E:\������\��ʵ�飩�����źŴ���\�Ľ�\Character_MFCC9.xls');
for j=1:100
    m=1;
    for i=1:length(a)
        if a(i,46)==j
            b(m,:)=a(i,1:45);
            m=m+1;
        end
        s(j).num9=b(1:m-1,:);
    end
end
    