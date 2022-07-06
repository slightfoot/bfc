String i386windows(String code) {
  return '''global _start 
  extern _putch, _getch, ExitProcess
   
  section .text 
  
  %macro m_open 0
  %push block
  %\$begin:
  cmp  byte [esi], 0 
  jz   %\$end 
  %endmacro
  
  %macro m_close 0
  jmp  %\$begin
  %\$end: 
  %pop
  %endmacro
    
  _start: 
    mov  ecx, 30000 
    sub  esp, ecx 
    mov  edi, esp 
    xor  eax, eax 
    rep  stosb 
    mov  esi, esp
     
  code: 
    $code
     
  exit: 
    push 0 
    call ExitProcess
     
  putchar: 
    xor eax, eax 
    mov al, byte [esi] 
  putchar_1: 
    push eax 
    call _putch 
    add esp, 4 
    ret
     
  getchar: 
    call _getch 
    mov byte [esi], al 
    jmp short putchar_1
  '''.replaceAll('\n  ', '\n');
}
