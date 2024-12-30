.ifndef __CONFIG_INC__
__CONFIG_INC__:

; Build file for Master ADFS with SCSI drivers
; --------------------------------------------

TARGETOS	:=	3		; 3=Master
HD_SCSI		:=	1		; VFS SCSI drivers
HD_SCSI_VFS	:=	1
;
USE65C12	:=	1		; use 65C12 opcodes
		.pc02		; USE65C12


CMOS_PER_ROM_BASE		= $14		; note: this appears to be a VFS bug, should be $30 according to https://beebwiki.mdfs.net/CMOS_configuration_RAM_allocation

HDDBASE=$FE80		; VFS controller
VERBASE=$170		; Master VFS

VFS_FLOPPY_VESTIGE	:= 1

.endif