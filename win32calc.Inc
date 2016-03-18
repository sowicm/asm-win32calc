
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include msvcrt.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib
includelib msvcrt.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const

IDD_DIALOG1			equ 101

IDD_HISTORY			equ 1000

IDC_HISTORY			equ 1200

IDC_EDIT			equ 1001

IDC_LEFT			equ 1002
IDC_RIGHT			equ 1003
IDC_DIV				equ 1004
IDC_MUL				equ 1005
IDC_SUB				equ 1006
IDC_ADD				equ 1010
IDC_EQU				equ 1017
IDC_0				equ 1100
IDC_1				equ 1101
IDC_2				equ 1102
IDC_3				equ 1103
IDC_4				equ 1104
IDC_5				equ 1105
IDC_6				equ 1106
IDC_7				equ 1107
IDC_8				equ 1108
IDC_9				equ 1109
IDC_DOT				equ 1019
IDC_BACK			equ 1008
IDC_AC				equ 1007

;#########################################################################

.data?

hInstance			dd ?

;#########################################################################
