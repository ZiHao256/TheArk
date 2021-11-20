%{
/* 定义声明段*/
#include<stdio.h>

#define BEG 	1
#define END 	2
#define IF		3
#define THEN	4
#define WHILE	5
#define DO		6
#define CONST	7
#define VAR		8
#define	CALL	9
#define	PROCEDURE	10
#define ODD		11

#define ADD	12
#define MINUS 13
#define MULTI	14
#define DIVIDE	15
#define	EQUAL	16
#define ASSIGN  17

#define JIN 18
#define LESS	19
#define MORE	20
#define LEFT	21
#define	RIGHT	22
#define COMMA	23
#define DOT 	24
#define SEMICOLON 25

#define ID 		26
#define NUM     27
#define ERRORCHAR 28
#define NEWLINE 29

int yylval;
/* yylval 是yacc中定义的变量，用来保存记号的属性值，默认是int类型。 
 * 在用lex实现的词法分析器中可以使用这个变量将记号的属性传递给用
 * yacc实现的语法分析器。
 *
 * 注意：该变量只有在联合使用lex和yacc编写词法和语法分析器时才可在lex
 *       中使用，此时该变量不需要定义即可使用。
 *       单独使用lex时，编译器找不到这个变量。这里定义该变量为了“欺骗”编译器。
 */
int installID();
int installNUM();

%}

/*定义段：正规定义*/

delim		[\t \n]
empty		{delim}+
letter		[A-Za-z]
digit		[0-9]
id			({letter}|_)({letter}|{digit}|_)*
digits		{digit}{digit}*
num			[+-]?[0-9][0-9]*((\.)[0-9][0-9]*)?((E)[+-]?([0-9][0-9]*))?

%%
    /*
     *词法规则段
     */
begin		{return (BEG);}
end			{return (END);}		
if			{return (IF);}
then		{return (THEN);}
while		{return (WHILE);}
do			{return (DO);}
const		{return (CONST);}
var			{return (VAR);}
call		{return (CALL);}
procedure	{return (PROCEDURE);}
odd			{return (ODD);}

{empty}		{;}
{id}		{yylval = installID(); return (ID);}
{num}		{yylval = installNUM(); return (NUM);}

"+"			{return (ADD);}
"-"			{return (MINUS);}
"*"			{return (MULTI);}
"/"			{return (DIVIDE);}
"="			{return (EQUAL);}
":="		{return (ASSIGN);}

"#"		    {return (JIN);}
"<"		    {return (LESS);}
">"		    {return (MORE);}
"("		    {return (LEFT);}
")"		    {return (RIGHT);}
","		    {return (COMMA);}
"."		    {return (DOT);}
";"		    {return (SEMICOLON);}

.		{return (ERRORCHAR);}

%%
/*
 * 辅助函数段
 */


/* yywrap这个辅助函数是词法分析器遇到输入文件结尾时会调用的，用来决定下一步怎么做：
 * 若yywrap返回0，则继续扫描；返回1，则词法分析器返回报告文件已结束的0。
 * lex库中的标准yywrap程序就是返回1，你也可以定义自己的yywrap。
 */
int yywrap(){
    return 1;
}

int installID(){
    /*将词法单元装入符号表，并返回指针*/
    return ID;
}
int installNUM(){
    return NUM;
}



void writeout(int c){
    /* yytext是当前识别的词法单元（词文）的指针*/
    switch(c){
        case ERRORCHAR: fprintf(yyout, "(ERRORCHAR, \"%s\") ", yytext);
            break;
        case BEG: fprintf(yyout, "(BEGIN, \"%s\") ", yytext);
            break;  	  
        case END: fprintf(yyout, "(END, \"%s\") ", yytext);
            break;
        case IF: fprintf(yyout, "(IF, \"%s\") ", yytext);
            break;
        case THEN: fprintf(yyout, "(THEN, \"%s\") ", yytext);
            break;
        case WHILE: fprintf(yyout, "(WHILE, \"%s\") ", yytext);
            break;
        case DO: fprintf(yyout, "(DO, \"%s\") ", yytext);
            break;
        case CONST: fprintf(yyout, "(CONST, \"%s\") ", yytext);
            break;
        case VAR: fprintf(yyout, "(VAR, \"%s\") ", yytext);
            break;
        case CALL: fprintf(yyout, "(CALL, \"%s\") ", yytext);
            break;
        case PROCEDURE: fprintf(yyout, "(PROCEDURE, \"%s\") ", yytext);
            break;
        case ODD: fprintf(yyout, "(ODD, \"%s\") ", yytext);
            break;
        case ADD: fprintf(yyout, "(ADD, \"%s\") ", yytext);
            break;
        case MINUS: fprintf(yyout, "(MINUS, \"%s\") ", yytext);
            break; 
        case MULTI: fprintf(yyout, "(MULTI, \"%s\") ", yytext);
            break; 
        case DIVIDE: fprintf(yyout, "(DIVIDE, \"%s\") ", yytext);
            break; 
        case EQUAL: fprintf(yyout, "(EQUAL, \"%s\") ", yytext);
            break; 
        case ASSIGN: fprintf(yyout, "(ASSIGN, \"%s\") ", yytext);
            break;
        case JIN: fprintf(yyout, "(JIN, \"%s\") ", yytext);
            break; 
        case LESS: fprintf(yyout, "(LESS, \"%s\") ", yytext);
            break; 
        case MORE: fprintf(yyout, "(MORE, \"%s\") ", yytext);
            break; 
        case LEFT: fprintf(yyout, "(LEFT, \"%s\") ", yytext);
            break; 
        case RIGHT: fprintf(yyout, "(RIGHT, \"%s\") ", yytext);
            break; 
        case COMMA: fprintf(yyout, "(COMMA, \"%s\") ", yytext);
            break; 
        case DOT: fprintf(yyout, "(DOT, \"%s\") ", yytext);
            break; 
        case SEMICOLON: fprintf(yyout, "(SEMICOLON, \"%s\") ", yytext);
            break; 
        case ID: fprintf(yyout, "(ID, \"%s\") ", yytext);
            break;     
        case NUM: fprintf(yyout, "(NUM, \"%s\") ", yytext);
            break;          
        case NEWLINE: fprintf(yyout, "\n");
            break;
        default:
            break;
    }
  return;
}

int main (int argc, char ** argv){
	int c,j=0;
	if (argc>=2){
	  if ((yyin = fopen(argv[1], "r")) == NULL){
	    printf("Can't open file %s\n", argv[1]);
	    return 1;
	  }
	  if (argc>=3){
	    yyout=fopen(argv[2], "w");
	  }
	}
	/* yyin和yyout是lex中定义的输入输出文件指针，它们指明了
	 * lex生成的词法分析器从哪里获得输入和输出到哪里。
	 * 默认：键盘输入，屏幕输出。 
	 */

	while (c = yylex()){
		writeout(c);
        writeout(NEWLINE);
	}
	if(argc>=2){
	  fclose(yyin);
	  if (argc>=3) fclose(yyout);
	}
	return 0;
}