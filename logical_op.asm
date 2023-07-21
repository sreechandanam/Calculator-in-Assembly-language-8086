;Logiical operators
PRINTF MACRO   TXT                                     
    LEA DX, TXT                                        
    MOV AH, 09H                                        
    INT 21H                                          
ENDM
SCANF MACRO NUMBER, LAB1, DONE_ENTER, NORMAL_NUM, HEX_NUM, SKIP_HEX      
    MOV CX, 10H                                      
    LAB1:
        MOV AH, 01H                                       
        INT 21H                                                

        CMP AL, 0DH                                          
        JE DONE_ENTER         

        CMP AL, 41H                                           
        JAE HEX_NUM                                         
                                                             
        NORMAL_NUM:                                       
        SUB AL, 30H                                         
        JMP SKIP_HEX                                        

        HEX_NUM:                                              
        SUB AL, 41H                                           
        ADD AL, 0AH                                         

        SKIP_HEX:
        MOV BL, AL                                     
        MOV AX, NUMBER                                  
        MUL CX                                        

        MOV BH, 0                                        
        ADD AX, BX                                      
        MOV NUMBER, AX                                    

        JMP LAB1                                         

    DONE_ENTER:
        NOP                                                       
ENDM

.STACK 100H
.DATA 
       
    MSG_1 DB  "ENTER THE FRST NUMBER: 0x$"
    MSG_2 DB  "ENTER THE SCND NUMBER: 0x$"
    MSG_3 DB  "ENTER YOUR CHOICE", 13, 10, "[1:AND, 2:OR, 3:NOT, 4:XOR]: $"
    MSG_4 DB  "RESULT IS: 0x$"

    NEWLINE_MSG DB 13,10,"$"

    NUM_1 DW  ?
    NUM_2  DW  ?
    OP_NUM DW  ?

.CODE

    START:
        MOV AX, @DATA                          
        MOV DS, AX

        PRINTF MSG_1                                      
        SCANF NUM_1, L1, L2, NN1, HN1, SH1                

        CALL NEWLINEP                                
        PRINTF MSG_3                                         
        SCANF OP_NUM, L5, L6, NN2, HN2, SH2                  
        CALL NEWLINEP   
        CMP OP_NUM, 03H                                   
        JE NOT_OP                                          
        PRINTF MSG_2                                 
        SCANF NUM_2, L3, L4, NN3, HN3, SH3               
        CALL NEWLINEP                                     
        MOV AX, NUM_1                 
                              
        CMP OP_NUM, 01H                                     ; CHECK IF AND OPERATION
        JE AND_OP
        CMP OP_NUM, 02H                                     ; CHECK IF OR OPERATION
        JE OR_OP
        CMP OP_NUM, 04H                                     ; CHECK IF XOR OPERATION
        JE XOR_OP


        AND_OP:                                            
        AND AX, NUM_2
        JMP NEXT

        OR_OP:                                          
        OR AX, NUM_2
        JMP NEXT

        NOT_OP:                                            
        MOV AX, NUM_1                                      
        NOT AX
        JMP NEXT

        XOR_OP:                                        
        XOR AX, NUM_2
        JMP NEXT

        NEXT: 
        MOV BX, 0010H                                  
        MOV CX, 0000H                        

        PUT_NUMBER_IN_STACK:
        MOV DX, 0000H                                    
        DIV BX                                       
        PUSH DX                                          
        INC CX                                         

        CMP CX, 0004H                                   
        JNE PUT_NUMBER_IN_STACK                         
            
        PRINTF MSG_4                       
       
        DISPLAY_RESULT:
        POP DX                                            
        ADD DL, 30H                                       
        CMP DL, 39H                                     
        JB  SKIP_ADDING                                  
        ADD DL, 07H                                    
        
        SKIP_ADDING:                                       
        
        MOV AH, 02H                                        
        INT 21H                                             
        LOOP DISPLAY_RESULT                                 

        CALL NEWLINEP   

        MOV AX, 4C00H                         
        INT 21H                                                         

        NEWLINEP PROC                                  
            MOV DX, OFFSET NEWLINE_MSG
            MOV AH, 09H                                   
            INT 21H                                      
            RET                                           
        NEWLINEP ENDP
    END START