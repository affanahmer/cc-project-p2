%{
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
extern char* yytext;
extern int yylex();
void yyerror(const char *s);

%}

/* Request verbose error messages to get "Expected X" */
%define parse.error verbose

/* Tokens Declaration (Must match scanner.l) */
%token BEGIN_MAIN END_MAIN PROC RETURN_VAL
%token TYPE_INT TYPE_REAL TYPE_TEXT CONSTANT
%token PRINT READ IF_COND ELSE_COND REPEAT_WHILE
%token TRUE FALSE
%token ASSIGN PLUS MULT SEMICOLON LPAREN RPAREN
%token ID NUMBER FLOAT_NUM

/* Precedence to handle arithmetic correctly */
%left PLUS
%left MULT

/* The Start Symbol */
%start program

%%

/* 1. Program Structure */
program: 
    BEGIN_MAIN stmt_list END_MAIN { printf("\nSyntax analysis successful\n"); }
    ;

/* List of statements */
stmt_list: 
    stmt stmt_list
    | stmt
    ;

/* 2. Syntax Rules (The 5 supported statements) */
stmt: 
      declaration_stmt
    | assignment_stmt
    | io_stmt
    | conditional_stmt
    | loop_stmt
    ;

/* Rule 1: Declaration Statement */
declaration_stmt:
    type ID SEMICOLON
    ;

type:
    TYPE_INT | TYPE_REAL | TYPE_TEXT
    ;

/* Rule 2: Assignment Statement (Using := as per CoreLang) */
assignment_stmt:
    ID ASSIGN expression SEMICOLON
    ;

/* Rule 3: Input/Output Statement */
io_stmt:
      PRINT LPAREN expression RPAREN SEMICOLON
    | READ LPAREN ID RPAREN SEMICOLON
    ;

/* Rule 4: Conditional Statement (if_cond) */
conditional_stmt:
      IF_COND LPAREN expression RPAREN block
    | IF_COND LPAREN expression RPAREN block ELSE_COND block
    ;

/* Rule 5: Loop Statement (repeat_while) */
loop_stmt:
    REPEAT_WHILE LPAREN expression RPAREN block
    ;

/* Helper rule for blocks of code (e.g. inside if/loops) */
block:
    BEGIN_MAIN stmt_list END_MAIN 
    /* Allowing single statement blocks or full blocks depends on design, 
       CoreLang implies structure, so we reuse BEGIN_MAIN/END_MAIN or just a stmt */
    | stmt 
    ;

/* Arithmetic Expressions */
expression:
      expression PLUS expression
    | expression MULT expression
    | LPAREN expression RPAREN
    | value
    ;

value:
      ID
    | NUMBER
    | FLOAT_NUM
    | TRUE
    | FALSE
    ;

%%

/* Error Handling Function */
void yyerror(const char *s) {
    /* Detailed error reporting as required */
    fprintf(stderr, "Syntax Error at Line %d\n", yylineno);
    fprintf(stderr, "Nature of error: %s\n", s);
    fprintf(stderr, "Found Token: %s\n", yytext);
    exit(1);
}

int main() {
    yyparse();
    return 0;
}
