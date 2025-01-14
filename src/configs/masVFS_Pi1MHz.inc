.ifndef __CONFIG_INC__
__CONFIG_INC__:

; Build file for Master ADFS with SCSI drivers
; For Pi1MHz
; --------------------------------------------

TARGETOS	:=	3		; 3=Master
HD_SCSI		:=	1		; VFS SCSI drivers
HD_SCSI_VFS	:=	1
HD_SCSI_VFS_NO_INVERT := 1 ; Stop normal VFS inverting of data.
VFS_TRIM_REDUNDANT :=1 ; Remove code that is unreachable
VFS_BUG_FIX :=  1 		; fix bugs in VFS
VFS_OPTIMISE := 1		; optimisations  in VFS
VFS_Pi1MHz_Mouse_Redirect := 1 ; Enable mouse to appear on the Pi
VFS_Pi1MHz_Redirect :=1 ; enable screen redirector
CMOS_PER_ROM_BASE = 30  ; fixed CMOS ram address VFS originally has 20

HDDBASE=$FC40		; VFS controller
VERBASE=$171		; Master VFS

MOUSE_REDIRECT = $FCAB ; Address of Pi mouse redirector

USE65C12	:=	1		; use 65C12 opcodes
		.pc02		; USE65C12

.endif