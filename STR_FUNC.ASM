.model tiny
.code
.186
org 100h


Start:
		Call Main	
		jmp Exit


Main proc
		mov bx, offset STRING_1
		mov si, offset STRING_2

		push bx
		push si
		push 3
		
		Call MyMemCmp

		ret
		endp


MyMemCmp	proc
		push bp
		mov bp, sp

		mov si, [bp + 8]
		mov di, [bp + 6]
		mov cx, [bp + 4]

		mov ax, 0

	again:
		add al, [si]
		sub al, [di]
		loop again

		pop bp
		ret 6
		endp


MyMemCpy	proc
		push bp
		mov bp, sp

		mov si, [bp + 8]
		mov di, [bp + 6]
		mov cx, [bp + 4]

		rep movsb

		mov ax, [bp + 6]

		pop bp
		ret 6
		endp


MyMemSet	proc
		push bp
		mov bp, sp

		mov di, [bp + 8]
		mov al, [bp + 6]
		mov cx, [bp + 4]

		rep stosb

		mov ax, [bp + 8]

		pop bp
		ret 6
		endp


MyMemChr	proc
		push bp
		mov bp, sp

		mov di, [bp + 8]
		mov al, [bp + 6]
		mov cx, [bp + 4]

		repne scasb

		cmp cx, 0
		je cmp_last_byte
		
		jmp ok

	cmp_last_byte:
		cmp al, es:[di - 1]
		je ok

		mov ax, 0

		jmp ret_func

	ok:
		sub di, 1
		mov ax, di

	ret_func:
		pop bp
		ret 6
		endp
		

MyStrLen	proc
		push bp
		mov bp, sp

		mov di, [bp + 4]

		cld

		mov al, '$'

		xor cx, cx	
		
		repne scasb
		not cx
		
		sub cx, 1
		mov ax, cx

		pop bp
		ret 2
		endp


Exit:
		mov ax, 4c00h
		int 21h


STRING_1 db "meow$"
STRING_2 db "meow$"


end Start