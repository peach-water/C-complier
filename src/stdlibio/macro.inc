%MACRO print 1
    [SECTION .DATA]
        %%STRING:   DB %1, 10
        %%LEN:      EQU $-%%STRING
    [SECTION .TEXT]
        MOV EAX, 4
        MOV EBX, 1
        MOV ECX, %%STRING
        MOV EDX, %%LEN
        INT 0x80
%ENDMACRO

%MACRO exit 1
    MOV EAX, 1
    MOV EBX, %1
    INT 0x80
%ENDMACRO

GLOBAL _start
[SECTION .TEXT]
_start: