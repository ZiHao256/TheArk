%{

#include<stdio.h>

%}


%%

[0-9]     {printf("NUM\n");}
"+" | "-" | "*" | "/"    {printf("SIGN\n");}
"("     {printf("LPA\n");}
")"     {printf("RPA\n");}
\n
.

%%

int main(int argc, char **argv){
    yylex();
    yywrap();
    return 0;
}

int yywrap(){
    return 1;
}