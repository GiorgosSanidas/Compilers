%{

    #include<stdio.h>

    int valid=1;

%}

%token digit letter
%token NEWLINE INTEGER FLOAT ADDITION SUBTRACTION MULTIPLICATION DIVISION LPAREN RPAREN ASSIGN SEMI AND OR IF THEN ELSE WHILE DO ENDWHILE
%left '+' '-'
%left '*' '/'
%left '<' '<'

%%

start : letter s

s :     letter s

      | digit s

      |

      ;
input:
 | input line
 ;
line: NEWLINE
 | expr NEWLINE { printf("\t%.10g\n",$1); }
;
expr: expr ADDITION term { $$ = $1 + $3; }
| expr SUBTRACTION term { $$ = $1 - $3; }
| expr MULTIPLICATION term { $$ = $1 * $3; } 
| expr DIVISION term { $$ = $1 / $3; }
| term 
;
;
term: LPAREN expr RPAREN { $$ = $2; }
| INTEGER 
| FLOAT 
;
E : T        {
                printf("Result = %d\n", $$);
                return 0;
            }
 
T :
    T '+' T { $$ = $1 + $3; }
    | T '-' T { $$ = $1 - $3; }
    | T '*' T { $$ = $1 * $3; }
    | T '/' T { $$ = $1 / $3; }
    | '-' NUMBER { $$ = -$2; }
    | '-' ID { $$ = -$2; }
    | '(' T ')' { $$ = $2; }
    | NUMBER { $$ = $1; }
    | ID { $$ = $1; };
%%

int yyerror(char* s)

{
printf("E\n");
printf("%s\n",s);
    valid=0;

    return 0;

}

int main()

{


    yyparse();

    if(valid)

    {

        printf("%s\n",valid);

    }

}