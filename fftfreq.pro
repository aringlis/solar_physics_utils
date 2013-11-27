FUNCTION fftfreq,n,d=d

;NAME: fftfreq
;
;PURPOSE: utility function for calculating frequency bins associated with an
;FFT
;
;INPUTS:
; n - length of the signal on which an FFT was performed
;
; d - sampling interval (default is 1)
;
;OUTPUT:
; f - array of frequency bins
;
;WRITTEN:
; A. Inglis 2013/11/27 - version 1 - copied from IDL help file
;

;default sampling interval is 1
default,d,1

x=(findgen((n-1)/2) + 1)

; l MOD n is equal to the remainder when l is divided by n. Remainder
; of an even number divided by 2 is zero.
is_n_even = (n MOD 2) EQ 0

IF (is_n_even) then begin
   f= [0.0, x, n/2, -n/2+x]/(n*d)
ENDIF ELSE BEGIN
   f= [0.0,x, -(n/2 + 1) + x]/(n*d)
ENDELSE

return,f


END
