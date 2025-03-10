
		.include "config.inc"
		.include "os.inc"
		.include "workspace.inc"
		.include "hardware.inc"



        .export VFS_0D95_20Hz_CTDN
        .export VFS_0D92_FLAG_POLL100
        .export VFS_0D93_CTDN_SEARCH
        .export VFS_OLD_BYTEV
        .export VFS_D9D_OLD_IRQ1V
        .export VFS_N93A_SEARCHING_IN_PROGRESS

		.export VFS_ServiceCallsExtra
		.export VFS_FSC3_STARCMD
		.export VFS_Serv9_extra
		.export SCSI_Command_AXY_CkErr
		.export PreserveZpAndPage9
		.export RestoreZpAndPage9
		.export swap7PWSP_373_N933
		.export swapP373N933brkTurnIlaceOn
        .export OSBYTE_Extended_Vectorcode
        .export Extended_IRQ1_Vector

        .export SCSICMD_C8_VENDOR_FCMDRESULT
        .export SCSICMD_1B_STARTSTOPUNIT

		.segment "vfs_mouse"

.macro ZEROY
.ifdef VFS_OPTIMISE
        ldy     #$00
.else
        jsr    setYeq0
.endif
.endmacro

CFGBITS_01_EJECT = 1
ZP_EXTRA_LEN =   12
SCSICMD_1B_STARTSTOPUNIT = $1b
LV_FCMD_27_EJECT = $27      ;F command Eject
LV_FCMD_2A_halt = $2a       ;F command for halt/pause/still
LV_FCMD_E_VideoOnOff = $45  ;F Command Video On/Off
LV_FCMD_L_still_forward = $4c ;F command for still/forward
LV_FCMD_M_still_reverse = $4d ;F command for still reverse
LV_FCMD_O_PlayBackwards = $4f ;F command - O - play backwards
LV_FCMD_F_TERM_R_HALT = $52 ;Terminator for F command F search then halt
LV_FCMD_S_SetSlowSpeed = $53 ;F command S - set slow speed
LV_FCMD_U_SlowForward = $55 ;F command - U - slow forwards
LV_FCMD_V_SlowReverse = $56 ;F command - V - slow reverse
LV_FCMD_Z_FastReverse = $5a ;F command - Z - fast rewind
SCSICMD_C8_VENDOR_FCMDRESULT = $c8
SCSICMD_CA_VENDOR_FCMD = $ca ;Philips LV Vendor command to send F command
OSBYTE_DB_RW_TABCODE = $db
LV_FCMD_N_PlayForwards = $e4 ;F command - N - play forwards
VFS_PWSKP_373_SAVE_N933 = $0373 ;8 bytes saved from N933

LV_FCMD_2B_JUMP_FWD = $2b   ;F command - jump forward +YY tracks
LV_FCMD_2D_JUMP_BACK = $2d  ;F command - -YY jump back YY tracks
LV_FCMD_F_GOTOFRAME = $46   ;F command - goto frame XXXXX and play (term 'N') or continue (term'Q')
LV_FCMD_Q_CHAPTER = $51     ;F command - Q - Play chapter sequence
LV_FCMD_F_TERM_S_HALT = $53 ;Terminator for F command F - play, stop at this frame
LV_FCMD_W_FastForwards = $57 ;F command - fast forward

ZP_EXTRA_BASE =  $84
ZP_EXTR_PTR_A =  $86
ZP_TEMP =        $88
ZP_TEMP2 =       $89
ZP_TEMP3 =       $8a
; $8b not used
ZP_EXTR_PTR_B =  $8c

ZP_Previous_mouse_screenptr =  $8e ; Bit 7 clear if mouse screen is 0, bit 7 set if mouse screen is 1

zp_vfsv_a8_textptr = $a8    ;Used in VFS video and mouse commands when parsing command lines
zp_mos_txtptr =  $f2        ;MOS text pointer, along with Y register

zp_mos_escape =  $ff        ;MOS Escape flag

; lots of spare bytes in the 50 bytes that are backed up to the workspace.

VFS_N900 =       $0900      ;Page 9 is used by VFS during mouse/video stuff, it gets backed up to private workspace
VFS_N900_MouseBounds = $0900 ;16:16 XY bounds
VFS_N904_MousePos = $0904   ;16:16 XY Mouse position
VFS_N908_MODESAVE = $0908
VFS_N909_MOUSEVISIBLE = $0909 ; 0 or 255 for visible
VFS_N90A_MOUSE_TYPE = $090a ; 0=type 0 , 7=type 1  , 255 not defined yet
VFS_N90B_MOUSE_POINTER_TYPE = $090b ; 0=cross , 1=magnifier  , 2= prt NW , 3= prt NE
VFS_N90C_MOUSE_LAST_BUTTON = $090c ;
VFS_N90D_MOUSE_BUTTON_STILL_ACTIVE = $090d ;
VFS_N90E_PreviousMousePos = $090e  ;16:16 XY Mouse position???
VFS_N912_MouseX =$0912 ; 16 bit X
VFS_N914_MouseX2 =$0914 ; 16 bit X
VFS_N916_MouseY =$0916 ; 16 bit Y

; d1B set to zero in adfs.asm but never used
; d1C set to zero in adfs.asm but never used
; d1D written too but never used
; d1E written too but never used
; d1F written too but never used
; 920 - 922 used
; NB 923 defined in ADFS.asm used as a flag

VFS_N924_PTR_Q = $0924
VFS_N926_ZPSAVE = $0926
; 927-931 unused
VFS_N932_ACCON_SAVE = $0932

VFS_N933_BASE = $0933
; 933 - +7 get copied
; the next 8 bytes are copied to the workspace

VFS_N937_PlayStart = $0937  ;16 bit starting frame number for play
VFS_N939_RETRY_CTR = $0939  ;Countdown retries of search/seeks

VFS_N93A_SEARCHING_IN_PROGRESS = $093a    ;0 or 13 (searching in progress)

VFS_N93B_TEMPBUF = $093b ; temporary 4 byte buffer only used parse16bitDecXA

VFS_0D92_FLAG_POLL100 = $0d92   ; 0 or 255
VFS_0D93_CTDN_SEARCH = $0d93 ; $0d93 $0d94 time counts @ 25Hz ?
VFS_0D95_20Hz_CTDN = $0d95  ;;count down 4..0
; d96 set to zero in adfs.asm but never used
VFS_OLD_BYTEV = $0D97 ; 0D97-0D98
; D99,a,b,C JSR FF06:RTI
VFS_D9D_OLD_IRQ1V = $0d9d ; 0D9D-0D9E

WKSP_ADFS_215_CMDBUF = $c215

sheila_ACCON =   $fe34


;*******************************************************************************
;* VFS_ServiceCallsExtra - extra service calls                                 *
;*                                                                             *
;* This is called at the start of the main service call handler routine before *
;* all the ADFS stuff is tried                                                 *
;*******************************************************************************
        ; .org    $a6f1
VFS_ServiceCallsExtra:
         cmp     #SERVICE_15_100Hz_POLL
         bne     @trySvc4
         jmp     Serv15_Poll100Hz

@trySvc4:
         cmp     #SERVICE_04_UK_OSCLI
         bne     @rts
;*******************************************************************************
;* VFS Service call 4 handler - unknown OSCLI command                          *
;*******************************************************************************
         php
         pha
         phx
         phy
         tya
         clc
         adc     zp_mos_txtptr
         sta     zp_vfsv_a8_textptr
         lda     zp_mos_txtptr+1
         adc     #$00
         sta     zp_vfsv_a8_textptr+1 ;a8/9 point to command tail
         ldy     #$00
         lda     (zp_vfsv_a8_textptr),Y
         and     #$df       ;lowercase
         cmp     #'L'
         bne     @skNoPre
         iny                ;Skip L as prefix for commands
         lda     (zp_vfsv_a8_textptr),Y
         and     #$df       ;lowercase
         cmp     #'V'
         bne     @ex        ;If L[^V] then not a valid prefix
         iny
@skNoPre:
         ldx     #$00
         sty     $aa        ;remember Y
@cmdLp:  lda     (zp_vfsv_a8_textptr),Y
         and     #$df       ;lowercase
         cmp     VFSM_cmdTable,X ;compare with table
         beq     @incXY
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #'.'
         beq     @gotmatch  ;was a '.' ...matched
         lda     VFSM_cmdTable,X
         bmi     @LA753
         ldy     $aa        ;reload saved Y and try again
@skipEndCurCmd:
         inx
         lda     VFSM_cmdTable,X
         bpl     @skipEndCurCmd
         inx
         inx                ;skip over pointer after string
         lda     VFSM_cmdTable,X ;check for end of table (top bit set)
         bpl     @cmdLp
@ex:     ply
         plx
         pla
         plp
@rts:    rts

@incXY:  inx
         iny
         bne     @cmdLp
@gotmatch:
         iny
         bne     @gotmatch2
@LA753:  dex
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #' '
         beq     @gotmatch2
         cmp     #$0d
         bne     @ex
@gotmatch2:
         inx
         lda     VFSM_cmdTable,X
         bpl     @gotmatch2
         jsr     skipCommaOrSpace ;skip over spaces/comma
         tya
         clc
         adc     zp_vfsv_a8_textptr
         sta     zp_vfsv_a8_textptr
         bcc     @skinc

.ifdef VFS_BUG_FIX
         inc     zp_vfsv_a8_textptr + 1
.else
         inc     zp_vfsv_a8_textptr ;BUG? should be A9!
.endif

@skinc:  lda     VFSM_cmdTable,X
         sta     $ab
         lda     VFSM_cmdTable+1,X
         sta     $aa
         lda     #OSBYTE_87_SCRCHAR_MODE
         jsr     OSBYTE     ;get current mode
         tya
         and     #$07
         pha                ;push mode and #7
         sei
         jsr     PreserveZpAndPage9 ;grab some ZP and Page 9
         pla
         sta     VFS_N908_MODESAVE ;save mode #
         jsr     jmpIndAA   ;call command routine
         jsr     RestoreZpAndPage9
         ply
         plx
         pla
         lda     #$00
         plp
         rts

jmpIndAA:
         jmp     ($00aa)

VFSM_cmdTable:
.ifdef VFS_OPTIMISE
strMOUSE:
.endif
         .byte   "MOUSE"
         .dbyt   VFSstarMOUSE
         .byte   "POINTER"
         .dbyt   VFSstarPOINTER
         .byte   "TMAX"
         .dbyt   VFSstarTMAX
.ifdef VFS_OPTIMISE
strTRACKERBALL:
.endif
         .byte   "TRACKERBALL"
         .dbyt   VFSstarMOUSE
         .byte   "TSET"
         .dbyt   VFSstarTSET
         .byte   $ff        ;table end marker
strVIDEO:
         .byte   "VIDEO"
.ifndef VFS_OPTIMISE
strMOUSE:
         .byte   "MOUSE"
strTRACKERBALL:
         .byte   "TRACKERBALL"
.endif
;*******************************************************************************
;* VFS_Serv9_extra                                                             *
;*                                                                             *
;* Help for extra VFS sections MOUSE, TRACKERBALL, VIDEO                       *
;*******************************************************************************
VFS_Serv9_extra:
         tya
         pha
         ldx     #$00
@lpVIDEO:
         lda     (zp_mos_txtptr),Y
         cmp     #'.'
         beq     @prVIDEOhelpStr
         and     #$df       ;lowercase
         cmp     strVIDEO,X
         beq     @incLenCkVIDEO
@jmpTryMouse:
         jmp     @tryMOUSE

@incLenCkVIDEO:
         iny
         inx
         cpx     #$05       ;TODO: len "VIDEO"
         bne     @lpVIDEO
         lda     (zp_mos_txtptr),Y
         cmp     #'!'
         bcs     @jmpTryMouse
@prVIDEOhelpStr:
         jsr     VFS_PrintNopTermString
         .byte   $0a,"AUDIO <0-3> 0-off, 3-on",$0d,"CHAPTER <digits> Plays chapt"
         .byte   "er(s)",$0d,"EJECT",$0d,"FAST <dir.> Cue or Review",$0d,"FCODE "
         .byte   "<string>",$0d,"FRAME <no.>",$0d,"PLAY <start>,<end> Plays from"
         .byte   " start to end",$0d,"(NB *PLAY <RETURN> plays from current fram"
         .byte   "e)",$0d,"RESET",$0d,"SEARCH <no.> As FRAME, but no wait",$0d
         .byte   "SLOW <speed>,<dir.> Speed from 5 (slow) to 253 (fast)",$0d,"ST"
         .byte   "EP <1/0/255> Stop/step player",$0d,"STILL as FRAME",$0d,"VOCOM"
         .byte   "PUTER Computer to VDU",$0d,"VODISC LV to VDU",$0d,"VOHIGLIGHT "
         .byte   "Computer colour highlights LV",$0d,"VOSUPERIMPOSE Computer ove"
         .byte   "r LV",$0d,"VOTRANSPARENT LV & computer mixed",$0d,"VP <digit>"
         .byte   $0d
         nop
@tryMOUSE:
         ldx     #$00
         pla
         pha
         tay
@lpMOUSE:
         lda     (zp_mos_txtptr),Y
         cmp     #'.'
         beq     @helpTRACKERBALL
         and     #$df       ;lowercase
         cmp     strMOUSE,X
         beq     @incCkLenMOUSE
         pla
         pha
         tay
         ldx     #$00
@lpTRACKERBALL:
         lda     (zp_mos_txtptr),Y
         cmp     #'.'
         beq     @helpTRACKERBALL
         and     #$df       ;lowercase
         cmp     strTRACKERBALL,X
         beq     @incCkLenTRACKERBALL
@plyret: pla
         tay
         rts

@incCkLenTRACKERBALL:
         iny
         inx
         cpx     #$0b
         bne     @lpTRACKERBALL
         beq     @checkTokEndMOUSE

@incCkLenMOUSE:
         iny
         inx
         cpx     #$05
         bne     @lpMOUSE
@checkTokEndMOUSE:
         lda     (zp_mos_txtptr),Y
         cmp     #'!'
         bcs     @plyret
@helpTRACKERBALL:
         jsr     VFS_PrintNopTermString
         .byte   $0a,"MOUSE <1/0>",$0d,"TRACKERBALL as *MOUSE",$0d,"POINTER <0/1"
         .byte   "/2> to hide/show/hide & halt pointer",$0d,"NB MODEs 0,1 & 2 on"
         .byte   "ly",$0d,"TMAX <x>,<y> sets boundaries",$0d,"TSET <x>,<y> sets "
         .byte   "position",$0d," ADVAL(5) is X boundary, (6) is Y,",$0d," ADVAL"
         .byte   "(7) is X coordinate, (8) is Y,",$0d," ADVAL(9) is buttons",$0d
         nop
         jmp     @plyret

VFS_PrintNopTermString:
         pla
         sta     $b6
         pla
         sta     $b7
         ldy     #$00
         jsr     getB6CmdCharInc
@lp:     jsr     getB6CmdCharInc
         bmi     @retPTR
         jsr     L92CB
         jmp     @lp

@retPTR: jmp     ($00b6)

getB6CmdCharInc:
         lda     ($b6),Y
         inc     $b6
         bne     @sk1
         inc     $b7
@sk1:    cmp     #$00
         rts

starEJECT:
         jsr     myCmosRead
         and     #CFGBITS_01_EJECT
         beq     @ok
         jsr     GenerateErrorNoSuff
         .byte   $94
         .asciiz "No eject"
@ok:     lda     #LV_FCMD_27_EJECT
;*******************************************************************************
;* Enter here with single character F command value in A                       *
;*                                                                             *
;* The character will be placed in the command data buffer followed by <CR>    *
;* and sent to the LV player as a $CA vendor command.                          *
;*******************************************************************************
FCMD_Single_CharA:
         sta     WKSP_VFS_E00_TXTBUF
         lda     #$0d
         sta     WKSP_VFS_E00_TXTBUF+1
;*******************************************************************************
;* Enter here to send the data constructed in the text buffer to the LV player *
;* as an F command as a $CA vendor command - the string should be terminated   *
;* with <CR>                                                                   *
;*******************************************************************************
FCMD_TextBuf:
         lda     #SCSICMD_CA_VENDOR_FCMD ;command $CA
sendCmdATxtBuf:
         ldx     #<WKSP_VFS_E00_TXTBUF
         ldy     #>WKSP_VFS_E00_TXTBUF
SCSI_Command_AXY_res:
         jsr     SCSI_Command_AXY
         beq     LAB92rts
         pha
         jsr     swap7PWSP_373_N933
         pla
         jmp     GenerateError

LAB92rts:
         rts
SCSI_Command_AXY_CkErr:
         jsr     SCSI_Command_AXY
         beq     LAB92rts
         jmp     GenerateError

;*******************************************************************************
;* Construct a SCSI command in the ADFS workspace at offset 215 and send to    *
;* the LV player.                                                              *
;*                                                                             *
;* On entry A contains the SCSI command code and XY should point at a HOST     *
;* address with address of the data buffer (if any) containing/read to receive *
;* data to/from the command                                                    *
;*******************************************************************************
SCSI_Command_AXY:
         stx     WKSP_ADFS_215_CMDBUF+1
         sty     WKSP_ADFS_215_CMDBUF+2
         ldx     #$ff
         stx     WKSP_ADFS_215_CMDBUF+3
         stx     WKSP_ADFS_215_CMDBUF+4
         sta     WKSP_ADFS_215_CMDBUF+5
         lda     #$00
         sta     WKSP_ADFS_215_CMDBUF
         ldy     #$04
@clp:    sta     WKSP_ADFS_215_CMDBUF+6,Y
         dey
         bpl     @clp
         inc     WKSP_ADFS_215_CMDBUF+9
         ldx     #<WKSP_ADFS_215_CMDBUF
         ldy     #>WKSP_ADFS_215_CMDBUF
         jmp     CommandExecXY

LABC3rts:
         rts

jmpSwapP373N933brkBadNumber:
         jmp     swapP373N933brkBadNumber

;*******************************************************************************
;* *VP <n>                                                                     *
;*                                                                             *
;* Sends a VP command to:                                                      *
;*                                                                             *
;* *VP 1   Video from LV            *VODISC                                    *
;* *VP 2   Video from Computer      *VOCOMPUTER                                *
;* *VP 3   Computer over LV         *VOSUPERIMPOSE                             *
;* *VP 4   Computer mixed with LV   *VOTRANSPARENT                             *
;* *VP 5   Laser vision "enhanced"  *VOHIGHLIGHT                               *
;*         by computer                                                         *
;*                                                                             *
;* This command actually looks to pass values 0..9 although only 1..5 are      *
;* documented in the VFS and LV415 manuals                                     *
;*******************************************************************************
starVP:  ZEROY
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #$30
         bcc     starVPint  ;if not a number skip forward and send
         cmp     #$3a
         bcs     starVPint  ;if not a number skip forward and send
         jsr     parse8bitDecA
         cmp     #$0a
         bcs     jmpSwapP373N933brkBadNumber
         ora     #'0'
starVPint:
         ldx     SYSVARS_291_ILACE
         bne     swapP373N933brkTurnIlaceOn
         sta     WKSP_VFS_E00_TXTBUF+2
         lda     #'V'
         sta     WKSP_VFS_E00_TXTBUF
         lda     #'P'
         sta     WKSP_VFS_E00_TXTBUF+1
         lda     #$0d
         sta     WKSP_VFS_E00_TXTBUF+3
         jmp     FCMD_TextBuf

swapP373N933brkTurnIlaceOn:
         jsr     swap7PWSP_373_N933
         jsr     ReloadFSMandDIR_ThenBRK
         .byte   $ad
         .asciiz "Turn interlace on"
;*******************************************************************************
;* *VODISC - show video from LV only                                           *
;*                                                                             *
;* Calls *VP 1 internally                                                      *
;*******************************************************************************
starVODISC:
         lda     #'1'
         bne     starVPint

;*******************************************************************************
;* *VOCOMPUTER - show video from computer only                                 *
;*                                                                             *
;* Calls *VP 2 internally                                                      *
;*******************************************************************************
starVOCOMPUTER:
         lda     #'2'
         bne     starVPint

;*******************************************************************************
;* *VOSUPERIMPOSE - computer overlaid on LV                                    *
;*                                                                             *
;* Calls *VP 3 internally                                                      *
;*******************************************************************************
starVOSUPERIMPOSE:
         lda     #'3'
         bne     starVPint

;*******************************************************************************
;* *VOTRANSPARENT - mix computer and LV                                        *
;*                                                                             *
;* Calls *VP 4 internally                                                      *
;*******************************************************************************
starVOTRANSPARENT:
         lda     #'4'
         bne     starVPint

;*******************************************************************************
;* *VOHIGHLIGHT - LV "enhanced" by computer                                    *
;*                                                                             *
;* Calls *VP 5 internally                                                      *
;*******************************************************************************
starVOHIGHLIGHT:
         lda     #'5'
         bne     starVPint

;*******************************************************************************
;* *FCODE <str>                                                                *
;*                                                                             *
;* Send an arbitrary GSTRANS string to the LV player, the string will be       *
;* terminated by <CR> by the command                                           *
;*******************************************************************************
starFCODE:
         ldx     zp_vfsv_a8_textptr
         stx     zp_mos_txtptr
         ldy     zp_vfsv_a8_textptr+1
         sty     zp_mos_txtptr+1
         ldy     #$00
         sec
         jsr     GSINIT
         beq     LABC3rts
         ldx     #$00
@lp:     jsr     GSREAD
         bcs     @skend
         sta     WKSP_VFS_E00_TXTBUF,X
         inx
         bne     @lp
@skend:  lda     #$0d
         sta     WKSP_VFS_E00_TXTBUF,X
         jmp     FCMD_TextBuf

;*******************************************************************************
;* *RESET - Send SCSI "Start Unit" command                                     *
;*                                                                             *
;* The SCSI command $1B is sent to the LV player to allow F commands to be     *
;* sent                                                                        *
;*******************************************************************************
starRESET:
         jsr     disableSearchPoll
         lda     #SCSICMD_1B_STARTSTOPUNIT
         jmp     SCSI_Command_AXY_res

;*******************************************************************************
;* *CHAPTER <N>[,<O>]                                                          *
;*                                                                             *
;* Play chapter sequence                                                       *
;*                                                                             *
;* If no <O> is specified:                                                     *
;*   -    chapter sequence is sent as an F-command Qxxyyzz..S with up to 7     *
;*        chapters specified and terminated with "S" for play sequence         *
;* otherwise                                                                   *
;* O = R  go to chapter, show a still and wait                                 *
;* O = N  go to chapter and play                                               *
;* O = S  as above                                                             *
;* others BRK Bad Parameter                                                    *
;*******************************************************************************
starCHAPTER:
         ZEROY
         lda     #LV_FCMD_Q_CHAPTER
         sta     WKSP_VFS_E00_TXTBUF
@diglp:  lda     (zp_vfsv_a8_textptr),Y
         sta     WKSP_VFS_E00_TXTBUF+1,Y
         cmp     #$0d
         beq     @term
         cmp     #' '
         beq     @term
         cmp     #','
         beq     @term
         iny
         bne     @diglp
@term:   tya
         tax
         jsr     skipCommaOrSpace
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #$0d
         bne     @parseOpt
         lda     #'S'
         bne     @setTermCharAndSend ;terminate with S and send

@parseOpt:
         iny
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #' '
         beq     @sk
         cmp     #$0d
         bne     @brkBadParm
@sk:     dey
         lda     (zp_vfsv_a8_textptr),Y
         and     #$df
         cmp     #'S'
         beq     @setTermCharAndSend
         cmp     #'R'
         beq     @setTermCharAndSend
         cmp     #'N'
         beq     @setTermCharAndSend
@brkBadParm:
         jsr     swap7PWSP_373_N933
         jsr     ReloadFSMandDIR_ThenBRK
         .byte   $ff
         .asciiz  "Bad parameter"

@setTermCharAndSend:
         sta     WKSP_VFS_E00_TXTBUF+1,X
         lda     #$0d
         sta     WKSP_VFS_E00_TXTBUF+2,X
         jsr     FCMD_TextBuf
         bra     FCMD_E1_VideoOn

.ifndef VFS_OPTIMISE
setYeq0: ldy     #$00                               ; should be inlined as that is shorter and quicker
         rts
.endif

; TODO: work out what this is then document
enableSearchPoll:                                   ; only called from starSEARCH
         lda     #$f0
         sta     VFS_0D93_CTDN_SEARCH
         lda     #$00
         sta     VFS_0D93_CTDN_SEARCH + 1
         rts

;*******************************************************************************
;* *SEARCH <N> - goto frame <N> return immediately                             *
;*******************************************************************************
starSEARCH:
         ZEROY
         lda     (zp_vfsv_a8_textptr),Y
         jsr     checkDecDigitBrkBadNumber ;check for digit - BRK bad number
         lda     #LV_FCMD_F_TERM_R_HALT
         jsr     parseDigitsBuildFCMD_F_TermA
         sta     VFS_N93A_SEARCHING_IN_PROGRESS      ;store <CR>
         jsr     enableSearchPoll
         jmp     FCMD_TextBuf

;*******************************************************************************
;* *STILL <N> - Go to frame and still                                          *
;*                                                                             *
;* If no frame number calls *STEP with no parameter to stop                    *
;*                                                                             *
;* or calls *FRAME with parameter                                              *
;*******************************************************************************
starSTILL:
         ZEROY
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #$0d
         bne     starFRAME
         jmp     starSTEP

starFRAME:
         lda     #$05       ;5 retries?
         sta     VFS_N939_RETRY_CTR
@retry:  jsr     starSEARCH
         jsr     waitForSeek
         bcc     FCMD_E1_VideoOn
         dec     VFS_N939_RETRY_CTR
         bne     @retry
         jmp     swapP373N933brkBadNumber

; Turn the video on
FCMD_E1_VideoOn:
         lda     #LV_FCMD_E_VideoOnOff
         sta     WKSP_VFS_E00_TXTBUF
         lda     #$01
         jmp     sk

; wait for a "SEEK" *STILL/*FRAME
;
; return Cy on fail or timeout
waitForSeek:
         lda     VFS_0D93_CTDN_SEARCH + 1
         bmi     disableSearchPoll
         bit     zp_mos_escape
         bpl     @noesc
         jmp     ErrorEscapeACKReloadFSM

@noesc:  jsr     FCMDRET_CheckForOpen ;check for "open" fail do BRK if open
         cli
         lda     WKSP_VFS_E00_TXTBUF ;check other return code
         cmp     #'A'       ;if not "A" try again
         bne     waitForSeek
         lda     WKSP_VFS_E00_TXTBUF+1
         cmp     #'0'       ;A0 - ok we're there? F*R or F*Q completed
         bne     checkNoFrame
disableSearchPoll:
         stz     VFS_0D93_CTDN_SEARCH ;OK disable timeout counters
         stz     VFS_0D93_CTDN_SEARCH + 1
         stz     VFS_N93A_SEARCHING_IN_PROGRESS
         clc
         rts

checkNoFrame:
         cmp     #'N'       ;AN?
         bne     waitForSeek ;if not then keep waiting
         jsr     disableSearchPoll ;disable search poll
         lda     VFS_N939_RETRY_CTR
         bne     @secrts    ;if not on last retry then just return sec
         jmp     swapP373N933brkBadNumber ;do BRK bad number if AN returned again - it's a bad frame no

@secrts: sec                ;signal error
         rts

;*******************************************************************************
;* The LV player will be queried for the previously sent F command's result    *
;* which will be returned in the text buffer using vendore command $C8         *
;*******************************************************************************
FCMD_GetResult:
         lda     #SCSICMD_C8_VENDOR_FCMDRESULT
         jmp     sendCmdATxtBuf

;*******************************************************************************
;* Check the result of the previous F command for "door open" and cause a      *
;* door-open brk if true                                                       *
;*******************************************************************************
FCMDRET_CheckForOpen:
         jsr     FCMD_GetResult
         lda     WKSP_VFS_E00_TXTBUF
         cmp     #'O'
         beq     @bkrDoorOpen
         rts

@bkrDoorOpen:
         jsr     disableSearchPoll
         jsr     swap7PWSP_373_N933
         jsr     ReloadFSMandDIR_ThenBRK
         .byte   $93
         .asciiz  "Door open"

;*******************************************************************************
;* *STEP <mode>                                                                *
;*                                                                             *
;* where mode is a "signed" 8 bit number:                                      *
;*                                                                             *
;* -50..-2 (206..254)   Does "-" jump back <N> when N is -<mode>               *
;* -1      (255)        Does "M" still on prev picture                         *
;* 0                    Does "*" halt                                          *
;* 1                    Does "L" still on next picture                         *
;* 2..50                Does "+" jump forwards <N> when N is s<mode>           *
;*******************************************************************************
starSTEP:
         ZEROY
         jsr     parse8bitDecA
         cmp     #51
         bcc     @ok        ;<= 50 is ok
         cmp     #206
         bcc     swapP373N933brkBadNumber ;else must be >= -50
@ok:     tay
         iny                ;inc value
         cpy     #$03       ;if value was -1,0,1 look up special F-command for that step speed
         bcs     @mag       ;if outside range skip forward
         lda     tblFCMDStepSmall,Y ;look up specific command
         jmp     FCMD_Single_CharA ;send specific single-char command

@mag:    cmp     #$00
         bmi     @stepback
         ldy     #LV_FCMD_2B_JUMP_FWD ;send command F command +YY
@send:   sty     WKSP_VFS_E00_TXTBUF
         jsr     bit8DecimalToStringAtBuf1 ;followed by number in A
         jmp     FCMD_TextBuf ;send it

@stepback:
         eor     #$ff
         inc     A          ;negate
         ldy     #LV_FCMD_2D_JUMP_BACK ;send command F command -YY
         bne     @send

tblFCMDStepSmall:
         .byte   LV_FCMD_M_still_reverse ;step -1 send F command "M" - still reverse
         .byte   LV_FCMD_2A_halt ;step 0 send F command "*" - halt
         .byte   LV_FCMD_L_still_forward ;step 1 send F command "L" - still/forward

;*******************************************************************************
;* Parse string at ($A8),Y as an 8-bit decimal number                          *
;*                                                                             *
;* Number is terminated by <CR> or space                                       *
;*                                                                             *
;* Cy set on exit for not a number or overflow                                 *
;*******************************************************************************
parse8bitDecA:
         lda     #$0d
; If entered here the expected termination char is in A
Parse8bitDecATerminA:
         sta     $ae
         lda     #$00
         sta     $af
@digloop:
         lda     (zp_vfsv_a8_textptr),Y
         cmp     $ae
         beq     @skterm
         cmp     #' '
         beq     @skterm
         jsr     checkDecDigitBrkBadNumber
         and     #$0f
         pha
         lda     $af
         asl     A
         bcs     swapP373N933brkBadNumber
         asl     A
         bcs     swapP373N933brkBadNumber
         adc     $af
         bcs     swapP373N933brkBadNumber
         asl     A
         bcs     swapP373N933brkBadNumber
         sta     $af
         pla
         adc     $af
         bcs     swapP373N933brkBadNumber
         sta     $af
         iny
         jmp     @digloop

@skterm: jsr     skipCommaOrSpace
         lda     $af
         rts

checkDecDigitBrkBadNumber:
         cmp     #'0'
         bcc     swapP373N933brkBadNumber
         cmp     #':'
         bcs     swapP373N933brkBadNumber
         rts

swapP373N933brkBadNumber:
         jsr     swap7PWSP_373_N933
brkBadNumber:
         jsr     ReloadFSMandDIR_ThenBRK
         .byte   $dc
         .asciiz "Bad number"

;*******************************************************************************
;* *AUDIO <N>                                                                  *
;*                                                                             *
;* Sends an A or B F-command                                                   *
;*                                                                             *
;* <N>     Command Descr                                                       *
;* 0       A0      Both channels off                                           *
;* 1       A1      Ch.1 on,   Ch.2 off                                         *
;* 2       B0      Ch.1 off   Ch.2 on                                          *
;* 3       B1      Ch.1 on    Ch.2 on                                          *
;*******************************************************************************
starAUDIO:
         ZEROY
         jsr     parse8bitDecA
         cmp     #$04
         bcs     swapP373N933brkBadNumber
         pha
         ldx     #'A'
         stx     WKSP_VFS_E00_TXTBUF
         and     #$01
         jsr     sk
         inc     WKSP_VFS_E00_TXTBUF
         pla
         lsr     A
sk:      ora     #$30
         sta     WKSP_VFS_E00_TXTBUF+1
         lda     #$0d
         sta     WKSP_VFS_E00_TXTBUF+2
         jmp     FCMD_TextBuf

;*******************************************************************************
;* *FAST - <direction>                                                         *
;*                                                                             *
;* Move at 3*play speed, in direction 0..127 forwards, 128..255 backwards      *
;*******************************************************************************
starFAST:
         ZEROY
         jsr     parse8bitDecA
         bpl     @rewind
         lda     #LV_FCMD_Z_FastReverse
         bne     @send

@rewind: lda     #LV_FCMD_W_FastForwards
@send:   jmp     FCMD_Single_CharA

;*******************************************************************************
;* *SLOW <speed>,<direction>                                                   *
;*                                                                             *
;* 5>=speed>=254                                                               *
;* direction                                                                   *
;*******************************************************************************
starSLOW:
         ZEROY
         lda     #','       ;expect comma separator
         jsr     Parse8bitDecATerminA
         sty     WKSP_VFS_E00_TXTBUF+16 ;stash Y pointer at offset 16
         eor     #$ff       ;invert number
         cmp     #$02       ;check for bounds
         bcc     swapP373N933brkBadNumber
         cmp     #$fb
         bcs     swapP373N933brkBadNumber
         jsr     bit8DecimalToStringAtBuf1 ;place inverted(!) number in buffer
         lda     #LV_FCMD_S_SetSlowSpeed
         sta     WKSP_VFS_E00_TXTBUF
         jsr     FCMD_TextBuf ;set slow speed
         ldy     WKSP_VFS_E00_TXTBUF+16 ;get back stashed Y
         jsr     parse8bitDecA ;parse direction
         bpl     @forwards  ;forwards
         lda     #LV_FCMD_V_SlowReverse ;slow reverse
         jmp     FCMD_Single_CharA

@forwards:
         lda     #LV_FCMD_U_SlowForward
         jmp     FCMD_Single_CharA

; Skip over commas/spaces - looks like it will skip over multiple commas
skipCommaOrSpace:
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #','
         beq     @sk
         cmp     #' '
         bne     @ex
@sk:     iny
         bne     skipCommaOrSpace
@ex:     rts

;*******************************************************************************
;* place a 3 digit decimal representation of A in the buffer at offset 1 and   *
;* terminate with a <CR>                                                       *
;*******************************************************************************
bit8DecimalToStringAtBuf1:
         ldx     #100
         jsr     @digit
         pha
         tya
         ora     #'0'
         sta     WKSP_VFS_E00_TXTBUF+1
         pla
         ldx     #$0a
         jsr     @digit
         ora     #'0'
         sta     WKSP_VFS_E00_TXTBUF+3
         tya
         ora     #'0'
         sta     WKSP_VFS_E00_TXTBUF+2
         lda     #$0d
         sta     WKSP_VFS_E00_TXTBUF+4
         rts

@digit:  stx     WKSP_VFS_E00_TXTBUF+17
         sec
         ldy     #$ff
@lp:     sbc     WKSP_VFS_E00_TXTBUF+17
         iny
         bcs     @lp
         adc     WKSP_VFS_E00_TXTBUF+17
         rts

FCMD_N_then_E1:
         lda     #LV_FCMD_N_PlayForwards-150
         jsr     FCMD_Single_CharA
         jmp     FCMD_E1_VideoOn

;*******************************************************************************
;* *PLAY [<start>[,<end>]]                                                     *
;*******************************************************************************
starPLAY:
         ZEROY
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #$0d
         beq     FCMD_N_then_E1 ;no parameter just play
         jsr     parse16BitToYX
         stx     VFS_N937_PlayStart
         sty     VFS_N937_PlayStart+1
         ZEROY
         jsr     @skip2ndNumber
         jsr     parse16BitToYX
         lda     #LV_FCMD_O_PlayBackwards
         cpy     VFS_N937_PlayStart+1 ;compare start/end and decide on direction
         beq     @Yeq
         bcc     @Xlt
         bcs     @Yge

@Yeq:    cpx     VFS_N937_PlayStart
         bcc     @Xlt
@Yge:    lda     #LV_FCMD_N_PlayForwards-150
@Xlt:    pha                ;stash play command
         jsr     starFRAME  ;set starting frame
         ZEROY
         jsr     @skip2ndNumber
         lda     #LV_FCMD_F_TERM_S_HALT
         jsr     parseDigitsBuildFCMD_F_TermA
         jsr     FCMD_TextBuf ;set ending frame number
         pla                ;get back play direction command stashed above
         jmp     FCMD_Single_CharA ;start playing

@skip2ndNumber:
         lda     (zp_vfsv_a8_textptr),Y
         iny
         cmp     #' '
         beq     @skSpace
         cmp     #$0d
         beq     jmpSwBrkBadNumber
         cmp     #','
         bne     @skip2ndNumber
@skSpace:
         jmp     skipCommaOrSpace

;*******************************************************************************
;* The command tail is parsed for digits which are entered into the SCSI       *
;* command buffer preceded by F Command "F".                                   *
;*                                                                             *
;* If no digits, non-digits, or >5 digits a BRK Bad number is issued           *
;*                                                                             *
;* The command is terminated by the code passed in 'A' which should be:        *
;* 'N'     Search then play                                                    *
;* 'Q'     Search then continue                                                *
;* 'R'     Search then halt       *SEARCH                                      *
;* 'S'     Play until this frame  *PLAY                                        *
;*******************************************************************************
parseDigitsBuildFCMD_F_TermA:
         pha
         jsr     skipCommaOrSpace
@lpSkipZeroes:
         lda     (zp_vfsv_a8_textptr),Y
         iny
         cmp     #'0'
         beq     @lpSkipZeroes
         dey
         ldx     #$00       ;text buffer pointer = 0
@lp:     lda     (zp_vfsv_a8_textptr),Y
         cmp     #$0d
         beq     @term
         cmp     #' '
         beq     @term
         cmp     #','
         beq     @term
         jsr     checkDecDigitBrkBadNumber
         sta     WKSP_VFS_E00_TXTBUF+1,X
         inx
         cpx     #$06
         bcs     jmpSwBrkBadNumber
         iny
         bne     @lp
@term:   lda     #LV_FCMD_F_GOTOFRAME
         sta     WKSP_VFS_E00_TXTBUF
         pla
         sta     WKSP_VFS_E00_TXTBUF+1,X
         lda     #$0d
         sta     WKSP_VFS_E00_TXTBUF+2,X
         rts

jmpSwBrkBadNumber:
         jmp     swapP373N933brkBadNumber

parse16BitToYX:
         jsr     parse16bitDecXA
         bcs     jmpSwBrkBadNumber
         pha
         txa
         tay
         plx
         rts

LAF3D:   lda     VFS_0D92_FLAG_POLL100
         beq     LAF4D
         lda     #$18
         sta     sheila_USRVIA_ier
         jsr     LB022
         stz     VFS_0D92_FLAG_POLL100
LAF4D:   rts

LAF4E:   jsr     RestoreZpAndPage9
         jsr     ReloadFSMandDIR_ThenBRK
         .byte   $95
         .asciiz "IRQ already indirected"
VFSstarMOUSE:
         ZEROY
         jsr     skipCommaOrSpace
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #$0d
         beq     @LAF84
         jsr     parse16bitDecXA
         bcc     @LAF80
         jmp     restoreP9BrkBadNumber

@LAF80:  and     #$01
         beq     LAF3D
@LAF84:  ldx     VFS_0D92_FLAG_POLL100
         bne     LAF4D
         lda     VFS_N924_PTR_Q-1
         bne     LAF4E
         stx     VFS_N90D_MOUSE_BUTTON_STILL_ACTIVE                     ; X = 0
         stx     VFS_N909_MOUSEVISIBLE
         dex
         stx     VFS_0D92_FLAG_POLL100      ; X = 255
         stx     VFS_N90A_MOUSE_TYPE
         lda     sheila_USRVIA_pcr
         and     #$0f
         sta     sheila_USRVIA_pcr
         lda     sheila_USRVIA_acr
         and     #$fc
         sta     sheila_USRVIA_acr
         lda     #$98
         sta     sheila_USRVIA_ier
         lda     #$00
         sta     sheila_USRVIA_ddrb
         lda     #$80
         sta     VFS_N904_MousePos          ; centre mouse pointer 640x512
         lda     #$02
         sta     VFS_N904_MousePos+1
         lda     #$00
         sta     VFS_N904_MousePos+2
         lda     #$02
         sta     VFS_N904_MousePos+3
         lda     #$7f
         sta     VFS_N900_MouseBounds
         sta     VFS_N900_MouseBounds+1
         lda     #$00
         sta     VFS_N900_MouseBounds+2
         sta     VFS_N900_MouseBounds+3
         rts
; *POINTER (0/1/2)
; ----------------
; *POINTER 0 - hides pointer
; *POINTER 1 - shows pointer (default)
; *POINTER 2 - hides pointer and turns off *MOUSE
VFSstarPOINTER:
         ZEROY
         jsr     skipCommaOrSpace
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #$0d
         bne     @LAFEA         ; can be reorganised to avoid this branch
         lda     #$01
         bne     @LAFF2

@LAFEA:  jsr     parse16bitDecXA
         bcc     @LAFF2
         jmp     restoreP9BrkBadNumber

@LAFF2:  ldy     #$18
         sty     sheila_USRVIA_ier
         pha
         and     #$02
         bne     @LB001
         lda     #$98                   ; Disable mouse interrupts
         sta     sheila_USRVIA_ier
@LB001:  pla
         and     #$01
         beq     LB022                      ; *pointer 0 /2
         lda     VFS_0D92_FLAG_POLL100      ; * pointer 1
         beq     LB021
         lda     VFS_N909_MOUSEVISIBLE
         bne     LB021                      ; if already shown don't show it again
         lda     #$ff
         sta     ZP_Previous_mouse_screenptr+1 ; Domesday appears endup here when the mouse stops moveing causing a flicker !!!!!
         jsr     Setup_mouse_pointer_workspace
         ldy     VFS_N904_MousePos
         dey
         sty     VFS_N90E_PreviousMousePos
         dec     VFS_N909_MOUSEVISIBLE
LB021:   rts

LB022:   lda     VFS_N909_MOUSEVISIBLE                ; If mouse is already hidden, don't hide it again
         beq     LB021
         stz     VFS_N909_MOUSEVISIBLE
.ifdef VFS_Pi1MHz_Mouse_Redirect
         lda     #255
         sta     MOUSE_REDIRECT+4
.endif
         lda     sheila_ACCON
         sta     VFS_N932_ACCON_SAVE
         and     #$fb
         bit     #$02
         beq     @LB038
         ora     #$04
@LB038:  sta     sheila_ACCON
         jsr     Restore_memory_under_mouse
         lda     VFS_N932_ACCON_SAVE
         sta     sheila_ACCON
         rts
; Update pointer if mouse has moved
; ---------------------------------
Move_Pointer_if_mouse_moved:
         lda     VFS_N904_MousePos      ; Current ADVAL(7) low byte
         cmp     VFS_N90E_PreviousMousePos
         bne     @LB065                 ; Mouse X has moved
         lda     VFS_N904_MousePos+2    ; Current ADVAL(8) low byte
         cmp     VFS_N90E_PreviousMousePos+2
         bne     @LB065                 ; Mouse Y has moved
         lda     VFS_N904_MousePos+1    ; Current ADVAL(7) high byte
         cmp     VFS_N90E_PreviousMousePos+1
         bne     @LB065                 ; Mouse X has moved
         lda     VFS_N904_MousePos+3    ; Current ADVAL(8) high byte
         cmp     VFS_N90E_PreviousMousePos+3
         beq     LB021                  ; Mouse Y has NOT moved
; Mouse has moved
@LB065:  lda     sheila_ACCON
         sta     VFS_N932_ACCON_SAVE
         and     #$fb
         bit     #$02
         beq     @LB073
         ora     #$04                   ; select shadow memory for access
@LB073:  sta     sheila_ACCON
         lda     VFS_N904_MousePos+2    ; Copy current mouse XY to previous mouse XY
         sta     VFS_N90E_PreviousMousePos+2
         lda     VFS_N904_MousePos+3
         sta     VFS_N90E_PreviousMousePos+3
         lda     VFS_N904_MousePos
         sta     VFS_N90E_PreviousMousePos
         lda     VFS_N904_MousePos+1
         sta     VFS_N90E_PreviousMousePos+1

         cmp     VFS_N900_MouseBounds+1  ; X coordinate
         bcc     @X_HIGH_LT                 ; less than
         beq     @X_HIGH_EQ                 ; Equal
         bcs     @X_HIGH_GT                 ; greater than

@X_HIGH_EQ:
         lda     VFS_N904_MousePos
         cmp     VFS_N900_MouseBounds
         bcc     @X_HIGH_LT                 ; If within X limit, continue
@X_HIGH_GT:
         lda     VFS_N90B_MOUSE_POINTER_TYPE                      ; not really sure why we load the prevoius mouse type here as we are going to over bits 0 and 1
         ora     #$01                       ; set bit 0 ( pointer 1 or 3)
         bne     @Test_bounds_Y             ; always taken

@X_HIGH_LT:
         lda     VFS_N90B_MOUSE_POINTER_TYPE
         and     #$02                       ; clear bit 0 ( pointer 0 or 2)

@Test_bounds_Y:
         tay
         lda     VFS_N904_MousePos+3
         cmp     VFS_N900_MouseBounds+3
         bcc     @Y_HIGH_LT
         beq     @Y_HIGH_EQ
         bcs     @Y_HIGH_GT

@Y_HIGH_EQ:
         lda     VFS_N904_MousePos+2
         cmp     VFS_N900_MouseBounds+2
         bcc     @Y_HIGH_LT
@Y_HIGH_GT:
         tya
         ora     #$02                      ; set bit 1 ( pointer 2 or 3)
         bne     @Check_if_new_pointer     ; always taken

@Y_HIGH_LT:
         tya
         and     #$01                       ; clear bit 1 ( pointer 0 or 1)

@Check_if_new_pointer:
         cmp     VFS_N90B_MOUSE_POINTER_TYPE
         beq     @LB0D0
         jsr     Setup_mouse_pointer_workspace   ; ( NB pointer type may have changed if the mouse has moved out of bounds )

@LB0D0:  ldy     VFS_N904_MousePos
         lda     VFS_N908_MODESAVE
         cmp     #$02
         bne     @LB0E9                     ; screen mode 0  or 1

         ; screen mode 2
         lda     VFS_N904_MousePos+1        ; X high byte
         cmp     #$04
         bne     @LB0E9

         cpy     #$f8                       ; X low byte
         bcc     @LB0E9
         ; mouse on the right of the screen
         dey
         dey
         dey
         dey

@LB0E9:
         ldx     VFS_N90B_MOUSE_POINTER_TYPE
         tya

         sec
         sbc     LB9A0,X                     ; 20, 24, 4, 40
         sta     VFS_N912_MouseX
.ifdef VFS_Pi1MHz_Mouse_Redirect
         sta     MOUSE_REDIRECT
.endif
         lda     VFS_N904_MousePos+1
         sbc     #$00
         sta     VFS_N912_MouseX+1
.ifdef VFS_Pi1MHz_Mouse_Redirect
         sta     MOUSE_REDIRECT +1
.endif
         lda     LB9A4,X                     ; 28, 20, 4, 4
         clc
         adc     VFS_N904_MousePos+2
         sta     VFS_N916_MouseY
.ifdef VFS_Pi1MHz_Mouse_Redirect
         sta     MOUSE_REDIRECT + 2
.endif
         lda     VFS_N904_MousePos+3
         adc     #$00
         sta     VFS_N916_MouseY+1
.ifdef VFS_Pi1MHz_Mouse_Redirect
         sta     MOUSE_REDIRECT + 3
         stx     MOUSE_REDIRECT + 4
.endif
         jsr     LB44C                  ; returns X = 0-3
         ldy     ZP_MOS_CURROM
         lda     SYSVARS_DF0_PWSKPTAB,Y
         inc     A
         sta     ZP_EXTRA_BASE+1        ; the mouse pointer as previously been copied to the workspace
         lda     LB990,X                ; get pointer to the correct shifted sprite
         sta     ZP_EXTRA_BASE
         jsr     Restore_memory_under_mouse

         lda     VFS_N912_MouseX
         sta     VFS_N914_MouseX2
         lda     VFS_N912_MouseX+1
         sta     VFS_N914_MouseX2+1
         lda     ZP_EXTR_PTR_B + 1
         pha
         lda     ZP_EXTR_PTR_B
         pha
         lda     ZP_EXTR_PTR_B + 1
         pha
         lda     ZP_EXTR_PTR_B
         pha
         ldx     #$00
         stx     ZP_TEMP3

@LB13D:  ldy     #$00
         sty     ZP_TEMP2
         lda     ZP_EXTR_PTR_B + 1
         bmi     @LB1A5
         cmp     #$30
         bcc     @LB199
         lda     VFS_N912_MouseX+1
         bmi     @LB1A5
         cmp     #$05
         bcc     @LB155
         jmp     @LB1D4

@LB155:  ldy     ZP_TEMP2
         lda     (ZP_EXTR_PTR_B),Y            ; get screen byte
         ldy     ZP_TEMP3
         sta     (ZP_EXTR_PTR_A ),Y            ; store old memory location
         inc     ZP_EXTRA_BASE+1

.ifdef VFS_OPTIMISE
         and     (ZP_EXTRA_BASE),Y             ; get sprite byte mask
         dec     ZP_EXTRA_BASE+1
                                               ; saves 11 cycles and 7 bytes
.else
         lda     (ZP_EXTRA_BASE),Y             ; get sprite byte mask
         dec     ZP_EXTRA_BASE+1
         ldy     ZP_TEMP2
         and     (ZP_EXTR_PTR_B),Y            ; mask pixels ( surely to the mask the other way around as A had the screen byte
         ldy     ZP_TEMP3
.endif
         ora     (ZP_EXTRA_BASE),Y  ; or in spite
         ldy     ZP_TEMP2
         sta     (ZP_EXTR_PTR_B),Y            ; save back to screen
         inc     ZP_TEMP3
         lda     ZP_TEMP3
         and     #$0f
         beq     @LB1AE
.ifdef VFS_OPTIMISE
         iny                    ; 2 cycles
         tya                    ; 2 cycles
         sta     ZP_TEMP2       ; 3 cycles
.else
         inc     ZP_TEMP2       ; 5 cycles
         lda     ZP_TEMP2       ; 3 cycles
.endif
         clc
         adc     ZP_EXTR_PTR_B
         and     #$07
         bne     @LB155

@LB182:
.ifdef VFS_OPTIMISE
.else
         ldy     VFS_N908_MODESAVE
.endif
         lda     ZP_EXTR_PTR_B
         and     #$f8
         clc
.ifdef VFS_OPTIMISE
         adc     #128 ; LB98A,Y ; Always 128   ( 640)
         sta     ZP_EXTR_PTR_B
         lda     ZP_EXTR_PTR_B + 1
         adc     #2 ; LB98D,Y ; Always 2
.else
         adc     LB98A,Y ; Always 128   ( 640)
         sta     ZP_EXTR_PTR_B
         lda     ZP_EXTR_PTR_B + 1
         adc     LB98D,Y ; Always 2
.endif
         sta     ZP_EXTR_PTR_B + 1
         jmp     @LB13D

@LB199:  lda     ZP_EXTR_PTR_B
         and     #$07
         clc
         adc     ZP_TEMP3
         sta     ZP_TEMP3
         jmp     @LB182

@LB1A5:  lda     ZP_TEMP3
         and     #$f0
         clc
         adc     #$10
         sta     ZP_TEMP3

@LB1AE:  lda     VFS_N912_MouseX
         clc
         adc     #$10
         sta     VFS_N912_MouseX
         bcc     @LB1BC
         inc     VFS_N912_MouseX+1
@LB1BC:  pla
         clc
         adc     #$08
         sta     ZP_EXTR_PTR_B
         pla
         adc     #$00
         sta     ZP_EXTR_PTR_B + 1
         pha
         lda     ZP_EXTR_PTR_B
         pha
         lda     ZP_TEMP3
         cmp     #$40
         beq     @LB1D4
         jmp     @LB13D

@LB1D4:  pla
         pla
         pla
         sta     ZP_Previous_mouse_screenptr
         pla
         sta     ZP_Previous_mouse_screenptr+1
         lda     VFS_N932_ACCON_SAVE
         sta     sheila_ACCON
         rts

RestoreZpAndPage9:
         lda     ZP_Previous_mouse_screenptr
         sta     VFS_N924_PTR_Q
         lda     ZP_Previous_mouse_screenptr+1
         sta     VFS_N924_PTR_Q+1
         ldx     #$0c
@lp:     lda     VFS_N926_ZPSAVE,X
         sta     ZP_EXTRA_BASE,X
         dex
         bpl     @lp
swapPage9AndPrivWkspP3:
         pha
         phx
         phy
         lda     ZP_EXTRA_BASE
         pha
         lda     ZP_EXTRA_BASE+1
         pha
         ldx     ZP_MOS_CURROM
         lda     SYSVARS_DF0_PWSKPTAB,X
         clc
         adc     #$03       ;save page 900 to 3rd page of private workspace
         sta     ZP_EXTRA_BASE+1
         lda     #$40
         sta     ZP_EXTRA_BASE
         ldy     #$32
@lp:     ldx     VFS_N900,Y
         lda     (ZP_EXTRA_BASE),Y
         sta     VFS_N900,Y
         txa
         sta     (ZP_EXTRA_BASE),Y
         dey
         bpl     @lp
         pla
         sta     ZP_EXTRA_BASE+1
         pla
         sta     ZP_EXTRA_BASE
         ply
         plx
         pla
         rts

PreserveZpAndPage9:
         jsr     swapPage9AndPrivWkspP3
         ldx     #ZP_EXTRA_LEN
@lp:     lda     ZP_EXTRA_BASE,X
         sta     VFS_N926_ZPSAVE,X
         dex
         bpl     @lp
         lda     VFS_N924_PTR_Q
         sta     ZP_Previous_mouse_screenptr
         lda     VFS_N924_PTR_Q+1
         sta     ZP_Previous_mouse_screenptr+1
LB23Frts:
         rts

Restore_memory_under_mouse:
         ldy     ZP_MOS_CURROM
         lda     SYSVARS_DF0_PWSKPTAB,Y
         clc
         adc     #$03
         sta     ZP_EXTR_PTR_A + 1      ; setup pointer the old screen data  ( 3rd page of private workspace)
         stz     ZP_EXTR_PTR_A
         lda     ZP_Previous_mouse_screenptr+1
         bmi     LB23Frts
         pha
         lda     ZP_Previous_mouse_screenptr
         pha
         ldy     #$00
         sty     ZP_TEMP3
@LB258:  ldy     #$00
         sty     ZP_TEMP2
         lda     ZP_Previous_mouse_screenptr+1
         bmi     @LB2C5
         cmp     #$30
         bcc     @LB2D1
         lda     VFS_N914_MouseX2+1
         bmi     @LB2C5
         cmp     #$05
         bcs     @LB2C2

@LB26D:  ldy     ZP_TEMP3
         lda     (ZP_EXTR_PTR_A ),Y         ; get old screen byte
         ldy     ZP_TEMP2
         sta     (ZP_Previous_mouse_screenptr),Y          ; put it back over the mouse pointer
         inc     ZP_TEMP3
         lda     ZP_TEMP3
         and     #$0f
         beq     @LB29F
         inc     ZP_TEMP2
         lda     ZP_TEMP2
         clc
         adc     ZP_Previous_mouse_screenptr
         and     #$07
         bne     @LB26D
@LB288:
.ifdef VFS_OPTIMISE
         lda     ZP_Previous_mouse_screenptr
         and     #$f8
         clc
         adc     #128 ; LB98A,Y ; Always 128   ( 640)
         sta     ZP_Previous_mouse_screenptr
         lda     ZP_Previous_mouse_screenptr+1
         adc     #2 ; LB98D,Y ; Always 2
.else
         ldy     VFS_N908_MODESAVE
         lda     ZP_Previous_mouse_screenptr
         and     #$f8
         clc
         adc     LB98A,Y                ; always 128 ( 640)
         sta     ZP_Previous_mouse_screenptr
         lda     ZP_Previous_mouse_screenptr+1
         adc     LB98D,Y                ; always 2
.endif
         sta     ZP_Previous_mouse_screenptr+1
         jmp     @LB258

@LB29F:  lda     VFS_N914_MouseX2
         clc
         adc     #$10
         sta     VFS_N914_MouseX2
         bcc     @LB2AD
         inc     VFS_N914_MouseX2+1
@LB2AD:  pla
         clc
         adc     #$08
         sta     ZP_Previous_mouse_screenptr
         pla
         adc     #$00
         sta     ZP_Previous_mouse_screenptr+1
         pha
         lda     ZP_Previous_mouse_screenptr
         pha
         ldy     ZP_TEMP3
         cpy     #$40                  ; do all 64 bytes of mouse pointer
         bne     @LB258
@LB2C2:  pla
         pla
         rts

@LB2C5:  lda     ZP_TEMP3
         and     #$f0
         clc
         adc     #$10
         sta     ZP_TEMP3
         jmp     @LB29F

@LB2D1:  lda     ZP_Previous_mouse_screenptr
         and     #$07
         clc
         adc     ZP_TEMP3
         sta     ZP_TEMP3
         jmp     @LB288

ERR_BAD_MODE:
         jsr     RestoreZpAndPage9
         jsr     ReloadFSMandDIR_ThenBRK

         .byte $ad
         .asciiz "Bad MODE"

Setup_mouse_pointer_workspace:
         sta     VFS_N90B_MOUSE_POINTER_TYPE                  ; Entry a= 0 1 2 , 255 ( effectively 3)
.ifdef VFS_OPTIMISE
         ror    A
         ROR    A
         ROR    A
         and   #$c0
.else
         asl     A
         asl     A
         asl     A
         asl     A
         asl     A
         asl     A                      ; *64  so we have 0 64 128 192
.endif
         tay
         lda     VFS_N908_MODESAVE
         cmp     #$03
         bcs     ERR_BAD_MODE                  ; Bad MODE
         pha
.ifndef VFS_OPTIMISE
         clc                                   ; Already clear from BCS above
.endif
         adc     #>LB9A8                       ; mouse symbol table +  mode*256
         sta     ZP_EXTRA_BASE+1
         lda     #<LB9A8
         sta     ZP_EXTRA_BASE

         pla
         clc
         adc     #>LBCA8                       ; mask table +  mode*256
         sta     ZP_EXTR_PTR_A + 1
         lda     #<LBCA8
         sta     ZP_EXTR_PTR_A

         ldx     ZP_MOS_CURROM
         lda     SYSVARS_DF0_PWSKPTAB,X
         inc     A
         sta     ZP_EXTR_PTR_B + 1            ; >workspace+1
         stz     ZP_EXTR_PTR_B

         sty     ZP_TEMP3                     ; table index ( which one of the 4 pointers)
         ldy     #$00                         ; why not STZ ????
         sty     ZP_TEMP2

@loop64bytes:
         ldy     ZP_TEMP3
         lda     (ZP_EXTRA_BASE),Y          ; get mouse pointer byte
         ldy     ZP_TEMP2
         sta     (ZP_EXTR_PTR_B),Y          ; store mouse pointer byte wksp+1
         ldy     ZP_TEMP3
         lda     (ZP_EXTR_PTR_A ),Y         ; get mouse mask byte
         ldy     ZP_TEMP2
         inc     ZP_EXTR_PTR_B + 1          ; wksp+2
         sta     (ZP_EXTR_PTR_B),Y          ; store mouse mask byte at wksp+2
         dec     ZP_EXTR_PTR_B + 1          ; restore wksp+2 to wksp+1
         inc     ZP_TEMP3                   ; inc get pointer
         inc     ZP_TEMP2                   ; inc store pointer
         ldy     ZP_TEMP2
         cpy     #$40                       ; do 64 bytes
         bne     @loop64bytes

         stz     ZP_EXTRA_BASE
         lda     #$40
         sta     ZP_EXTR_PTR_A              ; pointer to after mouse sprite
         ldx     ZP_MOS_CURROM
         lda     SYSVARS_DF0_PWSKPTAB,X
         inc     A
         sta     ZP_EXTRA_BASE+1            ; pointer to beginning of mouse sprite
         sta     ZP_EXTR_PTR_A + 1

         lda     #$00
         sta     ZP_TEMP

         jsr     @LB36B

         stz     ZP_EXTRA_BASE
         lda     #$40
         sta     ZP_EXTR_PTR_A              ; pointer to after mouse sprite mask
         ldx     ZP_MOS_CURROM
         lda     SYSVARS_DF0_PWSKPTAB,X
         clc
         adc     #$02
         sta     ZP_EXTRA_BASE+1
         sta     ZP_EXTR_PTR_A + 1          ; pointer to beginning of mouse sprite mask
         dec     ZP_TEMP

; shift the mouse sprite and the mask to each of the 4 possible bit positions and store in the wrokspace
; then exit

        ; ZP_temp is 0 or 0xFF
@LB36B:  lda     VFS_N908_MODESAVE
         beq     @mode0         ; mode 0
         cmp     #$01
         beq     @mode1         ; mode 1
         jmp     @mode2         ; mode 2

@mode1:  jsr     @LB37D         ; mode 1
         jsr     @LB37D

@LB37D:  ldx     #$00           ; Called three times
@LB37F:  lda     ZP_TEMP
         cmp     #$ff
         lda     #$00
         php
@LB386:  sta     ZP_TEMP3       ; first time = 0
         txa                    ; first time x = 0
         ora     ZP_TEMP3
         tay
         lda     (ZP_EXTRA_BASE),Y          ; pointer to beginning of mouse sprite/mask
         plp
         bcs     @LB395
         and     #$ef
         bcc     @LB397         ; always branch

@LB395:  ora     #$10
@LB397:  bit     ZP_TEMP
         bmi     @LB39C
         clc
@LB39C:  ror     A
         php
         sta     (ZP_EXTR_PTR_A ),Y ;
         lda     ZP_TEMP3
         clc
         adc     #$10
         cmp     #$40
         bne     @LB386
         plp
         inx
         cpx     #$10
         bne     @LB37F

@LB3AF:  lda     ZP_EXTRA_BASE+1
         sta     ZP_EXTR_PTR_A + 1
         lda     ZP_EXTR_PTR_A
         sta     ZP_EXTRA_BASE
         clc
         adc     #$40
         sta     ZP_EXTR_PTR_A
         bcc     @LB3C0
         inc     ZP_EXTR_PTR_A + 1
@LB3C0:  rts

@mode0:  jsr     @LB3C7     ; mode 0
         jsr     @LB3C7
@LB3C7:  jsr     @LB3D8
         lda     ZP_EXTRA_BASE+1
         sta     ZP_EXTR_PTR_A + 1
         lda     ZP_EXTR_PTR_A
         sta     ZP_EXTRA_BASE
         jsr     @LB3D8
         jmp     @LB3AF

@LB3D8:  ldx     #$00
@LB3DA:  lda     ZP_TEMP
         cmp     #$ff
         lda     #$00
         php
@LB3E1:  sta     ZP_TEMP3
         txa
         ora     ZP_TEMP3
         tay
         lda     (ZP_EXTRA_BASE),Y
         plp
         ror     A
         php
         sta     (ZP_EXTR_PTR_A ),Y
         lda     ZP_TEMP3
         clc
         adc     #$10
         cmp     #$40
         bne     @LB3E1
         plp
         inx
         cpx     #$10
         bne     @LB3DA
         rts

@mode2:  jsr     @LB440     ; mode 2
         jsr     @LB407
         jmp     @LB440

@LB407:  ldx     #$00
@LB409:  lda     ZP_TEMP
         cmp     #$ff
         lda     #$00
         php
@LB410:  sta     ZP_TEMP3
         txa
         ora     ZP_TEMP3
         tay
         lda     (ZP_EXTRA_BASE),Y
         and     #$aa
         lsr     A
         plp
         bcc     @LB426
         bit     ZP_TEMP
         bpl     @LB424
         ora     #$aa
@LB424:  ora     #$02
@LB426:  sta     (ZP_EXTR_PTR_A ),Y
         lda     (ZP_EXTRA_BASE),Y
         and     #$55
         lsr     A
         php
         lda     ZP_TEMP3
         clc
         adc     #$10
         cmp     #$40
         bne     @LB410
         plp
         inx
         cpx     #$10
         bne     @LB409
         jmp     @LB3AF

@LB440:  ldy     #$3f
@LB442:  lda     (ZP_EXTRA_BASE),Y
         sta     (ZP_EXTR_PTR_A ),Y
         dey
         bpl     @LB442
         jmp     @LB3AF

LB44C:   lda     VFS_N916_MouseY+1
         sta     ZP_EXTR_PTR_B
         lda     VFS_N916_MouseY

         lsr     ZP_EXTR_PTR_B
         ror     A

         lsr     ZP_EXTR_PTR_B
         ror     A

         sta     VFS_N916_MouseY  ; Y is now divided by 4

         lsr     A
         lsr     A
         lsr     A                ; Y is now divided by 8
         tax

         lda     VFS_N912_MouseX+1
         bpl     @LB467
         inx
@LB467:  lda     ZP_EXTR_PTR_B
         beq     @LB47B
         txa

         clc
         adc     #$20
         tax

         lda     VFS_N916_MouseY
         eor     #$07
         sta     VFS_N916_MouseY

         dec     VFS_N916_MouseY
@LB47B:
         lda     LB965,X
         sta     ZP_EXTR_PTR_B + 1
         lda     LB943,X   ; table return 0x80 for even X and 0x00 for odd.
         sta     ZP_EXTR_PTR_B
         lda     VFS_N912_MouseX+1
         bpl     @LB48D

         clc
         adc     #$05
@LB48D:
         sta     ZP_TEMP
         lda     VFS_N912_MouseX
         lsr     ZP_TEMP
         ror     A
         and     #$f8

         clc
         adc     ZP_EXTR_PTR_B
         sta     ZP_EXTR_PTR_B
         lda     ZP_TEMP
         adc     ZP_EXTR_PTR_B + 1
         sta     ZP_EXTR_PTR_B + 1

         lda     VFS_N916_MouseY
         and     #$07
         eor     #$07
         ora     ZP_EXTR_PTR_B
         sta     ZP_EXTR_PTR_B

         lda     VFS_N912_MouseX
         lsr     A
         lsr     A
         and     #$03
         tax                       ; return X = 0-3 to index into the sprite shifted table
         rts

OSBYTE_Extended_Vectorcode:
         cmp     #$80
         beq     @LB50A                 ; Jump with ADVAL
@LB4BA:  pha
         lda     VFS_OLD_BYTEV+1
         cmp     #$ff                   ; Jump if was exteneded
         beq     @LB4C6
         pla
         jmp     (VFS_OLD_BYTEV)                ; jump to old vector
; Old BYTEV was extended, fiddle around to vector via it
@LB4C6:  php
         sei
         phx
         phy
         ldx     #$03
@LB4CC:  lda     zp_vfsv_a8_textptr,X
         pha
         dex
         bpl     @LB4CC
         ldy     ZP_MOS_CURROM
         lda     SYSVARS_DF0_PWSKPTAB,Y
         clc
         adc     #$03
         sta     $ab
         stz     $aa
         ldy     #$5b
         lda     ($aa),Y
         clc
         adc     #$4e
         sta     zp_vfsv_a8_textptr
         iny
         lda     ($aa),Y
         sta     zp_vfsv_a8_textptr+1
         lda     #$5d
         sta     $aa
         ldy     #$02
@LB4F2:  lda     ($aa),Y
         sta     (zp_vfsv_a8_textptr),Y
         dey
         bpl     @LB4F2
         ldx     #$00
@LB4FB:  pla
         sta     zp_vfsv_a8_textptr,X
         inx
         cpx     #$04
         bne     @LB4FB
         ply
         plx
         plp
         pla
         jmp     $ff4e

; ADVAL handler
@LB50A:  cpx     #$09
         beq     @LB52F     ; ADVAL(9) - read buttons
         bcs     @LB4BA     ; ADVAL>9, pass on to oldBYTEV
         cpx     #$05
         bcc     @LB4BA     ; ADVAL<5, pass on to oldBYTEV
         php
         sei
         jsr     swapPage9AndPrivWkspP3
         txa
         asl     A
         adc     #$f6       ; Index into coordinates
         tay
         lda     VFS_N900,Y
         tax
         iny
         lda     VFS_N900,Y
         tay
         jsr     swapPage9AndPrivWkspP3
         plp
@LB52B:  lda     #$80
         clv
         rts
; ADVAL(9) - read buttons
@LB52F:  php
         sei
         jsr     swapPage9AndPrivWkspP3
         jsr     Get_Pointer_TypeX
         lda     sheila_USRVIA_orb
         cpx     #$00
         beq     @LB542         ; If &00, buttons in b0-b3
         rol     A              ; Move buttons from b5-b6 into b0-b3
         rol     A
         rol     A
         rol     A
@LB542:  and     #$07
         eor     #$07
         tax
         jsr     swapPage9AndPrivWkspP3
         plp
         ldy     #$00
         beq     @LB52B

Extended_IRQ1_Vector:
         cld
         lda     sheila_USRVIA_ier   ; Check user port CB1/CB2
         and     sheila_USRVIA_ier-1
         and     #$18
         bne     LB567                              ; Mouse moved
         lda     #>(LB567-1) ; rts_call_via_rti
         pha
         lda     #<(LB567-1) ; rts_call_via_rti
         pha
         php
         lda     $fc
         jmp     (VFS_D9D_OLD_IRQ1V)                ; Pass on to oldIRQ1V

         rts

LB567:  phx
         ldx     sheila_USRVIA_orb
         phy
         tay
         lda     ZP_EXTRA_BASE
         pha
         lda     ZP_EXTRA_BASE+1
         pha
         phx
         phy
         ldy     ZP_MOS_CURROM
         lda     SYSVARS_DF0_PWSKPTAB,Y
         clc
         adc     #$03
         sta     ZP_EXTRA_BASE+1
         lda     #$44
         sta     ZP_EXTRA_BASE
         jsr     swapZPEXTRA6with904
         ply
         jsr     Get_Pointer_TypeX
         tya
         and     #$10
         beq     @LB5CC
         pla
         pha
         and     LB6CC,X
         beq     @LB5B3
         lda     VFS_N904_MousePos+1
         cmp     #$04
         bne     @LB5A4
         lda     VFS_N904_MousePos
         cmp     #$fc
         bcs     @LB5CC
@LB5A4:  lda     VFS_N904_MousePos
         adc     #$04
         sta     VFS_N904_MousePos
         bcc     @LB5B1
         inc     VFS_N904_MousePos+1
@LB5B1:  bra     @LB5CC

@LB5B3:  lda     VFS_N904_MousePos
         ora     VFS_N904_MousePos+1
         beq     @LB5CC
         lda     VFS_N904_MousePos
         sec
         sbc     #$04
         sta     VFS_N904_MousePos
         lda     VFS_N904_MousePos+1
         sbc     #$00
         sta     VFS_N904_MousePos+1
@LB5CC:  tya
         and     #$08
         beq     @LB609
         pla
         and     LB6CB,X
         beq     @LB5F1
         lda     VFS_N904_MousePos+3
         cmp     #$03
         lda     VFS_N904_MousePos+2
         bcc     @LB5E5
         cmp     #$fc
         bcs     @LB60A
@LB5E5:  adc     #$04
         sta     VFS_N904_MousePos+2
         bcc     @LB60A
         inc     VFS_N904_MousePos+3
         bra     @LB60A

@LB5F1:  lda     VFS_N904_MousePos+2
         ora     VFS_N904_MousePos+3
         beq     @LB60A
         lda     VFS_N904_MousePos+2
         sec
         sbc     #$04
         sta     VFS_N904_MousePos+2
         bcs     @LB60A
         dec     VFS_N904_MousePos+3
         bra     @LB60A

@LB609:  pla
@LB60A:  lda     sheila_USRVIA_orb
         jsr     swapZPEXTRA6with904
         pla
         sta     ZP_EXTRA_BASE+1
         pla
         sta     ZP_EXTRA_BASE
         ply
         plx
         lda     $fc
         rts

Serv15_Poll100Hz:
; Check if mouse has moved, if so, move pointer to follow it
         php
         dec     VFS_0D95_20Hz_CTDN     ; Dec. 20Hz ticker, exit if >=0
         bpl     @poh2
         pha
         lda     #$04
         sta     VFS_0D95_20Hz_CTDN     ; Reset ticker to 4
         lda     VFS_0D93_CTDN_SEARCH + 1
         bmi     @sk2
         lda     VFS_0D93_CTDN_SEARCH
         bne     @sk1
         dec     VFS_0D93_CTDN_SEARCH + 1
@sk1:    dec     VFS_0D93_CTDN_SEARCH
@sk2:    lda     VFS_0D92_FLAG_POLL100
         beq     @poh3
         phx
         phy
         jsr     PreserveZpAndPage9
         jsr     LB67E                  ; Insert keypress if button state has changed
         lda     VFS_N909_MOUSEVISIBLE
         beq     @poh4
         jsr     Move_Pointer_if_mouse_moved
@poh4:   jsr     RestoreZpAndPage9
         ply
         plx
@poh3:   pla
@poh2:   dey                ;decrement semaphore
.ifndef VFS_OPTIMISE
         cpy     #$00
.endif
         bne     @poh
.ifdef VFS_OPTIMISE
         tya
.else
         lda     #$00       ;if we're the last then cancel the service call
.endif
@poh:    plp
         rts

;Check pointing device type
Get_Pointer_TypeX:   ldx     VFS_N90A_MOUSE_TYPE
         bpl     @LB67D         ;  Exit if b7=0 ( mouse type already defiend )
         ldx     #$00
         lda     sheila_USRVIA_orb
         and     #$e0
         cmp     #$e0
         bne     @LB678             ; b5-b7 not all set, exit with X=&07
         lda     sheila_USRVIA_orb
         and     #$18
         cmp     #$18
         bne     @LB67A             ; b3-b4 not all set, exit with X=&00
         ldx     #$07
         bne     @LB67D             ; Exit with X=&07

@LB678:  ldx     #$07
@LB67A:  stx     VFS_N90A_MOUSE_TYPE
@LB67D:  rts

;Check if button state has changed
LB67E:   jsr     Get_Pointer_TypeX  ; Get device type to X
         lda     sheila_USRVIA_orb  ; Get buttons
         and     @LB6C7,X           ; Mask with button position for this device
         cmp     VFS_N90D_MOUSE_BUTTON_STILL_ACTIVE
         beq     @LB698             ; Button state is the same
         cmp     VFS_N90C_MOUSE_LAST_BUTTON  ; 90c isn't initialized  so we can miss the first button press
         sta     VFS_N90C_MOUSE_LAST_BUTTON  ; why isn't this after the BEQ below?
         beq     @LB697
         sta     VFS_N90D_MOUSE_BUTTON_STILL_ACTIVE             ; Set last button state to current button state
@LB697:  rts

@LB698:  stz     VFS_N90D_MOUSE_BUTTON_STILL_ACTIVE             ; Clear last button state
         lda     VFS_N90C_MOUSE_LAST_BUTTON
         cmp     @LB6C7,X           ; Compare current button state with button locations
         beq     @LB697             ; No buttons pressed, exit
         ldy     #$0d               ; Prepare Y=<cr> for button 1
         and     @LB6C8,X           ; Mask with button 1
         beq     @LB6BF             ; Button 1 pressed
         lda     VFS_N90C_MOUSE_LAST_BUTTON              ; Get last button state
         ldy     #$c0               ; Prepare Y=f0 for button 3
         and     @LB6CA,X           ; Mask with button 3
         beq     @LB6BF             ; Button 3 pressed
         ; else it must be button 2 so read the tab character
         lda     #OSBYTE_DB_RW_TABCODE
         ldx     #$00
         ldy     #$ff
         jsr     OSBYTE             ; Get TAB key character
         txa
         tay                        ; TAB char for button 2
@LB6BF:  lda     #OSBYTE_99_INS_BUF_CKESC
         ldx     #$00
         jmp     OSBYTE             ; Insert into keyboard buffer

; first input device
         .byte   $18            ; Direction bits ( is this actually used?)

@LB6C7:  .byte   $07            ; button mask
@LB6C8:  .byte   $01            ; button 1
         .byte   $02            ;
@LB6CA:  .byte   $04            ; button 3

LB6CB:   .byte   $10            ; Xdir
LB6CC:   .byte   $08            ; Ydir

; second input device
         .byte   $05            ; Direction bits ( is this actually used?)

         .byte   $e0            ; button mask
         .byte   $20
         .byte   $40
         .byte   $80

         .byte   $04
         .byte   $01

swapZPEXTRA6with904:
         ldy     #$06
@lp:     ldx     VFS_N904_MousePos,Y
         lda     (ZP_EXTRA_BASE),Y
         sta     VFS_N904_MousePos,Y
         txa
         sta     (ZP_EXTRA_BASE),Y
         dey
         bpl     @lp
         rts

swap7PWSP_373_N933:
         ldx     ZP_MOS_CURROM
         lda     SYSVARS_DF0_PWSKPTAB,X
         clc
         adc     #>VFS_PWSKP_373_SAVE_N933
         sta     $ad
         lda     #<VFS_PWSKP_373_SAVE_N933
         sta     $ac
         ldy     #$07
@lp:     ldx     VFS_N933_BASE,Y
         lda     ($ac),Y
         sta     VFS_N933_BASE,Y
         txa
         sta     ($ac),Y
         dey
         bpl     @lp
         rts

;*******************************************************************************
;* Parse string at ($A8),Y as a decimal number                                 *
;*                                                                             *
;* Cy set on exit for not a number or overflow                                 *
;*******************************************************************************
parse16bitDecXA:
         ldx     #$03
@slp:    lda     VFS_N93B_TEMPBUF,X    ;save 93b-93d on stack for workspace (TODO: why not ZP?)
         pha
         dex
         bpl     @slp
         lda     #$00       ;zero accumulator
         sta     VFS_N93B_TEMPBUF
         sta     VFS_N93B_TEMPBUF+1
         sec
         php
         jsr     skipCommaOrSpace
@charlp: lda     (zp_vfsv_a8_textptr),Y
         cmp     #' '
         beq     @sksep
         cmp     #','
         beq     @sksep
         cmp     #$0d
         beq     @sksep
         cmp     #'0'
         bcc     @skError
         cmp     #':'
         bcs     @skError
; multiply current accumulator by 10, check for overflows
         lda     VFS_N93B_TEMPBUF
         sta     VFS_N93B_TEMPBUF+2
         lda     VFS_N93B_TEMPBUF+1
         sta     VFS_N93B_TEMPBUF+3
         lda     VFS_N93B_TEMPBUF
         asl     A
         rol     VFS_N93B_TEMPBUF+1
         bcs     @skError
         asl     A
         rol     VFS_N93B_TEMPBUF+1
         bcs     @skError
         adc     VFS_N93B_TEMPBUF+2
         sta     VFS_N93B_TEMPBUF
         lda     VFS_N93B_TEMPBUF+1
         adc     VFS_N93B_TEMPBUF+3
         bcs     @skError
         sta     VFS_N93B_TEMPBUF+1
         asl     VFS_N93B_TEMPBUF
         rol     VFS_N93B_TEMPBUF+1
         bcs     @skError
; get char back
         lda     (zp_vfsv_a8_textptr),Y
         and     #$0f
         clc
; add in and check for overflow
         adc     VFS_N93B_TEMPBUF
         sta     VFS_N93B_TEMPBUF
         bcc     @cysk
         inc     VFS_N93B_TEMPBUF+1
         beq     @skError
@cysk:   plp
         clc                ;clear carry error flag
         php
         iny
         bne     @charlp
@skError:
         plp
         sec                ;set carry for error flag
         php
@sksep:  plp                ;pop cy flag as set in routine
         lda     VFS_N93B_TEMPBUF      ;get low accumulator byte
         sta     $af        ;store in here briefly ; TODO: could have used this above!
         ldx     VFS_N93B_TEMPBUF+1      ;load high byte to return
         pla
         sta     VFS_N93B_TEMPBUF
         pla
         sta     VFS_N93B_TEMPBUF+1
         pla
         sta     VFS_N93B_TEMPBUF+2
         pla
         sta     VFS_N93B_TEMPBUF+3
         lda     $af        ;get back low byte
         rts
; *TMAX <x>,<y>
VFSstarTMAX:
         ZEROY
         jsr     parse16bitDecXA ;get first parameter
         bcs     restoreP9BrkBadNumber
         phx
         pha
         jsr     skipCommaOrSpace
         jsr     parse16bitDecXA ;get second param
         bcs     pl2RestoreP9BrkBadNumber
         ldy     #$02
         jsr     storeMouseYptrAX ;save second param at offset Y=2
         pla                ;unstack first param
         plx
         dec     VFS_N90E_PreviousMousePos      ; Fake a mouse move to force a redraw incase the pointer has chnages
         ldy     #$00       ;save at offset 0
storeMouseYptrAX:
         and     #$fc       ;clear bottom bits
         sta     VFS_N900_MouseBounds,Y
         txa
         iny
         sta     VFS_N900_MouseBounds,Y
         rts

pl2RestoreP9BrkBadNumber:
         pla
         pla
restoreP9BrkBadNumber:
         jsr     RestoreZpAndPage9
         jmp     brkBadNumber

VFSstarTSET:
         ZEROY
         jsr     parse16bitDecXA
         bcs     restoreP9BrkBadNumber
         phx
         pha
         jsr     skipCommaOrSpace
         jsr     parse16bitDecXA
         bcs     pl2RestoreP9BrkBadNumber
         cpx     #$04       ;check for Y>=1024
         bcc     @setY
         txa
         bpl     @setY1020
         lda     #$00
         tax
         beq     @setY
@setY1020:
         lda     #$fc
         ldx     #$03
@setY:   ldy     #$06
         jsr     storeMouseYptrAX
         pla
         plx
         cpx     #$05       ;check for X>=1280
         bcc     @setX
         txa
         bpl     @setX1276
         lda     #$00       ;-ve X?! set to 0
         tax
         beq     @setX
@setX1276:
         lda     #$fc
         ldx     #$04
@setX:   ldy     #$04
         jmp     storeMouseYptrAX

;*******************************************************************************
;* VFS_FSC3_STARCMD - parse a star command - passed from FSCV 3                *
;*                                                                             *
;*******************************************************************************
VFS_FSC3_STARCMD:
         stx     zp_vfsv_a8_textptr
         sty     zp_vfsv_a8_textptr+1
         ldy     #$00
         lda     (zp_vfsv_a8_textptr),Y
         and     #$df
         cmp     #'L'
         bne     @LB822
         iny
         lda     (zp_vfsv_a8_textptr),Y
         and     #$df
         cmp     #'V'
         bne     @LB849
         iny
@LB822:  ldx     #$00
         sty     $aa
@LB826:  lda     (zp_vfsv_a8_textptr),Y
         and     #$df
         cmp     @LB8A9,X
         beq     @LB84A
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #'.'
         beq     @LB84E
         lda     @LB8A9,X
         bmi     @LB851
         ldy     $aa
@LB83C:  inx
         lda     @LB8A9,X
         bpl     @LB83C
         inx
         inx
         lda     @LB8A9,X
         bpl     @LB826
@LB849:  rts

@LB84A:  inx
         iny
         bne     @LB826
@LB84E:  iny
         bne     @LB860
@LB851:  dex
         lda     (zp_vfsv_a8_textptr),Y
         cmp     #' '
         beq     @LB860
         cmp     #'"'
         beq     @LB860
         cmp     #$0d
         bne     @LB849
@LB860:  inx
         lda     @LB8A9,X
         bpl     @LB860
         cpx     #$22
         beq     @LB86D
         jsr     skipCommaOrSpace
@LB86D:  tya
         clc
         adc     zp_vfsv_a8_textptr
         sta     zp_vfsv_a8_textptr
         bcc     @LB877
         inc     zp_vfsv_a8_textptr
@LB877:  lda     @LB8A9,X
         sta     $ab
         lda     @LB8A9+1,X
         sta     $aa
         phx
         jsr     swap7PWSP_373_N933
         plx
         cpx     #$94
         beq     @LB89D
         lda     VFS_N93A_SEARCHING_IN_PROGRESS
         beq     @LB892
         jsr     waitForSeek
@LB892:  jsr     FCMD_GetResult
         ldx     #$00
@LB897:  stz     WKSP_VFS_E00_TXTBUF,X
         dex
         bne     @LB897
@LB89D:  stz     VFS_N939_RETRY_CTR
         jsr     jmpIndAA
         jsr     swap7PWSP_373_N933
         pla
         pla
         rts

@LB8A9:  .byte   "AUDIO"
         .dbyt   starAUDIO
         .byte   "CHAPTER"
         .dbyt   starCHAPTER
         .byte   "EJECT"
         .dbyt   starEJECT
         .byte   "FAST"
         .dbyt   starFAST
         .byte   "FCODE"
         .dbyt   starFCODE
         .byte   "FRAME"
         .dbyt   starFRAME
         .byte   "PLAY"
         .dbyt   starPLAY
         .byte   "SEARCH"
         .dbyt   starSEARCH
         .byte   "SLOW"
         .dbyt   starSLOW
         .byte   "STEP"
         .dbyt   starSTEP
         .byte   "STILL"
         .dbyt   starSTILL
         .byte   "VOCOMPUTER"
         .dbyt   starVOCOMPUTER
         .byte   "VODISC"
         .dbyt   starVODISC
         .byte   "VOHIGHLIGHT"
         .dbyt   starVOHIGHLIGHT
         .byte   "VOSUPERIMPOSE"
         .dbyt   starVOSUPERIMPOSE
         .byte   "VOTRANSPARENT"
         .dbyt   starVOTRANSPARENT
         .byte   "VP"
         .dbyt   starVP
         .byte   "RESET"
         .dbyt   starRESET
         .byte   $ff
         .byte   %00010000
         .byte   %00010000
         .byte   %00010000

LB943:   .byte   %10000000 ; table 128 or 0
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000
         .byte   %10000000
         .byte   %00000000

LB965:   .byte   %01111101 ; 125 0x7D
         .byte   %01111011 ; 123 0x7B
         .byte   %01111000 ; 120 0x78
         .byte   %01110110 ; 118 0x76
         .byte   %01110011 ; 115 0x73
         .byte   %01110001 ; 113 0x71
         .byte   %01101110 ; 110 0x6e
         .byte   %01101100 ; 108 0x6c
         .byte   %01101001 ; 105 0x69
         .byte   %01100111 ; 103 0x67
         .byte   %01100100 ; 100 0x64
         .byte   %01100010 ;
         .byte   %01011111
         .byte   %01011101
         .byte   %01011010
         .byte   %01011000
         .byte   %01010101
         .byte   %01010011
         .byte   %01010000
         .byte   %01001110
         .byte   %01001011
         .byte   %01001001
         .byte   %01000110
         .byte   %01000100
         .byte   %01000001
         .byte   %00111111
         .byte   %00111100
         .byte   %00111010
         .byte   %00110111 ;
         .byte   %00110101 ; 53 0x35
         .byte   %00110010 ; 50 0x32
         .byte   %00110000 ; 48 0x30
         .byte   %00101101 ; 45 0x2d
         .byte   %00101011 ; 43 0x2b

         .byte   %00000001 ; 1
         .byte   %00000010 ; 2
         .byte   %00000100 ; 4
.ifndef VFS_OPTIMSE
LB98A:   .byte   %10000000  ; this and the next table are always 640 for MODE 0 1 2
         .byte   %10000000
         .byte   %10000000
LB98D:   .byte   %00000010
         .byte   %00000010
         .byte   %00000010
.endif

LB990:   .byte   %00000000 ; 0
         .byte   %01000000 ; 64 0x40
         .byte   %10000000 ;128 0x80
         .byte   %11000000 ;192 0xc0

;; is this actually used ?
         .byte   %00000000 ; 0
         .byte   %01000000 ; 64
         .byte   %10000000 ;128
         .byte   %11000000 ;192
         .byte   %00000000 ;0
         .byte   %00000000 ;0
         .byte   %00000000 ;0
         .byte   %00000000 ;0
         .byte   %00000001 ;1
         .byte   %00000001 ;1
         .byte   %00000001 ;1
         .byte   %00000001 ;1

LB9A0:   .byte   %00010100 ;20
         .byte   %00011000 ;24
         .byte   %00000100 ;4
         .byte   %00101000 ;40

LB9A4:   .byte   %00011100 ;28
         .byte   %00010100 ;20
         .byte   %00000100 ;4
         .byte   %00000100 ;4
LB9A8:                          ; 3 tables of 256 bytes one for each mode in groups of 64
                                ; pointer sprite
                                ; cross, magnify glass, north west arrow, North east arrow
         .byte   %00000000  ; mode 0 pointer 0
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00111111
         .byte   %00111111
         .byte   %00111111
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11110000
         .byte   %11110000
         .byte   %11110000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000 ; mode 0 pointer 1
         .byte   %00000000
         .byte   %00000011
         .byte   %00000011
         .byte   %00001111
         .byte   %00001111
         .byte   %00001111
         .byte   %00000011
         .byte   %00000011
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00111111
         .byte   %11111111
         .byte   %11000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11000000
         .byte   %11111111
         .byte   %00111111
         .byte   %00000011
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11110000
         .byte   %11110000
         .byte   %00111100
         .byte   %00111100
         .byte   %00111100
         .byte   %11110000
         .byte   %11110000
         .byte   %11000000
         .byte   %11000000
         .byte   %11110000
         .byte   %11110000
         .byte   %00111100
         .byte   %00111100
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000  ; mode 0 pointer 2
         .byte   %00110000
         .byte   %00111100
         .byte   %00111111
         .byte   %00111111
         .byte   %00111111
         .byte   %00111111
         .byte   %00111111
         .byte   %00110011
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11000000
         .byte   %11110000
         .byte   %11111100
         .byte   %11000000
         .byte   %11000000
         .byte   %11110000
         .byte   %11110000
         .byte   %00111100
         .byte   %00111100
         .byte   %00001111
         .byte   %00001111
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000      ; mode 0 pointer 3
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000011
         .byte   %00001111
         .byte   %00111111
         .byte   %00000011
         .byte   %00000011
         .byte   %00001111
         .byte   %00001111
         .byte   %00111100
         .byte   %00111100
         .byte   %11110000
         .byte   %11110000
         .byte   %00000000
         .byte   %00000000
         .byte   %00001100
         .byte   %00111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11001100
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000      ; mode 1 pointer 0
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000111
         .byte   %00000111
         .byte   %00000111
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00001110
         .byte   %00001110
         .byte   %00001110
         .byte   %00001110
         .byte   %00001110
         .byte   %00001111
         .byte   %00001111
         .byte   %00001111
         .byte   %00001110
         .byte   %00001110
         .byte   %00001110
         .byte   %00001110
         .byte   %00001110
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00001100
         .byte   %00001100
         .byte   %00001100
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000      ; mode 1 pointer 1
         .byte   %00000000
         .byte   %00000001
         .byte   %00000001
         .byte   %00000011
         .byte   %00000011
         .byte   %00000011
         .byte   %00000001
         .byte   %00000001
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000111
         .byte   %00001111
         .byte   %00001000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00001000
         .byte   %00001111
         .byte   %00000111
         .byte   %00000001
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00001100
         .byte   %00001100
         .byte   %00000110
         .byte   %00000110
         .byte   %00000110
         .byte   %00001100
         .byte   %00001100
         .byte   %00001000
         .byte   %00001000
         .byte   %00001100
         .byte   %00001100
         .byte   %00000110
         .byte   %00000110
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000      ; mode 1 pointer 2
         .byte   %00000100
         .byte   %00000110
         .byte   %00000111
         .byte   %00000111
         .byte   %00000111
         .byte   %00000111
         .byte   %00000111
         .byte   %00000101
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00001000
         .byte   %00001100
         .byte   %00001110
         .byte   %00001000
         .byte   %00001000
         .byte   %00001100
         .byte   %00001100
         .byte   %00000110
         .byte   %00000110
         .byte   %00000011
         .byte   %00000011
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000      ; mode 1 pointer 3
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000001
         .byte   %00000011
         .byte   %00000111
         .byte   %00000001
         .byte   %00000001
         .byte   %00000011
         .byte   %00000011
         .byte   %00000110
         .byte   %00000110
         .byte   %00001100
         .byte   %00001100
         .byte   %00000000
         .byte   %00000000
         .byte   %00000010
         .byte   %00000110
         .byte   %00001110
         .byte   %00001110
         .byte   %00001110
         .byte   %00001110
         .byte   %00001110
         .byte   %00001010
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000      ; mode 2 pointer 0
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000011
         .byte   %00000011
         .byte   %00000011
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000          ; mode 2 pointer 1
         .byte   %00000000
         .byte   %00000000
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000011
         .byte   %00000011
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000011
         .byte   %00000011
         .byte   %00000001
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000      ; mode 2 pointer 2
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000010
         .byte   %00000010
         .byte   %00000011
         .byte   %00000011
         .byte   %00000010
         .byte   %00000010
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000001
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000010
         .byte   %00000010
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

         .byte   %00000000      ; mode 2 pointer 3
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000001
         .byte   %00000001
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000001
         .byte   %00000001
         .byte   %00000011
         .byte   %00000011
         .byte   %00000001
         .byte   %00000001
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000010
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000

LBCA8:                               ; mouse pointer mask table
         .byte   %11111100        ; mode 0 pointer mask 0
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111100
         .byte   %11111111
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %00000011
         .byte   %00000011
         .byte   %00000011
         .byte   %00000011
         .byte   %00000011
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111      ; mode 0 pointer mask 1
         .byte   %11111100
         .byte   %11110000
         .byte   %11110000
         .byte   %11000000
         .byte   %11000000
         .byte   %11000000
         .byte   %11110000
         .byte   %11110000
         .byte   %11111100
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00111111
         .byte   %00111111
         .byte   %00111111
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11000000
         .byte   %11111100
         .byte   %11111100
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111
         .byte   %00001111
         .byte   %00000011
         .byte   %00000011
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000011
         .byte   %00000011
         .byte   %00001111
         .byte   %00001111
         .byte   %00000011
         .byte   %00000011
         .byte   %00000000
         .byte   %00000000
         .byte   %11000011

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %00001111      ; mode 0 pointer mask 2
         .byte   %00000011
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11111100
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %00111111
         .byte   %00001111
         .byte   %00000011
         .byte   %00000000
         .byte   %00000011
         .byte   %00001111
         .byte   %00000011
         .byte   %00000011
         .byte   %00000000
         .byte   %00000000
         .byte   %11000000
         .byte   %11000000
         .byte   %11110000

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %00111111
         .byte   %00111111
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111      ; mode 0 pointer mask 3
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111100
         .byte   %11111100
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111100
         .byte   %11110000
         .byte   %11000000
         .byte   %00000000
         .byte   %11000000
         .byte   %11110000
         .byte   %11000000
         .byte   %11000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000011
         .byte   %00000011
         .byte   %00001111

         .byte   %11110000
         .byte   %11000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11101110      ; mode 1 pointer mask 0
         .byte   %11101110
         .byte   %11101110
         .byte   %11101110
         .byte   %11101110
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11101110
         .byte   %11101110
         .byte   %11101110
         .byte   %11101110
         .byte   %11101110
         .byte   %11111111

         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %00010001
         .byte   %00010001
         .byte   %00010001
         .byte   %00010001
         .byte   %00010001
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111       ; mode 1 pointer mask 1
         .byte   %11101110
         .byte   %11001100
         .byte   %11001100
         .byte   %10001000
         .byte   %10001000
         .byte   %10001000
         .byte   %11001100
         .byte   %11001100
         .byte   %11101110
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %10001000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %01110111
         .byte   %01110111
         .byte   %01110111
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %10001000
         .byte   %11101110
         .byte   %11101110
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111
         .byte   %00110011
         .byte   %00010001
         .byte   %00010001
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00010001
         .byte   %00010001
         .byte   %00110011
         .byte   %00110011
         .byte   %00010001
         .byte   %00010001
         .byte   %00000000
         .byte   %00000000
         .byte   %10011001

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %00110011     ; mode 1 pointer mask 2
         .byte   %00010001
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11101110
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %01110111
         .byte   %00110011
         .byte   %00010001
         .byte   %00000000
         .byte   %00010001
         .byte   %00110011
         .byte   %00010001
         .byte   %00010001
         .byte   %00000000
         .byte   %00000000
         .byte   %10001000
         .byte   %10001000
         .byte   %11001100

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %01110111
         .byte   %01110111
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111      ; mode 1 pointer mask 3
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11101110
         .byte   %11101110
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11101110
         .byte   %11001100
         .byte   %10001000
         .byte   %00000000
         .byte   %10001000
         .byte   %11001100
         .byte   %10001000
         .byte   %10001000
         .byte   %00000000
         .byte   %00000000
         .byte   %00010001
         .byte   %00010001
         .byte   %00110011

         .byte   %11001100
         .byte   %10001000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %01110111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111      ; mode 2 pointer mask 0
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %10101010
         .byte   %10101010
         .byte   %10101010
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11111111

         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111       ; mode 2 pointer mask 1
         .byte   %10101010
         .byte   %10101010
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %10101010
         .byte   %10101010
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %10101010
         .byte   %10101010
         .byte   %10101010
         .byte   %10101010
         .byte   %11111111

         .byte   %11111111
         .byte   %01010101
         .byte   %01010101
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %01010101

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %00000000    ; mode 2 pointer mask 2
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111
         .byte   %01010101
         .byte   %01010101
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %10101010
         .byte   %10101010
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %01010101
         .byte   %01010101
         .byte   %11111111
         .byte   %11111111
         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %01010101
         .byte   %00000000
         .byte   %00000000
         .byte   %01010101

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111         ; mode 2 pointer mask 3
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %10101010
         .byte   %10101010
         .byte   %11111111
         .byte   %11111111
         .byte   %10101010
         .byte   %10101010
         .byte   %10101010
         .byte   %10101010
         .byte   %00000000
         .byte   %00000000
         .byte   %10101010

         .byte   %11111111
         .byte   %10101010
         .byte   %10101010
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %01010101
         .byte   %01010101
         .byte   %11111111

         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %00000000
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111

         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
; end of sprite tables
.ifndef VFS_OPTIMSE
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
         .byte   %11111111
.endif

         .byte   "Many thanks to :-  Jonathan Griffiths, Tony Engeham, "
         .byte   "Chris Turner & Huge",$0d
