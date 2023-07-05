/*����ͼ�Ĳ���*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OK 1
#define ERROR 0
#define NO_OPRERATED 0
#define OPERATED 1
#define MaxVex 50
#define MOSTMAX 10000
#define NUMBER_VEX 13

typedef char* STRING;
typedef int SHORTSHORTPATH[MaxVex];
typedef int SHORTPATH[MaxVex];

typedef struct {
	int vexs[MaxVex];
	int arc[MaxVex][MaxVex];
	int NumberVertexs;
}Mgraph;/*ͼ�Ľṹ���������Ǵ���ڵ㣬�ߵ�Ȩֵ������*/

/*
* �涨ÿ�������ڳ����е����ֱ�־
* ����          0
* ��ˮ˼Դ		1
* ������3		2
* �ڷ���		3
* ������1		4
* ͼ���		5
* ������2		6
* ������4		7
* ��ѧ��¥		8
* ������		9
* �����		10
* ��Ǩ��		11
* ����			12
*/

//�˺������ڳ�ʼ��һ��ͼ
int CREATIVE_MAP(Mgraph& G) {
	int i = 0, j = 0;
	G.NumberVertexs = NUMBER_VEX;
	
	for (i = 0; i < G.NumberVertexs; i++) {
		for (j = 0; j < G.NumberVertexs; j++) {
			G.arc[i][j] =MOSTMAX;
		}
	}/*�������й�ϵ�ı��ȶ��������ֵ*/

	for (i = 0; i < G.NumberVertexs; i++) {
		G.vexs[i] = i;
	}/*���ΰ�˳����ڵ�ֵ0-12*/
	//����ͼ�й�ϵ��ֵ
	G.arc[0][2] = 22; 
	G.arc[0][1] = 18;
	G.arc[1][3] = 19;
	G.arc[1][4] = 27;
	G.arc[3][2] = 4;
	G.arc[4][5] = 4;
	G.arc[3][5] = 23;
	G.arc[5][6] = 4;
	G.arc[3][7] = 32;
	G.arc[5][8] = 15;
	G.arc[7][9] = 4;
	G.arc[9][8] = 8;
	G.arc[8][10] = 21;
	G.arc[10][12] = 30;
	G.arc[9][12] = 14;
	G.arc[12][6] = 21;
	G.arc[6][11] = 43;
	G.arc[11][12] = 20;
	G.arc[2][0] = 22;
	G.arc[1][0] = 18;
	G.arc[3][1] = 19;
	G.arc[4][1] = 27;
	G.arc[2][3] = 4;
	G.arc[5][4] = 4;
	G.arc[5][3] = 23;
	G.arc[6][5] = 4;
	G.arc[7][3] = 32;
	G.arc[8][5] = 15;
	G.arc[9][7] = 4;
	G.arc[8][9] = 8;
	G.arc[10][8] = 21;
	G.arc[12][10] = 30;
	G.arc[12][9] = 14;
	G.arc[6][12] = 21;
	G.arc[11][6] = 43;
	G.arc[12][11] = 20;

	for (i = 0; i < G.NumberVertexs; i++) {
		G.arc[i][i] = 0;
	}/*�涨���������ȨֵΪ0*/
	return OK;
}
//������ͼ��Ѱ����vo��ΪԴ�㵽������ľ��룬���Ҵ洢��DisTance��
void shortest_DIJ(Mgraph G,int v0,SHORTPATH &Path,SHORTSHORTPATH &DisTance) {
	int Final_DIG[MaxVex];//���ڴ洢������ҵ���ΪOPERATED��δ�ҵ����·����ΪNO_OPRERATED
	int V_Min_path_V0 = 0,V_TMP = 0; //V_Min_path_V0ָ���Ǿ���V0Դ������ĵ�
	int i = 0;
	int Min_path = 0;//��̵ĳ���ֵ

	for (V_Min_path_V0 = 0; V_Min_path_V0 < G.NumberVertexs; V_Min_path_V0++)
	{
		Final_DIG[V_Min_path_V0] = NO_OPRERATED;
		DisTance[V_Min_path_V0] = G.arc[v0][V_Min_path_V0];
		Path[V_Min_path_V0] = 0;
	}//��ʼ��PATH·������DIATANCE
	DisTance[v0] = 0; Final_DIG[v0] = OPERATED;

	for (i = 1; i < G.NumberVertexs; i++) {
		Min_path = MOSTMAX; //���½�min_path����ԭ����ֵ

		for (V_TMP = 0; V_TMP < G.NumberVertexs; V_TMP++) {
			if (!Final_DIG[V_TMP]) {
				if (DisTance[V_TMP] < Min_path) {
					V_Min_path_V0 = V_TMP; Min_path = DisTance[V_TMP];
				}/*Ѱ�Ҿ���V0����ĵ㣬Ҳ����Ѱ��DISTANCE[W]����С��*/
			}
		}//�ҵ�DisTance[V_TMP]�е���Сֵ,�õ��arc��V_Min_path_V0
		Final_DIG[V_Min_path_V0] = OPERATED;

		for (V_TMP = 0; V_TMP < G.NumberVertexs; V_TMP++) {
			if (!Final_DIG[V_TMP]) {
				if (Min_path + G.arc[V_Min_path_V0][V_TMP] < DisTance[V_TMP]) {
					DisTance[V_TMP] = Min_path + G.arc[V_Min_path_V0][V_TMP];
					Path[V_TMP] = V_Min_path_V0;
				}
			}
		}//Ѱ�������ҵ���W�����ĵ㣬�������ǵ�DisTance[W]��
	}
}


int Translate(STRING str) {
	if (!strcmp(str, "����")) return 0;
	else  if (!strcmp(str, "��ˮ˼Դ")) return 1;
	else if (!strcmp(str, "������3")) return 2;
	else if (!strcmp(str, "�ڷ���")) return 3;
	else if (!strcmp(str, "������1")) return 4;
	else if (!strcmp(str, "ͼ���")) return 5;
	else if (!strcmp(str, "������2")) return 6;
	else if (!strcmp(str, "������4")) return 7;
	else if (!strcmp(str, "��ѧ��¥")) return 8;
	else if (!strcmp(str, "������")) return 9;
	else if (!strcmp(str, "�����")) return 10;
	else if (!strcmp(str, "��Ǩ��")) return 11;
	else if (!strcmp(str, "����")) return 12;
	else return -1;
}

//�����Ӧ����������ĵ���
void PRINTF_INT_STR(int PosiTion_Number) {
	switch(PosiTion_Number) {
	case 0:printf("����");
		break;
	case 1:printf("��ˮ˼Դ");
		break;
	case 2:printf("������3");
		break;
	case 3:printf("�ڷ���");
		break;
	case 4:printf("������1");
		break;
	case 5:printf("ͼ���");
		break;
	case 6:printf("������2");
		break;
	case 7:printf("������4");
		break;
	case 8:printf("��ѧ��¥");
		break;
	case 9:printf("������");
		break;
	case 10:printf("�����");
		break;
	case 11:printf("��Ǩ��");
		break;
	case 12:printf("����");
		break;
	}
}

//����·�������Ұ���˳�������
void Feed_back_PATH(SHORTPATH& path,int go,int end) {
	int i = end, j = 1;
	SHORTPATH path_new;
	while (i != go) {
		path_new[j++] = i;
		i = path[i];
	}
	path_new[j] = i;
	path_new[0] = j;
	for (; j >= 2; j--) {
		PRINTF_INT_STR(path_new[j]); printf("->");
	}
	PRINTF_INT_STR(path_new[1]);
	printf("\n");
}

int main(int argc, char*argv[]) {
	if (argc != 3) {
		printf("ERROR_01");
		return -1;
	}//������
	Mgraph ScoolMap;
	CREATIVE_MAP(ScoolMap);
	int GO = 0, END = 0;
	GO = Translate(argv[1]);
	END = Translate(argv[2]);
	if (GO == -1 || END == -1) {
		printf("ERROR_02");
		return -2;
	}//����ص��Ƿ�����
	int path[MaxVex] = { 0 };
	int distance[MaxVex] = { 0 };
	shortest_DIJ(ScoolMap, GO,path, distance);
	//Feed_back_PATH(path, GO, END);
	printf("%d", distance[END]);
	return 0;
}