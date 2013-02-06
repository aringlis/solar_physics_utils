FUNCTION month2num,month

;PURPOSE: converts a three letter month string, e.g. 'jan','apr' to a 2-digit string
;number, e.g. '01','04'. Input is case insensitive.
;
;INPUTS: month - a three letter string of a month,
;                e.g. 'jan','apr','nov'. Case insensitive.
;OUTPUTS: num - the corresponding month number as a string,
;               e.g. '01','04','11'.
;WRITTEN: Andrew Inglis - 06 Feb 2013
;

month=strlowcase(month)

CASE month OF
   'jan': num='01'
   'feb': num='02'
   'mar': num='03'
   'apr': num='04'
   'may': num='05'
   'jun': num='06'
   'jul': num='07'
   'aug': num='08'
   'sep': num='09'
   'oct': num='10'
   'nov': num='11'
   'dec': num='12'
ENDCASE

RETURN, num
END
