%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h" /* Updated header name */
/* We removed int yylineno = 1; to fix the error */
%}

/* Tell Flex to track line numbers automatically */
%option yylineno

/* Regex Definitions based on CoreLang Phase 1 */
DIGIT       [0-9]
LETTER      [a-zA-Z]
ID          ({LETTER}|_)({LETTER}|{DIGIT}|_)*
INTEGER     {DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
WHITESPACE  [ \t\r]+

%%

"begin_main"    { return BEGIN_MAIN; }
"end_main"      { return END_MAIN; }
"proc"          { return PROC; }
"return_val"    { return RETURN_VAL; }
"integer"       { return TYPE_INT; }
"real"          { return TYPE_REAL; }
"text"          { return TYPE_TEXT; }
"constant"      { return CONSTANT; }
"print"         { return PRINT; }
"read"          { return READ; }
"if_cond"       { return IF_COND; }
"else_cond"     { return ELSE_COND; }
"repeat_while"  { return REPEAT_WHILE; }
"true"          { return TRUE; }
"false"         { return FALSE; }

":="            { return ASSIGN; }
"+"             { return PLUS; }
"*"             { return MULT; }
";"             { return SEMICOLON; }
"("             { return LPAREN; }
")"             { return RPAREN; }

{FLOAT}         { return FLOAT_NUM; }
{INTEGER}       { return NUMBER; }
{ID}            { return ID; }

\n              { /* Flex handles line numbers automatically now */ }
{WHITESPACE}    { /* Ignore whitespace */ }

.               { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
