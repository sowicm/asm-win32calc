.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

; history dlgwithtext


include win32calc.inc

.data
	szTitle	db 'ok', 0
	szText db 'okokok', 0
	szFormatd db '%d', 0
	szFormatlf db "%lf", 0

	szFormat db '(%s)', 0
;	szFormat2 db '%s%lf%s', 0
	szFormat2 db '%s%g%s', 0

	;szFormat2 db '%s', 0

	szWrong db 'Invalid Expression', 0

	bAns byte 0

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	LOCAL @szBuffer[1024]:byte
	LOCAL @szBuffer2[1024]:byte

	LOCAL @operands[1024]:real8
	LOCAL @operators[100]:byte

	LOCAL @operands_l[1024]:real8
	LOCAL @operators_l[100]:byte

	LOCAL @q:dword
	LOCAL @p:dword
	LOCAL @k:dword
	LOCAL @l:dword
	LOCAL @r:dword

	LOCAL @opt1:byte
	LOCAL @opt2:byte

	LOCAL @num1:real8
	LOCAL @num2:real8

	mov		eax,uMsg
	.if eax==WM_INITDIALOG

	.elseif eax==WM_COMMAND

		mov		ebx, wParam
		.if ebx > 1000 && ebx < 1110
			invoke GetDlgItemText, hWin, IDC_EDIT, addr @szBuffer, sizeof @szBuffer

			.if bAns == 1
				mov @szBuffer[0], 0
				mov bAns, 0
			.endif


			;mov 	ecx, @szBuffer
			;lea 	ecx, @szBuffer[0]
			;mov cl, byte ptr[ecx]
			;inc     ecx
			;test cl, cl
			;je add_char_to_edit

	;l1:
			;mov cl, byte ptr[ecx]
			;inc ecx
			;test cl, cl
			;jne l1

			xor edi, edi

l1:
			mov cl, @szBuffer[edi]
			inc edi
			test cl, cl
			jne l1

			dec edi

;add_char_to_edit:

			;invoke  wsprintf, addr @szBuffer, addr szFormatd, ebx
     		;invoke  MessageBox, NULL, addr @szBuffer, addr szTitle, MB_ICONQUESTION or MB_YESNO


			.if ebx == IDC_LEFT
				mov @szBuffer[edi], '('

			.elseif bx == IDC_RIGHT
				mov @szBuffer[edi], ')'

			.elseif bx == IDC_DIV
				mov @szBuffer[edi], '/'

			.elseif bx == IDC_MUL
				mov @szBuffer[edi], '*'

			.elseif bx == IDC_SUB
				mov @szBuffer[edi], '-'

			.elseif bx == IDC_ADD
				mov @szBuffer[edi], '+'

			.elseif bx == IDC_EQU

				;invoke RtlZeroMemory, addr @operators, sizeof @operators
				;invoke RtlZeroMemory, addr @operands, sizeof @operands
				;invoke RtlZeroMemory, addr @operators_l, sizeof @operators_l
				;invoke RtlZeroMemory, addr @operands_l, sizeof @operands_l

; invoke  MessageBox, NULL, addr @szBuffer, addr szTitle, MB_ICONQUESTION or MB_YESNO

				invoke wsprintf, addr @szBuffer2, addr szFormat, addr @szBuffer
				invoke crt_strcpy, addr @szBuffer, addr @szBuffer2
; invoke  MessageBox, NULL, addr @szBuffer, addr szTitle, MB_ICONQUESTION or MB_YESNO

				;mov eax, @szBuffer2
				;lea eax, @szBuffer2
				;mov @szBuffer, eax
				;mov @szBuffer, @szBuffer2
;				mov @szBuffer, @szBuffer2
				;invoke  MessageBox, NULL, eax, addr szTitle, MB_ICONQUESTION or MB_YESNO

				.while @szBuffer[0] == '('
					;invoke  MessageBox, NULL, addr @szBuffer, addr szTitle, MB_ICONQUESTION or MB_YESNO

					;xor ch, ch
					; .while @szBuffer[ch] != ')'
					; 	inc ch
					; .endw
					xor edi, edi
					.while @szBuffer[edi] != ')' && @szBuffer[edi] != 0
						inc edi
					.endw

					.if @szBuffer[edi] == 0
						;invoke MessageBox, NULL, addr szWrong, addr szWrong, MB_ICONQUESTION or MB_YESNO
						invoke crt_strcpy, addr @szBuffer, addr szWrong
						.break
					.endif

					mov @szBuffer[edi], 0
					mov @r, edi

; l2:
; 					mov bl, @szBuffer[ch]
; 					inc ch
; 					test bl, bl
; 					jne l2

					; mov cl, ch
					; .while @szBuffer[cl] != '('
					; 	dec cl
					; .endw
					.while @szBuffer[edi] != '('
						dec edi
					.endw
					mov @szBuffer[edi], 0
					mov @l, edi

; invoke crt_sprintf, addr @szBuffer2, addr szFormatd, @l
; invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION

; invoke crt_sprintf, addr @szBuffer2, addr szFormatd, @r
; invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION

					;mov ah, 1
					mov @q, 1
					;xor al, al
					mov @p, 0
					;mov si, cl
					;inc si
					;inc cl
					;mov @l, cl
					;mov @r, ch
					;mov si, cl
					mov edi, @l
					inc edi
					mov @k, edi
					.while edi < @r
						mov bl, @szBuffer[edi]
						.if bl == '+' || bl == '-' || bl == '*' || bl == '/'
							mov esi, @q
							.if bl == '+'
								mov @operators[esi], 2
							.elseif bl == '-'
								mov @operators[esi], 3
							.elseif bl == '*'
								mov @operators[esi], 4
							.elseif bl == '/'
								mov @operators[esi], 5
							.endif
							.if edi == 0
								;mov @operands[esi], 0
								;fld rzero
								fldz
								fstp @operands[esi * 8]
							.else
								mov @szBuffer[edi], 0
								lea ebx, @szBuffer
								add ebx, @k
								;invoke  MessageBox, NULL, ebx, addr szTitle, MB_ICONQUESTION or MB_YESNO

								;invoke crt_atof, ebx
								lea eax, @operands[esi * 8]

								invoke crt_sscanf, ebx, addr szFormatlf, eax;addr @num1
								.if eax != 1
									fldz
									fstp @operands[esi * 8]
								.endif

								; ;lea eax, @operands[esi]
								; fld @operands[esi * 8]
								; fst @num1

								; invoke crt_sprintf, addr @szBuffer2, addr szFormatd, esi
								; invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION or MB_YESNO

								; ;invoke wsprintf, addr @szBuffer2, addr szFormatlf, eax ;addr @szBuffer, ecx, ecx
								; invoke crt_sprintf, addr @szBuffer2, addr szFormatlf, @num1
								; invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION or MB_YESNO

								;mov @operands[esi], eax
							.endif
							mov @k, edi
							inc @k
							inc @q
							mov ebx, @q
							fldz
							fstp @operands[ebx]
							mov @operators[ebx], 0
						.endif
						inc edi
					.endw

					;dec edi
					;mov @szBuffer[edi], 0
					lea ebx, @szBuffer
					add ebx, @k
					;invoke crt_atof, eax
					mov esi, @q
					lea eax, @operands[esi * 8]
					invoke crt_sscanf, ebx, addr szFormatlf, eax;addr @num1
;invoke  MessageBox, NULL, addr szWrong, addr szTitle, MB_ICONQUESTION or MB_YESNO
;invoke crt_sprintf, addr @szBuffer2, addr szFormatd, eax
;invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION or MB_YESNO

					.if eax != 1
						fldz
						fstp @operands[esi * 8]
					.endif
					;

					; fld @operands[esi * 8]
					; fst @num1

; invoke crt_sprintf, addr @szBuffer2, addr szFormatd, esi
; invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION or MB_YESNO
; invoke  MessageBox, NULL, ebx, addr szTitle, MB_ICONQUESTION or MB_YESNO
; invoke  MessageBox, NULL, addr szWrong, addr szTitle, MB_ICONQUESTION or MB_YESNO

					; invoke crt_sprintf, addr @szBuffer2, addr szFormatlf, @num1
					; invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION or MB_YESNO

					; fld @operands[1 * 8]
					; fst @num1
					; invoke crt_sprintf, addr @szBuffer2, addr szFormatlf, @num1
					; invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION or MB_YESNO



					;mov @operands[esi], eax

					;movsw @num1, @operands[1]
					;movsw ecx, @operators[1]
					mov cl, @operators[1]
					mov @opt1, cl
					;mov ecx, @operands[1]
					fld @operands[1 * 8]
					fstp @num1

					; fstp @num1

; invoke crt_sprintf, addr @szBuffer2, addr szFormatlf, @num1 ;addr @szBuffer, ecx, ecx
; invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION or MB_YESNO


					mov edi, 2
					.while edi <= @q
						;mov ebx, @operands[edi]
						; movsw @num2, @operands[edi]
						; movsw edx, @operators[edi]
						mov cl, @operators[edi]
						mov @opt2, cl
						;mov edx, @operands[edi]
						fld @operands[edi * 8]
						fstp @num2
						.repeat
							mov @k, 0
							mov al, @opt1
							shr al, 1
							mov bl, @opt2
							shr bl, 1
							.if al < bl
								inc @p
								mov esi, @p
								
								;mov @operands_l[esi], ecx
								;fxch
								fld @num1
								fstp @operands_l[esi * 8]
								fld @num2
								fstp @num1

								mov cl, @opt1
								mov @operators_l[esi], cl
								
								;mov ecx, edx
								
								mov cl, @opt2
								mov @opt1, cl
							.else
								fld @num1
								fld @num2
								.if @opt1 == 2
									;fadd ecx, edx
									fadd
									;invoke  MessageBox, NULL, addr szText, addr szTitle, MB_ICONQUESTION or MB_YESNO

								.elseif @opt1 == 3
									;fsub ecx, edx
									fsub
								.elseif @opt1 == 4
									;fmul ecx, edx
									fmul
								.elseif @opt1 == 5
									;fdiv ecx, edx
									fdiv
								.else
									invoke  MessageBox, NULL, addr szWrong, addr szWrong, MB_ICONQUESTION or MB_YESNO
								.endif
								fstp @num1
								mov cl, @opt2
								mov @opt1, cl
								mov @opt2, 0
								.if @p > 0
									mov esi, @p
									;mov edx, ecx
									;fxch
									;fld @operands_l[esi * 8]
									fld @num1
									fstp @num2
									fld @operands_l[esi * 8]
									fstp @num1

									mov cl, @opt1
									mov @opt2, cl
									;mov ecx, @operands_l[esi]
									mov cl, @operators_l[esi]
									mov @opt1, cl
									dec @p
									mov @k, 1
								.endif
							.endif
						.until @k != 1
						;invoke  MessageBox, NULL, addr szText, addr szTitle, MB_ICONQUESTION or MB_YESNO

						inc edi
					.endw

					;invoke wsprintf, addr @szBuffer2, addr szFormatd, ebx ;addr @szBuffer, ecx, ecx

					;mov ebx, @r
					;lea ecx, @szBuffer;[ebx+1]

					;invoke  MessageBox, NULL, ecx, addr szTitle, MB_ICONQUESTION or MB_YESNO


					;add ecx, @r
					;inc ecx
					;invoke  MessageBox, NULL, addr @szBuffer, addr szTitle, MB_ICONQUESTION or MB_YESNO

					lea ebx, @szBuffer
					add ebx, @r
					inc ebx
					;fst @num1
					;fld rzero
					;fst @num1

					;invoke crt_sprintf, addr @szBuffer2, addr szFormatlf, @num1 ;addr @szBuffer, ecx, ecx
					;invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION or MB_YESNO


					invoke crt_sprintf, addr @szBuffer2, addr szFormat2, addr @szBuffer, @num1, ebx
; invoke  MessageBox, NULL, addr @szBuffer2, addr szTitle, MB_ICONQUESTION or MB_YESNO

					invoke crt_strcpy, addr @szBuffer, addr @szBuffer2
					;invoke  MessageBox, NULL, addr @szBuffer, addr szTitle, MB_ICONQUESTION or MB_YESNO

				.endw
				mov edi, 511
				mov bAns, 1
			.elseif bx == IDC_0
				mov @szBuffer[edi], '0'

			.elseif bx == IDC_1
				mov @szBuffer[edi], '1'

			.elseif bx == IDC_2
				mov @szBuffer[edi], '2'

			.elseif bx == IDC_3
				mov @szBuffer[edi], '3'

			.elseif bx == IDC_4
				mov @szBuffer[edi], '4'

			.elseif bx == IDC_5
				mov @szBuffer[edi], '5'

			.elseif bx == IDC_6
				mov @szBuffer[edi], '6'

			.elseif bx == IDC_7
				mov @szBuffer[edi], '7'

			.elseif bx == IDC_8
				mov @szBuffer[edi], '8'

			.elseif bx == IDC_9
				mov @szBuffer[edi], '9'

			.elseif bx == IDC_DOT
				mov @szBuffer[edi], '.'

			.elseif bx == IDC_BACK
				sub edi, 2

			.elseif bx == IDC_AC
				mov edi, -1

			.endif

			inc edi
			mov @szBuffer[edi], 0
			;inc ecx
			;mov byte ptr[ecx], 0
			;mov @szBuffer[eax + 1], 0
			; mov @szBuffer[0], 'o'
			; mov @szBuffer[1], 'k'
			; mov @szBuffer[2], 0

			invoke SetDlgItemText, hWin, IDC_EDIT, addr @szBuffer
		.elseif bx == IDC_HISTORY

			;invoke DialogBoxParam,hInstance,IDD_HISTORY,NULL,addr DlgProc, NULL
			invoke CreateDialog, hInstance, IDD_HISTORY, hWnd, addr DlgProc
			;invoke DialogBox, hInstance, IDD_HISTORY, hWnd, addr DlgProc
			;invoke DialogBoxParam,hInstance,IDD_HISTORY,hWin,addr DlgProc, NULL
		.endif

	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

end start
