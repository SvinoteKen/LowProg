.686p
.model flat, stdcall
option casemap :none   
GetModuleHandleA PROTO STDCALL :DWORD
LoadCursorA PROTO STDCALL :DWORD,:DWORD
LoadIconA PROTO STDCALL :DWORD,:DWORD
RegisterClassExA PROTO STDCALL :DWORD
CreateWindowExA PROTO STDCALL :DWORD,:DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
ShowWindow PROTO STDCALL :DWORD,:DWORD
UpdateWindow PROTO STDCALL :DWORD
GetMessageA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
TranslateMessage PROTO STDCALL :DWORD
DispatchMessageA PROTO STDCALL :DWORD
DefWindowProcA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
PostQuitMessage PROTO STDCALL :DWORD
GetCommandLineA PROTO STDCALL
CreateSolidBrush PROTO STDCALL :DWORD
ExitProcess PROTO STDCALL :DWORD
WinMain PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
GetCursorPos PROTO STDCALL :DWORD
GetClientRect PROTO STDCALL :DWORD,:DWORD 
MessageBoxA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
wsprintfA PROTO C :VARARG
SetWindowTextA PROTO STDCALL :DWORD,:DWORD 
GetDesktopRect PROTO STDCALL :DWORD,:DWORD 
Sleep PROTO STDCALL :DWORD
MoveWindow PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetWindowPos PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
POINT STRUCT
; координата X указателя мыши в момент отправки сообщения
x DWORD ?
; координата Y указателя мыши в момент отправки сообщения
y DWORD ? 
POINT ENDS

RECT STRUCT
left DWORD ? 
top DWORD ? 
right DWORD ? 
bottom DWORD ? 
RECT ENDS

MSG STRUCT
; дескриптор окна, которому предназначено сообщение
hwnd DWORD ?
; идентификатор сообщения
message DWORD ?
; параметр сообщения wParam
wParam DWORD ?
; параметр сообщения lParam
lParam DWORD ?
; время помещения сообщения в очередь
time DWORD ?
; координаты указателя мыши в момент отправки сообщения
MSG ENDS

WNDCLASSEXA STRUCT
; размер структуры в байтах (30h)
cbSize DWORD ?
; флаги, указывающие стили класса
style DWORD ? 
; указатель на оконную процедуру
lpfnWndProc DWORD ?
; количество дополнительных байтов класса, которые 
; размещаются вслед за структурой класса окна
cbClsExtra DWORD ?
; количество дополнительных байтов окна, которые 
; размещаются вслед за внутренней структурой окна
cbWndExtra DWORD ?
; дескриптор экземпляра приложения, который содержит 
; оконную процедуру для класса
hInstance DWORD ?
; дескриптор значка класса, дескриптор ресурса значка
hIcon DWORD ?
; дескриптор курсора класса, дескриптор ресурса курсора
hCursor DWORD ?
; дескриптор кисти фона класса, дескриптор физической 
; кисти, которая используется при создании фона окна
hbrBackground DWORD ?
; указатель на символьную строку с именем ресурса меню 
lpszMenuName DWORD ?
; указатель на символьную строку с именем класса
lpszClassName DWORD ?
; дескриптор мелкого значка, связанного с данным окном
hIconSm DWORD ?
WNDCLASSEXA ENDS

.data
myRECT RECT<>
myWRECT RECT<>
myXY POINT <>
TitleMsg db 'Координаты',0
; указываем буфер для форматированного вывода
buffer db 128 dup(0)
; указываем строку формата со спецификациями форматов
format db 'x=%d y=%d', 0
; символьная строка, которая определяет имя класса окна
ClassName db "SimpleWinClass",0
; символьная строка, которая определяет имя окна
AppName db "Наше первое окно",0
NewName db "---------",0
; дескриптор экземпляра приложения
hInstance dd 00000000h
; указатель на командную строку текущего процесса
CommandLine dd 00000000h
.const
; идентификатор сообщения, генерируемого при закрытии окна
WM_DESTROY equ 2h
; идентификатор сообщения, генерируемого при нажатии 
; несистемной клавиши
WM_KEYDOWN equ 100h

VK_F9 equ 78h

VK_SPACE equ 20h
; виртуальный код клавиши ESC
VK_ESCAPE equ 1Bh
; идентификатор стандартной иконки
IDI_APPLICATION equ 32512
; идентификатор стандартного курсора-стрелки
IDC_ARROW equ 32512
; идентификатор нормального режима показа окна
SW_SHOWNORMAL equ 1
; идентификатор перерисовки окна при изменении ширины окна
CS_HREDRAW equ 2h
; идентификатор перерисовки окна при изменении высоты окна
CS_VREDRAW equ 1h
; идентификатор цвета кисти фона класса окна
COLOR_BTNFACE equ 15
; идентификатор заданной по умолчанию позиции или размера
CW_USEDEFAULT equ 80000000h
; идентификатор перекрытия окна другими окнами
WS_OVERLAPPED equ 0h
; идентификатор окна с заголовком
WS_CAPTION equ 0C00000h
; идентификатор окна с системным меню в заголовке
WS_SYSMENU equ 80000h
; идентификатор окна с рамкой
WS_THICKFRAME equ 40000h
; идентификатор окна с кнопкой свертывания окна
WS_MINIMIZEBOX equ 20000h
; идентификатор окна с кнопкой развертывания окна
WS_MAXIMIZEBOX equ 10000h
; идентификатор перекрывающегося окна с заголовком, 
; системным меню, рамкой, кнопками свертывания и 
; развертывания
WS_OVERLAPPEDWINDOW equ WS_OVERLAPPED OR WS_CAPTION OR WS_SYSMENU OR WS_THICKFRAME OR WS_MINIMIZEBOX OR WS_MAXIMIZEBOX
; идентификатор показа окна способом, заданным по умолчанию
SW_SHOWDEFAULT equ 10
WM_LBUTTONDOWN equ 201h
WM_RBUTTONDBLCLK equ 206h
WM_LBUTTONDBLCLK equ 203h
SWP_SHOWWINDOW equ 40h
HWND_TOP equ 0
WM_SETTEXT equ 0h
.code
start:
; получаем дескриптор экземпляра приложения hInstance
invoke GetModuleHandleA, 0
mov hInstance,eax
; получаем указатель на командную строку текущего процесса
invoke GetCommandLineA
mov CommandLine,eax
; вызываем главную функцию
invoke WinMain, hInstance, 0 , CommandLine, SW_SHOWDEFAULT
; завершаем процесс
invoke ExitProcess,eax

WinMain proc hInst:DWORD ,hPrevInst:DWORD, CmdLine:DWORD, CmdShow:DWORD
; локальная переменная типа структуры класса окна
LOCAL wc:WNDCLASSEXA
; локальная переменная типа структуры сообщения
LOCAL msg:MSG
; локальная переменная – дескриптор окна
LOCAL hwnd:DWORD
; заполнение полей структуры c атрибутами класса окна
; размер структуры
mov wc.cbSize,SIZEOF WNDCLASSEXA
; перерисовка окна при изменении его ширины и высоты
mov wc.style, CS_HREDRAW or CS_VREDRAW
; указатель на функцию обработки сообщений окна
mov wc.lpfnWndProc, OFFSET WndProc
; число дополнительных байт за структурой класса окна
mov wc.cbClsExtra,0
; число дополнительных байт за экземпляром окна
mov wc.cbWndExtra,0
; дескриптор экземпляра приложения
push hInst
pop wc.hInstance
; фон окна – синий
invoke CreateSolidBrush,00FF0000h
mov wc.hbrBackground,eax
; оконное меню отсутствует
mov wc.lpszMenuName,0
; имя класса окна
mov wc.lpszClassName,OFFSET ClassName
; стандартный значок и мелкий значок приложения
invoke LoadIconA,0,IDI_APPLICATION
mov wc.hIcon,eax
mov wc.hIconSm,eax
; стандартный курсор-стрелка
invoke LoadCursorA,0,IDC_ARROW
mov wc.hCursor,eax
; регистрация класса окна
invoke RegisterClassExA, addr wc
invoke CreateWindowExA,0,ADDR ClassName, ADDR AppName, WS_OVERLAPPEDWINDOW, 20, 20, CW_USEDEFAULT,CW_USEDEFAULT,0,0, hInst,0
mov hwnd,eax; описателль созданного окна
; отображение окна
invoke ShowWindow, hwnd,SW_SHOWNORMAL
; обновление содержимого окна
invoke UpdateWindow, hwnd
; цикл обработки сообщений
.WHILE 1
; получить сообщение
invoke GetMessageA, ADDR msg,0,0,0
.BREAK .IF (!eax)
; преобразовать аппаратное сообщение в символьное
invoke TranslateMessage, ADDR msg
; передать сообщение оконной функции для обработки
invoke DispatchMessageA, ADDR msg
.ENDW
mov eax,msg.wParam
ret
WinMain endp

WndProc proc hWnd:DWORD, wMsg:DWORD, wParam:DWORD, lParam:DWORD

LOCAL h:DWORD
LOCAL w:DWORD

.IF wMsg==200h
invoke GetCursorPos, addr myXY
invoke GetClientRect, hWnd ,addr myRECT
mov eax, myRECT.bottom
cdq
mov ebx,2
idiv ebx
.IF myXY.y<eax
invoke Sleep,300
invoke SetWindowTextA, hWnd, addr NewName
invoke Sleep,300
invoke SetWindowTextA, hWnd, addr AppName
.ENDIF
.ENDIF


.IF wMsg==100h
.IF wParam==VK_F9
invoke SetWindowPos,hWnd,HWND_TOP,1425,0,500,300,SWP_SHOWWINDOW
.ENDIF
.ENDIF


; сообщение о необходимости уничтожения окна
.IF wMsg==WM_DESTROY
; помещение в очередь сообщение WM_QUIT
invoke PostQuitMessage,0
; если нажата клавиша

.ELSE
; вызов функции обработки сообщений по умолчанию
invoke DefWindowProcA,hWnd,wMsg,wParam,lParam
ret
.ENDIF
xor eax,eax
ret
WndProc endp
end start
