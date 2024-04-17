%{

#include <stdio.h>
#include "y.tab.h"
#include <math.h>
%}


string [a-zA-Z]+
number ([0-9]+|[0-9]+\.[0-9]+)

%%

{number}  {
   yylval.ydouble = atof(yytext);
   return NUMBER;
}

{string} { printf("yytext = %s\n", yytext); yylval.ystr = yytext; return VARIABLE; } 

[\t ] ;

\n {return END;}  

[+-/=^*] {
                 
                 return(yytext[0]);
              }
%%
