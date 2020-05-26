%{
    #include "y.tab.h"
%}
%%
" "
"   "
"\n"
"main"                                   		                      {printf("tMAIN");return(tMAIN);}
"const"                                  		                      {printf("tCONST");return(tCONST);}
"void"                                   		                      {printf("tVOID");return(tVOID);}
"int"                                    		                      {printf("tINT");return(tINT);}
"char"                                   		                      {printf("tCHAR");return(tCHAR);}
"float"                                  		                      {printf("tFLOAT");return(tFLOAT);}
"printf"                                 		                      {printf("tPRINT");return(tPRINTF);}
"="                                      		                      {printf("tEQ");return(tEQ);}
"+"                                      		                      {printf("tADD");return(tADD);}
"-"                                      		                      {printf("tSUB");return(tSUB);}
[0-9]*                                   		                      {printf("tNB");   yylval.nb=atof(yytext); return(tNB);}
[0-9]*("."[0-9]*)                        		                      {printf("tREAL"); yylval.nb=atof(yytext); return(tREAL);}
[0-9]+"e"[+-]?[0-9]                                               {printf("tEXP");  yylval.nb=atof(yytext); return(tEXPO);}
"*"                                      		                      {printf("tMUL");return(tMUL);}
"^"                                      		                      {printf("tPOW");return(tPOW);}
"/"                                      		                      {printf("tDIV");return(tDIV);}
";"                                      		                      {printf("tPTvirg\n");return(tPTvirg);}
"("                                      		                      {printf("tPARo");return(tPARo);}
")"                                      		                      {printf("tPARf");return(tPARf);}
"{"                                      		                      {printf("tACCo");return(tACCo);}
"}"                                      		                      {printf("ACCf");return(tACCf);}
"NULL"                                   		                      {printf("tNULL"); return(tNULL);}
([a-zA-Z]|_)(([0-9]|[a-zA-Z])|_)*                                 {strcpy(yylval.var,yytext) ; printf("(tVAR)%s\n\n\n\n\n",yylval.var); return(tVAR);}
%%
