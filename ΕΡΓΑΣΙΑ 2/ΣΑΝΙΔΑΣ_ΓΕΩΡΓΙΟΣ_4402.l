%{

#include <stdio.h>
#include <stdlib.h>

#define NO_OP 0
#define ADD 1
#define SUB 2
#define MULT 3
#define DIV 4
#define MOD 5
#define POW 6
#define LEFT_PARENTH 7
#define RIGHT_PARENTH 8
#define EXPR 100
#define NUM 101
#define OPER 102

float calculate(int oper, float a, float b);
void compute();
int insertExprNode();
int insertOperationNode(int operation);


typedef struct node{
 int kind;
 int index;
 float subResult;
 int operator;
 struct node *children[250];
 struct node *parent;
} Node;


Node root = {.index = 0, .kind = EXPR, .subResult = 0.0};
Node *currentNode = &root;
int levels = 1;
int openPars = 0;
int invalidNums = 0;
int extraRightPar = 0;
int CURRENT_OPERATION = NO_OP;
void reset();
%}

%option noyywrap
string [a-zA-Z_$#&@!;:]+
white [ \t]+
digit [0-9]
integer	{digit}+
real {integer}("."{integer})?
newline \n
%%

{string} {
  invalidNums++;  
}
{newline} {compute();
           reset();
           }
{white}	{ }
{real} { 
   float value = atof(yytext);
   if(currentNode!= NULL && CURRENT_OPERATION != NO_OP && CURRENT_OPERATION != LEFT_PARENTH) {
     currentNode->subResult = calculate(CURRENT_OPERATION, currentNode->subResult, value);
   }
   else if(currentNode!= NULL && (CURRENT_OPERATION == NO_OP || CURRENT_OPERATION == LEFT_PARENTH)){
     currentNode->subResult = value;
   }
}

"+" {
      CURRENT_OPERATION = ADD;}
"-" {
      CURRENT_OPERATION = SUB;} 
"*" {
      CURRENT_OPERATION = MULT;}
"/" {
      CURRENT_OPERATION = DIV;}
"^" {
      CURRENT_OPERATION = POW;}
"%" {
      CURRENT_OPERATION = MOD;}

"(" {
      openPars++;
      insertExprNode();
      CURRENT_OPERATION = LEFT_PARENTH;
    }
")" {
   CURRENT_OPERATION = RIGHT_PARENTH; 
   if(openPars == 0){
     extraRightPar = 1;
     compute();
     reset();
   }
   else {
   openPars--;
   if(currentNode != NULL){
     Node *parent = currentNode->parent;
     Node *operationNode = parent->children[0];
     if(operationNode->kind == OPER && operationNode->operator != NO_OP){
        parent->subResult = calculate(operationNode->operator, parent->subResult, currentNode->subResult);
     }
     else if(operationNode->kind == OPER && operationNode->operator == NO_OP) {
        parent->subResult = currentNode->subResult;
     }
     parent->index = 0;
     currentNode = parent;
     levels--;
   }
  }
}

%%

int insertOperationNode(int operation){
  if(currentNode != NULL){
    Node *newNode = (Node*) malloc(sizeof(Node));
    if(newNode == NULL){
      return 0;
    }
    newNode->parent = currentNode;
    newNode->kind = OPER;
    newNode->operator = operation;

    currentNode->children[currentNode->index] = newNode;

    currentNode->index++;
    return 1;
  }
  return 0;
}

int insertExprNode(){
  if(currentNode!=NULL){
    insertOperationNode(CURRENT_OPERATION);

    Node *newNode = (Node *) malloc(sizeof(Node));
    if(newNode == NULL){
      return 0;
    }
    newNode->kind = EXPR;
    newNode->parent = currentNode; 
    currentNode->children[currentNode->index] = newNode;

    currentNode->index++;
    currentNode = newNode;
    levels++;
    return 1;
  }
  return 0;
}

void reset(){
  int i = 0;
  currentNode = &root;
  for(i = 0; i < currentNode->index; i++){
    free(currentNode->children[i]);
  }
  currentNode->index = 0;
  currentNode->subResult = 0.0;
  currentNode->parent = NULL;
  levels = 1;
  openPars = 0;
  extraRightPar = 0;
  invalidNums = 0;
  CURRENT_OPERATION = NO_OP;
}

float calculate(int oper, float a, float b){
  if(oper == ADD){
    return a + b;
  }
  else if(oper == SUB){
    return a - b;
  }
  else if(oper == MULT){
    return a  * b;
  }
  else if(oper == DIV){
    return a / b;
  }
  else if(oper == MOD){
    return (int)a % (int) b;
  }
  else if(oper == POW){
    int i = 0;
    float prod = 1;
    for(i = 0; i<b; i++){
      prod = prod * a;
    }
    return prod;
  }
  else if(oper == NO_OP || oper == LEFT_PARENTH || oper == RIGHT_PARENTH){
    return b;
  }
}

void compute(){
  if(invalidNums > 0){
    printf("There are %d invalid numbers\n", invalidNums);
  }
  else if(openPars != 0){
    printf("%d parenthesis have not been closed\n", openPars);
  }
  else if(extraRightPar){
    //pass
  }
  else {
    printf(" Result %f\n", currentNode->subResult);
  }
}



void main(int argc, char **argv) {
	++argv, --argc;	/* skip over program name */
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;

    yylex();
}