;Arithmetic operators
org 100h
.DATA            
;User input statements
    msg1 DB 0AH,0DH, "Enter first  Number: $"                       
    msg2 DB 0AH,0DH, "Enter second Number: $"     
    msg3 DB 0AH,0DH, "Enter your choice: (1. addition(+), 2. subtraction (-) , 3. multiplication (*), 4. diviion (/), 5. modulus (%) , 6. power (^):  $"
    result DB 0AH,0DH, "Result is : $"
    proj  DB 0AH,0DH,   "                   -------- CAPSTONE PROJECT - CALCULATOR -------$" 
    myname  DB 0AH,0DH, "                   -------------- TEAM - 26 ---------------$"
    section  DB 0AH,0DH,"                   ---------------- CSE - A -----------------$" 
    done  DB 0AH,0DH, "---------------------------------$" 
    done2  DB 0AH,0DH, "********************************************************************************$"
    invalid_message DB 0AH,0DH, "INVALID INPUT$"    
    num1 dw 00h
    num2 dw 00h
    overflow db 00h  
.CODE       
            include 'emu8086.inc'
            LEA DX,done2            
            MOV AH,09H              
            INT 21H                
            LEA DX,proj             
            MOV AH,09H            
            INT 21H                
            LEA DX,myname         
            MOV AH,09H              
            INT 21H                
            LEA DX,section          
            MOV AH,09H              
            INT 21H                 
            LEA DX,done2         
            MOV AH,09H              
            INT 21H                
                    
 calculator:
            MOV AX,@DATA           
            MOV DS,AX              
            CALL input              
            CALL parser             
            CALL operation          
            MOV [SI],'&'           
            call reverse_parser    
            call print_result       

;Input Procedure
 input  PROC                       
                MOV [SI],'&'        
                LEA DX,msg1        
                MOV AH,09H        
                INT 21H           
                          
        input1:          
                MOV AH,01H       
                INT 21H             
                CMP AL,13d          
                JZ  print_message2  
                MOV AH,AL
                SUB AH,'0'          
                JC invalid       
                MOV AH,AL 
                MOV DH,'9'
                SUB DH,AH          
                JC invalid         
                SUB AL,'0'        
                INC SI            
                MOV [SI],AL        
                JMP input1       
                              
        print_message2:
                INC SI           
                MOV [SI],'&'      
                LEA DX,msg2   
                MOV AH,09H      
                INT 21H            
                                   
        input2:
                MOV AH,01H         
                INT 21H            
                CMP AL,13d       
                JZ exit            
                MOV AH,AL
                SUB AH,'0'         
                JC invalid         
                MOV AH,AL 
                MOV DH,'9'
                SUB DH,AH          
                JC invalid         
                SUB AL,'0'          
                INC SI            
                MOV [SI],AL        
                JMP input2         
        exit:              
                ret
                
       invalid: LEA DX,invalid_message 
                MOV AH,09H        
                INT 21H            
                hlt
 ENDP ;END of input procedure 
 
;Parser Procedure
 parser PROC                      
  
                MOV CX,01d         
                MOV BX,00H         
                
        parse2:  
                MOV AX,00H       
                MOV AL,[SI]       
                MUL CX             
                ADD BX,AX          
                MOV AX,CX        
                MOV CX,10d        
                MUL CX             
                MOV CX,AX         
                DEC SI              
                CMP [SI],'&'     
                JNZ parse2        
                
                MOV [num2],BX      
                MOV BX,00H                  
                MOV DX,00h         
                DEC SI             
                MOV CX,01d         
                
         parse1:  
                MOV AX,00H       
                MOV AL,[SI]       
                MUL CX              
                ADD BX,AX          
                MOV AX,CX         
                MOV CX,10d          
                MUL CX            
                MOV CX,AX          
                DEC SI           
                CMP [SI],'&'       
                JNZ parse1         
                
                MOV [num1],BX     
                MOV AX,[num1]       
                MOV BX,[num2]      
                
        ret                                                                                                     
 ENDP       ;END of parser procedure
       
;Operation Procedure 
 operation proc                  
               MOV CX,AX       
               LEA DX,msg3        
               MOV AH,09H         
               INT 21H      
                
               MOV AH,01H        
               INT 21H            
               
               CMP AL,'+'           
               JZ addition        
               
               CMP AL,'-'           
               JZ subtraction      
               
               CMP AL,'*'        
               JZ multiplication  
               
               CMP AL,'/'         
               JZ division         
               
               CMP AL,'%'           
               JZ mod               
               
               CMP AL,'^'         
               JZ pow             
             
               LEA DX,invalid_message 
               MOV AH,09H         
               INT 21H            
           hlt
       
       addition:
                MOV AX,CX         
                MOV DX,00h        
                ADD AX,BX       
                ADC AX,DX          
                RET
       subtraction:
                MOV AX,CX           
                SUB AX,BX          
                JC ov 
                JNC nov
             ov:NEG AX
                MOV [overflow],01h
                RET
            nov:RET 
                
       multiplication:
                MOV AX,CX     
                MOV DX,00H       
                MUL BX       
                RET
       division:
                MOV AX,CX         
                MOV DX,00H        
                ADD BX,DX
                JZ DbyZ
                DIV BX            
                RET
         DbyZ:  print 'ERROR : DIVIDE BY ZERO'
                JMP calculator
       mod:
                MOV AX,CX         
                MOV DX,00H         
                ADD BX,DX
                JZ DbZ
                DIV BX            
                MOV AX,DX         
           DbZ: RET
       pow:
                MOV AX,CX          
                MOV CX,BX          
                ADD CX,00h        
                JZ Lc   
                SUB CX,01h         
                JZ La              
                JNZ Lb             
           La:  ret                                      
           Lb:  MOV BX,AX           
                MOV DX,00h        
           L1:  MUL BX             
                LOOP L1            
                ret
           Lc:  MOV AX,01h
                ret                                     
                                  
 ENDP                               ;END OF operation procedure
                  
;reverse_parser Procedure             
 reverse_parser PROC                
     
        r_parse:
                MOV DX,00h        
                MOV BX,10d          
                DIV BX              
                ADD DL,'0'        

                INC SI             
                MOV [SI],DL          
                ADD AX,00h         
                JNZ r_parse             
      
 ENDP                               ;END of reverse_parser procedure 
 
;print_result Procedure
 print_result PROC                 
              
              LEA DX,result        
              MOV AH,09H           
              INT 21H             
              MOV CL,01h           
              CMP CL,[overflow]     
              MOV [overflow],00h
              JZ print_minus      
              JNZ print         
 print_minus: MOV DL,'-'          
              MOV AH,02H        
              INT 21H             
 
       print: 
              MOV DL,[SI]       
              MOV AH,02H         
              INT 21H            
              DEC SI               
              CMP [SI],'&'        
              JNZ print           
     
              LEA DX,done     
              MOV AH,09H        
              INT 21H          
    
              JMP calculator      
 
  ENDP                              ;END of print_result Procedure                    