---
title: PL/0 语法分析
title: Alex Ma
---

[参考](https://blog.csdn.net/weixin_44007632/article/details/108666375)



# Bison/Yacc

新手框架：

test.l

```C
%{
#include "y.tab.h"
void yyerror(char *);
%}
//正规定义
%%
//词法规则
%%
//空
```

test.y

```C
%{
int yylex(void);
void yyerror(char *);
%}
%token //种别

%%
//产生式
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

```

## 小练习

```
练习简介：
  在C语言中，我们常常需要定义变量，而定义变量是有语法规则的。
  现在我们希望编写一个分析器，判断一行定义变量的C代码是否合法。
目前我们希望以下定义方式合法：
  [类型] [变量名] ;
  [类型] [变量名] = [值];
  [类型]为int、double或char，字符的值用''括起。
  	产生式：
  	e: type ID END
    | type ID EQUAL value END
    ;
    type: INT
    | DOUBLE
    | CHAR
    ;
    value: INT_VALUE
    | CHAR_VALUE
    | DOUBLE_VALUE
    ;
  如果在定义变量时直接赋值，则需要满足以下规定：
  int型与char型的变量，值可以是整数或字符，不能为小数（不判断值是否会溢出）
  double型的变量，值可以是小数或整数，但不能是字符

测试数据：
  double a_test;
  int a=5;
  double b=2.33;
  char c='t';
  （以上都是合法输入）
  ...
  语法组合较多，请自行编写测试数据。

```





**词法分析：**

* 种别：
  * 关键词 INT DOUBLE CHAR
  * 标识符 ID
  * 界符 EQUAL END
  * 常量 INUM_VALUE FNUM_VALUE CHAR_VALUE

```C

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
```



**语法分析：**

* 产生式：

  * ```
    
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
        
    ```

  * 

```C

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
```

## 计算器

​		做出只有加减乘除四种功能的计算器。这个计算器的功能为，当输入合法时，输出这个表达式的值。a+b*c

### flex 程序传值给 bison程序

> bison程序维护了两个栈，一个是**文法符号栈**，用来进行语法上的归约和移进；另一个则是**属性值栈**，这个栈内的值是与文法符号栈一一对应的，当一个文法符号被压栈时，它的值也被压进了属性值栈。因此，我们可以在属性值栈中寻找我们需要的值。

​		bison的全局变量yylval。在flex进行词法分析时，一旦分析成功，我们就在action中令yylval等于需要传入的值。

* 例子：在分析出一个整数之后，可以做sscanf(yytext,"%d",&yylval);操作

​		bison 宏，叫做YYSTYPE，表示yylval的数据类型。通常情况下，YYSTYPE定义为int型。如果想要更改，可以做如下操作：#define YYSTYPE double

​		传更多类型：在bison第一部分：

```C
%union{
  int inum;
  double fnum;
  char c;
  char * string;
  //其余类型随意加
}
```

### test.y

```C
%{
#include <stdio.h>
#include <string.h>
int yylex(void);
void yyerror(char *);
%}

//定义从flex程序传来的yylval数据类型
%union{
  int inum;
  double dnum;
}
%token ADD SUB MUL DIV CR
%token <inum> NUM		//指定类型和终结符
%type  <inum> expression term single	//指定类型和非终结符

%%
       line_list: line
                | line_list line
                ;
				
	       line : expression CR  {printf(">>%d\n",$1);}

      expression: term 
                | expression ADD term   {$$=$1+$3;}	//计算终结符或者非终结符的值
				| expression SUB term   {$$=$1-$3;}
                ;

            term: single
				| term MUL single		{$$=$1*$3;}
				| term DIV single		{$$=$1/$3;}
				;
				
		  single: NUM
				;
%%

```

### test.l

```C
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
```



# PL/0 语法分析



