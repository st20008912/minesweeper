GetChar macro Char
	mov ah,06h
	mov dl,0ffh
	int 21h
	mov Char,al
endm

SetMode macro mode
	mov ah,00h
	mov al,mode
	int 10h
endm

SetColor macro mode,color
	mov ah,0bh
	mov bh,mode
	mov bl,color
	int 10h
endm

WrPixel macro row,col,color
	mov ah,0ch
	mov bh,00h
	mov al,color
	mov cx,row
	mov dx,col
	int 10h
endm

SET_CUR macro Row,Col
	mov dh,Row
	mov dl,Col
	mov bx,0000h
	mov ah,02h
	int 10h
	endm
	
randDelay macro seed
	mov cx,0f00h
  R1:
	mov ax,seed
	mov bl,0030h
	div bl
	mov al,ah
	xor ah,ah
	mov bp,ax
  R2:
	dec bp
	cmp bp,0
	jnz R2
	loop R1
	endm
;.8086
;.model small
;.stack 1024
.data
mineCount db 0
bomCount db 0
soundtimes dw 0
mineNumber dw 0
firstBlock dw 0
difficulty db 0
position db 0,0,0  ;row0 row1 col
row dw 0
col dw 0
BlockWide dw 20
XLimit dw 640
YLimit dw 480
RowCounter dw 0
ColCounter dw 0
getc db 0
BlockState db 768 dup(0)
mineState db 768 dup(0)
scanCount dw 0
checkCount dw 0
timeCount dw 0
timeCount1 db 0
score db 0,0,0 
cheat db 0
WinMessage1	db "|-------------------------------------------|$"
WinMessage2	db "| __     __          __          ___        |$"       
WinMessage3	db "| \ \   / /          \ \        / (_)       |$"      
WinMessage4	db "|  \ \_/ /__  _   _   \ \  /\  / / _ _ __   |$"  
WinMessage5	db "|   \   / _ \| | | |   \ \/  \/ / | | '_ \  |$" 
WinMessage6	db "|    | | (_) | |_| |    \  /\  /  | | | | | |$"
WinMessage7	db "|    |_|\___/ \__,_|     \/  \/   |_|_| |_| |$"
WinMessage8	db "|                                           |$"
WinMessage9	db "|                Time:000000                |$";22,23,24,25,26,27
WinMessage10	db "|-------------------------------------------|$"
isStart db 0
loseMessage1 db "|-------------------------------------------|$"
loseMessage2 db "| __     __           _                     |$"                    
loseMessage3 db "| \ \   / /          | |                    |$"                   
loseMessage4 db "|  \ \_/ /__  _   _  | |     ___  ___  ___  |$" 
loseMessage5 db "|   \   / _ \| | | | | |    / _ \/ __|/ _ \ |$"
loseMessage6 db "|    | | (_) | |_| | | |___| (_) \__ \  __/ |$"
loseMessage7 db "|    |_|\___/ \__,_| |______\___/|___/\___| |$"
loseMessage8 db "|                                           |$"
loseMessage9 db "|-------------------------------------------|$"
selectedBitmap0	db 20 dup(08h)
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 20 dup(08h)
selectedBitmap1 db 20 dup(08h)
				db 08h,18 dup(07h),08h
				db 08h,7 dup(07h),3 dup(09h),8 dup(07h),08h
				db 08h,6 dup(07h),4 dup(09h),8 dup(07h),08h
				db 08h,5 dup(07h),5 dup(09h),8 dup(07h),08h
				db 08h,5 dup(07h),2 dup(09h),07h,2 dup(09h),8 dup(07h),08h
				db 08h,8 dup(07h),2 dup(09h),8 dup(07h),08h
				db 08h,8 dup(07h),2 dup(09h),8 dup(07h),08h
				db 08h,8 dup(07h),2 dup(09h),8 dup(07h),08h
				db 08h,8 dup(07h),2 dup(09h),8 dup(07h),08h
				db 08h,8 dup(07h),2 dup(09h),8 dup(07h),08h
				db 08h,8 dup(07h),2 dup(09h),8 dup(07h),08h
				db 08h,8 dup(07h),2 dup(09h),8 dup(07h),08h
				db 08h,8 dup(07h),2 dup(09h),8 dup(07h),08h
				db 08h,8 dup(07h),2 dup(09h),8 dup(07h),08h
				db 08h,8 dup(07h),2 dup(09h),8 dup(07h),08h
				db 08h,4 dup(07h),10 dup(09h),4 dup(07h),08h
				db 08h,4 dup(07h),10 dup(09h),4 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 20 dup(08h)
selectedBitmap2 db 20 dup(08h)	
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,6 dup(07h),6 dup(0ah),6 dup(07h),08h
				db 08h,5 dup(07h),8 dup(0ah),5 dup(07h),08h
				db 08h,4 dup(07h),2 dup(0ah),5 dup(07h),3 dup(0ah),4 dup(07h),08h
				db 08h,4 dup(07h),1 dup(0ah),7 dup(07h),2 dup(0ah),4 dup(07h),08h
				db 08h,12 dup(07h),2 dup(0ah),4 dup(07h),08h
				db 08h,12 dup(07h),2 dup(0ah),4 dup(07h),08h
				db 08h,11 dup(07h),3 dup(0ah),4 dup(07h),08h
				db 08h,9 dup(07h),4 dup(0ah),5 dup(07h),08h
				db 08h,7 dup(07h),4 dup(0ah),7 dup(07h),08h
				db 08h,6 dup(07h),3 dup(0ah),9 dup(07h),08h
				db 08h,5 dup(07h),3 dup(0ah),10 dup(07h),08h
				db 08h,4 dup(07h),2 dup(0ah),12 dup(07h),08h
				db 08h,4 dup(07h),10 dup(0ah),4 dup(07h),08h
				db 08h,5 dup(07h),9 dup(0ah),4 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 20 dup(08h)
selectedBitmap3 db 20 dup(08h)	
				db 08h,18 dup(07h),08h
				db 08h,6 dup(07h),6 dup(0ch),6 dup(07h),08h
				db 08h,5 dup(07h),8 dup(0ch),5 dup(07h),08h
				db 08h,4 dup(07h),2 dup(0ch),5 dup(07h),3 dup(0ch),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(0ch),6 dup(07h),2 dup(0ch),4 dup(07h),08h
				db 08h,12 dup(07h),2 dup(0ch),4 dup(07h),08h
				db 08h,12 dup(07h),2 dup(0ch),4 dup(07h),08h
				db 08h,7 dup(07h),7 dup(0ch),4 dup(07h),08h
				db 08h,7 dup(07h),6 dup(0ch),5 dup(07h),08h
				db 08h,11 dup(07h),2 dup(0ch),5 dup(07h),08h
				db 08h,12 dup(07h),2 dup(0ch),4 dup(07h),08h
				db 08h,12 dup(07h),2 dup(0ch),4 dup(07h),08h
				db 08h,12 dup(07h),2 dup(0ch),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(0ch),6 dup(07h),2 dup(0ch),4 dup(07h),08h
				db 08h,4 dup(07h),9 dup(0ch),5 dup(07h),08h
				db 08h,5 dup(07h),7 dup(0ch),6 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 20 dup(08h)
selectedBitmap4 db 20 dup(08h)	
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,9 dup(07h),2 dup(01h),7 dup(07h),08h
				db 08h,8 dup(07h),3 dup(01h),7 dup(07h),08h
				db 08h,7 dup(07h),4 dup(01h),7 dup(07h),08h
				db 08h,6 dup(07h),2 dup(01h),1 dup(07h),2 dup(01h),7 dup(07h),08h
				db 08h,5 dup(07h),2 dup(01h),2 dup(07h),2 dup(01h),7 dup(07h),08h
				db 08h,4 dup(07h),2 dup(01h),3 dup(07h),2 dup(01h),7 dup(07h),08h
				db 08h,3 dup(07h),2 dup(01h),4 dup(07h),2 dup(01h),7 dup(07h),08h
				db 08h,3 dup(07h),11 dup(01h),4 dup(07h),08h
				db 08h,3 dup(07h),11 dup(01h),4 dup(07h),08h
				db 08h,9 dup(07h),2 dup(01h),7 dup(07h),08h
				db 08h,9 dup(07h),2 dup(01h),7 dup(07h),08h
				db 08h,9 dup(07h),2 dup(01h),7 dup(07h),08h
				db 08h,9 dup(07h),2 dup(01h),7 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 20 dup(08h)
selectedBitmap5 db 20 dup(08h)	
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h
				db 08h,5 dup(07h),9 dup(04h),4 dup(07h),08h
				db 08h,4 dup(07h),9 dup(04h),5 dup(07h),08h
				db 08h,4 dup(07h),2 dup(04h),12 dup(07h),08h
				db 08h,4 dup(07h),2 dup(04h),12 dup(07h),08h
				db 08h,4 dup(07h),2 dup(04h),12 dup(07h),08h
				db 08h,4 dup(07h),8 dup(04h),6 dup(07h),08h
				db 08h,5 dup(07h),8 dup(04h),5 dup(07h),08h
				db 08h,11 dup(07h),3 dup(04h),4 dup(07h),08h
				db 08h,12 dup(07h),2 dup(04h),4 dup(07h),08h
				db 08h,12 dup(07h),2 dup(04h),4 dup(07h),08h
				db 08h,12 dup(07h),2 dup(04h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(04h),5 dup(07h),3 dup(04h),4 dup(07h),08h
				db 08h,4 dup(07h),9 dup(04h),5 dup(07h),08h
				db 08h,5 dup(07h),7 dup(04h),6 dup(07h),08h
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h
				db 20 dup(08h)
selectedBitmap6 db 20 dup(08h)	
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h
				db 08h,5 dup(07h),9 dup(01h),4 dup(07h),08h
				db 08h,4 dup(07h),9 dup(01h),5 dup(07h),08h
				db 08h,4 dup(07h),2 dup(01h),12 dup(07h),08h
				db 08h,4 dup(07h),2 dup(01h),12 dup(07h),08h
				db 08h,4 dup(07h),2 dup(01h),12 dup(07h),08h
				db 08h,4 dup(07h),8 dup(01h),6 dup(07h),08h
				db 08h,4 dup(07h),9 dup(01h),5 dup(07h),08h
				db 08h,4 dup(07h),2 dup(01h),5 dup(07h),3 dup(01h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(01h),6 dup(07h),2 dup(01h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(01h),6 dup(07h),2 dup(01h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(01h),6 dup(07h),2 dup(01h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(01h),5 dup(07h),3 dup(01h),4 dup(07h),08h
				db 08h,4 dup(07h),9 dup(01h),5 dup(07h),08h
				db 08h,5 dup(07h),7 dup(01h),6 dup(07h),08h
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h
				db 20 dup(08h)
selectedBitmap7 db 20 dup(08h)
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h				
				db 08h,5 dup(07h),9 dup(00h),4 dup(07h),08h
				db 08h,6 dup(07h),9 dup(00h),3 dup(07h),08h
				db 08h,13 dup(07h),2 dup(00h),3 dup(07h),08h
				db 08h,13 dup(07h),2 dup(00h),3 dup(07h),08h
				db 08h,13 dup(07h),2 dup(00h),3 dup(07h),08h
				db 08h,13 dup(07h),2 dup(00h),3 dup(07h),08h
				db 08h,12 dup(07h),2 dup(00h),4 dup(07h),08h
				db 08h,12 dup(07h),2 dup(00h),4 dup(07h),08h
				db 08h,11 dup(07h),2 dup(00h),5 dup(07h),08h
				db 08h,11 dup(07h),2 dup(00h),5 dup(07h),08h
				db 08h,11 dup(07h),2 dup(00h),5 dup(07h),08h
				db 08h,11 dup(07h),2 dup(00h),5 dup(07h),08h
				db 08h,10 dup(07h),2 dup(00h),6 dup(07h),08h
				db 08h,10 dup(07h),2 dup(00h),6 dup(07h),08h
				db 08h,10 dup(07h),2 dup(00h),6 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 20 dup(08h)
selectedBitmap8 db 20 dup(08h)	
				db 08h,18 dup(07h),08h	
				db 08h,6 dup(07h),6 dup(08h),6 dup(07h),08h
				db 08h,5 dup(07h),8 dup(08h),5 dup(07h),08h
				db 08h,4 dup(07h),3 dup(08h),4 dup(07h),3 dup(08h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(08h),6 dup(07h),2 dup(08h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(08h),6 dup(07h),2 dup(08h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(08h),6 dup(07h),2 dup(08h),4 dup(07h),08h
				db 08h,5 dup(07h),2 dup(08h),4 dup(07h),2 dup(08h),5 dup(07h),08h
				db 08h,6 dup(07h),6 dup(08h),6 dup(07h),08h
				db 08h,5 dup(07h),8 dup(08h),5 dup(07h),08h
				db 08h,4 dup(07h),3 dup(08h),4 dup(07h),3 dup(08h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(08h),6 dup(07h),2 dup(08h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(08h),6 dup(07h),2 dup(08h),4 dup(07h),08h
				db 08h,4 dup(07h),2 dup(08h),6 dup(07h),2 dup(08h),4 dup(07h),08h
				db 08h,4 dup(07h),3 dup(08h),4 dup(07h),3 dup(08h),4 dup(07h),08h
				db 08h,5 dup(07h),8 dup(08h),5 dup(07h),08h
				db 08h,6 dup(07h),6 dup(08h),6 dup(07h),08h
				db 08h,18 dup(07h),08h
				db 20 dup(08h)
selectedBitmap9 db 20 dup(08h)	
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h	
				db 08h,3 dup(07h),1 dup(00h),4 dup(07h),2 dup(00h),4 dup(07h),1 dup(00h),3 dup(07h),08h
				db 08h,4 dup(07h),1 dup(00h),2 dup(07h),4 dup(00h),2 dup(07h),1 dup(00h),4 dup(07h),08h
				db 08h,5 dup(07h),8 dup(00h),5 dup(07h),08h
				db 08h,5 dup(07h),1 dup(00h),3 dup(0fh),4 dup(00h),5 dup(07h),08h
				db 08h,4 dup(07h),2 dup(00h),3 dup(0fh),5 dup(00h),4 dup(07h),08h
				db 08h,3 dup(07h),3 dup(00h),3 dup(0fh),6 dup(00h),3 dup(07h),08h
				db 08h,3 dup(07h),12 dup(00h),3 dup(07h),08h
				db 08h,4 dup(07h),10 dup(00h),4 dup(07h),08h
				db 08h,5 dup(07h),8 dup(00h),5 dup(07h),08h
				db 08h,5 dup(07h),8 dup(00h),5 dup(07h),08h
				db 08h,4 dup(07h),1 dup(00h),2 dup(07h),4 dup(00h),2 dup(07h),1 dup(00h),4 dup(07h),08h
				db 08h,3 dup(07h),1 dup(00h),4 dup(07h),2 dup(00h),4 dup(07h),1 dup(00h),3 dup(07h),08h
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h	
				db 20 dup(08h)
edgeBitmap	db 20 dup(08h)
				db 08h,08h,16 dup(07h),08h,08h
				db 08h,07h,08h,14 dup(07h),08h,07h,08h
				db 08h,7,7,8,12 dup(07h),8,7,7,08h
				db 08h,7,7,7,8,10 dup(07h),8,7,7,7,08h
				db 08h,7,7,7,7,8,8 dup(07h),8,7,7,7,7,08h
				db 08h,7,7,7,7,7,8,6 dup(07h),8,7,7,7,7,7,08h
				db 08h,7,7,7,7,7,7,8,4 dup(07h),8,7,7,7,7,7,7,08h
				db 08h,7,7,7,7,7,7,7,8,2 dup(07h),8,7,7,7,7,7,7,7,08h
				db 08h,8 dup(7),8,8,8 dup(7),08h
				db 08h,8 dup(7),8,8,8 dup(7),08h
				db 08h,7,7,7,7,7,7,7,8,2 dup(07h),8,7,7,7,7,7,7,7,08h
				db 08h,7,7,7,7,7,7,8,4 dup(07h),8,7,7,7,7,7,7,08h
				db 8h,7,7,7,7,7,8,6 dup(07h),8,7,7,7,7,7,08h
				db 08h,7,7,7,7,8,8 dup(07h),8,7,7,7,7,08h
				db 08h,7,7,7,8,10 dup(07h),8,7,7,7,08h
				db 08h,7,7,8,12 dup(07h),8,7,7,08h
				db 08h,07h,08h,14 dup(07h),08h,07h,08h
				db 08h,08h,16 dup(07h),08h,08h
				db 20 dup(08h)
BlockBitmap db 39 dup(0fh),08h
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 2 dup(0fh),16 dup(07h),2 dup(08h)
			db 0fh,39 dup(08h)
flagBitmap	db 39 dup(0fh),08h
			db 2 dup(0fh),7 dup(07h),2 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),6 dup(07h),3 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),5 dup(07h),4 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),4 dup(07h),5 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),3 dup(07h),6 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),2 dup(07h),7 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),3 dup(07h),6 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),4 dup(07h),5 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),5 dup(07h),4 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),6 dup(07h),3 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),7 dup(07h),2 dup(0ch),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),8 dup(07h),1 dup(00h),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),8 dup(07h),1 dup(00h),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),8 dup(07h),1 dup(00h),7 dup(07h),2 dup(08h)
			db 2 dup(0fh),3 dup(07h),10 dup(00h),3 dup(07h),2 dup(08h)
			db 2 dup(0fh),2 dup(07h),12 dup(00h),2 dup(07h),2 dup(08h)
			db 0fh,39 dup(08h)
mineSweeper db "            __  __ _             _____ ",10,13                                 
		    db "           |  \/  (_)           / ____|",10,13                                 
		    db "           | \  / |_ _ __   ___| (_____      _____  ___ _ __   ___ _ __ ",10,13
            db "           | |\/| | | '_ \ / _ \\___ \ \ /\ / / _ \/ _ \ '_ \ / _ \ '__|",10,13
            db "           | |  | | | | | |  __/____) \ V  V /  __/  __/ |_) |  __/ |",10,13   
            db "           |_|  |_|_|_| |_|\___|_____/ \_/\_/ \___|\___| .__/ \___|_|",10,13   
            db "                                                       | | ",10,13             
            db "                                                       |_|  ",10,13
			db 10,13
			db 10,13
			db "                                   How to play ",10,13
			db "                      <w>:up  <s>:down  <a>:left  <d>:right ",10,13
			db "                        <j>:open block  <k>:set/reset flag   ",10,13
			db 10,13
			db 10,13
			db "                                 <c>Change mine",10,13
			db 10,13
			db "                            Choose difficulty and start",10,13
			db "    <1>Easy(8x8,10 mines) <2>Normal(16x16,40 mines)  <3>Hard(32x24,120 mines)",10,13
			db "                                    <e>:exit game$"
fireworkRow dw 56,60,96,100
			dw 52,56,92,96
			dw 52,84,88
			dw 8,12,48,52,76,80;3
			dw 12,16,48,72
			dw 16,20,24,28,48,68,72
			dw 0,4,8,12,28,32,48,68,100,104
			dw 12,16,32,48,64,92,96,100;7
			dw 16,20,36,48,60,84,88,92
			dw 24,36,84
			dw 28,32,40,80,84
			dw 12,16,40,76,80;11
			dw 4,8,20,24,72,76
			dw 28,32,84,88,92,96,100
			dw 44,48,100,104
			dw 28,40,72,76,108;15
			dw 24,36,40,52,56,80,84,108,112
			dw 20,32,48,88,112;17
			dw 16,28,32,44,56,72,92,96
			dw 12,28,40,56,72,84,96
			dw 8,24,36,40,56,72,84,100
			dw 8,20,24,36,56,72,88,104
			dw 4,20,36,56,72,92,104
			dw 4,20,32,56,76,92,108;23
			dw 0,20,32,60,76,96,108
			dw 0,20,32,60,76,96,108
			dw 0,20,32,60,80,96;26
			dw 36,60,64,84,96
			dw 36,96
			dw 96
fireworkCol dw 4 dup(0),4 dup(4),3 dup(8)
			dw 6 dup(12),4 dup(16),7 dup(20),10 dup(24),8 dup(28),8 dup(32)
			dw 3 dup(36),5 dup(40),5 dup(44),6 dup(48),7 dup(52),4 dup(56)
			dw 5 dup(60),9 dup(64),5 dup(68),8 dup(72),7 dup(76),8 dup(80)
			dw 8 dup(84),7 dup(88),7 dup(92),7 dup(96),7 dup(100),6 dup(104)
			dw 5 dup(108),2 dup(112),116
fireworkBitmap 	db 4,4,14,14
				db 4,4,14,14
				db 4,14,14
				db 14,14,4,4,14,14
				db 14,14,4,14;4
				db 14,14,14,14,4,14,14
				db 4,4,4,4,14,14,4,14,14,14
				db 4,4,14,4,14,14,14,14
				db 4,4,14,4,14,14,14,14
				db 4,14,14;9
				db 4,4,14,14,14
				db 14,14,14,14,14
				db 14,14,14,14,14,14
				db 14,14,4,4,4,4,4
				db 14,14,4,4;14
				db 4,14,14,14,4
				db 4,14,14,4,4,14,14,4,4
				db 4,14,4,14,4
				db 4,14,14,4,14,4,14,14;18
				db 4,14,4,14,4,4,14
				db 4,14,4,4,14,4,4,14
				db 4,14,14,4,14,4,4,14
				db 4,14,4,14,4,4,14;22
				db 4,14,4,14,4,4,14
				db 4,14,4,14,4,4,14
				db 4,14,4,14,4,4,14
				db 4,14,4,14,4,4;26
				db 4,14,14,4,4
				db 4,4
				db 4,100
				
bombBitmap	    db 20 dup(08h)	
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h	
				db 08h,3 dup(07h),1 dup(00h),4 dup(07h),2 dup(00h),4 dup(07h),1 dup(00h),3 dup(07h),08h
				db 08h,4 dup(07h),1 dup(00h),2 dup(07h),4 dup(00h),2 dup(07h),1 dup(00h),4 dup(07h),08h
				db 08h,5 dup(07h),8 dup(00h),5 dup(07h),08h
				db 08h,5 dup(07h),1 dup(00h),3 dup(0fh),4 dup(00h),5 dup(07h),08h
				db 08h,4 dup(07h),2 dup(00h),3 dup(0fh),5 dup(00h),4 dup(07h),08h
				db 08h,3 dup(07h),3 dup(00h),3 dup(0fh),6 dup(00h),3 dup(07h),08h
				db 08h,3 dup(07h),12 dup(00h),3 dup(07h),08h
				db 08h,4 dup(07h),10 dup(00h),4 dup(07h),08h
				db 08h,5 dup(07h),8 dup(00h),5 dup(07h),08h
				db 08h,5 dup(07h),8 dup(00h),5 dup(07h),08h
				db 08h,4 dup(07h),1 dup(00h),2 dup(07h),4 dup(00h),2 dup(07h),1 dup(00h),4 dup(07h),08h
				db 08h,3 dup(07h),1 dup(00h),4 dup(07h),2 dup(00h),4 dup(07h),1 dup(00h),3 dup(07h),08h
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h	
				db 08h,18 dup(07h),08h	
				db 20 dup(08h)
				;1,4,15
dihongBitmap	db 10 dup(9),10 dup(12)
				db 9,9,15,9,15,9,15,9,9,9,10 dup(12)
				db 8 dup(9),15,9,10 dup(12)
				db 9,15,9,9,2 dup(15),4 dup(9),10 dup(12)
				db 3 dup(9),4 dup(15),9,15,9,10 dup(12)
				db 9,15,9,4 dup(15),3 dup(9),10 dup(12)
				db 4 dup(9),2 dup(15),9,9,15,9,10 dup(12)
				db 9,15,8 dup(9),10 dup(12)
				db 9,9,9,15,9,15,9,15,9,9,10 dup(12)
				db 10 dup(9),10 dup(12)
				db 200 dup(12)
flowerBitmap	db 40 dup(7);7 14 15
				db 9 dup(7),15,15,9 dup(7)
				db 3 dup(7),3 dup(15),2 dup(7),4 dup(15),2 dup(7),3 dup(15),3 dup(7)
				db 3 dup(7),4 dup(15),1 dup(7),4 dup(15),1 dup(7),4 dup(15),3 dup(7)
				db 3 dup(7),14 dup(15),3 dup(7)
				db 4 dup(7),12 dup(15),4 dup(7)
				db 5 dup(7),3 dup(15),1 dup(7),2 dup(15),1 dup(7),3 dup(15),5 dup(7)
				db 3 dup(7),4 dup(15),1 dup(7),4 dup(14),1 dup(7),4 dup(15),3 dup(7)
				db 2 dup(7),6 dup(15),4 dup(14),6 dup (15),2 dup(7)
				db 2 dup(7),6 dup(15),4 dup(14),6 dup (15),2 dup(7)
				db 3 dup(7),4 dup(15),1 dup(7),4 dup(14),1 dup(7),4 dup(15),3 dup(7)
				db 5 dup(7),3 dup(15),1 dup(7),2 dup(15),1 dup(7),3 dup(15),5 dup(7)
				db 4 dup(7),12 dup(15),4 dup(7)
				db 3 dup(7),14 dup(15),3 dup(7)
				db 3 dup(7),4 dup(15),1 dup(7),4 dup(15),1 dup(7),4 dup(15),3 dup(7)
				db 3 dup(7),3 dup(15),2 dup(7),4 dup(15),2 dup(7),3 dup(15),3 dup(7)
				db 9 dup(7),15,15,9 dup(7)
				db 40 dup(7)
.code			
;.startup
main proc
startup:
	Setmode 12h
	SetColor 00h,00h
	SET_CUR 3,0
	mov ah,09h
	lea dx,mineSweeper
	int 21h
	call showChange
  readStart:
	mov ah,07h
	int 21h
	cmp al,'e'
	je ex
	cmp al,'1'
	je easy
	cmp al,'2'
	je normal
	cmp al,'3'
	je hard
	cmp al,'c'
	je changeMine
	jmp readStart
easy:
	mov mineNumber,10
	mov di,0
  Le1:
	mov ax,di
	mov bl,32
	div bl
	cmp ah,8
	jae Le2
	cmp al,8
	jae Le2
	inc di
	cmp di,768
	je Le3
	jmp Le1
  Le2:
	mov BlockState[di],1
	mov mineState[di],10
	inc di
	cmp di,768
	je Le3
	jmp Le1
  Le3:
	mov di,0
	mov difficulty,1
	jmp afterSelect
normal:
	mov mineNumber,40
	mov di,0
  Ln1:
	mov ax,di
	mov bl,32
	div bl
	cmp ah,16
	jae Ln2
	cmp al,16
	jae Ln2
	inc di
	cmp di,768
	je Ln3
	jmp Ln1
  Ln2:
	mov BlockState[di],1
	mov mineState[di],10
	inc di
	cmp di,768
	je Ln3
	jmp Ln1
  Ln3:
	mov di,0
	mov difficulty,2
	jmp afterSelect
hard:
	mov mineNumber,120
	jmp afterSelect
changeMine:
	inc mineCount
	cmp mineCount,0
	je setBombBitmap
	cmp mineCount,1
	je setFlowerBitmap
	cmp mineCount,2
	je setDiHongBitmap
	mov mineCount,0
	jmp setBombBitmap
  setDiHongBitmap:
	mov ax,ds
	mov es,ax
	mov si,offset dihongBitmap
	mov di,offset selectedBitmap9
	mov cx,400
	rep movsb
	call showChange
	jmp readStart
  setBombBitmap:
	mov ax,ds
	mov es,ax
	mov si,offset bombBitmap
	mov di,offset selectedBitmap9
	mov cx,400
	rep movsb
	call showChange
	jmp readStart
  setFlowerBitmap:
	mov ax,ds
	mov es,ax
	mov si,offset flowerBitmap
	mov di,offset selectedBitmap9
	mov cx,400
	rep movsb
	call showChange
	jmp readStart
afterSelect:
	mov bp,0
	call scanMap
	
	
	
Flash:
	call printChoose
	call checkWin
readin:
	GetChar getc
	inc timeCount
	cmp timeCount,0ffffh
	jne notCarry
	mov timeCount,0
	inc timeCount1
	cmp timeCount1,00fh
	jne notCarry
	inc score[2]
	mov timeCount1,0
	cmp score[2],100
	jne notCarry
	mov score[2],0
	inc score[1]
	cmp score[1],100
	jne notCarry
	mov score[1],0
	inc score[0]
  notCarry:
	cmp getc,'w';72
	je up
	cmp getc,'d';77
	je right
	cmp getc,'a';75
	je left
	cmp getc,'s';80
	je down
	cmp getc,'j'  
	je select
	cmp getc,'k'
	je setFlag
	cmp getc,72
	je cheatUp
	cmp getc,77
	je cheatRight
	cmp getc,75
	je cheatLeft
	cmp getc,80
	je cheatDown
	cmp getc,'b'
	je cheatB
	jmp readin
up:
	mov cheat,0
	call reChoose
	cmp position[2],0
	je top
	dec position[2]
	jmp chooseUp
  top:
	mov position[2],23
  chooseUp:
	xor ax,ax
	mov al,20
	mul position[2]
	mov col,ax
	jmp Flash
down:
	mov cheat,0
	call reChoose
	cmp position[2],23
	je bottom
	inc position[2]
	jmp chooseDown
  bottom:
	mov position[2],0
  chooseDown:
	xor ax,ax
	mov al,20
	mul position[2]
	mov col,ax
	jmp Flash
right:
	mov cheat,0
	call reChoose
	cmp position[0],31
	je RLimit
	inc position[0]
	jmp chooseRight
  RLimit:
	mov position[0],0
  chooseRight:
	xor ax,ax
	mov al,20
	mul position[0]
	mov row,ax
	jmp Flash
left:
	cmp cheat,9
	je setCheat
	mov cheat,0
	call reChoose
	cmp position[0],0
	je LLimit
	dec position[0]
	jmp chooseLeft
  LLimit:
	mov position[0],31
  chooseLeft:
	xor ax,ax
	mov al,20
	mul position[0]
	mov row,ax
	jmp Flash
select:
	mov cheat,0
	cmp isStart,0
	jne started
	mov isStart,1
	mov timeCount,0
	mov timeCount1,0
	mov score[0],0
	mov score[1],0
	mov score[2],0
	xor ax,ax
	mov al,32
	mul position[2]
	add ax,word ptr position[0]
	mov di,ax
	mov mineState[di],99
	mov firstBlock,di
	call setmine
	call calculate
started:
	xor ax,ax
	mov al,32
	mul position[2]
	add ax,word ptr position[0]
	mov di,ax
	cmp BlockState[di],0
	jne Flash
	mov BlockState[di],1
	push di
	call reChoose
	pop di
	cmp mineState[di],9
	je lose
	push di
	call selectSound
	pop di
	cmp mineState[di],0
	jne Flash
	call check
	push col
	push row
	mov row,0
	mov col,0
	call scanMap
	pop row
	pop col
	jmp Flash
lose:
	call bombSound
	call runLose
	SET_CUR 11,17
	lea dx,loseMessage1
	mov ah,09h
	int 21h
	SET_CUR 12,17
	lea dx,loseMessage2
	mov ah,09h
	int 21h
	SET_CUR 13,17
	lea dx,loseMessage3
	mov ah,09h
	int 21h
	SET_CUR 14,17
	lea dx,loseMessage4
	mov ah,09h
	int 21h
	SET_CUR 15,17
	lea dx,loseMessage5
	mov ah,09h
	int 21h
	SET_CUR 16,17
	lea dx,loseMessage6
	mov ah,09h
	int 21h
	SET_CUR 17,17
	lea dx,loseMessage7
	mov ah,09h
	int 21h
	SET_CUR 18,17
	lea dx,loseMessage8
	mov ah,09h
	int 21h
	SET_CUR 19,17
	lea dx,loseMessage9
	mov ah,09h
	int 21h
	call loseSound
	mov ah,07h
	int 21h
	call reset
	jmp startup
setFlag:
	mov cheat,0
	xor ax,ax
	mov al,32
	mul position[2]
	add ax,word ptr position[0]
	mov di,ax
	cmp BlockState[di],0
	jne notSet
	mov BlockState[di],2
	call reChoose
	call setFlagSound
	jmp Flash
  notSet:
	cmp BlockState[di],2
	jne Flash
	mov BlockState[di],0
	call reChoose
	call resetFlagSound
	jmp Flash
cheatUp:
	cmp cheat,2
	jae resetCheat
	inc cheat
	jmp readin
cheatDown:
	cmp cheat,2
	jb resetCheat
	cmp cheat,4
	jae resetCheat
	inc cheat
	jmp readin
cheatLeft:
	cmp cheat,4
	jne cheatL2
	inc cheat
	jmp readin
  cheatL2:
	cmp cheat,6
	jne resetCheat
	inc cheat
	jmp readin
cheatRight:
	cmp cheat,5
	jne cheatR2
	inc cheat
	jmp readin
  cheatR2:
	cmp cheat,7
	jne resetCheat
	inc cheat
	jmp readin
cheatB:
	cmp cheat,8
	jne resetCheat
	inc cheat
	jmp readin
resetCheat:
	mov cheat,0
	jmp readin
setCheat:
	mov di,0
openCheat:
	cmp mineState[di],9
	je cheatNext
	mov BlockState[di],1
  cheatNext:
	inc di
	cmp di,768
	jne openCheat
	mov row,0
	mov col,0
	call scanMap
	call checkWin
ex:
	SetMode 03h
;.exit
main endp
printblock proc near
	cmp BlockState[di],2
	jne notFlag
	mov bp,400
notFlag:
	mov di,0
	add di,bp
	mov cx,row		
	mov dx,col	
	mov RowCounter,0
	mov ColCounter,0
PRow:
	WrPixel cx,dx,BlockBitmap[di]
	inc cx
	inc di
	inc RowCounter
	mov si,RowCounter
	cmp si,20
	je over
	jmp PRow
over:
	mov cx,row
	inc dx
	inc ColCounter
	mov si,ColCounter
	mov RowCounter,0
	cmp si,20
	je done
	jmp PRow
done:
	mov bp,0
	ret
printblock endp


scanMap proc near
	mov di,0
	mov scanCount,0
initial:
	mov di,scanCount
	cmp BlockState[di],1
    je Show
	call printblock
	jmp change
show:
	call printSelect
change:
	inc scanCount
	add row,20
	mov ax,XLimit
	cmp row,ax
	je NextCol
	jmp initial
NextCol:
	mov row,0
	add col,20
	mov ax,YLimit
	add ax,20
	cmp col,ax
	je initialDone
	jmp initial
initialDone:
	mov row,0
	mov col,0
	mov di,0
	ret
scanMap endp

printChoose proc near
	mov cx,row		
	mov dx,col	
	mov RowCounter,0
	mov ColCounter,0
PRowCUp:
	WrPixel cx,dx,04h
	inc cx
	inc RowCounter
	mov si,RowCounter
	cmp si,20
	je overCUp
	jmp PRowCUp
overCup:
	mov cx,row
	inc dx
	inc ColCounter
	mov si,ColCounter
	mov RowCounter,0
	cmp si,2
	je doneCUp
	jmp PRowCUp
doneCUp:
	mov cx,row			
	mov RowCounter,0
	mov ColCounter,0
PRowCMid1:
	WrPixel cx,dx,04h
	inc cx
	inc RowCounter
	mov si,RowCounter
	cmp si,2
	je overCMid1
	jmp PRowCMid1
overCMid1:
	add cx,15
	WrPixel cx,dx,04h
	inc cx
	inc RowCounter
	mov si,RowCounter
	cmp si,4
	je overCMid2
	sub cx,15
	jmp overCMid1
overCMid2:
	mov cx,row
	inc dx
	mov RowCounter,0
	inc ColCounter
	mov si,ColCounter
	cmp si,16
	je doneCMid
	jmp PRowCMid1
doneCMid:
	mov cx,row			
	mov RowCounter,0
	mov ColCounter,0
PRowCBot: ;bottom
	WrPixel cx,dx,04h
	inc cx
	inc RowCounter
	mov si,RowCounter
	cmp si,20
	je overCBot
	jmp PRowCBot
overCBot:
	mov cx,row
	inc dx
	inc ColCounter
	mov si,ColCounter
	mov RowCounter,0
	cmp si,2
	je doneC
	jmp PRowCBot
doneC:
	ret
printChoose endp

reChoose proc near
	xor ax,ax
	mov al,32
	mul position[2]
	add ax,word ptr position[0]
	mov di,ax
	cmp BlockState[di],0
	je unSelected
	cmp BlockState[di],2
	je flag
	call printSelect
	ret
unSelected:
	call printblock
	ret
flag:
	mov bp,400
	call printblock
	ret
reChoose endp

printSelect proc near
	xor ax,ax
	mov al,mineState[di]
	mov bx,400
	mul bx
	mov di,ax
	mov cx,row		
	mov dx,col	
	mov RowCounter,0
	mov ColCounter,0
PRowS:
	WrPixel cx,dx,selectedBitmap0[di]
	inc cx
	inc di
	inc RowCounter
	mov si,RowCounter
	cmp si,20
	je overS
	jmp PRowS
overS:
	mov cx,row
	inc dx
	inc ColCounter
	mov si,ColCounter
	mov RowCounter,0
	cmp si,20
	je doneS
	jmp PRowS
doneS:
	ret
printSelect endp

calculate proc 
	mov di,0
start0:
	cmp mineState[di],9
	jae n3
	cmp mineState[di+1],9
	jne n1
	inc mineState[di]
  n1:
	cmp mineState[di+32],9
	jne n2
	inc mineState[di]
  n2:
	cmp mineState[di+33],9
	jne n3
	inc mineState[di]
  n3:
	inc di
start1to30:
	cmp mineState[di],9
	jae n8
	cmp mineState[di-1],9
	jne n4
	inc mineState[di]
  n4:
	cmp mineState[di+1],9
	jne n5
	inc mineState[di]
  n5:
	cmp mineState[di+31],9
	jne n6
	inc mineState[di]
  n6:
	cmp mineState[di+32],9
	jne n7
	inc mineState[di]
  n7:
	cmp mineState[di+33],9
	jne n8
	inc mineState[di]
  n8:
	inc di
	cmp di,30
	jbe start1to30
start31:
	cmp mineState[di],9
	jae n11
	cmp mineState[di-1],9
	jne n9
	inc mineState[di]
  n9:
	cmp mineState[di+31],9
	jne n10
	inc mineState[di]
  n10:
	cmp mineState[di+32],9
	jne n11
	inc mineState[di]
  n11:
	inc di
startC32to704: 
	cmp mineState[di],9
	jae n16
	cmp mineState[di-32],9
	jne n12
	inc mineState[di]
  n12:
	cmp mineState[di-31],9
	jne n13
	inc mineState[di]
  n13:
	cmp mineState[di+1],9
	jne n14
	inc mineState[di]
  n14:
	cmp mineState[di+32],9
	jne n15
	inc mineState[di]
  n15:
	cmp mineState[di+33],9
	jne n16
	inc mineState[di]
  n16:
	add di,32
	cmp di,704
	jbe startC32to704
	mov di,63
startC63to735:
	cmp mineState[di],9
	jae n21
	cmp mineState[di-33],9
	jne n17
	inc mineState[di]
  n17:
	cmp mineState[di-32],9
	jne n18
	inc mineState[di]
  n18:
	cmp mineState[di-1],9
	jne n19
	inc mineState[di]
  n19:
	cmp mineState[di+31],9
	jne n20
	inc mineState[di]
  n20:
	cmp mineState[di+32],9
	jne n21
	inc mineState[di]
  n21:
	add di,32
	cmp di,735
	jbe startC63to735
	mov di,33
startM33to734:
	cmp mineState[di],9
	jae n29
	cmp mineState[di-33],9
	jne n22
	inc mineState[di]
  n22:
	cmp mineState[di-32],9
	jne n23
	inc mineState[di]
  n23:
	cmp mineState[di-31],9
	jne n24
	inc mineState[di]
  n24:
	cmp mineState[di-1],9
	jne n25
	inc mineState[di]
  n25:
	cmp mineState[di+1],9
	jne n26
	inc mineState[di]
  n26:
	cmp mineState[di+31],9
	jne n27
	inc mineState[di]
  n27:
	cmp mineState[di+32],9
	jne n28
	inc mineState[di]
  n28:
	cmp mineState[di+33],9
	jne n29
	inc mineState[di]
  n29:
	inc di
	cmp di,735
	je n30
	mov ax,di
	mov bl,32
	div bl
	cmp ah,31
	je nextL
	jmp startM33to734
  nextL:
	add di,2
	jmp startM33to734
  n30:
	mov di,736
start736:
	cmp mineState[di],9
	jae n33
	cmp mineState[di-32],9
	jne n31
	inc mineState[di]
  n31:
	cmp mineState[di-31],9
	jne n32
	inc mineState[di]
  n32:
	cmp mineState[di+1],9
	jne n33
	inc mineState[di]
  n33:
	inc di
start737to766:
	cmp mineState[di],9
	jae n38
	cmp mineState[di-33],9
	jne n34
	inc mineState[di]
  n34:
	cmp mineState[di-32],9
	jne n35
	inc mineState[di]
  n35:
	cmp mineState[di-31],9
	jne n36
	inc mineState[di]
  n36:
	cmp mineState[di-1],9
	jne n37
	inc mineState[di]
  n37:
	cmp mineState[di+1],9
	jne n38
	inc mineState[di]    
  n38:
	inc di
	cmp di,766
	jbe start737to766
start767:
	cmp mineState[di],9
	jae calculateDone
	cmp mineState[di-33],9
	jne n39
	inc mineState[di]
  n39:
	cmp mineState[di-32],9
	jne n40
	inc mineState[di]
  n40:
	cmp mineState[di-1],9
	jne calculateDone
	inc mineState[di]
calculateDone:	
	ret
calculate endp

check proc near
again:
	mov di,0
	mov checkCount,0
checkRight:
	cmp BlockState[di],1
	jne c1
	cmp mineState[di],0
	jne c1
	cmp BlockState[di+1],0
	jne c1
	mov BlockState[di+1],1
	mov checkCount,1
  c1:
	inc di
	cmp di,767
	je c2
	mov ax,di
	mov bl,32
	div bl
	cmp ah,31
	jne checkRight
	inc di
	jmp checkRight
  c2:
	mov di,1
checkLeft:
	cmp BlockState[di],1
	jne c3
	cmp mineState[di],0
	jne c3
	cmp BlockState[di-1],0
	jne c3
	mov BlockState[di-1],1
	mov checkCount,1
  c3:
	inc di
	cmp di,768
	je c4
	mov ax,di
	mov bl,32
	div bl
	cmp ah,0
	jne checkLeft
	inc di
	jmp checkLeft
  c4:
	mov di,0
checkDown:
	cmp BlockState[di],1
	jne c5
	cmp mineState[di],0
	jne c5
	cmp BlockState[di+32],0
	jne c5
	mov BlockState[di+32],1
	mov checkCount,1
  c5:
	inc di
	cmp di,736
	je c6
	jmp checkDown
  c6:
	mov di,32
checkUp:
	cmp BlockState[di],1
	jne c7
	cmp mineState[di],0
	jne c7
	cmp BlockState[di-32],0
	jne c7
	mov BlockState[di-32],1
	mov checkCount,1
  c7:
	inc di
	cmp di,768
	je c8
	jmp checkUp
  c8:
	cmp checkCount,1
	je again
	ret
check endp

checkWin proc
	mov di,0
checkw:
	cmp BlockState[di],0
	jne w1
	cmp mineState[di],9
	jne w2
  w1:
	inc di
	cmp di,768
	je w3
	jmp checkw
  w2:
	ret
  w3:
	xor ax,ax
	mov al,score[0]
	mov bl,10
	div bl
	add ah,30h
	add al,30h
	mov WinMessage9[23],ah
	mov WinMessage9[22],al
	xor ax,ax
	mov al,score[1]
	mov bl,10
	div bl
	add ah,30h
	add al,30h
	mov WinMessage9[25],ah
	mov WinMessage9[24],al
	xor ax,ax
	mov al,score[2]
	mov bl,10
	div bl
	add ah,30h
	add al,30h
	mov WinMessage9[27],ah
	mov WinMessage9[26],al
	SET_CUR 11,17 
	lea dx,WinMessage1
	mov ah,09h
	int 21h
	SET_CUR 12,17 
	lea dx,WinMessage2
	mov ah,09h
	int 21h
	SET_CUR 13,17 
	lea dx,WinMessage3
	mov ah,09h
	int 21h
	SET_CUR 14,17 
	lea dx,WinMessage4
	mov ah,09h
	int 21h
	SET_CUR 15,17 
	lea dx,WinMessage5
	mov ah,09h
	int 21h
	SET_CUR 16,17 
	lea dx,WinMessage6
	mov ah,09h
	int 21h
	SET_CUR 17,17 
	lea dx,WinMessage7
	mov ah,09h
	int 21h
	SET_CUR 18,17 
	lea dx,WinMessage8
	mov ah,09h
	int 21h
	SET_CUR 19,17 
	lea dx,WinMessage9
	mov ah,09h
	int 21h
	SET_CUR 20,17 
	lea dx,WinMessage10
	mov ah,09h
	int 21h
	call firework
	call firework
	call firework
	call reset
	mov ah,07h
	int 21h
	jmp startup
	ret 
checkWin endp

runLose proc
	mov di,0
  L1:
	cmp mineState[di],9
	jne L2
	mov BlockState[di],1
  L2:
	inc di
	cmp di,768
	jne L1
	mov row,0
	mov col,0
	call scanMap
	ret
runLose endp

reset proc
	mov cheat,0
	mov row,0
	mov col,0
	mov isStart,0
	mov difficulty,0
	mov position[0],0
	mov position[1],0
	mov position[2],0
	mov ax,ds
	mov es,ax
	mov di,offset BlockState
	cld
	xor al,al
	mov cx,768
	rep stosb
	
	mov ax,ds
	mov es,ax
	mov di,offset mineState
	cld
	xor al,al
	mov cx,768
	rep stosb
	ret
reset endp

setmine proc
	mov cx,mineNumber
mineSet:
	in ax,40h
	xor dx,dx
	mov bx,768
	div bx
	mov di,dx
	cmp BlockState[di],0
	jne mineskip
	cmp mineState[di],9
	je mineskip
	cmp mineState[di],99
	je mineskip
	mov mineState[di],9
	push cx
	in ax,40h
	randDelay ax
	pop cx
	loop mineSet
  mineskip:
	inc cx
	loop mineSet
	mov di,firstBlock
	mov mineState[di],0
	ret
SetMine endp

selectSound proc 
	mov di,200
setFreq:
	cmp soundtimes,3
	je exSound
	inc soundtimes
	mov si,0
	mov al, 0b6H
    out 43h, al
    mov dx, 12h
    mov ax, 348ch
    div di
    out 42h, al
	
    mov al, ah
    out 42h, al
SL1:
	in al, 61h
    mov ah, al
    or al, 3
    out 61h, al

	cmp si,0fffh
	je SL2
	inc si
	jmp SL1
SL2:
	mov di,230
	jmp setFreq
exSound:
	in al, 61h
	and al,0fch 
	out 61h,al
	mov soundtimes,0
	ret
selectSound endp

firework proc
	mov di,2000
	in ax,40h
	mov bx,500
	mov dx,0
	div bx
	mov row,dx
	in ax,40h
	mov bx,360
	mov dx,0
	div bx
	mov col,dx
fireworkL:
	cmp soundtimes,400
	je exFirework
	inc soundtimes
	mov al, 0b6H
    out 43h, al
    mov dx, 12h
    mov ax, 348ch
    div di
    out 42h, al
	
    mov al, ah
    out 42h, al
FL1:
	in al, 61h
    mov ah, al
    or al, 3
    out 61h, al

	cmp si,0ffh
	je FL2
	inc si
	jmp FL1
FL2:
	mov si,0
	cmp soundtimes,360
	je bom
	dec di
	jmp fireworkL
bom:
	mov si,0
	mov di,0
	mov bomCount,0
	mov bp,0
  bomLoop:
	mov cx,row
	mov dx,col
	add cx,fireworkRow[di]
	add dx,fireworkCol[di]
  bomLoop1:
	WrPixel cx,dx,fireworkBitmap[bp]
	inc si
	inc cx
	cmp si,4
	jb bomLoop1
	cmp bomCount,3
	je bomLoop2
	inc bomCount
	inc dx
	sub cx,4
	mov si,0
	jmp bomLoop1
  bomLoop2:
	add di,2
	mov si,0
	inc bp
	mov bomCount,0
	cmp fireworkBitmap[bp],100
	je bomSound
	jmp bomLoop
  bomSound:
	mov di,250
	je fireworkL
exFirework:
	in al, 61h
	and al,0fch 
	out 61h,al
	mov soundtimes,0
	mov cx,0000h
Fdelay1:
	mov bp,09000h
Fdelay2:
	dec bp
	cmp bp,0
	jnz Fdelay2
	Loop Fdelay1
	ret
firework endp

showChange proc
	mov row,310
	mov col,270
	mov di,0
	mov mineState[0],9
	call printSelect
	mov mineState[0],0
	mov di,0
	mov row,0
	mov col,0
	ret
showChange endp

setFlagSound proc 
	mov di,500
setFFreq:
	cmp soundtimes,3
	je exFSound
	inc soundtimes
	mov si,0
	mov al, 0b6H
    out 43h, al
    mov dx, 12h
    mov ax, 348ch
    div di
    out 42h, al
	
    mov al, ah
    out 42h, al
SFL1:
	in al, 61h
    mov ah, al
    or al, 3
    out 61h, al

	cmp si,0fffh
	je SFL2
	inc si
	jmp SFL1
SFL2:
	mov di,530
	jmp setFFreq
exFSound:
	in al, 61h
	and al,0fch 
	out 61h,al
	mov soundtimes,0
	ret
setFlagSound endp

resetFlagSound proc 
	mov di,530
resetFFreq:
	cmp soundtimes,3
	je exRFSound
	inc soundtimes
	mov si,0
	mov al, 0b6H
    out 43h, al
    mov dx, 12h
    mov ax, 348ch
    div di
    out 42h, al
	
    mov al, ah
    out 42h, al
RFL1:
	in al, 61h
    mov ah, al
    or al, 3
    out 61h, al

	cmp si,0fffh
	je RFL2
	inc si
	jmp RFL1
RFL2:
	mov di,500
	jmp resetFFreq
exRFSound:
	in al, 61h
	and al,0fch 
	out 61h,al
	mov soundtimes,0
	ret
resetFlagSound endp

bombSound proc 
	mov di,130
bombFreq:
	mov si,0
	mov al, 0b6H
    out 43h, al
    mov dx, 12h
    mov ax, 348ch
    div di
    out 42h, al
	
    mov al, ah
    out 42h, al
BL1:
	in al, 61h
    mov ah, al
    or al, 3
    out 61h, al
	
	in al, 61h
	and al,0fch 
	out 61h,al
	
	cmp si,0fffh
	je exBSound
	inc si
	jmp BL1
exBSound:
	ret
bombSound endp

loseSound proc 
	mov di,200
loseFreq:
	cmp soundtimes,5
	je exLSound
	inc soundtimes
	mov si,0
	mov al, 0b6H
    out 43h, al
    mov dx, 12h
    mov ax, 348ch
    div di
    out 42h, al
	
    mov al, ah
    out 42h, al
LL1:
	in al, 61h
    mov ah, al
    or al, 3
    out 61h, al

	cmp si,03200h
	je LL2
	inc si
	jmp LL1
LL2:
	sub di,15
	jmp loseFreq
exLSound:
	in al, 61h
	and al,0fch 
	out 61h,al
	mov soundtimes,0
	ret
loseSound endp

end

