%{
#include <stdio.h>
#include <stdlib.h>
int check(char *s);
%}

%option noyywrap

%%
[0-9]+ {printf("%s: number\n", yytext);}
["*""?""%""+"\-"=""("")"">""<"]? {printf("%s: operator\n", yytext);}
[A-Za-z0-9]+ { if(check(yytext) == 0 ){
                 printf("%s: ID\n", yytext);
	       }
               else {
                 printf("%s: RESERVED", yytext);
               }
             }
[ ]+ {}
. {printf("%s: Unknown symbols!\n", yytext);}
%%

int check(char *s){
  char *reservedWords[] = {
    "and", "else", "if", "int", "float", "not",
    "or", "print", "read", "while", "for"
  };

  int size = 11;
  int i=0;
  for( i=0;i< size; i++){
    if(strcmp(s, reservedWords[i]) == 0){
      return 1;
    }
    else continue;
   }
  return 0;
}

void main(int argc, char **argv){
  ++argv;
  --argc;

  if(argv > 0)
    yyin = fopen(argv[0], "r");
  else
    yyin = stdin;

  yylex();
}
