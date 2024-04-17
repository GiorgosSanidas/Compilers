%{

	#include <stdio.h>
	void display(int);
	int check(char *s);
%}

%option noyywrap

%%
[0-9]+          			{ printf("%s:number\n",yytext); }
["*"?"%"+"-"="(")">"<"]? 	{ printf("%s:operator\n",yytext); } 	
[A-Za-z0-9]* { 
    if (check(yytext)==1) 
        printf("%s:reserved\n",yytext);
    else
        printf("%s:ID\n",yytext); 

}


[ ]+                        {printf(" "); }
.                           {printf("%s:Unknown symbols!\n",yytext); }
%%              	

int check(char *s)
{
	if (strcmp(s, "when")==0)
		return 1;
	else if	(strcmp(s, "for")==0)
		return 1;
	else if	(strcmp(s, "and")==0)
		return 1;
	else if	(strcmp(s, "while")==0)
		return 1;
	else if	(strcmp(s, "else")==0)
		return 1;
	else if	(strcmp(s, "read")==0)
		return 1;
	else if	(strcmp(s, "if")==0)
		return 1;
	else if	(strcmp(s, "printf")==0)
		return 1;
	else if	(strcmp(s, "float")==0)
		return 1;
	else if	(strcmp(s, "or")==0)
		return 1;
	else if	(strcmp(s, "not")==0)
		return 1;
	else
		return 0;							

}
 
void main(int argc,char **argv) {
	++argv, --argc;	
	if ( argc > 0 ) 
		yyin = fopen( argv[0], "r" );  
	else
	    yyin = stdin; 	

	yylex(); 
}