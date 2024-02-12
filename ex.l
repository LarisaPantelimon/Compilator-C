%option noyywrap
%{
    #include "ex.tab.h"
    #include <iostream>
    #include <stdlib.h>
    #include<stdio.h>
    using namespace std;
    int lineNo = 1;
    int colNo = 1;
    // singura parte de unde a fost luat cod a fost ultimul laborator!
%}
%%
"+" { colNo++; return TOK_PLUS; }
"-" { colNo++; return TOK_MINUS; }
"*" { colNo++; return TOK_MULTIPLY; }
"/" { colNo++; return TOK_DIVIDE; }
"(" { colNo++; return TOK_LEFT; }
")" { colNo++; return TOK_RIGHT; }
";" { colNo++; return ';'; }
"=" { colNo++; return '='; }
"{" {return '{';}
"}" {return '}';}

">"  {yylval.sir = strdup(yytext); return mare;}
"<"  {yylval.sir = strdup(yytext); return mic;}
"<=" {yylval.sir = strdup(yytext); return micegal;}
">=" {yylval.sir = strdup(yytext); return mareegal;}
"==" {yylval.sir = strdup(yytext); return egalegal;}
"!=" {yylval.sir = strdup(yytext); return noegal;}

"&&" {yylval.sir = strdup(yytext); return myand;}
"||" {yylval.sir = strdup(yytext); return myor;}

"if"                {  return TOK_IF;}
"else"              {return TOK_ELSE;}
"while"             {return TOK_WHILE;}
"for"               {return TOK_FOR;}

"\"%d\""            {return intg;}
"\"%f\""            {return flt;}
"&"                 {return '&';}
","                 { return VIRGULA;}

\"([^\\\"]|\\.|\ )*\" { yylval.sir = strdup(yytext); return TOK_STRING; }
\"                    {return GHILIMELE;}
"//".*                {return COMENTARIU;}

"/*"([^*]|\n|(\*+([^*/]|\n)))*\*+"/"  {return COMENTARIU2;}
[0-9]+                           { yylloc.first_line = lineNo;
                                        yylloc.first_column = colNo;
                                        colNo+=strlen(yytext);
                                        yylval.val = atoi(yytext); return TOK_CTI;}

[0-9]*\.[0-9]+                   { yylloc.first_line = lineNo;
                                        yylloc.first_column = colNo;
                                        colNo+=strlen(yytext);
                                        yylval.val = atof(yytext); return TOK_CTR;}

[0-9]+[.]+[0-9]+f                { yylloc.first_line = lineNo;
                                        yylloc.first_column = colNo;
                                        colNo+=strlen(yytext);
                                        yylval.val = atof(yytext); return TOK_CTF;}
[a-zA-Z]*\.txt                          {yylval.sir = strdup(yytext); return FISIER;}
"run"                                   { return RUN;}

"printf"            { colNo+=6; return TOK_PRINT; }
"scanf"             { colNo+=5; return TOK_SCAN; }
"int"               {colNo+=3;  yylval.sir = strdup(yytext); return TOK_INT;}
"float"             {colNo+=5; yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext); return TOK_FLOAT;}
"double"            { colNo+=6  ; yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext); return TOK_DOUBLE;}

[a-zA-Z][a-zA-Z0-9]*    { yylloc.first_line = lineNo;
                        yylloc.first_column = colNo;
                        colNo+=strlen(yytext);
                        yylval.sir = new char[strlen(yytext)+1];
                        strcpy(yylval.sir,yytext);
                        return TOK_VARIABLE;}

\r\n                    { lineNo++; colNo=1; }
\n                      { lineNo++; colNo=1; cout<<"> "; }
[\t]                   ;
[ ]                     ;
.                       { colNo++; return TOK_ERROR; }

%%
