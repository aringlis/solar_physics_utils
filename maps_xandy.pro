FUNCTION maps_xandy,map,xy=xy

;PURPOSE: given a Solar Software (SSW) image map, returns a structure
;containing the x and y axis arrays in the image coordinates
;(e.g. arcseconds). Also optionally returns the pixel coordinates of a
;given point in the image.

;INPUTS: map - a solarsoftware (SSW) image map.
;
;KEYWORDS: xy - an optional 2-element vector, e.g. xy=[x,y],
;               specifying a point in the map image coordinates. If set,
;               the pixel location of the specified xy point will be
;               saved in the returned structure.
;
;CALLING SEQUENCE: result=maps_xandy(map,xy=xy)
;
;WRITTEN: A. Inglis 2013/03/01


sz=size(map.data)
xsize=sz[1]
ysize=sz[2]

x_axis=(findgen(xsize)-(xsize/2)) * map.dx + map.xc
y_axis=(findgen(ysize)-(ysize/2)) * map.dy + map.yc

IF keyword_set(xy) THEN BEGIN
xpos=value_locate(x_axis,xy[0])
ypos=value_locate(y_axis,xy[1])
ENDIF ELSE BEGIN
xpos=0
ypos=0
ENDELSE

info=create_struct('x_axis',x_axis,'y_axis',y_axis,'xpos',xpos,'ypos',ypos)
print,'x index = ',xpos
print,'y index = ',ypos

return,info
END
