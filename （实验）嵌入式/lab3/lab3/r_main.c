/***********************************************************************************************************************
* DISCLAIMER
* This software is supplied by Renesas Electronics Corporation and is only intended for use with Renesas products.
* No other uses are authorized. This software is owned by Renesas Electronics Corporation and is protected under all
* applicable laws, including copyright laws. 
* THIS SOFTWARE IS PROVIDED "AS IS" AND RENESAS MAKES NO WARRANTIESREGARDING THIS SOFTWARE, WHETHER EXPRESS, IMPLIED
* OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NON-INFRINGEMENT.  ALL SUCH WARRANTIES ARE EXPRESSLY DISCLAIMED.TO THE MAXIMUM EXTENT PERMITTED NOT PROHIBITED BY
* LAW, NEITHER RENESAS ELECTRONICS CORPORATION NOR ANY OF ITS AFFILIATED COMPANIES SHALL BE LIABLE FOR ANY DIRECT,
* INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES FOR ANY REASON RELATED TO THIS SOFTWARE, EVEN IF RENESAS OR
* ITS AFFILIATES HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
* Renesas reserves the right, without notice, to make changes to this software and to discontinue the availability 
* of this software. By using this software, you agree to the additional terms and conditions found by accessing the 
* following link:
* http://www.renesas.com/disclaimer
*
* Copyright (C) 2011, 2015 Renesas Electronics Corporation. All rights reserved.
***********************************************************************************************************************/

/***********************************************************************************************************************
* File Name    : r_main.c
* Version      : CodeGenerator for RL78/G13 V2.03.01.03 [30 Jan 2015]
* Device(s)    : R5F100LG
* Tool-Chain   : CA78K0R
* Description  : This file implements main function.
* Creation Date: 2017/5/26
***********************************************************************************************************************/

/***********************************************************************************************************************
Pragma directive
***********************************************************************************************************************/
/* Start user code for pragma. Do not edit comment generated here */
/* End user code. Do not edit comment generated here */

/***********************************************************************************************************************
Includes
***********************************************************************************************************************/
#include "r_cg_macrodriver.h"
#include "r_cg_cgc.h"
#include "r_cg_port.h"
#include "r_cg_wdt.h"
/* Start user code for include. Do not edit comment generated here */
#include "r_cg_lcd.h"
#include "r_cg_KeyScan.h"
#include "r_cg_digtalLED.h"
#include "r_cg_timer.h"
#include "r_cg_pclbuz.h"
/* End user code. Do not edit comment generated here */
#include "r_cg_userdefine.h"

/***********************************************************************************************************************
Global variables and functions
***********************************************************************************************************************/
/* Start user code for global. Do not edit comment generated here */
unsigned int i;
extern volatile uint8_t num_keyboard;
extern volatile uint8_t num;
uint8_t num_10;
uint8_t  count=0;
bit bit_control;
uint8_t array_key[2];
uint8_t buzflag=0;
unsigned char date[16]="_   ��  ��  ��  ";
unsigned int x=0;
unsigned char pre=' ';
unsigned int flag=0;
int bflag=0;
int sflag=0;
int change=0;
/* End user code. Do not edit comment generated here */
void R_MAIN_UserInit(void);
void display();
void getnext();
void getpre();
void delaya(void);
void leddispaly(void);
/***********************************************************************************************************************
* Function Name: main
* Description  : This function implements main function.
* Arguments    : None
* Return Value : None
***********************************************************************************************************************/
void main(void)
{
    hdwinit();
    	R_PCLBUZ0_Create();
	R_TAU0_Create();
	R_TAU0_Channel0_Start();
    R_MAIN_UserInit();
    lcd_init();
    num_keyboard=0;
    /* Start user code. Do not edit comment generated here */
    while (1U)
    {
	lcd_display(0,"    ����      "
			"  �Զ���71��    "
			"  2171411498    ");
	 lcd_display(48,date);
	 Keyboard_scan();
	 if(num_keyboard==14){sflag=1;}
	 if(sflag==1)num_10 = num/10;
	 else {num=0;num_10=0;}
	 if(bflag==0 && num_10==10){ R_PCLBUZ0_Start();  bflag=1; delaya();R_PCLBUZ0_Stop();}
		
	 if(num_keyboard==13){bflag=0; num=0;num_keyboard=0;sflag=0;}

	 if(num_keyboard!=0)
	 display();
	 if(num_keyboard==13){bflag=0; num=0;num_keyboard=0;sflag=0;}
	 leddispaly();
	NOP();
	WDTE = 0xAC;
    }
    /* End user code. Do not edit comment generated here */
}

/***********************************************************************************************************************
* Function Name: R_MAIN_UserInit
* Description  : This function adds user code before implementing main function.
* Arguments    : None
* Return Value : None
***********************************************************************************************************************/
void R_MAIN_UserInit(void)
{
    /* Start user code. Do not edit comment generated here */
    EI();
    /* End user code. Do not edit comment generated here */
}
void display()
{
     //if(num_keyboard!=0��flag++��
     flag++;
     if(flag>35)
     {
	  if(num_keyboard>10)
	  {
		 
		 switch(num_keyboard)
		 {
			 case(11):
			 {
				 getpre();
				 date[x]=' ';
				 break;
			 }
			 case(12):
			 {
				 date[x]=pre;
				 getpre();
				 pre=date[x];
				 date[x]=95;
				 break;
			 }
		 }
	  }
	  else
	  {
		date[x]=num_keyboard+47;
		x++;
		
		getnext();

		if(x!=0) date[x]=95;//��ʾ_ָʾ��һλ����λ��
	  }
          flag=0;
          num_keyboard=0;
     }
}
void getnext()
{
	switch(x)
	{
	     case(4):x=x+2;break;
	     case(8):x=x+2;break;
	     case(12):x=0;break;
	     default:break;
	}
}
void getpre()
{
	switch(x)
		 {
		         case(6):x=x-3;break;
		         case(10):x=x-3;break;
			 case(0):x=11;break;
	                 default:x--;
		 }
}
void leddispaly(void)
{
	array_key[0]=num_10%10;    //the second char
	array_key[1]=num_10/10;    //the front char
	if(count<2)
	{
		if(count==0)bit_control=1;    //from bit4 to bit1
		if(count==1)bit_control=0;
		//testvalue1 = Getcode(array_key[count]);
		//DIGTAL_PORT = testvalue1;
		DIGTAL_LED_D4 = ~bit_control;
		DIGTAL_LED_D3 = ~bit_control;


		DIGTAL_PORT = Getcode(array_key[count]);

		DIGTAL_LED_D4 = bit_control;
		DIGTAL_LED_D3 = ~bit_control;
		count++;
	}
	else
	{
		count=0;

	}
}
void delaya(void)
{
	int i,j;
	for(i=0;i<800;i++)
	   for(j=0;j<800;j++);
}
/* Start user code for adding. Do not edit comment generated here */
/* End user code. Do not edit comment generated here */
