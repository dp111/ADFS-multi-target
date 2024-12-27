.ifndef __CONFIG_INC__
__CONFIG_INC__:

; Build file for Master ADFS with SCSI drivers
; For Pi1MHz
; --------------------------------------------

TARGETOS	:=	3		; 3=Master
HD_SCSI		:=	1		; VFS SCSI drivers
HD_SCSI_VFS	:=	1
HD_SCSI_VFS_NO_INVERT := 1 ; Stop normal VFS inverting of data. 

HDDBASE=$FC44		; VFS controller
VERBASE=$171		; Master VFS

USE65C12	:=	1		; use 65C12 opcodes
		.pc02		; USE65C12

VFS_FLOPPY_VESTIGE	:= 1

.endif