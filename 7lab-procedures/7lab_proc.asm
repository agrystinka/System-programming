.386
.model flat, stdcall
option casemap:none

     	public calcDenominator
     extern var_a:real8, var_b:real8, var_res:real8      
           
.data
     two2 real8 2.0
     
.code  
    calcDenominator proc                       ; a * 2 - b
            fld var_a                          ; st0 = a
            fmul two2                          ; st0 = a * 2
            fsub var_b                         ; st0 = a * 2 - b
            fstp var_res                       ; var_res = a * 2 - b
            ret   
    calcDenominator endp
end   

