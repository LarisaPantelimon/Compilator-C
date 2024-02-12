%{
using namespace std;
#include<iostream>
#include <stdio.h>
#include <string.h>
#include<stdlib.h>
#include<sstream>
#include"ex.tab.h"
int yylex();
int yyerror(const char *msg);
int ExecuteConditions3(double n1,double n2,char*compare);
void run_script(const char* filename);
int EsteCorecta = 1;
int if_=-1, while_=-1;//ne mai gandim la for
int if_adevarat=-1,while_adevarat=-1;
int operatie=0; //1 pentru adunare 2 pentru scadere 3 pentru inmultire 4 pentru impartire
char msg[500];
class TVAR
{char *type; //-- tipul de data
char* nume;
double valoare;
TVAR* next;
public:
static TVAR* head;
static TVAR* tail;
TVAR();
TVAR(char* n,  char *t=NULL, float v = -1);
int exists(char* n);
void add(char* n,  char *t=NULL, float v = -1);
float getValue(char* n);
void setValue(char* n, float v);
void printVars();
double CalculateVariable(char*n1, char*n2);
double SimpleCalculus(char *n1, float n);
int ExecuteConditions(char *n1, char*n2, char*compare);
int ExecuteConditions2(char*n1,double n2,char*compare);
};
TVAR* TVAR::head;
TVAR* TVAR::tail;
TVAR::TVAR(char* n,char* t,float v)
{
this->nume = new char(strlen(n)+1);
this->type = strdup(t);
strcpy(this->nume,n); 
this->valoare = v;
this->next = NULL;
}
TVAR::TVAR()
{
TVAR::head = NULL;
TVAR::tail = NULL;
}
int TVAR::exists(char* n)
{
TVAR* tmp = TVAR::head;
while(tmp != NULL)
{
if(strcmp(tmp->nume,n) == 0)
return 1;
tmp = tmp->next;
}
return 0;
}
void TVAR::add(char* n, char* t, float v )
{
TVAR* elem = new TVAR(n, t,v);

if(head == NULL)
{
TVAR::head = TVAR::tail = elem;
}
else
{
TVAR::tail->next = elem;
TVAR::tail = elem;
}

}
float TVAR::getValue(char* n)
{
TVAR* tmp = TVAR::head;
while(tmp != NULL)
{
if(strcmp(tmp->nume,n) == 0)
return tmp->valoare;
tmp = tmp->next;
}
return -1;
}
void TVAR::setValue(char* n, float v)
{
TVAR* tmp = TVAR::head;
while(tmp != NULL)
{
if(strcmp(tmp->nume,n) == 0)
{
tmp->valoare = v;
}
tmp = tmp->next;
}
}
void TVAR::printVars()
{
cout<<"\nPrinting table of variables...\n";
TVAR* tmp = TVAR::head;
while(tmp != NULL)
{
cout<<tmp->nume<<"="<<tmp->valoare<<"\n";
tmp = tmp->next;
}
}
double TVAR:: CalculateVariable(char*n1, char*n2)
{
TVAR* tmp = TVAR::head;
double v1,v2;
while(tmp != NULL)
{
    if(strcmp(tmp->nume,n1) == 0)
    {
    v1=tmp->valoare;
    }
    if(strcmp(tmp->nume,n2) == 0)
    {
    v2=tmp->valoare;
    }
    tmp = tmp->next;
}

switch(operatie)
{
    case 1:
    return v1+v2;
    break;
    case 2:
    return v1-v2;
    break;
    case 3:
    return v1*v2;
    break;
    case 4:
    {
        if(v2==0) printf("Impartirea la 0 nu este permisa!\n");
        return v1;
    }
    break;
    default:
    return 0;
}
}


double TVAR:: SimpleCalculus(char *n1, float n){
    TVAR* tmp = TVAR::head;
double v1;
while(tmp != NULL)
{
    if(strcmp(tmp->nume,n1) == 0)
    {
    v1=tmp->valoare;
    }
    tmp = tmp->next;
}

switch(operatie)
{
    case 1:
    return v1+n;
    break;
    case 2:
    return v1-n;
    break;
    case 3:
    return v1*n;
    break;
    case 4:
    {
        if(n==0) printf("Impartirea la 0 nu este permisa!\n");
        return v1;
    }
    // return v1/n;
    break;
    default:
    return 0;
}
}

int TVAR::ExecuteConditions(char *n1, char*n2, char* conditie)
{
    TVAR* ts = TVAR::head;
    int expresie_=-1;
    if(strcmp(conditie,">")==0)
    {
        
            if(ts->exists(n1)==1 && ts->exists(n2)==1)
            {
                if(ts->getValue(n1)>ts->getValue(n2))
                expresie_=1;
                else
                expresie_=0;
            } else printf("Variabilele din conditie nu exista!\n");
    }
    else if(strcmp(conditie,"<")==0)
    {
        
            if(ts->exists(n1)==1 && ts->exists(n2)==1)
            {
                if(ts->getValue(n1)<ts->getValue(n2))
                expresie_=1;
                else
                expresie_=0;
            } else printf("Variabilele din conditie nu exista!\n");
    }
    else if(strcmp(conditie,"<=")==0)
    {
        
            if(ts->exists(n1)==1 && ts->exists(n2)==1)
            {
                if(ts->getValue(n1)<=ts->getValue(n2))
                expresie_=1;
                else
                expresie_=0;
            } else printf("Variabilele din conditie nu exista!\n");
    }
    else if(strcmp(conditie,">=")==0)
    {
        
            if(ts->exists(n1)==1 && ts->exists(n2)==1)
            {
                if(ts->getValue(n1)>=ts->getValue(n2))
                expresie_=1;
                else
                expresie_=0;
            } else printf("Variabilele din conditie nu exista!\n");
    }
    else if(strcmp(conditie,"==")==0)
    {

            if(ts->exists(n1)==1 && ts->exists(n2)==1)
            {
                if(ts->getValue(n1)==ts->getValue(n2))
                expresie_=1;
                else
                expresie_=0;
            } else printf("Variabilele din conditie nu exista!\n");
    }
    return expresie_;
}

int TVAR::ExecuteConditions2(char*n1,double n2,char*conditie)
{
    TVAR* ts = TVAR::head;
    int expresie_=-1;
    if(strcmp(conditie,">")==0)
    {
        
            if(ts->exists(n1)==1 )
            {
                if(ts->getValue(n1)>n2)
                expresie_=1;
                else
                expresie_=0;
            } else printf("Variabilele din conditie nu exista!\n");
    }
    else if(strcmp(conditie,"<")==0)
    {
        
            if(ts->exists(n1)==1)
            {
                if(ts->getValue(n1)<n2)
                expresie_=1;
                else
                expresie_=0;
            } else printf("Variabilele din conditie nu exista!\n");
    }
    else if(strcmp(conditie,"<=")==0)
    {
        
            if(ts->exists(n1)==1)
            {
                if(ts->getValue(n1)<=n2)
                expresie_=1;
                else
                expresie_=0;
            } else printf("Variabilele din conditie nu exista!\n");
    }
    else if(strcmp(conditie,">=")==0)
    {
        
            if(ts->exists(n1)==1)
            {
                if(ts->getValue(n1)>=n2)
                expresie_=1;
                else
                expresie_=0;
            } else printf("Variabilele din conditie nu exista!\n");
    }
    else if(strcmp(conditie,"==")==0)
    {

            if(ts->exists(n1)==1)
            {
                if(ts->getValue(n1)==n2)
                expresie_=1;
                else
                expresie_=0;
            }
    }
   // printf("Comparison result: %d\n", expresie_);
    return expresie_;
}
int ExecuteConditions3(double n1,double n2,char*conditie)
{
    
    int expresie_=-1;
    if(strcmp(conditie,">")==0)
    {
                if(n1>n2)
                expresie_=1;
                else
                expresie_=0;
    }
    else if(strcmp(conditie,"<")==0)
    {
                if(n1<n2)
                expresie_=1;
                else
                expresie_=0;
    }
    else if(strcmp(conditie,"<=")==0)
    {
                if(n1<=n2)
                expresie_=1;
                else
                expresie_=0;
    }
    else if(strcmp(conditie,">=")==0)
    {
                if(n1>=n2)
                expresie_=1;
                else
                expresie_=0;
    }
    else if(strcmp(conditie,"==")==0)
    {
                if(n1==n2)
                expresie_=1;
                else
                expresie_=0;
    }
    return expresie_;
}
extern FILE* yyin;
void run_script(const char* filename)
{
    FILE *file = fopen(filename, "r");
    if (!file) {
        fprintf(stderr, "Error: Couldn't open file %s\n", filename);
        return;
    }

    yyin = file;
    yyparse();

    fclose(file);
}

TVAR* ts = NULL;
%}
%union { char* sir; float val; }

%token TOK_WHILE TOK_FOR TOK_IF TOK_ELSE
%token TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT GHILIMELE VIRGULA 
%token TOK_PRINT TOK_ERROR TOK_SCAN COMENTARIU COMENTARIU2 intg flt RUN

%token <sir> mare mic micegal mareegal egalegal noegal myand myor FISIER
%token <val> TOK_NUMBER TOK_CTI TOK_CTF TOK_CTR
%token <sir> TOK_INT TOK_FLOAT TOK_DOUBLE TOK_VARIABLE TOK_STRING 
%type <val> E
%type <sir> COMPARATII LOGICAL
%type <val> EXPRESII REGULI CONDITII

%start S
%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%
S :
| I ';' S
| RECUNOASTE ';' S
| COMMENT S
| PRINT_SCAN ';' S
| CONTROL S
| EXECUTE_FILE
| BLOC_COD S
| TOK_ERROR { EsteCorecta = 0; }
;
I : TOK_VARIABLE '=' E //mai trebuie definit sa pot atribui asa : int a=5; - done
{//trebuie sa definesc numerele reale, intregi si float - done
if((if_==1 &&if_adevarat==1)|| if_!=1){
if(ts != NULL)
{
        if(ts->exists($1) == 1)
        {
        ts->setValue($1, $3);
        }
        else
        {
        sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
        yyerror(msg);
        YYERROR;
        }
}
    else
{
sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizatafara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
yyerror(msg);
YYERROR;
}
} if_=-1;
}
| TOK_INT TOK_VARIABLE '=' E //mai trebuie definit sa pot atribui asa : int a=5;
{//trebuie sa definesc numerele reale, intregi si float
if((if_==1 &&if_adevarat==1)|| if_!=1){
if(ts != NULL)
{
if(ts->exists($2) == 0)
            {
            ts->add($2,$1,$4);
            //ts->setValue($2,$4);
            }
            else
            {
            sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
            yyerror(msg);
            YYERROR;
            }
}
else
{
ts = new TVAR();
ts->add($2,$1,$4);
//ts->setValue($2,$4);
}} if_=-1;
}
| TOK_FLOAT TOK_VARIABLE '=' E //mai trebuie definit sa pot atribui asa : int a=5;
{//trebuie sa definesc numerele reale, intregi si float
if((if_==1 &&if_adevarat==1)|| if_!=1){
    if(ts != NULL)
{ 
if(ts->exists($2) == 0)
            {
            ts->add($2,$1,$4);
           // ts->setValue($2,$4);
            }
            else
            {
            sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
            yyerror(msg);
            YYERROR;
            }
}
else
{
ts = new TVAR();
ts->add($2,$1,$4);
//ts->setValue($2,$4);
}} if_=-1;
}

| TOK_DOUBLE TOK_VARIABLE '=' E //mai trebuie definit sa pot atribui asa : int a=5;
{//trebuie sa definesc numerele reale, intregi si float
if((if_==1 &&if_adevarat==1)|| if_!=1){
if(ts != NULL)
{
if(ts->exists($2) == 0)
            {
            //ts->add($2);
            //ts->setValue($2,$4);
            ts->add($2,$1,$4);
            }
            else
            {
            sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
            yyerror(msg);
            YYERROR;
            }
}
else
{
ts = new TVAR();
ts->add($2,$1,$4);
//ts->setValue($2,$4);
}} if_=-1;
}
| TOK_INT TOK_VARIABLE
{ if((if_==1 &&if_adevarat==1)|| if_!=1){
if(ts != NULL)
{
if(ts->exists($2) == 0)
            {
            ts->add($2,$1);
            }
            else
            {
            sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
            yyerror(msg);
            YYERROR;
            }
}
else
{
ts = new TVAR();
ts->add($2,$1);
}} if_=-1;
}
| TOK_DOUBLE TOK_VARIABLE
{ if((if_==1 &&if_adevarat==1)|| if_!=1){
if(ts != NULL)
{
if(ts->exists($2) == 0)
            {
            ts->add($2,$1);
            }
            else
            {
            sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
            yyerror(msg);
            YYERROR;
            }
}
else
{
ts = new TVAR();
ts->add($2,$1);
}} if_=-1;
}
| TOK_FLOAT TOK_VARIABLE
{
    if((if_==1 &&if_adevarat==1)|| if_!=1){
if(ts != NULL)
{
if(ts->exists($2) == 0)
            {
            ts->add($2,$1);
            }
            else
            {
            sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
            yyerror(msg);
            YYERROR;
            }
}
else
{
ts = new TVAR();
ts->add($2,$1);
}} if_=-1;
}
| TOK_VARIABLE OPERATIE E
{
    if((if_==1 &&if_adevarat==1)|| if_!=1){
    if(ts!=NULL)
    {
        if(ts->exists($1) == 1)
        {
            float suma= ts->SimpleCalculus($1,$3);
            printf("Calculul este: %f\n",suma);
        }
        else
        {
                sprintf(msg,"Una dintre variabile nu exista!!!\n");
                yyerror(msg);
                YYERROR;
        }
    }} if_=-1;
}
|  TOK_VARIABLE OPERATIE TOK_VARIABLE
{
    if((if_==1 &&if_adevarat==1)|| if_!=1){
    if(ts!=NULL)
    {
        if(ts->exists($1) == 1 && ts->exists($3) == 1)
        {
            float suma= ts->CalculateVariable($1,$3);
            printf("Calculul este este: %f\n",suma);
        }
        else
        {
                sprintf(msg,"Una dintre variabile nu exista!!!\n");
                yyerror(msg);
                YYERROR;
        }
    }} if_=-1;
}
| TOK_INT TOK_VARIABLE '=' TOK_VARIABLE OPERATIE TOK_VARIABLE
{
    if((if_==1 &&if_adevarat==1)|| if_!=1){
    if(ts!=NULL)
    {
        if(ts->exists($4)==1 && ts->exists($6)==1)
        {
            int suma=ts->CalculateVariable($4,$6);
            ts->add($2,$1,suma);
        }
        else printf("Variabilele introduse pentru initializare nu exista!\n");
    } else printf("Nu puteti initializa variabila in acest fel!\n");} if_=-1;
}
| TOK_FLOAT TOK_VARIABLE '=' TOK_VARIABLE OPERATIE TOK_VARIABLE
{
    if((if_==1 &&if_adevarat==1)|| if_!=1){
    if(ts!=NULL)
    {
        if(ts->exists($4)==1 && ts->exists($6)==1)
        {
            float suma=ts->CalculateVariable($4,$6);
            ts->add($2,$1,suma);
        }
        else printf("Variabilele introduse pentru initializare nu exista!\n");
    } else printf("Nu puteti initializa variabila in acest fel!\n");} if_=-1;
}
| TOK_VARIABLE '=' TOK_VARIABLE OPERATIE TOK_VARIABLE
{
    if((if_==1 &&if_adevarat==1)|| if_!=1){
    if(ts!=NULL)
    {
        if(ts->exists($1)==1 && ts->exists($3)==1 && ts->exists($5)==1)
        {
            double x=ts->CalculateVariable($3,$5);
            ts->setValue($1,x);
        }
        else printf("Una dintre variabile nu exista!\n");
    } else printf("Variabila nedeclarata!\n");} if_=-1;
}
| TOK_VARIABLE '=' TOK_VARIABLE OPERATIE E
{
    if((if_==1 &&if_adevarat==1)|| if_!=1){
    if(ts != NULL) 
    {
        if(ts->exists($1)==1&& ts->exists($3)==1)
        {
            double x=ts->SimpleCalculus($3,$5);
            ts->setValue($1,x);
        }
        else printf("Una dintre variabile nu a fost declarata!\n");
    } else printf("Variabila nedeclarata!\n");} if_=-1;
}
| TOK_VARIABLE '=' E OPERATIE TOK_VARIABLE
{ if((if_==1 &&if_adevarat==1)|| if_!=1){
    if(ts != NULL) 
    {
        if(ts->exists($1)==1&& ts->exists($5)==1)
        {
            double x=ts->SimpleCalculus($5,$3);
            ts->setValue($1,x);
        }
        else printf("Una dintre variabile nu a fost declarata!\n");
    } else printf("Variabila nedeclarata!\n");} if_=-1;
}
| TOK_DOUBLE TOK_VARIABLE '=' TOK_VARIABLE OPERATIE TOK_VARIABLE
{
    if((if_==1 &&if_adevarat==1)|| if_!=1){
    if(ts!=NULL)
    {
        if(ts->exists($4)==1 && ts->exists($6)==1)
        {
            double suma=ts->CalculateVariable($4,$6);
            ts->add($2,$1,suma);
        }
        else printf("Variabilele introduse pentru initializare nu exista!\n");
    } else printf("Nu puteti initializa variabila in acest fel!\n");} if_=-1;
}
;
OPERATIE : TOK_PLUS {operatie=1;}
         | TOK_MINUS  {operatie=2;}
         | TOK_DIVIDE {operatie=4;}
         | TOK_MULTIPLY {operatie=3;}
         ;

BLOC_COD : '{' CONTINUT '}'
         ;
E : E TOK_PLUS E { $$ = $1 + $3; }
| E TOK_MINUS E { $$ = $1 - $3; }
| E TOK_MULTIPLY E { $$ = $1 * $3; }
| E TOK_DIVIDE E
{
if($3 == 0)
{
sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!",@1.first_line, @1.first_column);
yyerror(msg);
YYERROR;
}
else
{
$$ = $1 / $3;
}
}
| TOK_LEFT E TOK_RIGHT { $$ = $2; }
| TOK_CTF {$$=$1;}
| TOK_CTI {$$=$1;}
| TOK_CTR {$$=$1;}
;
EXECUTE_FILE : RUN FISIER { run_script($2);}
             ;
COMMENT : COMENTARIU
        | COMENTARIU2
        ;
PRINT_SCAN : TOK_PRINT TOK_LEFT TOK_STRING TOK_RIGHT //asta imi permite printarea pentru text obisnuit
            {
                if((if_adevarat==1 && if_==1)|| if_!=1)
                {string original=$3;
                if(original.length()>=2){
                string resultat=original.substr(1,original.length()-2);
                cout<<resultat<<endl;}
                //if_=-1;
                }
                 if_=-1;
            }
           | TOK_PRINT TOK_LEFT intg VIRGULA TOK_VARIABLE TOK_RIGHT{
             if(if_adevarat==1 && if_==1){
            if(ts->exists($5) == 1)
            printf("%d\n",(int)ts->getValue($5));
            else printf("Variabila pe care vreti sa o afisati nu exista!\n");}
            else if(if_!=1)
            {
                 if(ts->exists($5) == 1)
            printf("%d\n",(int)ts->getValue($5));
            else printf("Variabila pe care vreti sa o afisati nu exista!\n");
            }
            if_=-1;
           }
           | TOK_PRINT TOK_LEFT flt VIRGULA TOK_VARIABLE TOK_RIGHT{
            if(if_adevarat==1 && if_==1){
            if(ts->exists($5) == 1)
            printf("%f\n",(float)ts->getValue($5));
            else printf("Variabila pe care vreti sa o afisati nu exista!\n");}
            else if(if_!=1){
                if(ts->exists($5) == 1)
            printf("%f\n",(float)ts->getValue($5));
            else printf("Variabila pe care vreti sa o afisati nu exista!\n");
            }
            if_=-1;
           }
           | TOK_PRINT TOK_LEFT TOK_STRING VIRGULA TOK_VARIABLE TOK_RIGHT
           {
            if((if_==1 &&if_adevarat==1)|| if_!=1){
            if(ts!=NULL)
            {
                std::string str;
               
                if(ts->exists($5) == 1)
                { double number;

                std::string text = $3;

                if(text.find("%d")!=std::string::npos){
                 number = (int)ts->getValue($5);
                 str = std::to_string(number);
                 }

                 if(text.find("%f")!=std::string::npos){
                 number =ts->getValue($5);
                 str = std::to_string(number);
                 }

                size_t pos = text.find("%d");

                if (pos != std::string::npos) {

                    text.replace(pos, 2, str);
                }else{
                    pos = text.find("%f");
                    if (pos != std::string::npos)

                    text.replace(pos, 2, str);
                }

                if (text.size() >= 2) {
                    text = text.substr(1, text.size() - 2);
                } else {
                    text.clear();
                }

                std::cout << text << std::endl;
                }
                else
                {
                    printf("Variabila pe care o cautati nu exista\n");
                }
            }
            else printf("Variabila pe care o cautati nu exista\n");
            }
            if_=-1;
    }
    | TOK_SCAN TOK_LEFT intg VIRGULA '&' TOK_VARIABLE TOK_RIGHT
    {
        if((if_==1 &&if_adevarat==1)|| if_!=1){
        if(ts!=NULL)
        {
            if(ts->exists($6)==1)
            {
                int x;
                scanf("%d",&x);
                ts->setValue($6,x);
            }
            else printf("Nu ati declarat variabila!\n");
        } else printf("Nu ati declarat variabila!\n");}
        if_=-1;
    }
    | TOK_SCAN TOK_LEFT flt VIRGULA '&' TOK_VARIABLE TOK_RIGHT
    { if((if_==1 &&if_adevarat==1)|| if_!=1){
        if(ts!=NULL)
        {
            if(ts->exists($6)==1)
            {
                float x;
                scanf("%f",&x);
                ts->setValue($6,x);
            }
            else printf("Nu ati declarat variabila!\n");
        } else printf("Nu ati declarat variabila!\n");
    } if_=-1;
    }
    ;
RECUNOASTE: TOK_INT TOK_VARIABLE '=' TOK_LEFT TOK_INT TOK_RIGHT TOK_VARIABLE
{
    if((if_==1 &&if_adevarat==1)|| if_!=1){
    if(ts!=NULL)
    {
        if(ts->exists($7) == 1)
        {
            ts->add($2,$1,(int)ts->getValue($7));
        }
        else printf("Numarul pentru care vreti sa faceti conversia nu exista!\n");
    }
    else printf("Numarul pentru care vreti sa faceti conversia nu exista!\n");} if_=-1;
}
| TOK_FLOAT TOK_VARIABLE '=' TOK_LEFT TOK_FLOAT TOK_RIGHT TOK_VARIABLE
{
    if((if_==1 &&if_adevarat==1)|| if_!=1){
     if(ts!=NULL)
    {
        if(ts->exists($7) == 1)
        {
            ts->add($2,$1,(float)ts->getValue($7));
        }
        else printf("Numarul pentru care vreti sa faceti conversia nu exista!\n");
    }
    else printf("Numarul pentru care vreti sa faceti conversia nu exista!\n");} if_=-1;
}
| TOK_DOUBLE TOK_VARIABLE '=' TOK_LEFT TOK_DOUBLE TOK_RIGHT TOK_VARIABLE
{ if((if_==1 &&if_adevarat==1)|| if_!=1){
     if(ts!=NULL)
    {
        if(ts->exists($7) == 1)
        {
            ts->add($2,$1,(double)ts->getValue($7));
        }
        else printf("Numarul pentru care vreti sa faceti conversia nu exista!\n");
    }
    else printf("Numarul pentru care vreti sa faceti conversia nu exista!\n");} if_=-1;
}
;
COMPARATII : mare
           | mic
           | micegal
           | mareegal
           | egalegal
           | noegal
           ;
LOGICAL : myand
        | myor
        ;
EXPRESII : TOK_VARIABLE COMPARATII TOK_VARIABLE 
        {
            if(ts!=NULL)
        {
            $$= ts->ExecuteConditions($1,$3,$2);
            
        } else printf("Variabilele din conditie nu exista!\n");

        }
         | TOK_VARIABLE COMPARATII E 
         {
            if(ts!=NULL)
            {
                 $$= ts->ExecuteConditions2($1,$3,$2);
            } else printf("Variabilele din conditie nu exista!\n");
         }
         | E COMPARATII TOK_VARIABLE
         {
             if(ts!=NULL)
            {
                 $$= ts->ExecuteConditions2($3,$1,$2);
            } else printf("Variabilele din conditie nu exista!\n");
         }
         | E COMPARATII E
         {
                $$= ExecuteConditions3($1,$3,$2);
         }
         ;
REGULI : REGULI LOGICAL REGULI
        {
            if(strcmp($2,"&&")==0)
            {
                if($1==1 && $3==1) $$=1;
                else  $$= 0;
            }
            else if(strcmp($2,"||")==0)
            {
                if($1==0 && $3==0)  $$= 0;
                else  $$= 1;
            }
        }
       | TOK_LEFT EXPRESII TOK_RIGHT { $$= $2;}
       | EXPRESII {$$=$1;} 
       ;
CONDITII: TOK_IF TOK_LEFT REGULI TOK_RIGHT { if_=1; $$ =$3;if_adevarat=$3;}
        | TOK_WHILE TOK_LEFT REGULI TOK_RIGHT {while_=1;  $$= $3;while_adevarat=$3;}
        ;
CONTINUT : CONTINUT I ';'
         | CONTINUT PRINT_SCAN ';'
         | I ';'
         | PRINT_SCAN ';'
         ;
CONTROL : CONDITII '{' CONTINUT '}'
{
    printf("%f\n",$1); //printeaza 1 pentru adevarat si 0 pentru fals
}
        | CONTROL  TOK_ELSE  CONTROL
        | CONTROL TOK_ELSE '{' CONTINUT '}' 
        ;
%%
int main()
{ cout<<"> ";
yyparse();

return 0;
}
int yyerror(const char *msg)
{
cout<<"EROARE: "<<msg<<endl;
return 1;
}