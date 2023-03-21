.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Vaporase_joc",0
area_width EQU 700
area_height EQU 700
area DD 0
cont equ 16
counter DD 0 ; numara evenimentele de tip timer
counter_ratari dd 0
counter_succes dd 0
nr_bucati equ 15
counter_total dd 0
;counter_ok DD 0
arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

latime EQU 500
lungime EQU 700

patrat_1_x EQU 130
patrat_1_y EQU 130
patrat_2_x EQU 530
patrat_2_y EQU 130
patrat_3_x EQU 330
patrat_3_y EQU 290

symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc

button_x EQU 500
button_y EQU 150
button_size EQU 80
.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_counter_succes proc
push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FF0000h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_counter_succes endp

make_counter_piese proc
push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi],040E0D0h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_counter_piese endp

make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FF00FFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp
make_counter_ratari proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 000BFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_counter_ratari endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm
make_counter_ratari_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_counter_ratari
	add esp, 16
endm

make_counter_succes_macro macro symbol,drawArea,x,y
push y
push x
push drawArea
push symbol
call make_counter_succes
add esp,16
endm

make_counter_piese_macro macro symbol,drawArea,x,y
push y
push x
push drawArea
push symbol
call make_counter_piese
add esp,16
endm
line_horizontal macro x,y,len,color
local bucla_linie
    mov EAX,y;EAX=y
    mov EBX,area_width
    mul EBX;EAX=y*area_width
    add EAX,x;EAX=y*area_width+x
    shl EAX,2;EAX=(y*area_width+x)*4
    add EAX,area
	mov ECX,len
bucla_linie:
   mov dword ptr[EAX],color
   add EAX,4
   loop bucla_linie
endm
line_vertical macro x,y,len,color
local bucla_linie2
mov EAX,y;EAX=y
    mov EBX,area_width
    mul EBX;EAX=y*area_width
    add EAX,x;EAX=y*area_width+x
    shl EAX,2;EAX=(y*area_width+x)*4
    add EAX,area
	mov ECX,len
bucla_linie2:
   mov dword ptr[EAX],color
   add EAX,4*area_width
   loop bucla_linie2
endm
cadran macro n,m,color
line_horizontal (area_width-n)/2,(area_height-m)/2,n,color
line_horizontal (area_width-n)/2,m+(area_height-m)/2,n,color
line_vertical (area_width-n)/2,(area_height-m)/2,m,color
line_vertical n+(area_width-n)/2,(area_height-m)/2,m,color
endm
cadran2 macro 
line_horizontal 50,90,600,08B008Bh
	line_horizontal 50,130,600,08B008Bh
	line_horizontal 50,170,600,08B008Bh
	line_horizontal 50,210,600,08B008Bh
	line_horizontal 50,250,600,08B008Bh
	line_horizontal 50,290,600,08B008Bh
	line_horizontal 50,330,600,08B008Bh
	line_horizontal 50,370,600,08B008Bh
	line_horizontal 50,410,600,08B008Bh
	line_horizontal 50,450,600,08B008Bh
	line_horizontal 50,490,600,08B008Bh
	line_horizontal 50,530,600,08B008Bh
	line_horizontal 50,570,600,08B008Bh
	line_horizontal 50,610,600,08B008Bh
	
	line_vertical 90,50,600,08B008Bh
	line_vertical 130,50,600,08B008Bh
	line_vertical 170,50,600,08B008Bh
	line_vertical 210,50,600,08B008Bh
	line_vertical 250,50,600,08B008Bh
	line_vertical 290,50,600,08B008Bh
	line_vertical 330,50,600,08B008Bh
	line_vertical 370,50,600,08B008Bh
	line_vertical 410,50,600,08B008Bh
	line_vertical 450,50,600,08B008Bh
	line_vertical 490,50,600,08B008Bh
	line_vertical 530,50,600,08B008Bh
	line_vertical 570,50,600,08B008Bh
	line_vertical 610,50,600,08B008Bh
	
endm
colorare macro corx,cory,Lungime,latime,color
local loop1,loop2
mov eax,cory
mov ebx,area_width
mul ebx
add eax,corx
shl eax,2
add eax,area
mov ecx,Lungime
loop1:
mov esi,ecx
mov ecx,latime

loop2:
mov dword ptr[eax],color
add eax,4
loop loop2
mov ecx,esi
add eax,area_width*4
sub eax,latime*4
loop loop1
endm
; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	colorare 0,0,area_width,area_height,0FF00FFh
	colorare 50,50,600,600,09370DBh
	cadran 600,600,08B008Bh
	cadran2
	colorare 90,5,40,40,040E0D0h
	colorare 170,5,40,40,000BFFFh
	colorare 250,5,40,40,0FF0000h
	jmp afisare_litere
	
	evt_timer:
	inc counter
	evt_click:
	mov eax,[ebp+arg2]
	mov esi,eax
	mov ebx,[ebp+arg3]
	
	mov eax,ebx;EAX=y
    mov ebx,area_width
    mul ebx;EAX=y*area_width
    add eax,esi;EAX=y*area_width+x
    shl eax,2;EAX=(y*area_width+x)*4
	add eax,area
	cmp dword ptr[eax],09370DBh
	jne afisare_litere
	mov ecx,50
	mov edx,50
	mov eax,[ebp+arg2]
	mov ebx,[ebp+arg3]
	cmp eax,50
	jl nu_click
	cmp eax,650
	jg nu_click
	mov ebx,[ebp+arg3]
	cmp ebx,50
	jl nu_click
	cmp ebx,650
	jg nu_click
	
	comp_eax_mai_mare_ecx:
	add ecx,40
	cmp eax,ecx
	jg comp_eax_mai_mare_ecx
	
	comp_ebx_mai_mare_edx:
	add edx,40
	cmp ebx,edx
	jg comp_ebx_mai_mare_edx
	
	coloreaza:
	sub ecx,40
	sub edx,40
	
	verif_1x_sus:
	cmp ecx,patrat_1_x
	jne verif_1x_jos
	verif_1y_sus:
	cmp edx,patrat_1_y-40
	je coloreaza_rosu
	verif_1x_jos:
	cmp ecx,patrat_1_x
	jne verif_1_stanga
	verif_1y_jos:
	cmp edx,patrat_1_y+40
	je coloreaza_rosu
	verif_1_stanga:
	cmp ecx,patrat_1_x-40
	je verif_1_y
	verif_1_dreapta:
	cmp ecx,patrat_1_x+40
	je verif_1_y
	verif_1_x:
	cmp ecx,patrat_1_x
	je verif_1_y
	
	verif_2x_sus:
	cmp ecx,patrat_2_x
	jne verif_2x_jos
	verif_2y_sus:
	cmp edx,patrat_2_y-40
	je coloreaza_rosu
	verif_2x_jos:
	cmp ecx,patrat_2_x
	jne verif_2_stanga
	verif_2y_jos:
	cmp edx,patrat_2_y+40
	je coloreaza_rosu
	verif_2_stanga:
	cmp ecx,patrat_2_x-40
	je verif_2_y
	verif_2_dreapta:
	cmp ecx,patrat_2_x+40
	je verif_2_y
	verif_2_x:
	cmp ecx,patrat_2_x
	je verif_2_y
	
	verif_3x_sus:
	cmp ecx,patrat_3_x
	jne verif_3x_jos
	verif_3y_sus:
	cmp edx,patrat_3_y-40
	je coloreaza_rosu
	verif_3x_jos:
	cmp ecx,patrat_3_x
	jne verif_3_stanga
	verif_3y_jos:
	cmp edx,patrat_3_y+40
	je coloreaza_rosu
	
	
	verif_3_stanga:
	cmp ecx,patrat_3_x-40
	je verif_3_y
	verif_3_dreapta:
	cmp ecx,patrat_3_x+40
	je verif_3_y
	verif_3_x:
	cmp ecx,patrat_3_x
	je verif_3_y
	jmp colorare_albastru
	verif_1_y:
	cmp edx,patrat_1_y
	je coloreaza_rosu
	jmp verif_2_x
	verif_2_y:
	cmp edx,patrat_2_y
	je coloreaza_rosu
	jmp verif_3_x
	verif_3_y:
	cmp edx,patrat_3_y
	je coloreaza_rosu
	colorare_albastru:
	colorare ecx,edx,40,40,000BFFFh
	inc counter_ratari
	inc counter_total
	jmp afisare_litere
	coloreaza_rosu:
	colorare ecx,edx,40,40,0FF0000h
	
	inc counter_succes
	inc counter_total
	nu_click:
	jmp afisare_litere
afisare_litere:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 30, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 20, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 10, 10
	
	
	mov ebx,10
	mov eax,counter_succes
	cmp counter_succes,15
	jg castigator
	cmp counter_total,30
	jg pierzator
	cmp eax,nr_bucati
	je castigator
	mov edx,0
	div ebx
	add edx,'0'
	make_counter_succes_macro edx,area,265,20
	add eax,'0'
	make_counter_succes_macro eax,area,255,20
	mov ebx,10
	mov eax,nr_bucati
	sub eax,counter_succes
	mov edx,0
	div ebx
	add edx,'0'
	make_counter_piese_macro edx,area,103,20
	add eax,'0'
	make_counter_piese_macro eax,area,93,20
	
	mov ebx,10
	mov eax,counter_ratari
	mov edx,0
	div ebx
	add edx,'0'
	make_counter_ratari_macro edx,area,185,20
	add eax,'0'
	make_counter_ratari_macro eax,area,175,20
	jmp final_draw
	castigator:
	colorare 0,0,area_width,area_height,0FF00FFh
	colorare 50,50,600,600,09370DBh
	cadran 600,600,08B008Bh
	cadran2
	colorare 90,5,40,40,040E0D0h
	colorare 170,5,40,40,000BFFFh
	colorare 250,5,40,40,0FF0000h
	make_text_macro 'A', area, 307, 661
		make_text_macro 'I', area, 317, 661
		make_text_macro ' ', area, 327, 661
		make_text_macro 'C', area, 337, 661
		make_text_macro 'A', area, 347, 661
		make_text_macro 'S', area, 357, 661
		make_text_macro 'T', area, 367, 661
		make_text_macro 'I', area, 377, 661
		make_text_macro 'G', area, 387, 661
		make_text_macro 'A', area, 397, 661
		make_text_macro 'T', area, 407, 661
		jmp final_draw
	pierzator:
	
		colorare 0,0,area_width,area_height,0FF00FFh
	colorare 50,50,600,600,09370DBh
	cadran 600,600,08B008Bh
	cadran2
	colorare 90,5,40,40,040E0D0h
	colorare 170,5,40,40,000BFFFh
	colorare 250,5,40,40,0FF0000h
		make_text_macro 'A', area, 307, 661
		make_text_macro 'I', area, 317, 661
		make_text_macro ' ', area, 327, 661
		make_text_macro 'P', area, 337, 661
		make_text_macro 'I', area, 347, 661
		make_text_macro 'E', area, 357, 661
		make_text_macro 'R', area, 367, 661
		make_text_macro 'D', area, 377, 661
		make_text_macro 'U', area, 387, 661
		make_text_macro 'T', area, 397, 661
		
		
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
