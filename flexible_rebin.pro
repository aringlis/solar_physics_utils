;NAME: flexible_rebin
;
;PURPOSE: To shrink a vector while dealing with end effects where
;f=v_old/v_new is not an integer. The last element of the new vector
;will be the average of however many data points were remaining from
;the original array.
;
;INPUTS: vector - any vector in float or integer format
;
;OUTPUT: new_vector - the new, shrunk vector
;
;WRITTEN: 2013/02/12 - Andrew Inglis

FUNCTION flexible_rebin,vector,n,discard=discard

l=n_elements(vector)

new_vector=fltarr((l/n)+1)

FOR i=0,l-1,n do begin
   IF NOT (i+n ge (l-1)) THEN BEGIN
       new_vector[i/n]=total(vector[i:i+(n-1)])/float(n)
   ENDIF ELSE BEGIN
       IF keyword_set(discard) THEN BEGIN
          new_vector=new_vector[0:l/n]
       ENDIF ELSE BEGIN
          new_vector[i/n]=total(vector[i:l-1])/((l-1) - i)
       return,new_vector
       ENDELSE
   ENDELSE

ENDFOR

l2=n_elements(new_vector)

IF keyword_set(discard) THEN BEGIN
   new_vector=new_vector[0:l2-2]
ENDIF

return,new_vector

END
