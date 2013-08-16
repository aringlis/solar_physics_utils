; NAME:
; 		GET_HESSI_FLUX
;
; PURPOSE:
; Returns time series data from RHESSI (and optionally GBM) for a given time
; interval, in the form of a .SAV file. For RHESSI, the count flux 
; is returned in the 'standard' channels, 3-6 keV, 6-12 kev...etc,
; corresponding to binning code 10.
; 
;
; CATEGORY:
;       XRAYS, TIME SERIES
;
; CALLING SEQUENCE:
;       GET_HESSI_FLUX,times=times,no_hsi=no_hsi,gbm=gbm
;
; CALLS:
;       break_time.pro
;
; PREREQUISITES
; requires SSW with the HESSI and SPEX packages installed.
;
; KEYWORDS:
;    times  - optional 2-element vector of times within which to
;               search for data. Should always be given, although
;               there is a default value.
;    no_hsi - don't search for any RHESSI data. Use this if you
;             already have the RHESSI data and just want to search for GBM
;             data
;    gbm    - search for FERMI/GBM data as well. Data from the 4 most
;             sunward NAI detectors will be downloaded. BGO is not included.
;      .
;
; WRITTEN: Andrew Inglis, 2012/08/06
;          Andrew Inglis, 2013/08/16 - fixed bug where energy bins for
;                                      GBM data were always native
;                                      (128 bins). Now set to 7 bins,
;                                      matching RHESSI quicklook bins.
;                                                                                                                                             
;                                                
pro get_hessi_flux, obj=obj,times=times,gbm=gbm,no_hsi=no_hsi,obs_summ=obs_summ                                                    
;
search_network,/enable
     
default,times, [' 6-Jul-2012 00:00:00.000', ' 6-Jul-2012 08:00:00.000']  

;get a file extension string with which to append filenames
ext=break_time(times[0])

;get RHESSI data unless this keyword is set
IF (NOT keyword_set(no_hsi)) OR (NOT keyword_set(obs_summ)) THEN BEGIN
                                                                              
obj = hsi_spectrum()                                                                  
obj-> set, obs_time_interval= [times[0], times[1]]
obj-> set, sp_data_unit= 'Flux'                                                       
obj-> set, sp_energy_binning= 10L                                                     

                                                                                                              
obj-> plot, /pl_time     ; plot the time history                                     

;write a spectrum/time history file to be read by ospex                          
obj->filewrite,/buildsrm,/fits,all_simplify=0,specfile='temp_spectrum_'+ext+'.fits',srmfile='temp_srm_'+ext+'.fits'                                                                                     
;now launch ospex 
o = ospex(/no_gui)                                       

;get the input files we just made
o-> set, $                                                                                
 spex_specfile= 'temp_spectrum_'+ext+'.fits'         
o-> set, spex_drmfile= 'temp_srm_'+ext+'.fits'                                                   
o-> set, spex_eband= [[3.00000, 6.00000], [6.00000, 12.0000], [12.0000, 25.0000], $       
 [25.0000, 50.0000], [50.0000, 100.000], [100.000, 300.000], [300.000, 1000.00], [1000.00, $
 2500.00], [2500.00, 20000.0]]                                                              
o-> set, spex_tband= -1.0000000D                                                          

;extract the time series data
hessi_flux=o->getdata(spex_units='flux')
hessi_time=o->getaxis(/ut,/mean)
hessi_energies=o->getaxis(/ct_energy,/edges_2)

;save the time series data to a file
SAVE,hessi_flux,hessi_time,hessi_energies,filename='/Users/ainglis/physics/event_list/event_list_data/hessi_flux_'+ext+'.sav'
;stop

ENDIF

IF keyword_set(obs_summ) THEN BEGIN
   obj=hsi_obs_summary()
   obj->set,obs_time_interval=[times[0],times[1]]
   ;write a summary save file
   obj->savwrite,savfile='/Users/ainglis/physics/event_list/event_list_data/obs_summ_'+ext+'.sav',/corrected
ENDIF


;search for GBM data as well if this keyword is set
IF keyword_set(gbm) THEN BEGIN

  ;find out how sunward the various GBM detectors were during the observing
  ;time. Want the most sunward detectors

   cos=gbm_get_det_cos(times,ut_cos=ut_cos,status=status)
   ;if no angles were found then there's no data. Stop!
   IF (status eq 0) THEN BEGIN
      print,'Error: no detector angles found. Returning...'
      return
   ENDIF
   ;get the average angle of each detector over the observation time
   ;and sort into order

   ave=average(cos,2)
   s=reverse(sort(ave))
   ;select the 4 most sunward detectors to get data from
   dets=s[0:3]

   dets='n'+strtrim(dets,2)
   
   ;extract a string to use in the file name
   ext_gbm=strmid(ext,2,6)
   
   ;find the gbm data from the detectors we chose at the observing times
   gbm_find_data,date=times,det=dets,/copy,file=file

   spawn,'\ls glg_cspec_'+dets[0]+'_bn'+ext_gbm+'*.rsp*',srm_tab

   ;if ospex is not running then run ospex with the files we just downloaded
   if not is_class(o,'SPEX',/quiet) then o = ospex()      

   ;use the most sunward detector to get the time series data                              
   o-> set, spex_specfile= 'glg_cspec_'+dets[0]+'_'+ext_gbm+'_v00.pha'  
   o-> set, $                                                                             
      spex_drmfile= srm_tab[0]  
;o-> set, spex_source_angle= 90.0000                                                    
   o-> set, spex_eband= [[4.50000, 15.0000], [15.0000, 25.0000], [25.0000, 50.0000], $    
                         [50.0000, 100.000], [100.000, 300.000], [300.000, 600.000], [600.000, 2000.00]]         
   o-> set, spex_tband= -1
   
   ;extract the GBM time series data
   d=o->getdata(spex_units='flux')
   eband=o->get(/spex_eband)
   gbm_flux=(o->get(/obj,class='spex_data'))->bin_data(data=d, intervals=eband)
   gbm_time=o->getaxis(/ut,/mean)
   gbm_energies=eband;o->getaxis(/ct_energy,/edges_2)
   
   ;save the time series data to a file
   SAVE,gbm_flux,gbm_time,gbm_energies,filename='/Users/ainglis/physics/event_list/event_list_data/gbm_flux_'+ext+'.sav'
   print,'GBM save file written: gbm_flux_'+ext+'.sav'

ENDIF
;stop



end                                         

                                                                                  
