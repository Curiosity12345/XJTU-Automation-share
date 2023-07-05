#include <reg51.h>    //����ͷ�ļ�
sbit KEY1=P1^0;     //��λ����ָ��ֱ���4����������Ӧ������
sbit KEY2=P1^1;
sbit KEY3=P1^2;
sbit KEY4=P1^3;
unsigned char keyval;  // ȫ�ֱ������壬�����ֵ����
//LED��ˮ����ʱ����
void led_delay(void)
{
  unsigned char i,j;
 for(i = 0;i < 251;i++)
 {
   for(j = 0;j < 251;j++);
 }
}
//����������ʱ����
void delay20ms(void)
{
  unsigned char i,j;
 for(i = 0;i < 100;i++)
 {
   for(j = 0;j < 60;j++);
 }
}
//������ˮ��
void forward(void)
{
 P3 = 0xfe;     //����P3.0���ŵ�LED��
 led_delay();
 P3 = 0xfd;
 led_delay();
 P3 = 0xfb;
 led_delay();
 P3 = 0xf7;
 led_delay();
 P3 = 0xef;
 led_delay();
 P3 = 0xdf;
 led_delay();
 P3 = 0xbf;
 led_delay();
 P3 = 0x7f;
 led_delay();
 P3 = 0xfe;
 led_delay();
}
//������ˮ��
void backward(void)
{
 P3 = 0x7f;    //����P3.7���ŵ�LED��
 led_delay();
 P3 = 0xbf;
 led_delay();
 P3 = 0xdf;
 led_delay();
 P3 = 0xef;
 led_delay();
 P3 = 0xf7;
 led_delay();
 P3 = 0xfb;
 led_delay();
 P3 = 0xfd;
 led_delay();
 P3 = 0xfe;
 led_delay();
 P3 = 0x7f;
 led_delay();
}
//�ر�����LED��
void stop(void)
{
  P3 = 0xff; 
}
//����LED��˸
void flash(void)
{
  P3 = 0xff;
 led_delay();
 P3 = 0x00;
 led_delay(); 
}
//����ɨ�躯��
void key_scan(void)
{
  if((P1 & 0x0f)!=0x0f)    //����Ƿ��а���������
 {
   delay20ms();
  if((P1 & 0x0f)!=0x0f)    //��ʱ���ٴμ���Ƿ��а���������
  {
   if(KEY1 == 0)    //�ж����Ǹ�����������
   {
     keyval = 1;
   }
   if(KEY2 == 0)
   {
     keyval = 2;
   }
   if(KEY3 == 0)
   {
     keyval = 3;
   }
   if(KEY4 == 0)
   {
     keyval = 4;
   }
  }
 }
}
//������
void main(void)
{
 keyval = 0;      //
 while(1)
 {
   key_scan();    //���ü�ֵ��⺯��
  switch(keyval)     //���ݼ�ֵʵ����Ӧ����
  {
   case 1:forward();
          break;
   case 2:backward();
          break;
   case 3:stop();
          break;
   case 4:flash();
          break;
  }
 }
} 
