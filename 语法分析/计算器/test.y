%{
#include<stdio.h>
int yylex(void);
void yyerror(char *);
%}

%union{
    int inum;
}
%token ADD SUB MUL DIV LF
%token <inum> NUM
%type  <inum> expr term single 

%%

    line_list: line
    | line_list line
    ;

    line: expr LF {printf("%d\n", $1);}

    expr: term
    | expr ADD term     {$$=$1+$3;}
    | expr SUB term     {$$=$1-$3;}
    ;


    term: single        {$$=$1;}
    | term MUL single   {$$=$1*$3;}
    | term DIV single   {$$=$1/$3;}
    ;

    single: NUM     {$$=$1;}
    ;



%%
void yyerror(char *str){
    fprintf(stderr,"error:%s\n",str);
}

int yywrap(){
    return 1;
}
int main()
{
    yyparse();
}
