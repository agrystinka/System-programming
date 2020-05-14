.386
.model flat, stdcall
option casemap:none

 include C:\masm32\include\masm32.inc 
 include C:\masm32\include\user32.inc 
 include C:\masm32\include\kernel32.inc 
  
 includelib C:\masm32\lib\masm32.lib 
 includelib C:\masm32\lib\user32.lib 
 includelib C:\masm32\lib\kernel32.lib

.data
      vala real8 3.6, 3.9, 2.1, 12.7, 13.56 
      valb real8 0.2, -2.2, 3.6, 0.57, 17.2
      valc real8 2.5, 3.9, -1.2, 0.365, 7.5
      vald real8 50.0, 20.5, 36.0, 6.0, 3.2
      
      valr real8 0.0, 0.0, 0.0, 0.0, 0.0      
     
      two real8 2.0
      four real8 4.0
        
      help1 db 15 dup ('b')
      help2 db 15 dup ('a') 
      help3 db 15 dup ('c')
      help4 db 15 dup ('a')
      help5 db 15 dup ('b') 

	Tittle db "Lab_6",0
	Text db 200 dup ('a')

      format db "#1: %s", 13,		
                "#2: %s", 13,	
                "#3: %s", 13,	                
                "#4: %s", 13,		
                "#5: %s", 13,	0                        
	
.code

; (c * 2 - lg (d / 4))/(a * 2 - b)

      start:       
            mov ebp, 0 
                       
      leb1: fld vald[ebp]     ;st0 = d
            fdiv four         ;st0 = d / 4           

            fldlg2            ;st0 = const = lg 2, st1 = d / 4
            fxch              ;st0 = d / 4, st1 = const
            fyl2x             ;st0 = lg (d / 4) = const * log2(d/4)

            fld valc[ebp]     ;st0 = c, st1 = lg (d / 4)
            fmul two          ;st0 = c * 2, st1 = lg (d / 4)
            fxch              ;st0 = lg (d / 4), st1 = c * 2
            fsub              ;st0 = c * 2 - lg (d / 4)           

            fld vala[ebp]     ;st0 = a, st1 = c * 2 - lg (d / 4)  
            fmul two          ;st0 = a * 2            
            fsub valb[ebp]    ;st0 = a * 2 - b
            
            fdiv              ;st0 = (c * 2 - lg (d / 4))/(a * 2 - b)
            fstp valr[ebp]
            add ebp, 8
            cmp ebp, 40       
            jne leb1            
           
            invoke FloatToStr, valr[0], addr help1
            invoke FloatToStr, valr[8], addr help2
            invoke FloatToStr, valr[16], addr help3
            invoke FloatToStr, valr[24], addr help4
            invoke FloatToStr, valr[32], addr help5

            invoke wsprintfA, addr Text, addr format, addr help1, addr help2, addr help3, addr help4, addr help5
	      invoke MessageBoxA, 0, addr Text, addr Tittle, 0                        
		invoke ExitProcess, 0	

	end start
