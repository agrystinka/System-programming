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
	a dd 53, -53, -53, 53, 53
      	b dd 2, 3, 2, 10, -17
     	d dd -108, -1161, -3, 2337, 2013
      	r dd 5 dup (0)

	Tittle db "Laba_5",0

	Text db 200 dup (?)
	format db "#1: A =%d, B =%d, C = %d", 13,	
                        "Result: ", "%d",13,
                        "#2: A =%d, B =%d, D =%d", 13,	
                        "Result: ", "%d",13,
                        "#3: A =%d, B =%d, D =%d", 13,	
                        "Result: ", "%d",13,
                        "#4: A =%d, B =%d, D =%d", 13,	
                        "Result: ", "%d",13,
                        "#5: A =%d, B =%d, D =%d", 13,	
                        "Result: ", "%d",13, 0
                        
	

	
.code
      start: 

		;result = (-53 / a + d -4 * a) / (1 + a * b)
		;if result is even result = result / 2
		;if result is odd result = result * 5

		mov esi, 0		
		mov cx, 5
		   l1:  mov eax, -53
			mov edx, 0FFFFFFFFh
			idiv   a[esi]             ;eax = -53/a
			
			add eax, d[esi]           ;eax = -53/a + d             
			mov ebp,eax               ;ebp = -53/a + d			
                        mov eax, 4
			imul a[esi]               ;eax = 4*a
			
			sub ebp, eax              ;ebp = -53/a + d - 4*a
						
			mov eax, b[esi]
			imul  a[esi]              ;eax = a*b
			inc eax                   ;eax = a*b + 1
							             
			mov ebx, eax              ;ebx = a*b + 1
			mov eax,ebp               ;eax =  -53/a + d - 4*a
			mov edx, 0
			
			test eax, 80000000h
			jz l2
			mov edx, 0FFFFFFFFh
	           l2:  idiv ebx
   				
			test eax, 1 
			jz even

			mov ebp,5                 ;result = result * 5
		        imul ebp
			jmp l3
				
	         even:  mov edx, 0
			test eax, 80000000h
			jz l4
			mov edx, 0FFFFFFFFh

	           l4:  mov ebp,2
		        idiv  ebp                 ;result = result / 2
		   l3:  mov r[esi], eax
			add esi, 4
		        dec cx
                        cmp cx, 0
                        jne l1

                  
              invoke wsprintfA, addr Text, addr format, a, b, d, r, a[4], b[4], d[4], r[4], a[8], b[8], d[8], r[8], a[12], b[12], d[12], r[12], a[16], b[16], d[16], r[16]
	      invoke MessageBoxA, 0, addr Text, addr Tittle, 0  
                        
	      invoke ExitProcess, 0	

	end start
