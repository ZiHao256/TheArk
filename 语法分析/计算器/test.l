%{
#include<stdio.h>
#include<string.h>
#include "y.tab.h"
void yyerror(char *);

%}

NUM     [1-9]+[0-9]*|0

%%

{NUM}   {sscanf(yytext, "%d", &yylval);return NUM;}
"+"     return ADD;
"-"     return SUB;
"*"     return MUL;
"/"     return DIV;
"\n"    return LF;
.


%%


