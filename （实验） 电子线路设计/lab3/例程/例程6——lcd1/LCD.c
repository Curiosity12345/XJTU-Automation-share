#include<reg51.h>
#include<intrins.h>
#define uint unsigned int
#define uchar unsigned char
void Initiallize_LCD();//
void ShowString(uchar x,uchar y,uchar *str);
uchar code Display[32]="0123456789abcdef 123456789abcdef";

 //�ַ�Ҫ��˫�������������ո�Ҳ��-һ���ַ�����32���ַ�(0~31)��

 void main()
{
 Initiallize_LCD();
 ShowString(0,0,Display); //�ӵ�һ������ʼʪʾ
 ShowString(0,1,Display+16);//�ڥ��дӵ�17���ַ�д��0�ǵ�һ���ַ�
 while(1);
}
 
