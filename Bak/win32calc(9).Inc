
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.const

IDD_DIALOG1			equ 101

IDC_EDIT			equ 1001

IDC_LEFT			equ 1002
IDC_RIGHT			equ 1003
IDC_DIV				equ 1004
IDC_MUL				equ 1005
IDC_SUB				equ 1006
IDC_ADD				equ 1010
IDC_EQU				equ 1017
IDC_0				equ 1100
IDC_9				equ 1109
IDC_DOT				equ 1019

;#########################################################################

.data?

hInstance			dd ?

;#########################################################################
