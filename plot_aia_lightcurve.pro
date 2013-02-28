; NAME:
; 	PLOT_AIA_LIGHTCURVE
;
; PURPOSE:
; Given a set of AIA images, plots a lightcurve of these images by
; summing the flux in the image pixels.
; 
;
; CATEGORY:
;       SDO, TIME SERIES
;
; CALLING SEQUENCE:
;       PLOT_AIA_LIGHTCURVE,filelist,aia_time,aia_flux,filename=filename,xrange=xrange,yrange=yrange
;
; CALLS:
;       fits2map.pro
;       sub_map.pro
;
; INPUTS:
;
;       filelist - a string array of AIA image files at a specified
;                  wavelength.
;
; OUTPUTS:
;       aia_time - array containing the time information from each
;                  image
;       aia_flux - array containing the total flux from each image
;
; KEYWORDS:
;       filename - the name of the output postscript file. If not set,
;                  the default is aia_lightcurve.ps
;       xrange   - optionally specify an x-range over which to sum
;                  up. This will invoke the sub_map routine.
;       yrange   - optionally specify a y-range over which to sum
;                  up. This will invoke the sub_map routine.
;      .
; WRITTEN: Andrew Inglis, 2012/08/06


PRO plot_aia_lightcurve, filelist, filename = filename, aia_time, aia_flux, xrange=xrange,yrange=yrange

default, filename, 'aia_lightcurve.ps'

n=n_elements(filelist)
aia_flux=fltarr(n)
aia_time=strarr(n)

fits2map,filelist,aiamap

IF keyword_set(xrange) AND keyword_set(yrange) THEN BEGIN
   sub_map,aiamap,aiasubmap,xrange=xrange,yrange=yrange
   aiamap=aiasubmap
ENDIF

for i=0,n-1 do begin
    aia_flux[i] = total(aiamap[i].data/aiamap[i].dur)
    aia_time[i] = aiamap[i].time
endfor

limits=minmax(aia_flux)
if (limits[0] lt 0) THEN limits[0] = 0

ylimits=[limits[0],limits[1]]

window,1
utplot,aia_time,aia_flux,thick=2,charsize=1.5,ytitle='AIA flux',/ynozero,yrange=limits,ystyle=1



set_plot,'ps'
device,encaps=1,filename=filename
utplot,aia_time,aia_flux,thick=2,charsize=1.5,ytitle='AIA flux',/ynozero,yrange=ylimits,ystyle=1
device,/close
set_plot,'x'

;stop

END
