%{

#include<stdio.h>
#include<string.h>

int int_value=0;
double double_value=0.0;
char var[100];
int state=-1;

%}

KEY     int|double
NUM     [1-9]+[0-9]*(.[0-9]+)?
id      [_a-zA-Z]+[0-9a-zA-Z]*

%%

{KEY}           {
    if(yytext[0]=='i'){
        state = 0;
    }else{
        state = 1;
    }
}

{NUM}           {
    if(state=0){
        
        sscanf(yytext, "%d", &int_value);
        printf("%s",yytext);
    }else{
        sscanf(yytext, "%lf", &double_value);
    }
}

{id}            {
    strcpy(var, yytext);
}
;       {
    if(state==0){
        printf("<%s, int, %d>\n", var, int_value);
    }else{
        printf("<%s, double, %lf>\n", var, double_value);
    }

}
\n
.

%%

int main(int argc, char ** agrv){
    yylex();
    yywrap();
    return 0;
}
int yywrap(){
    return 1;
}