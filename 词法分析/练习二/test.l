%{

#include<stdio.h>
int key_count = 0;
int mark_count = 0;

%}




%%

if|else|int|double|return {key_count++; printf("KEY ");}
[a-zA-Z]+[a-zA-Z_]*     {mark_count++; printf("MARK ");}
\n          {printf("\n");}
.

%%

int main(int argc, char **argv){
    yylex();
    printf("\n%d %d",key_count,mark_count);
    yywrap();
    return 0;
}

int yywrap(){
    return 1;
}