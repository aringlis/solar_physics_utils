;NAME: FILE_APPEND
;
;PURPOSE: A script to append the filenames of a list of files. For example, for a list of files
;['file1.ext','file2.ext','file3.ext'], applying the append string 'app' will result in the creation of the
;new files ['file1_app.ext','file2_app.ext','file3_app.ext'].
;
;CALLING SEQUENCE: file_append,file_list,append_string
;
;INPUTS: FILE_LIST     - a list of files
;	 APPEND_STRING - the string with which to append the files (an underscore is not required - one is
;			automatically added).
;
;OUTPUTS: New files with their filenames appended as described above. The original files are NOT deleted.
;
;WRITTEN: Andrew Inglis, 2012/12/04


PRO file_append,file_list,append_string

for i=0,n_elements(file_list)-1 do begin
	substring=strsplit(file_list[i],'.',/extract)
	file_ext='.'+substring[1]
	base=substring[0]	
	file_copy,file_list[i],base+'_'+append_string+file_ext,/verbose	
endfor

END