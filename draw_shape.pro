;NAME: DRAW_SHAPE
;
;PURPOSE: Users the IDL cursor procedure to get an array of x-y points
;from user left-clicks on an image, and returns them after a
;right-click. 
;Optionally also draws the final shape.
;
;INPUTS:
; None
;
;OUTPUTS:
; x - an array of x positions
; y - an array of y positions
;
;KEYWORDS:
; draw - if set, will draw the final shape after the user has finished clicking.
;
;WRITTEN:
;  A. Inglis, version 1 - 2014/02/12
;
PRO draw_shape,x,y,draw=draw

cursor,x1,y1
x=x1
y=y1
WHILE (!MOUSE.BUTTON NE 4) DO BEGIN
   cursor,x1,y1,/down
   x=[x,x1]
   y=[y,y1]
ENDWHILE

IF keyword_set(draw) THEN BEGIN
   plots,[x,x[0]],[y,y[0]],thick=2
ENDIF

END
