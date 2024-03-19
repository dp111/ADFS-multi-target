NMIVARS_CMD_PRECOMP		= $0D56			; bit 2 set if precomp
NMIVARS_TRACK_COUNT		= $0D57
NMIVARS_SECTOR_COUNT		= $0D58			; sector count?
NMIVARS_SECTOR			= $0D59			; sector number?
NMIVARS_SECTORS_THIS_TRACK	= $0D5A
NMIVARS_FDC_CMD_STEP		= $0D5C			; bits 0/1 set to step rate
NMIVARS_FLAGS_SAVE 		= $0D5D			; ZP_ADFS_FLAGS is put here before an NMI transfer
NMIVARS_SIDE			= $0D5E			; side of disk
NMIVAR_WTF			= $0D5F			; gets set but not read?