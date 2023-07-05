#include<reg52.h>
#define uint unsigned int
#define uchar unsigned char
#define HALFF  6000000  //12M�����Ƶ
#define MAX 65536   //16λ����������������
sbit sound = P1^0;
uint C;
uchar STH0;
uchar STL0;
//C����Ƶ
//#define soo 392 //����'5'
//#define dao 523	//�궨��������1��Ƶ��Ϊ523Hz
//#define re 587
//#define mi 659
//#define fa 698
//#define so 784
//#define la 880
//#define xi 987

#define soo 784 //����'5'
#define dao 1047	//�궨�������1��Ƶ��Ϊ1047Hz
#define re 1175
#define mi 1319
#define fa 1397
#define so 1568
#define la 1760
#define xi 1967

/******
 1����ʱ��λ��1000ms
 ����ΪC��4/4�ģ�������һ����������С�ģ�Ϊ1/4�ģ�����1/4��Ϊ1����ʱ��λ
 ����forִ��ʱ�䣺
 ��i����Ϊint(��unsign int)ʱ��Ϊ8��ʱ�����ڣ�
 ��i����Ϊchar��unsign charʱ��Ϊ3��ʱ�����ڡ�
*/
void delay()
{
	uint i,j;
	for(i=0; i<110; i++)
		for(j=0; j<110; j++);	//1ms
}

void main()
{
	uchar i,j;
	//����ֻ�ϻ�������
	uint code song[] = {dao,re,mi,dao,
						dao,re,mi,dao,
						mi,fa,so,
						mi,fa,so,
						so,la,so,fa,mi,dao,
						so,la,so,fa,mi,dao,
						re,soo,dao,
						re,soo,dao,
						0xff};	//��0xffΪ����������־
	//����Ϊÿ����������,4����ʱ��λΪ1��
	//'4'��Ӧ4����ʱ��λ��'2'��Ӧ2����ʱ��λ��'1'��Ӧ1��
	uchar code JP[] = {4,4,4,4,
					   4,4,4,4,
					   4,4,8,
					   4,4,8,
					   3,1,3,1,4,4,
					   3,1,3,1,4,4,
					   4,4,8,
					   4,4,8};
	EA = 1;         //�����ж�
	ET0 = 1;        //����ʱ��T0�ж�
	TMOD = 0x01;	//��ʱ��T0�ù�����ʽ1(16λ������)
	while(1)
	{
		i = 0;
		while(song[i] != 0xff)
		{
			C = HALFF/song[i];
			STH0 = (MAX - C) / 256; // ��8λ
			STL0 = (MAX - C) % 256; // ��8λ
			TR0 = 1;			   //������ʱ��

			for(j=0; j<JP[i]; j++) //���ƽ���
			 delay();		   //��ʱ1����ʱ��λ
			TR0 = 0;			   //�رն�ʱ��
			i++;				   //������һ������
		}
	}
}

/************
  ��ʱ��T0���жϷ����ӳ���ʹP1.0�����Ƶ��Ҫ�ķ���
*/
/**********
  Ҫ������Ƶ���壬ֻҪ���ĳһ��Ƶ�����ڣ�1/Ƶ�ʣ���
  Ȼ�󽫴����ڳ���2����Ϊ�����ڵ�ʱ�䡣
  ���ö�ʱ����ʱ���������ʱ�䣬ÿ����ʱ����ͽ���������I/O���࣬
  Ȼ���ظ���ʱ�˰�����ʱ���ٶ�I/O���࣬�Ϳ���I/O���ϵõ���Ƶ�ʵ�����
********/
void t0() interrupt 1 using 1
{
	TH0 = STH0;
	TL0 = STL0;
    sound = ~sound; 
	 
}
