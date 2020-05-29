.386
.model flat, stdcall
option casemap:none

 include C:\masm32\include\masm32.inc 
 include C:\masm32\include\user32.inc 
 include C:\masm32\include\kernel32.inc 
 ;include \masm32\include\windows.inc
  
 includelib C:\masm32\lib\masm32.lib 
 includelib C:\masm32\lib\user32.lib 
 includelib C:\masm32\lib\kernel32.lib

.data
    two real8 2.0
    four real8 4.0
    
.code

MyFunction PROTO :real8, :real8, :real8, :real8

    ; with entry point
    ; var 7
    ; (c * 2 - lg (d / 4))/(a * 2 - b)
    
    DllMain proc hInstDLL:DWORD, reason:DWORD, reserved1:DWORD
           mov eax, 1
           ret
    DllMain endp

    MyFunction   proc  var_a:real8, var_b:real8, var_c:real8, var_d:real8
            fld var_d         ;st0 = d
            fdiv four         ;st0 = d / 4           

            fldlg2            ;st0 = const = lg 2, st1 = d / 4
            fxch              ;st0 = d / 4, st1 = const
            fyl2x             ;st0 = lg (d / 4) = const * log2(d/4)

            fld var_c        ;st0 = c, st1 = lg (d / 4)
            fmul two          ;st0 = c * 2, st1 = lg (d / 4)
            fxch              ;st0 = lg (d / 4), st1 = c * 2
            fsub              ;st0 = c * 2 - lg (d / 4)           

            fld var_a         ;st0 = a, st1 = c * 2 - lg (d / 4)  
            fmul two          ;st0 = a * 2            
            fsub var_b        ;st0 = a * 2 - b
            
            fdiv              ;st0 = (c * 2 - lg (d / 4))/(a * 2 - b)            
            ret
    MyFunction endp
    end DllMain
