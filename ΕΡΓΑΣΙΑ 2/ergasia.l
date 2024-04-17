%{
  int op = 0,i,invaNum=0,unclosedPar=0;
  float a, b, c;
  #include <stdio.h>
  #include <ctype.h>
  #define MAXSTACK 100
  #define POSTFIXSIZE 100
  int stack[MAXSTACK];
  int top=-1;

%}
dig [0-9]+|([0-9]*)"."([0-9]+)
lex [a-zA-Z_0-9]* 
add "+"
sub "-"
mul "*"
div "/"
pow "^"
rem "%"
leftPar "("
rightPar ")"
ln \n
%%
{dig} {digi();}
{add} {op=1;}
{sub} {op=2;}
{mul} {op=3;}
{div} {op=4;}
{pow} {op=5;}
{rem} {op=6;}
{lex} {invaNum++;}
{leftPar} {unclosedPar++;}
{rightPar} {unclosedPar--;}
{ln} {compute();}

%%
digi()
{
  if(op==0)
    a=atof(yytext);
  else
  {
    b=atof(yytext);
    switch(op)
    {
      case 1:a=a+b;
      break;

      case 2:a=a-b;
      break;

      case 3:a=a*b;
      break;

      case 4:a=a/b;
      break;

      case 5:for(i=a;b>1;b--)
        a=a*i;
      break;

      case 6:while(a>=b){
        a=a-b;}
      break;
    }
    op=0;
  }
}
void compute()
{
  if (invaNum==0 && unclosedPar==0)
    printf("\n The Answer :%f\n\n",a);
  else if (unclosedPar==0)
    printf("\n There are %d invalid numbers\n\n",invaNum);
  else
    printf("\n %d parentheses have not been closed\n\n",unclosedPar);
  unclosedPar=0;
  invaNum=0;
}

main(int argv,char *argc[])
{
 yylex();
}
  
yywrap()
 {
  return 1;
 }