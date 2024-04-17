%{
#include <stdio.h>
#define YYSTYPE unsigned long int
FILE *yyin;
int yylex();
%}

%token ONE
%token ZERO
%token END
%token INVALID_CHAR
%token SPACE;

%start Line

%%

Line: Line Number END { printf("Result = %ld\n", $2); }
   | Line END
   | /* empty */
   | error END { $$ = 0; yyerror("Invalid character or syntax!"); yyclearin; yyerrok;}
;

Number: Number Binary { $$ = $1 * 2 + $2; }
	| Binary { $$ = $1; } 
;

 
Binary: ONE { $$ = $1; }
   | ZERO { $$ = $1; }


%%

int yyerror(char *s) 
{
	printf("Syntax error: %s\n", s);
}


void main(int argc, char **argv) {
	++argv, --argc;
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;

    yyparse();
}
