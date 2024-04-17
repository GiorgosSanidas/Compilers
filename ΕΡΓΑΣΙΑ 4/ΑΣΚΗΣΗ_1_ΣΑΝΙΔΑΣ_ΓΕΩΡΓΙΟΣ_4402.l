%{
#define YYSTYPE unsigned long int
#include "y.tab.h"
extern YYSTYPE yylval;
%}

%option noyywrap

end \n
one 1
zero 0
space [ \t]+

%%

{one} {yylval=atoi(yytext); return ONE;}
{zero} {yylval=atoi(yytext); return ZERO;}
{end} {return END;}
{space} {return SPACE;}
. {return INVALID_CHAR;}

%%