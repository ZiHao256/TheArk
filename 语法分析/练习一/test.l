%{

#include<stdio.h>
#include"y.tab.h"
void yyerror(char *);

%}

ID          [_a-zA-Z]+[0-9a-zA-Z_]*
INUM_VALUE        [1-9][0-9]*|0
FNUM_VALUE        ([1-9][0-9]*|0)(\.[0-9]*)?
CHAR_VALUE        \'[a-zA-Z0-9]\'

%%

{ID}        return ID;
{INUM}      return INUM;
{FNUM}      return FNUM;
{CHAR_VALUE} return CHAR_VALUE;
int         return INT;
double      return  DOUBLE;
char        return CHAR;
"="          return EQUAL;
\n          return LF;
[ \t]
.


%%