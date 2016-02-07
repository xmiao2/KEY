;--------------------------------------------------------------------
;   Program:  KEY (MASM version)
;
;   Function: Program reads ASCII characters (20h-7Fh) from the
;             standard input device, converts [a-z] to uppercase
;             form, and print them to the standard output device
;             along with [A-Z .]
;
;             When [.] is encountered, program exits without error.
;
;             Special keys like F1-F12, Home, PgUp, PgDn, Del, etc.
;             will not be handled.
;
;             In assembler you have as much flexibility as you want.
;
;   Owner:    Xiaohang Miao (xmiao2)
;
;   Date:     Changes
;   02/03/16  original version
;
;---------------------------------------
         .model    small               ;64k code and 64k data
         .8086                         ;only allow 8086 instructions
         .stack    256                 ;reserve 256 bytes for the stack
;---------------------------------------
      
;---------------------------------------
         .data                         ;start the data segment
;---------------------------------------
list     db        ' .ABCDEFGHIJKLMNOPQRSTUVWXYZ'       ;the hello world message
term     db        '$'                 ;dos end of string
listlen  dw        term-list+1         ;total length of the message
;---------------------------------------

;---------------------------------------
         .code                         ;start the code segment
;---------------------------------------

start:
         mov       ax,@data
         mov       ds,ax
;---------------------------------------
; read a char from standard input
;---------------------------------------
read:                                  ;
         mov       ah,8                ;setup reading from standard input, no echo
         int       21h                 ;read from stadnard input
;---------------------------------------
; convert to uppercase char if possible
;---------------------------------------
         cmp       al,41h              ;compare latest input with letter A
         jb        loop_s              ;if below A, do not convert to uppercase, otherwise
                                       ;----risking converting " " and "."
         and       al,0DFh             ;since all characters above "Z" are either invalid
                                       ;----or needs to be converted, a mask is used
                                       ;----to reduce the 6th bits to 0, effectively
                                       ;----minus 20h on all lowercase characters, but
                                       ;----keeps all uppercase characters un-changed
;---------------------------------------
; initialize loop
;---------------------------------------
loop_s:
         mov       cx,listlen
         mov       si,offset list
loop_:
         cmp       al,[si]
         je        print
         inc       si
         loop      loop_
         jmp       read
;---------------------------------------
; print input char to standard output
;---------------------------------------
print:                                 ;
         mov       ah,2                ;setup printing to standard output
         mov       dl,al               ;move latest input to output spot
         int       21h                 ;return to dos
         cmp       dl,"."              ;check for termination condition
         jne       read                ;read the next input

;---------------------------------------
; terminate program execution
;---------------------------------------
exit:                                  ;
         mov       ax,4c00h            ;set dos code to terminate program
         int       21h                 ;return to dos
         end       start               ;end marks the end of the source code
                                       ;....and specifies where you want the
                                       ;....program to start execution
;---------------------------------------