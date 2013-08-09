PRO plot_box,box_corners,thick=thick,color=color

;PURPOSE: Plots a box over an existing image

;WRITTEN: A. Inglis 2013/01

x0=box_corners[0]
x1=box_corners[1]
y0=box_corners[2]
y1=box_corners[3]

oplot,[x0,x1],[y0,y0],thick=thick,color=color
oplot,[x1,x1],[y0,y1],thick=thick,color=color
oplot,[x0,x1],[y1,y1],thick=thick,color=color
oplot,[x0,x0],[y1,y0],thick=thick,color=color

END
