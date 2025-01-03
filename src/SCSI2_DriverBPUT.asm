		.include "config.inc"
		.include "os.inc"
		.include "workspace.inc"
		.include "hardware.inc"

		.export HD_BPUT_WriteSector

		.segment "hd_driver_bput"

HD_BPUT_WriteSector:

; setup data address from &BE
	lda	$BC
	sta	WKSP_ADFS_216_DSKOPSAV_MEMADDR
	lda	$BD
	sta	WKSP_ADFS_216_DSKOPSAV_MEMADDR+1
	lda	#$FF
	sta	WKSP_ADFS_216_DSKOPSAV_MEMADDR+2
	sta	WKSP_ADFS_216_DSKOPSAV_MEMADDR+3
	lda	#$0A				; &08 - READ
	ldx	$C1
	jsr	HD_CommandBGETBPUTsector
	bne	LAB5BJmpGenerateError
