%{

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

void init_parser(int argc, char *argv[]);
void quit_parser();

extern FILE* yyin;
FILE *asmfile, *incfile;
#define BUFSIZE 256

#define out_asm(fmt, ...) \
    {fprintf(asmfile, fmt, ##__VA_ARGS__); fprintf(asmfile, "\n");}

#define out_inc(fmt, ...) \
    {fprintf(incfile, fmt, ##__VA_ARGS__); fprintf(incfile, "\n");}

void file_error(char *msg);

int ii = 0, itop = -1, istack[128];
int wi = 0, wtop = -1, wstack[128];

#define _BEG_IF     (istack[++itop] = ++ii)
#define _END_IF     (itop--)
#define _i          (istack[itop])

#define _BEG_WHILE  (wstack[++wtop] = ++wi)
#define _END_WHILE  (wtop--)
#define _w          (wstack[wtop])

int argc = 0, varc = 0;
char *_fn, *args[128], *vars[128];
void _WRITE_FUNCHEAD();
void _END_FUNCDEF();

#define _BEG_FUNCDEF(name)  (_fn = (name))
#define _APPEND_ARG(arg)    (args[argc++] = (arg))
#define _APPEND_VAR(var)    (vars[varc++] = (var))

#define YYSTYPE char *

%}

%token T_Void T_Int T_While T_If T_Else T_Return T_Break T_Continue T_Print
%token T_Le T_Ge T_Eq T_Ne T_And T_Or
%token T_IntConstant T_StringConstant T_Identifier T_FloatConstant

%left '='
%left T_Or
%left T_And
%left T_Eq T_Ne
%left '<' '>' T_Le T_Ge
%left '+' '-'
%left '*' '/' '%'
%left '!'

%%

Start:
    Func                            { /* empty */ }
;

Func:
    /* empty */                     { /* empty */ }
|   Func FuncDef                    { /* empty */ }
;

FuncDef:
    T_Int  FuncName Args Vars Modules EndFuncDef
|   T_Void FuncName Args Vars Modules EndFuncDef
;

FuncName:
    T_Identifier                    { _BEG_FUNCDEF($1); }
;

Args:
    '(' ')'                         { /* empty */ }
|   '(' _Args ')'                   { /* empty */ }
;

_Args:
    T_Int T_Identifier              { _APPEND_ARG($2); }
|   _Args ',' T_Int T_Identifier    { _APPEND_ARG($4); }
;

Vars:
    _Vars                           { _WRITE_FUNCHEAD(); }
;

_Vars:
    '{'                             { /* empty */ }
|   _Vars Var ';'                   { /* empty */ }
;

Var:
    T_Int T_Identifier              { _APPEND_VAR($2); }
|   Var ',' T_Identifier            { _APPEND_VAR($3); }
;

Modules:
    /* empty */                     { /* empty */ }
|   Modules Module                  { /* empty */ }
;

Module:
    AssignModule                    { /* empty */ }
|   IfModule                        { /* empty */ }
|   WhileModule                     { /* empty */ }
|   BreakModule                     { /* empty */ }
|   ContinueModule                  { /* empty */ }
|   CallModule                      { /* empty */ }
|   ReturnModule                    { /* empty */ }
|   PrintModule                     { /* empty */ }
;

AssignModule:
    T_Identifier '=' Expr ';'       { out_asm("\tpop %s", $1); }
;

CallModule:
    CallExpr ';'                    { out_asm("\tpop"); }
;

IfModule:
    If '(' Expr ')' Then '{' Modules '}' EndThen EndIf
                                    { /* empty */ }
|   If '(' Expr ')' Then '{' Modules '}' EndThen T_Else '{' Modules '}' EndIf
                                    { /* empty */ }
;

If:
    T_If            { _BEG_IF; out_asm("_begIf_%d:", _i); }
;

Then:
    /* empty */     { out_asm("\tjz _elIf_%d", _i); }
;

EndThen:
    /* empty */     { out_asm("\tjmp _endIf_%d\n_elIf_%d:", _i, _i); }
;

EndIf:
    /* empty */     { out_asm("_endIf_%d:", _i); _END_IF; }
;

WhileModule:
    While '(' Expr ')' Do '{' Modules '}' EndWhile
                    { /* empty */ }
;

While:
    T_While         { _BEG_WHILE; out_asm("_begWhile_%d:", _w); }
;

Do:
    /* empty */     { out_asm("\tjz _endWhile_%d", _w); }
;

EndWhile:
    /* empty */     { out_asm("\tjmp _begWhile_%d\n_endWhile_%d:", 
                                                _w, _w); _END_WHILE; }
;

BreakModule:
    T_Break ';'     { out_asm("\tjmp _endWhile_%d", _w); }
;

ContinueModule:
    T_Continue ';'  { out_asm("\tjmp _begWhile_%d", _w); }
;

ReturnModule:
    T_Return ';'            { out_asm("\tret"); }
|   T_Return Expr ';'       { out_asm("\tret ~"); }
;

PrintModule:
    T_Print '(' T_StringConstant PrintArgs ')' ';'
                            { out_asm("\tprint %s", $3); }
;

PrintArgs:
    /* empty */             { /* empty */ }
|   PrintArgs ',' Expr      { /* empty */ }
;

Expr:
    T_IntConstant           { out_asm("\tpush %s", $1); }
|   T_Identifier            { out_asm("\tpush %s", $1); }
|   '-' Expr %prec '!'      { out_asm("\tneg"); }
|   '!' Expr                { out_asm("\tnot"); }
|   CallExpr                { /* empty */ }
|   Expr '+' Expr           { out_asm("\tadd"); }
|   Expr '-' Expr           { out_asm("\tsub"); }
|   Expr '*' Expr           { out_asm("\tmul"); }
|   Expr '/' Expr           { out_asm("\tdiv"); }
|   Expr '%' Expr           { out_asm("\tmod"); }
|   Expr '>' Expr           { out_asm("\tcmpgt"); }
|   Expr '<' Expr           { out_asm("\tcmplt"); }
|   Expr T_Ge Expr          { out_asm("\tcmpge"); }
|   Expr T_Le Expr          { out_asm("\tcmple"); }
|   Expr T_Eq Expr          { out_asm("\tcmpeq"); }
|   Expr T_Ne Expr          { out_asm("\tcmpne"); }
|   Expr T_Or Expr          { out_asm("\tor"); }
|   Expr T_And Expr         { out_asm("\tand"); }
|   '(' Expr ')'            { /* empty */ }
;

CallExpr:
    T_Identifier Parameters { out_asm("\t$%s", $1); }
;

Parameters:
    '(' ')'
|   '(' _Parameters ')'
;

_Parameters:
    Expr
|   Expr ',' _Parameters
;

EndFuncDef:
    '}'                             { _END_FUNCDEF(); }
;

%%

int main(int argc, char *argv[]) {
    init_parser(argc, argv);
    yyparse();
    quit_parser();
}

void init_parser(int argc, char *argv[]) {
    if (argc < 2) {
        file_error("Must provide an source file!");
    }

    if (argc > 2) {
        file_error("Too much arguments!");
    }

    char *InFileName = argv[1];
    int len = strlen(InFileName);

    if (len <= 2 || InFileName[len-1] != 'c' \
            || InFileName[len-2] != '.') {
        file_error("Must provide an '.c' source file!");
    }

    if (!(yyin = fopen(InFileName, "r"))) {
        file_error("Input file open error");
    }

    char OutFileName[BUFSIZE];
    strcpy(OutFileName, InFileName);

    OutFileName[len-1] = 'a';
    OutFileName[len]   = 's';
    OutFileName[len+1] = 'm';
    OutFileName[len+2] = '\0';
    if (!(asmfile = fopen(OutFileName, "w"))) {
        file_error("Output 'asm' file open error");
    }

    OutFileName[len-1] = 'i';
    OutFileName[len]   = 'n';
    OutFileName[len+1] = 'c';
    OutFileName[len+2] = '\0';
    if (!(incfile = fopen(OutFileName, "w"))) {
        file_error("Output 'inc' file open error");
    }
}

void file_error(char *msg) {
    printf("\n*** Error ***\n\t%s\n", msg);
    puts("");
    exit(-1);
}

char *cat_strs(char *buf, char *strs[], int strc) {
    int i;
    strcpy(buf, strs[0]);
    for (i = 1; i < strc; i++) {
        strcat(strcat(buf, ", "), strs[i]);
    }
    return buf;
}

void _WRITE_FUNCHEAD() {
    char buf[BUFSIZE];
    int i;

    out_asm("FUNC @%s:", _fn);
    if (argc > 0) {
        out_asm("\t%s.arg %s", _fn, cat_strs(buf, args, argc));
    }
    if (varc > 0) {
        out_asm("\t%s.var %s", _fn, cat_strs(buf, vars, varc));
    }

    out_inc("; ==== `%s` begin ====", _fn);
    out_inc("%%define %s.argc %d", _fn, argc);
    out_inc("\n%%MACRO $%s 0\n"
            "   CALL @%s\n"
            "   ADD ESP, 4*%s.argc\n"
            "   PUSH EAX\n"
            "%%ENDMACRO",
            _fn, _fn, _fn);
    if (argc) {
        out_inc("\n%%MACRO %s.arg %s.argc", _fn, _fn);
        for (i = 0; i < argc; i++) {
            out_inc("\t%%define %s [EBP + 8 + 4*%s.argc - 4*%d]",
                        args[i], _fn, i+1);
        }
        out_inc("%%ENDMACRO");
    }
    if (varc) {
        out_inc("\n%%define %s.varc %d", _fn, varc);
        out_inc("\n%%MACRO %s.var %s.varc", _fn, _fn);
        for (i = 0; i < varc; i++) {
            out_inc("\t%%define %s [EBP - 4*%d]",
                        vars[i], i+1);
        }
        out_inc("\tSUB ESP, 4*%s.varc", _fn);
        out_inc("%%ENDMACRO");
    }
}

void _END_FUNCDEF() {
    int i;

    out_asm("ENDFUNC@%s\n", _fn);

    out_inc("\n%%MACRO ENDFUNC@%s 0\n\tLEAVE\n\tRET", _fn);
    for (i = 0; i < argc; i++) {
        out_inc("\t%%undef %s", args[i]);
    }
    for (i = 0; i < varc; i++) {
        out_inc("\t%%undef %s", vars[i]);
    }
    out_inc("%%ENDMACRO");
    out_inc("; ==== `%s` end ====\n", _fn);

    argc = 0;
    varc = 0;
}

void quit_parser() {
    fclose(yyin); fclose(asmfile); fclose(incfile);
}
