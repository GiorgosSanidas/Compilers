%{

  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <math.h>
  int yylex();
  #define SIZE 100

typedef struct Variable {
    char name[512];
    double value;
} Variable;

Variable variables[SIZE];

int lookup(char *str);
void init();
int top = 0;
%}

%union {
 double ydouble;
 char *ystr;
} 
  
%token NUMBER END
%token VARIABLE

%left '+' '-'
%left '*' '/' '^'
%right UMINUS

%start statementList

%%
  
statementList: statement END {printf("In: %f\n", $1.ydouble);}
   | statementList statement END
   | error END {yyerrok;}
  ;


statement: expression { printf("Result = %f\n", $1.ydouble);} 
   |  VARIABLE '=' NUMBER  {strcpy(variables[top].name, $1.ystr);
                           printf("Input %s\n", $$.ystr);
                           //variables[top].value = $3.ydouble;
                           top++;}
 
expression: expression "+" terminal { $$.ydouble = $1.ydouble + $3.ydouble; }
           | expression "-" terminal { $$.ydouble = $1.ydouble + $3.ydouble; }
           | terminal { $$.ydouble = $1.ydouble; }
   ;

terminal: terminal "*" factor {$$.ydouble = $1.ydouble * $3.ydouble;}
    | terminal "^" factor {$$.ydouble = pow($1.ydouble, $3.ydouble);}
    | terminal "/" factor {if($3.ydouble == 0.0) yyerror("Divide by zero!"); else $$.ydouble = $1.ydouble / $3.ydouble; }
    | factor { $$.ydouble = $1.ydouble; }
;

factor: "(" expression ")" { $$.ydouble = $2.ydouble; }
      | "-" factor %prec UMINUS { $$.ydouble = -$2.ydouble; }
      | NUMBER { $$.ydouble = $1.ydouble; } 
      | VARIABLE { 
           int index = lookup($1.ystr);
           printf("Value=%f\n", variables[index].value);
           if(index!=-1){
             $$.ydouble = variables[index].value;
           }
           else {
             $$.ydouble=0.0;
             yyerror("No variable!");
           }
           
           printf("%f\n", $$.ydouble);
         }
    ;
     
%%
  
//driver code
void main()
{
   init();
   yyparse();
 
}

int lookup(char *str){
    int i=0;
    printf("Search for: %s\n",str); 
    for(i=0; i<SIZE; i++){
      printf("Compare with %s\n", variables[i].name);
      if (strcmp(str, variables[i].name) == 0) {
        return i;
      }
    }
    return -1;
}

void init(){
    int i = 0;

    for(i=0; i<SIZE; i++){
      strcpy(variables[i].name, "");
      variables[i].value = 0.0;
    }
}


void yyerror(char *msg)
{
   printf("\nEntered arithmetic expression is Invalid: %s\n\n", msg);
}


yywrap()
{
  return(1);
}
