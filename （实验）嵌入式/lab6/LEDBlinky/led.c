//LED����˸����C����
#define WriteReg(Address,Value)  *(unsigned int volatile *)(Address) = Value
#define U32       unsigned int
#define REG_EXT0CON	      0xFFF01018 
#define EBILED_ADDRESS       0x78000000 
//�Ӻ������� 
void EBILedSet(U32 Value); 
void Delay(U32 t); 
//������ 
int main(void) 
{ 
     U32 i;
     WriteReg(REG_EXT0CON, 0xF0078003); 
     while(1) 
     { 
         for(i = 0 ;i < 8; i++) 
         { 
              EBILedSet(0x1<<i); 
              Delay(1000000); 
         } 
     } 
     return 0; 
} 
//��ʱ 
void Delay(U32 t) 
{ 
     do 
     { 
         t--; 
     }while(t); 
} 
//����LED �Ƶ����� 
void EBILedSet(U32 Value) 
{ 
	WriteReg(EBILED_ADDRESS, ~Value); 
}