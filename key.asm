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
         .code                         ;start the code segment
;---------------------------------------

;---------------------------------------
; read a char from standard input
;---------------------------------------
read:                                  ;
         mov       ah,8                ;setup reading from standard input, no echo
         int       21h                 ;read from stadnard input
;---------------------------------------
; check whether input is a whitespace
;---------------------------------------
         cmp       al," "              ;compare latest input with a space
         je        print               ;a space is a valid character, print to console
;---------------------------------------
; check whether input is a period
;---------------------------------------
         cmp       al,"."              ;compare latest input with a period
         je        print               ;a period is a valid character, print to console
;---------------------------------------
; convert to lowercase char
;---------------------------------------
         and       al,0DFh             ;Since all characters above "Z" are either invalid
                                       ;----or needs to be converted, a mask is used
                                       ;----to reduce the 6th bits to 0, effectively
                                       ;----minus 20h on all lowercase characters, but
                                       ;----keeps all uppercase characters un-changed
;---------------------------------------
; check whether input is uppercase char
;---------------------------------------
         cmp       al,"A"              ;compare latest input with A
         jb        read                ;input is not within range A-Z, throw away
         cmp       al,"Z"              ;compare latest input with Z
         ja        read                ;input is within range A-Z, print to screen
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
         end       read                ;end marks the end of the source code
                                       ;....and specifies where you want the
                                       ;....program to start execution
;---------------------------------------