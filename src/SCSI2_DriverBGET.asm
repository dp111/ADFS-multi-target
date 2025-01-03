		.include "config.inc"
		.include "os.inc"
		.include "workspace.inc"
		.include "hardware.inc"

		.export HD_BGET_ReadSector

		.segment "hd_driver_bget"

HD_BGET_ReadSector:
	; setup data address from &BE
	lda	$BE
	sta	WKSP_ADFS_216_DSKOPSAV_MEMADDR
	lda	$BF
	sta	WKSP_ADFS_216_DSKOPSAV_MEMADDR+1
	lda	#$FF
	sta	WKSP_ADFS_216_DSKOPSAV_MEMADDR+2
	sta	WKSP_ADFS_216_DSKOPSAV_MEMADDR+3
	lda	#$08				; &08 - READ
	jsr	HD_CommandBGETBPUTsector
