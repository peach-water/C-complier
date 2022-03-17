#ifndef TOKEN_H
#define TOKEN_H

#include<stdio.h>

typedef enum {
    T_Le = 256, T_Ge, T_Eq, T_Ne, T_And, T_Or, T_IntConstant,
    T_StringConstant, T_FloatConstant,T_Identifier, T_Void, T_Int, T_Float, T_While,
    T_If, T_Else, T_Return, T_Break, T_Continue, T_Printf, T_Scanf,
    T_ReadInt
} TokenType;

static const char* print_token(int token) {
    static const char* token_strs[] = {
        "T_Le", "T_Ge", "T_Eq", "T_Ne", "T_And", "T_Or", "T_IntConstant",
        "T_StringConstant", "T_FloatConstant","T_Identifier", "T_Void", "T_Int", "T_Float", "T_While",
        "T_If", "T_Else", "T_Return", "T_Break", "T_Continue", "T_Printf", "T_Scanf",
        "T_ReadInt"
    };
    static char t = '\0';

    if (token < 256) {
        //printf("%-20c", token);
        t = (char)token;
        return &t;
    } else {
        //printf("%-20s", token_strs[token-256]);
        return token_strs[token-256];
    }
}

#endif