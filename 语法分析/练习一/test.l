
%{

#include<stdio.h>
#include"y.tab.h"
void yyerror(char *);

%}

ID          [_a-zA-Z]+[0-9a-zA-Z_]*
INUM_VALUE        [1-9][0-9]*|0
FNUM_VALUE        ([1-9][0-9]*|0)(\.[0-9]*)?
CHAR_VALUE        '.'

%%

"int"         return INT;
"double"      return  DOUBLE;
"char"        return CHAR;
{ID}        return ID;
{INUM_VALUE}      return INUM_VALUE;
{FNUM_VALUE}      return FNUM_VALUE;
{CHAR_VALUE} return CHAR_VALUE;
"="          return EQUAL;
";"			return END;
"\n"          return LF;
.


%%