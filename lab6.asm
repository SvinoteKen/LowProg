.386p
.model flat, stdcall
option casemap:none

GetModuleHandleA PROTO STDCALL :DWORD
LoadCursorA PROTO STDCALL :DWORD,:DWORD
RegisterClassExA PROTO STDCALL :DWORD
CreateWindowExA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
LoadIconA PROTO STDCALL :DWORD,:DWORD
ShowWindow PROTO STDCALL :DWORD,:DWORD
UpdateWindow PROTO STDCALL :DWORD
GetMessageA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
TranslateMessage  PROTO STDCALL :DWORD
DispatchMessageA  PROTO STDCALL :DWORD
DefWindowProcA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
PostQuitMessage PROTO STDCALL :DWORD
ExitProcess PROTO      :DWORD


WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
MessageBoxA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD 
GetCommandLineA PROTO STDCALL
SetFocus PROTO STDCALL :DWORD
SetWindowTextA PROTO STDCALL :DWORD,:DWORD
GetWindowTextA PROTO STDCALL :DWORD,:DWORD,:DWORD
DestroyWindow PROTO STDCALL :DWORD
SendMessageA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
wsprintfA PROTO C :VARARG
StrToIntA PROTO STDCALL :DWORD

HINSTANCE typedef DWORD
LPSTR     typedef DWORD
HWND      typedef DWORD
UINT      typedef DWORD
WPARAM    typedef DWORD
LPARAM    typedef DWORD

POINT STRUCT
  x  DWORD ?
  y  DWORD ?
POINT ENDS


MSG STRUCT
  hwnd      DWORD      ?
  message   DWORD      ?
  wParam    DWORD      ?
  lParam    DWORD      ?
  time      DWORD      ?
  pt        POINT      <>
MSG ENDS


WNDCLASSEXA STRUCT
  cbSize            DWORD      ?
  style             DWORD      ?
  lpfnWndProc       DWORD      ?
  cbClsExtra        DWORD      ?
  cbWndExtra        DWORD      ?
  hInstance         DWORD      ?
  hIcon             DWORD      ?
  hCursor           DWORD      ?
  hbrBackground     DWORD      ?
  lpszMenuName      DWORD      ?
  lpszClassName     DWORD      ?
  hIconSm           DWORD      ?
WNDCLASSEXA ENDS


.data
   ClassName db "SimpleWinClass",0
   AppName   db "Сумма двух чисел",0

   ButtonClassName db "button",0
   Button1Text db "Рассчитать",0
   Button2Text db "Очистить",0

   EditClassName db "edit",0
   StaticClassName db "static",0
   StaticText db "Тут будет сумма векторов",0
   Text1 db "x1",0
   Text2 db "y1",0
   Text3 db "x2",0
   Text4 db "y2",0
   format     db 'a( %d , %d ) + b( %d , %d ) = c( %d , %d )', 0
   buffer      db 128 dup(0)
   x dd 0
   y dd 0
   x1 dd 0
   x2 dd 0

.data?
   hInstance HINSTANCE ?
   CommandLine LPSTR ?
   hwndButton1 HWND ?
   hwndButton2 HWND ?
   hwndEdit1 HWND ?
   hwndEdit2 HWND ?
   hwndEdit3 HWND ?
   hwndEdit4 HWND ?
   hwndStatic HWND ?
   
.const 
WM_DESTROY	equ 2h 		; сообщение приходит при закрытии окна
WM_KEYDOWN      equ 100h        ; сообщение приходит окну при нажатии несистемной клавиши
VK_ESCAPE       equ 1Bh		; виртуальный код клавиши ESC

IDI_APPLICATION equ 32512 	; идентификатор стандартной иконки
IDC_ARROW	equ 32512 	; идентификатор курсора
SW_SHOWNORMAL	equ 1 		; режим показа окна Ч нормальный
CS_HREDRAW      equ 2h		; внутренн¤¤ область окна должна быть перерисована при изменении ширины окна
CS_VREDRAW      equ 1h  	; внутренн¤¤ область окна должна быть перерисована при изменении высоты окна
CS_GLOBALCLASS  equ 4000h	; данный класс ¤вл¤етс¤ глобальным и доступным другим приложени¤м. 
				; другие приложени¤ могут создавать окна на базе этого класса
COLOR_BACKGROUND  	equ 3		; дескриптор кисти фона класса окна
CW_USEDEFAULT           equ 80000000h   ; заданна¤ по умолчанию позици¤ или размер

WS_OVERLAPPED           equ 0h		; перекрывающеес¤ окно
WS_CAPTION              equ 0C00000h	; окно с заголовком
WS_SYSMENU              equ 80000h	; окно с кнопкой системного меню
WS_THICKFRAME           equ 40000h	; окно с рамкой, используемой дл¤ изменени¤
WS_MINIMIZEBOX          equ 20000h      ; окно с кнопкой свертывани¤ окна
WS_MAXIMIZEBOX          equ 10000h      ; окно с кнопкой развертывани¤ окна
; перекрывающеес¤ окно с заголовком, системным меню, рамкой, кнопками свертывани¤ и развертывани¤
WS_OVERLAPPEDWINDOW     equ WS_OVERLAPPED OR WS_CAPTION OR WS_SYSMENU OR WS_THICKFRAME OR WS_MINIMIZEBOX OR WS_MAXIMIZEBOX

   Button1ID equ 1
   Button2ID equ 2
   Edit1ID equ 3 
   Edit2ID equ 4
   Edit3ID equ 5
   Edit4ID equ 6
   StaticID equ 7                             
   SW_SHOWDEFAULT   equ 10
   WS_EX_CLIENTEDGE equ 00000200h
   WS_CHILD   equ 40000000h
   WS_VISIBLE equ 10000000h
   WS_BORDER  equ 800000h
   BS_DEFPUSHBUTTON  equ 1h
   ES_LEFT           equ 0h
   WM_CREATE         equ 1h
   WM_COMMAND        equ 111h
   ES_AUTOHSCROLL    equ 80h
   BN_CLICKED        equ 0
   COLOR_BTNFACE     equ 15
   SS_CENTER         equ 1h
   MB_OK equ 0

.code
start:	
       invoke GetModuleHandleA, 0
       mov    hInstance,eax
       invoke GetCommandLineA
       mov CommandLine,eax
       invoke WinMain, hInstance,0,CommandLine, SW_SHOWDEFAULT
       invoke ExitProcess,eax

   WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
       LOCAL wc:WNDCLASSEXA
       LOCAL msg:MSG
       LOCAL hwnd:HWND

       mov   wc.cbSize,SIZEOF WNDCLASSEXA
       mov   wc.style, CS_HREDRAW or CS_VREDRAW
       mov   wc.lpfnWndProc, OFFSET WndProc
       mov   wc.cbClsExtra,0
       mov   wc.cbWndExtra,0
       push  hInst
       pop   wc.hInstance
       mov   wc.hbrBackground,COLOR_BTNFACE+1
       mov   wc.lpszMenuName,0
       mov   wc.lpszClassName,OFFSET ClassName

       invoke LoadIconA,0,IDI_APPLICATION
       mov   wc.hIcon,eax
       mov   wc.hIconSm,eax
       invoke LoadCursorA,0,IDC_ARROW
       mov   wc.hCursor,eax
       invoke RegisterClassExA, addr wc
       invoke CreateWindowExA,WS_EX_CLIENTEDGE,ADDR ClassName, \
                           ADDR AppName, WS_OVERLAPPEDWINDOW,\
                           600, 300, 400,400,0,0, hInst,0
       mov   hwnd,eax
       invoke ShowWindow, hwnd,SW_SHOWNORMAL
       invoke UpdateWindow, hwnd
       .WHILE 1
           invoke GetMessageA, ADDR msg,0,0,0
           .BREAK .IF (!eax)
           invoke TranslateMessage, ADDR msg
           invoke DispatchMessageA, ADDR msg
       .ENDW
       mov     eax,msg.wParam
       ret

   WinMain endp

   WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
       .IF uMsg==WM_DESTROY
           invoke PostQuitMessage,0
       .ELSEIF uMsg==WM_CREATE
           ; создание первого пол¤ редактировани¤
           invoke CreateWindowExA,WS_EX_CLIENTEDGE, ADDR EditClassName,ADDR Text1, \
 			WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or ES_AUTOHSCROLL,\
                        50,50,130,20,hWnd,Edit1ID,hInstance,0
           mov  hwndEdit1,eax
           invoke SetFocus, hwndEdit1
           ; создание второго пол¤ редактировани¤
           invoke CreateWindowExA,WS_EX_CLIENTEDGE, ADDR EditClassName,ADDR Text2,\
                           WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
                           ES_AUTOHSCROLL,\
                           190,50,130,20,hWnd,Edit2ID,hInstance,0
           mov  hwndEdit2,eax
		   invoke CreateWindowExA,WS_EX_CLIENTEDGE, ADDR EditClassName,ADDR Text3,\
                           WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
                           ES_AUTOHSCROLL,\
                           50,100,130,20,hWnd,Edit3ID,hInstance,0
           mov  hwndEdit3,eax
		   invoke CreateWindowExA,WS_EX_CLIENTEDGE, ADDR EditClassName,ADDR Text4,\
                           WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
                           ES_AUTOHSCROLL,\
                           190,100,130,20,hWnd,Edit4ID,hInstance,0
           mov  hwndEdit4,eax
           ; создание статического текста
           invoke CreateWindowExA,WS_EX_CLIENTEDGE, ADDR StaticClassName,ADDR StaticText,\
                           WS_CHILD or WS_VISIBLE or SS_CENTER,\
                           50,230,270,20,hWnd,StaticID,hInstance,0
           mov  hwndStatic,eax

           ; создание кнопки дл¤ расчета
           invoke CreateWindowExA,0, ADDR ButtonClassName,ADDR Button1Text,\
                           WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\     
                           50,150,270,30,hWnd,Button1ID,hInstance,0
           mov  hwndButton1,eax
           ; создание кнопки очистки
           invoke CreateWindowExA,0, ADDR ButtonClassName,ADDR Button2Text,\
                           WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\     
                           50,270,270,30,hWnd,Button2ID,hInstance,0
           mov  hwndButton2,eax

       .ELSEIF uMsg==WM_COMMAND
           mov eax,wParam
           .IF lParam!=0
               .IF ax==Button1ID
                   shr eax,16
                   .IF ax==BN_CLICKED
                       invoke GetWindowTextA,hwndEdit1,ADDR buffer,10
                       invoke StrToIntA, ADDR buffer
					   mov x1,eax
                       push eax

                       invoke GetWindowTextA,hwndEdit3,ADDR buffer,10
                       invoke StrToIntA, ADDR buffer
                       mov ecx,eax
					   mov x2,ecx
                       pop ebx 
                       add  eax,ebx
					   mov x,eax
					   
					   invoke GetWindowTextA,hwndEdit2,ADDR buffer,10
                       invoke StrToIntA, ADDR buffer
                       push eax

                       invoke GetWindowTextA,hwndEdit4,ADDR buffer,10
                       invoke StrToIntA, ADDR buffer
                       mov ecx,eax
                       pop ebx 
                       add  eax,ebx
					   mov y,eax
					   
                       invoke wsprintfA, addr buffer, addr format, x1, ecx,x2,ebx,x,y
                       invoke SetWindowTextA,hwndStatic, ADDR buffer
                   .ENDIF
               .ENDIF
                .IF ax==Button2ID
                    shr eax,16
                   .IF ax==BN_CLICKED
                       invoke SetWindowTextA,hwndEdit1, 0
                       invoke SetWindowTextA,hwndEdit2, 0
					   invoke SetWindowTextA,hwndEdit3, 0
					   invoke SetWindowTextA,hwndEdit4, 0
                       invoke SetWindowTextA,hwndStatic, 0
                       invoke SetFocus, hwndEdit1
                   .ENDIF
                .ENDIF
           .ENDIF
       .ELSE
           invoke DefWindowProcA,hWnd,uMsg,wParam,lParam
           ret
       .ENDIF
       xor    eax,eax

       ret

   WndProc endp
end start

