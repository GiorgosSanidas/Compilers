%{

    #include "y.tab.h"

%}

%%

[a-zA-Z_][a-zA-Z_0-9]* return letter;

[0-9]                       return digit;

.                      return yytext[0];

\n                     return 0;
%union {
double ydouble;
char*ystr;
}
%%

int yywrap()

{

return 1;

}