%{
// #include "../head/Token.h" 
#define YYSTYPE char *
#include "y.lab.h"
#define _DUPTEXT {yylval = strdup(yytext);}
void yyerror(const char* msg);
int cur_line_num = 1;
void unrecognized_char(char c);
void lex_error(char* msg, int line);
%}

/* Definitions, note: \042 is '"' */
INTEGER             ([0-9]+)
FLOAT               ([0-9]+.[0-9]+)
UNTERM_STRING       (\042[^\042\n]*)
STRING              (\042[^\042\n]*\042)
IDENTIFIER          ([_a-zA-Z][_a-zA-Z0-9]*)
OPERATOR            ([+*-/%=,;!<>(){}])
SINGLE_COMMENT      ("//"[^\n]*)

%%

[\n]                { cur_line_num++;                       }
[ \t\r\a]+          { /* ignore all spaces */               }
{SINGLE_COMMENT}    { /* skip for single line comment */    }

{OPERATOR}          { return yytext[0];         }   

"<="                { return T_Le;              }
">="                { return T_Ge;              }
"=="                { return T_Eq;              }
"!="                { return T_Ne;              }
"&&"                { return T_And;             }
"||"                { return T_Or;              }
"void"              { return T_Void;            }
"int"               { return T_Int;             }
"float"             { return T_Float;           }
"while"             { return T_While;           }
"if"                { return T_If;              }
"else"              { return T_Else;            }
"return"            { return T_Return;          }
"break"             { return T_Break;           }
"continue"          { return T_Continue;        }
"printf"            { return T_Printf;          }
"print"             { return T_Printf;          }
"scanf"             { return T_Scanf;           }

{INTEGER}           { _DUPTEXT; return T_IntConstant;     }
{STRING}            { _DUPTEXT; return T_StringConstant;  }
{IDENTIFIER}        { _DUPTEXT; return T_Identifier;      }
{FLOAT}             { _DUPTEXT; return T_FloatConstant;   }

<<EOF>>             { return 0; }

{UNTERM_STRING}     { lex_error("Unterminated string constant", cur_line_num);  }
.                   { lex_error("Unrecognized character", cur_line_num);        }

%%

// int main(int argc, char* argv[]) {
//     int token;
//     FILE *fp = fopen("./Token.txt","w");
//     while (token = yylex()) {
//         printf("%-20s",print_token(token));
//         printf("%-10s\t", yytext);
//         printf("%d\n",token);
//         fprintf(fp,"%-20s",print_token(token));
//         fprintf(fp,"%-10s",yytext);
//         fprintf(fp,"\t%d\n",token);
//     }
//     fclose(fp);
//     return 0;
// }

void yyerror(const char *msg){
    printf("Error at line %d:\n\t%s\n", cur_line_num, msg);
    exit(-1);
}

void unrecognized_char(char c){
    char buf[32] = "Unrecognized ?";
    buf[13] = c;
    buf[14] = 0;
    yyerror(buf);
}

void lex_error(char* msg, int line){
    printf("\nError at line %-3d: %s\n\n", line, msg);
}

int yywrap(void) {
    return 1;
}