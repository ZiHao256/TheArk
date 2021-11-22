
%{
#include<stdio.h>
#include<string.h>
int yylex(void);
void yyerror(char *);
%}
%token ID INUM_VALUE FNUM_VALUE CHAR_VALUE INT DOUBLE CHAR EQUAL END LF

%%

    line_list: line
    | line_list line
    ;

    line: e LF  {printf("YES\n");}

    e: INT ID END
    | INT ID EQUAL INUM_VALUE END
    | INT ID EQUAL CHAR_VALUE END
    | DOUBLE ID END
    | DOUBLE ID EQUAL INUM_VALUE END
    | DOUBLE ID EQUAL FNUM_VALUE END
    | CHAR ID END
    | CHAR ID EQUAL INUM_VALUE END
    | CHAR ID EQUAL CHAR_VALUE END
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