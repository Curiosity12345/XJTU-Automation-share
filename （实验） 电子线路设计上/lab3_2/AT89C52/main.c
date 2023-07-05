#include <REGX52.H>
#include "SD.h"
#include <intrins.h> 
//����ܶ���˿�
#define PP  P3
//����������ܶ���
unsigned char code SEG7[]={/*0,1,2,3,4,5,6,7,8,9,*/
0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90,};
//�������ʾ����
unsigned char num[]={1,2};
//�����λ��˿�
sbit      q1=P2^6;
sbit      q2=P2^7;
//��λ��ʼֹͣ��1��1����
sbit      k1=P2^5;
sbit      k2=P1^4;
sbit      k3=P1^5;
sbit      k4=P1^6;
sbit      k5=P1^7;
//----------------------------------------------------
unsigned long  SD_ADDR=0;
unsigned int count;
unsigned char xdata DATA[512];
sbit E = P2^0;
sbit RW = P2^1;
sbit RS = P2^2;
sbit CS2 = P2^3;
sbit CS1 = P2^4;	//�˿ڶ���
#define DataPort P0
 /*12864��æ */
bit Chek_Busy(void)
{
    DataPort = 0xff;
    RW = 1;
    RS = 0;
    E = 1;
    E = 0;
    return (bit)(DataPort & 0x80);
}
/*------------------------------------------------
            ѡ��
i:0������,1������,2ȫ��
------------------------------------------------*/
void Choose_12864(unsigned char i)
{						 
   switch (i)			 
   {
       case 0: CS1 = 0;CS2 = 1;break;   
       case 1: CS1 = 1;CS2 = 0;break;
       case 2: CS1 = 0;CS2 = 0;break;
	   default: break;
   }
}
/*------------------------------------------------
        д����
------------------------------------------------*/
void LCD_Cmd(unsigned char cmd)
{
    while(Chek_Busy());
    RW = 0;	         
    RS = 0;
    DataPort = cmd;
    E = 1;
    E = 0;          
}
/*------------------------------------------------
        ��LCD
------------------------------------------------*/
unsigned char LCD_Read()
{
    unsigned char read_data;
    while(Chek_Busy());
    RW = 1;//�����һ�οն�
    RS = 1;
    E = 1;
    E = 0;

    RW = 1;
    RS = 1;
    E = 1;
    read_data = DataPort;
    E = 0;        
    return (read_data);    
}
/*------------------------------------------------
        д����
------------------------------------------------*/
void  LCD_Data(unsigned char dat)
{
    while(Chek_Busy());
    RW = 0;	         
    RS = 1;
    DataPort = dat;
    E = 1;
    E = 0; 
}
/*------------------------------------------------
             ���õ�ַ
PAGE:0-7;
Y_Address:0-63
------------------------------------------------*/
void Set_PageY(unsigned char PAGE,unsigned char Y_Address)
{
    LCD_Cmd(0xB8 + PAGE);
    LCD_Cmd(0x40 + Y_Address);
}
/*------------------------------------------------
                ����
------------------------------------------------*/
void LCD_Clear(void)
{
    unsigned char page,row;
    Choose_12864(2);
    for (page = 0xb8; page < 0xc0; page ++)
    {
        LCD_Cmd(page);
    	LCD_Cmd(0x40);
    	for (row = 0; row < 64; row ++)
    	{
    	    LCD_Data(0x00);//��12864���е�ַȫ��д��
    	}
    }
}
/*------------------------------------------------
               ��ʼ��
------------------------------------------------*/
void LCD_Init(void)
{
    CS2 = 0;
    CS1 = 0;
    LCD_Cmd(0x3F);//����ʾ
}
/*-------------------------------------------------
    ��ʾһ��12864ͼƬ
-------------------------------------------------*/
void Dis_Picture(unsigned char *picture)
{
    unsigned char ii,kk;
    for (kk = 0; kk < 4; kk ++)//LCD����7=8ҳ
    {
        Choose_12864(2);
        Set_PageY(kk,0);
        Choose_12864(0);        
        for (ii = 0; ii < 128; ii ++)
        {
            LCD_Data(*picture);
            picture ++;
            if (ii == 63)
            {
                Choose_12864(1);
            }
        }
    }
}
void Dis_Pictureb(unsigned char *picture)
{
    unsigned char ii,kk;
    for (kk = 4; kk < 8; kk ++)//LCD����7=8ҳ
    {
        Choose_12864(2);
        Set_PageY(kk,0);
        Choose_12864(0);        
        for (ii = 0; ii < 128; ii ++)
        {
            LCD_Data(*picture);
            picture ++;
            if (ii == 63)
            {
                Choose_12864(1);
            }
        }
    }
}
void delayus(unsigned char t)
{
    while(--t);
}
void delayms(unsigned char t)
{
    while(t--)
    {
        delayus(245);
        delayus(245);
    }
}

//--------------------------------------------------------------------
//����ʱģ��
//��ʱ����ms
void _delay_ms(unsigned int t)
{
   unsigned int i,j;
   for(i=0;i<t;i++)
     for(j=0;j<120;j++);
}
//�������ʾ
void dis()
{ 
 //------------------  
 //��ʾ��1λ
  PP=num[0];
  q1=1;
  _delay_ms(2);
  q1=0;
 //��ʾ��2λ
  PP=num[1];
  q2=1;
  _delay_ms(2);
  q2=0;
 
}
//��ʱ����
unsigned int jishu1s=10;
unsigned int jishu1=10;
unsigned int jishu2;
//��ʼֹͣ����
unsigned int  bz;
//��ʾ����
void dispaly()
{ 
   num[0]=SEG7[jishu1%100/10];	//��ʾ��λ
   num[1]=SEG7[jishu1%10]; //��ʾС��λ
}
//��������
void key()
{
  if(k1==0){jishu1=jishu1s;while(k1==0);}//��λ
  if(k2==0){bz=1;while(k2==0);}//��ʼ
  if(k3==0){bz=0;while(k3==0);}//ֹͣ
  if(bz==0)
  {
    if(k4==0){if(jishu1s<99)jishu1s=jishu1s+1;jishu1=jishu1s;while(k4==0);} //+1
    if(k5==0){if(jishu1s>0 )jishu1s=jishu1s-1;jishu1=jishu1s;while(k5==0);} //-1
  }
} 

//----------------------------
void main(void)
{
_delay_ms(10);  
   //��ʱ��0���÷�ʽ1 16
  TMOD=0x01;	
  //ʹ�ܶ�ʱ��0 
  ET0=1;
  //��ʱ���ĳ�ֵ
  TH0=(65536-50000)/256; 
  TL0=(65536-50000)%256;
  //ֹͣ������ʱ��0
  TR0=1;
  EA=1;	  
	LCD_Init();
	LCD_Clear();
	SdInit();
	DATA[0]=255;;
	DATA[1]=1;
	DATA[2]=2;
	DATA[3]=3;
	DATA[511]=0xf0;
	while(1)
  {
   dispaly();//��ʾ���� 
   dis(); //��ʾ
   key();//����
	 if(jishu1==0)
	 {
		 while(1)
		{
				while(!SdReadBlock(DATA,SD_ADDR,512));
				SD_ADDR+=512;
				Dis_Picture(DATA);
				while(!SdReadBlock(DATA,SD_ADDR,512));
				Dis_Pictureb(DATA);
				SD_ADDR+=512;
				delayms(100);
			  key();//����
			  if(jishu1!=0) break;
			  if(bz==1) SD_ADDR=0;
	  }
   }
  }
	  
}
 //----T0 ����		 
void  Time0() interrupt 1
{
  //��װ��ֵ50ms;
  TH0=(65536-50000)/256;  
  TL0=(65536-50000)%256;
  //��ʼ
  if(bz==1)
  {
   jishu2=jishu2+1;
   //����1s
   if(jishu2==20)
   { 
     jishu2=0;
     if(jishu1>0)jishu1=jishu1-1;//��1s
     if(jishu1==0)bz=0;//����
   }
  }
  
}