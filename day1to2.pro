;PURPOSE: Converts a single letter day string to a 2-letter string,
;e.g. '3' becomes '03'.

;WRITTEN: Andrew Inglis - 6 Feb 2013

FUNCTION day1to2,day

IF (strlen(day) eq 1) THEN BEGIN
   day='0'+day
ENDIF

RETURN,day

END
