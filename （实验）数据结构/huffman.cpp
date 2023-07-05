#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <malloc.h>
#include <string.h>
#define max 100
#define STACKINCREMENT 100
#define STACK_INIT_SIZE 50
#define ERROR 0
#define OK 1

//��̬��������洢�շ�����
typedef struct{
	int weight;
	int parent;
	int lchild;
	int rchild;
} htnode, * huffmantree;

//��̬��������洢�շ�������� 
typedef char** huffmancode;


typedef struct{
	int* base;
	int* top;
	int stacksize;
}Sqstack;


int Initstack(Sqstack& S){
	S.base = (int*)malloc(STACK_INIT_SIZE * sizeof(int));
	if (!S.base)
	{
		return ERROR;
	}
	S.top = S.base;
	S.stacksize = STACK_INIT_SIZE;
	return OK;
}


int StackEmpty(Sqstack& S){
	if (S.base == S.top){
		return OK;
	}
	else{
		return ERROR;
	}
}


//ɾ��ջ��Ԫ��
void Pop(Sqstack& S){
	if (S.top == S.base)
	{
		return;
	}
	--S.top;
}

//����ջ��Ԫ�ص�ֵ
int Gettop(Sqstack& S){
	int e;
	e = *--S.top;
	return e;
}

//��e����ջ��Ԫ�� 
void Push(Sqstack& S, int e)
{
	if (S.top - S.base > S.stacksize)
	{
		S.base = (int*)realloc(S.base, (S.stacksize + STACKINCREMENT) * sizeof(int));
		if (!S.base)
		{
			return;
		}
		S.top = S.base + S.stacksize;
		S.stacksize += STACKINCREMENT;
	}
	*S.top = e;
	S.top++;
}


void select(huffmantree& ht, int target_length, int min[2], char* Sort)
{
	int i = 1, j = 1;  //��ʼ��i��j,��������֪����1��ʼ���ǣ����Գ�ʼ��Ϊ1
	while (ht[i].parent != 0) {
		i++;
	}					//�ҵ���һ����ĸʱ0�Ľڵ㣬Ҳ���ǹ����ĵ�
	min[0] = i;			//��ʼ��������������С�ĵ�
	int min1_weight = ht[i].weight;			//�����Ǽ�������WEIGHTҲ��Ȼ����С��
	for (i = 1; i <= target_length; i++) {
		if (ht[i].weight < min1_weight && ht[i].parent == 0) {
			min[0] = i;
			min1_weight = ht[i].weight;
		}			//�������������������һ�������ڵ㣬����Ȩ�ػ��Ƚ�С����ĩ���Ǿͻ�
					//�ؼ��ľ��Ǳ���ʱ�����ڵ�
	}
	//��Ȼ�µĽڵ�Ҳ�ǹ����ģ����һ�������min1
	while (ht[j].parent != 0 || j == min[0]) {
		j++;
	}
	min[1] = j;
	int min2_weight = ht[j].weight;
	//������Ȼ֪��ǰ��ĵ㶼�ǲ����������ģ���ĩ��Ȼ�������򼴿�
	for (; j <= target_length; j++) {
		if (j != min[0] && ht[j].weight < min2_weight && ht[j].parent == 0) {
			min[1] = j;
			min2_weight = ht[j].weight;
		}
	}
}


//����շ���������շ�������
void creative_huffmantree(huffmantree& HT, huffmancode& HC, int* w, int length, char* Sort) {
	int total_lenth = 2 * length - 1;
	int i = 1;
	int min[2] = { 0,0 };
	htnode* ptr;
	HT = (huffmantree)malloc((total_lenth + 1) * sizeof(htnode));

	for (ptr = HT + 1, i = 1; i <= length; ++i, ++ptr, ++w) {
		*ptr = { *w, 0, 0, 0 };
	}
	for (; i <= total_lenth; ++i, ++ptr) {
		*ptr = { 0,0,0,0 };
	}
	for (i = length + 1; i <= total_lenth; ++i) {
		select(HT, i - 1, min, Sort);
		HT[min[0]].parent = i;
		HT[min[1]].parent = i;
		HT[i].lchild = min[0];
		HT[i].rchild = min[1];
		HT[i].weight = HT[min[0]].weight + HT[min[1]].weight;
	}

	int start = 0, newer = 0, older = 0; ;
	char* cd;
	HC = (huffmancode)malloc((total_lenth + 1) * sizeof(char*));
	cd = (char*)malloc(length * sizeof(char));
	cd[length - 1] = '\0';

	for (i = 1; i <= length; ++i) {
		start = length - 1;
		for (newer = i, older = HT[i].parent; older != 0; newer = older, older = HT[older].parent) {
			if (HT[older].lchild == newer) {
				cd[--start] = '0';
			}
			else {
				cd[--start] = '1';
			}
		}
		HC[i] = (char*)malloc((length - start) * sizeof(char));
		strcpy(HC[i], &cd[start]);
	}
	free(cd);
}



//��String�е��ַ������Ⱥ�˳��洢��Target��
void creative_target_w_pos(char* Str, char* Target, int* w, int* pos){
	int SYMBOL = 0;
	int i = 1;
	int j = 0;
	int k = 1;
	//ȷ�����ȣ��Է�����������
	int length_str = 0;
	while (Str[length_str] != 0) {
		length_str++;
	}
	Target[0] = Str[0];

	//���SYMBOLΪ1,��˵���Ѿ�������ֱ����������
	for (i = 1; i < length_str; i++) {
		SYMBOL = 0;
		for (j = 0; j < k; j++) {
			if (Target[j] == Str[i]) {
				SYMBOL = 1;
				break;
			}
		}
		if (SYMBOL == 0) {
			Target[k] = Str[i];
			k++;
		}
	}
	i = 0, j = 0;
	int length_target = strlen(Target);
	int temp = 0;
	for (i = 0; i < length_target; i++)
	{
		for (j = i; j < length_target; j++)
		{
			if (Target[j] < Target[i])
			{
				temp = Target[j];
				Target[j] = Target[i];
				Target[i] = temp;
			}
		}
	}

	i = 0, j = 0;
	while (Target[i] != 0) {
		w[i] = 0;
		j = 0;
		while (Str[j] != 0) {
			if (Str[j] == Target[i]) {
				w[i]++;
			}
			j++;
		}
		i++;
	}

	//��String[i]��sort[]�е�λ�ô���pos[]�� 
	i = 0, j = 0;
	//STR��Ϊ�����ظ����������Ȼ���ܵ�Ӱ�죬����������Ҫ�ҵ����ǵ�λ��
	while (Str[i] != 0) {
		j = 0;//��ÿ���ҵ���ʱ�򣬽�λ����Ϣ����
		while (Target[j] != Str[i]) {
			j++;
		}
		pos[i] = j;
		i++;
	}
}



//�ж�S[]�Ƿ�Ϊһ���ַ��ı��룬���ǣ�������ַ���sort�е��±� �������ǣ����-1 
int Exist(huffmancode HC, char* s, int n)     //nΪ�ַ����� 
{
	int i = 1;
	for (i = 1; i <= n; i++)
	{
		if (strcmp(HC[i], s) == 0)              //���ҵ�s 
		{
			return i - 1;                     //����ΪHC[i]���ַ���Sort���±�Ϊi-1 
		}
	}
	return -1;
}

//���벢�������trans[],�ҷ����Ƿ���ɹ���״̬������1������ʧ�ܣ�����0������ɹ� 
int Translate(char* trans, char* Number, huffmancode HC, char* Sort)
{
	if (!strlen(Number))               //������Ϊ�գ�����ʧ�� 
	{
		return 1;
	}
	int i = 0, j = 0, l = 0;
	char temp[100];
	int k = 0;
	temp[0] = '\0';
	while (Number[i])
	{
		while (Number[i] && Exist(HC, temp, strlen(Sort)) == -1)        //����ֵΪ-1��δ�ҵ�����������ַ���temp���ȼ�һ
		{
			temp[k] = Number[i];
			temp[k + 1] = '\0';
			k++;
			i++;
		}
		if (Exist(HC, temp, strlen(Sort)) != -1)                        //ƥ��ɹ������ַ�����Sort����temp��0 
		{
			trans[j] = Sort[Exist(HC, temp, strlen(Sort))];
			j++;
			for (l = 0; l < k; l++)
			{
				temp[l] = 0;
			}
			k = 0;
		}
	}
	if (strlen(temp))    // tempδ����0�����һ��ƥ�䲻�ɹ�������ʧ��,flagΪ1������1 
	{
		return 1;
	}

	return 0;
}

void printer(huffmantree& HT, int* level, int i, char* Sort)                   //iΪ�ýڵ����� 
{
	int div = 0;                                     //ͳ�ƽڵ�Ķ��� 
	if (HT[i].parent)
	{
		div++;
	}
	if (HT[i].rchild)
	{
		div++;
	}
	if (HT[i].lchild)
	{
		div++;
	}
	if (i >= 1 && i <= strlen(Sort))         //ԭ�еĽڵ� 
	{
		printf("%4c %6d %3d %5d\n", Sort[i - 1], HT[i].weight, div, level[i]);//���ʱ���Ҷ��룬Nodeռ4�� 
	}                                                                   //weightռ6�У�divռ3�У�levelռ5�� 
	else
	{
		printf("NULL %6d %3d %5d\n", HT[i].weight, div, level[i]);
	}
}

//��ÿ���ڵ�Ĳ�������������level[]�� 
void Layer(int* level, huffmantree& HT, char* Sort)
{
	int i = 0;
	int flag = 1;                           //flagΪ��־������flag=0��ʾ��˫�� 
	for (i = 1; i <= 2 * strlen(Sort) - 1; i++)
	{
		level[i] = 1;
		flag = HT[i].parent;
		while (flag != 0)
		{
			level[i]++;
			flag = HT[flag].parent;
		}
	}
}

//�ǵݹ����Ա���
void Traverse(huffmantree& HT, Sqstack& S, char* Sort, int* level)
{
	Initstack(S);
	int p = 2 * strlen(Sort) - 1;      //ʹp��ʾ���ڵ����� 
	Push(S, p);                 //���ڵ���ջ 
	while (!StackEmpty(S))      //ջ����
	{
		p = Gettop(S);           //��p����ջ��Ԫ����� 
		printer(HT, level, p, Sort);
		if (HT[p].rchild)       //p���Һ��Ӵ��ڣ��Һ�����ջ 
		{
			Push(S, HT[p].rchild);
		}
		if (HT[p].lchild)       //p�����Ӵ��ڣ�������ջ 
		{
			Push(S, HT[p].lchild);
		}
		else
		{
			if (HT[p].rchild)    //p���Һ��Ӵ��ڣ�ɾ��p���Һ�����ջ 
			{
				Pop(S);
				Push(S, HT[p].rchild);
			}
		}
	}
}

void printresult(huffmancode HC, char* trans, char* result, int* pos, int n)
{
	int i = 0;
	for (i = 0; i < n; i++)
	{
		strcat(result, HC[pos[i] + 1]);     //�ַ���pos[]���±�Ϊk����HC����Ϊk+1
	}
	printf("%s", result);
	printf(" ");
	printf("%s", trans);
}

int main(int argc, char* argv[])		//					
{
	if (argc != 3) {							//������������
		printf("ERROR_01");
		return 0;
	}
	if (strlen(argv[1]) < 20) {                   //�ַ�������С��20������ʧ�� 
		printf("ERROR_02");
		return 0;
	}


	char result[max] = { 0 };
	int w[max] = { 0 };
	char Sort[max] = { 0 };
	int pos[max] = { 0 };
	char trans[max] = { 0 };
	int level[max] = { 0 };

	huffmantree HT;
	huffmancode HC;
	Sqstack S;
	int i = 0;
	creative_target_w_pos(argv[1], Sort, w, pos);
	if (strlen(Sort) == 1)
	{
		printf("ERROR_03");
		return 0;
	}
	creative_huffmantree(HT, HC, w, strlen(Sort), Sort);  // strlen(Sort)��ʾ�ڵ���� 
	Layer(level, HT, Sort);
	if (Translate(trans, argv[2], HC, Sort) == 1) {
		printf("ERROR_03");
		return 0;
	}
	printresult(HC, trans, result, pos, strlen(argv[1]));
	free(HT);
	free(HC);
	return 0;
}