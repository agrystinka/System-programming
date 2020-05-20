.386
.model flat, stdcall
option casemap:none

 include C:\masm32\include\masm32.inc 
 include C:\masm32\include\user32.inc 
 include C:\masm32\include\kernel32.inc

  
 includelib C:\masm32\lib\masm32.lib 
 includelib C:\masm32\lib\user32.lib 
 includelib C:\masm32\lib\kernel32.lib

 extern calcDenominator@0:near
 public var_a, var_b, var_res  
   
 
.data
      vala real8 3.6, 3.9, 2.1, 12.7, 13.56 
      valb real8 0.2, -2.2, 3.6, 0.57, 17.2
      valc real8 2.5, 3.9, -1.2, 0.365, 7.5
      vald real8 50.0, 20.5, 36.0, 6.0, 3.2
      ;lg(d/4) = 1.096, 0.70, 0.954 ....
      
      valr real8 0.0, 0.0, 0.0, 0.0, 0.0  

      var_a real8 0.0
      var_b real8 0.0
      var_res real8 0.0   
      
      res1 real8 0.0
      res2 real8 0.0
          
      two real8 2.0
      four real8 4.0
        
      help1 db 15 dup ('b')
      help2 db 15 dup ('a') 
      help3 db 15 dup ('c')
      help4 db 15 dup ('a')
      help5 db 15 dup ('b') 

	Tittle db "Lab_7",0
	Text db 200 dup ('a')

      format db "#1: %s", 13,		
                "#2: %s", 13,	
                "#3: %s", 13,	                
                "#4: %s", 13,		
                "#5: %s", 13,	0               
	
.code

; var 7
; (c * 2 - lg (d / 4))/(a * 2 - b)

; c * 2 - registers
; lg (d / 4) - stack
; (a * 2 - b) - extern, public

      multiplication proc                ; c * 2 - registers ;
        fld qword ptr [eax]              ; [eax] = c_adress, st0 = c
        fld qword ptr [ebx]              ; [ebx] = two_adress, st0 = 2, st1 = c
        fmul                             ; st0 = c * 2
        ret            
      multiplication endp


      logarithm proc                     ; lg (d / 4) - stack
        push ebp                         ;stack: 0-3b ebp, 4-7b forward address, 8-11b 4_address, 12-15b d_address
        mov ebp, esp                     
        mov eax, [ebp + 12]              ;eax = d_address
        mov ebx, [ebp + 8]               ;ebx = 4_address
        fld qword ptr [eax]              ;st0 = d
        fdiv qword ptr [ebx]             ;st0 = d/4
        fldlg2                           ;st0 = const = lg 2, st1 = d/4
        fxch                             ;st0 = d / 4, st1 = const
        fyl2x                            ;st0 = lg (d / 4) = const * log2(d/4)
        pop ebp
        ret 8
      logarithm endp


      start:       
            mov ebp, 0 
                       
      leb1: lea eax, valc[ebp]
            lea ebx, two
            call multiplication          ; st0 = c * 2
            fstp res1                    ; res1 = c * 2

            lea eax, vald[ebp]
            lea ebx, four
            push eax
            push ebx
            call logarithm               ; st0 = lg (d / 4)
            fstp res2                    ; res2 = lg (d / 4)

            fld vala[ebp]
            fstp var_a
            fld valb[ebp]
            fstp var_b

            call calcDenominator@0       ; var_res = a * 2 - b
            
            fld res1                     ; st0 = c * 2
            fsub res2                    ; st0 = c * 2 - lg (d / 4)
            fld var_res
            fdiv
            ;fstp valr[ebp]
           
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