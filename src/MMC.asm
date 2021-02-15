; ADFS MMC Card Driver
; (C) 2015 David Banks
; Based on code from MMFS ROM by Martin Mather
;
; 20-Feb-2016 JGH:
; Corrected error numbers. None of these should be errors, they should be
; return results otherwise, eg OSWORD &72 bombs out instead of returning a
; result.
;
; 27-Mar-2016 JGH:
; MMC_BEGIN redefined interface to destroy all registers, returns result,
; falls through to MMC_INIT to initialise and return result.
; setCommandAddress returns error result on failure.
; StartRead/Write return error result on failure.
; MMC return codes translated to ADFS return codes.


trys%=&32

go_idle_state    =&40
send_op_cond     =&41
mmc_command_48   =&48
send_cid         =&4A
set_blklen       =&50
read_single_block=&51
write_block      =&58


; MMC_BEGIN - Initialise MMC card
; *******************************
; Returns EQ, A=0 ok
;         NE, A=MMC error code, failed
; Corrupts X,Y
.MMC_BEGIN
{
	JSR MMC_DEVICE_RESET	; Reset device
	BIT mmcstate%		; Check if MMC initialised
	BVC MMC_INIT		; Card needs initialising
	LDA #&00		; Return A='ok'
	RTS
}


; MMC_INIT - Initialise MMC card
; ******************************
; Returns EQ, A=0 if ok
;         NE, A=ADFS error code, card can't be initialised
; Corrupts X,Y
.MMC_INIT
{
IF USE65C12
     STZ mmcstate%
ELSE
     LDA #0
     STA mmcstate%
ENDIF

     LDA #trys%
     STA attempts%

     ;; 80 Clocks
.iloop
     LDY #10
     JSR MMC_Clocks

     ;; CMD0
     LDA #go_idle_state
     JSR MMC_SetCommand
     LDA #&95
     STA cmdseq%+6                   ; token (crc7)
     JSR MMC_DoCommand
     AND #&81                        ; ignore errors
     CMP #1                          ; b0='idle state'
     SEC
     BNE il10                        ; not idle, fail this attempt
.il0
     LDA #&01
     STA cardsort%
     LDA #&48
     JSR MMC_SetCommand
     LDA #&01
     STA cmdseq%+4
     LDA #&AA
     STA cmdseq%+5
     LDA #&87
     STA cmdseq%+6
     JSR MMC_DoCommand
     CMP #1
     BEQ isdhc

     LDA #&02
     STA cardsort%
.il1
     ;; CMD1
     LDA #send_op_cond
     JSR MMC_SetCommand
     JSR MMC_DoCommand
     CMP #2                          ; anything other than 'idle'
.il10
     BCS ifail                       ; not idle, fail this attempt
.il11
     BIT EscapeFlag                  ; may hang
     BMI ifail
     CMP #0
     BNE il1                         ; not 'ok', try again
     LDA #&02
     STA cardsort%
     BNE iok

.isdhc
     JSR UP_ReadByteX
     JSR UP_ReadByteX
     JSR UP_ReadByteX
     JSR UP_ReadByteX
.isdhc2
     LDA #&77
     JSR MMC_SetCommand
     JSR MMC_DoCommand
     LDA #&69
     JSR MMC_SetCommand
     LDA #&40
     STA cmdseq%+2
     JSR MMC_DoCommand
     CMP #&00
     BNE isdhc2
     LDA #&7A
     JSR MMC_SetCommand
     JSR MMC_DoCommand
     CMP #&00
     BNE ifail
     JSR UP_ReadByteX
     AND #&40
     PHA
     JSR UP_ReadByteX
     JSR UP_ReadByteX
     JSR UP_ReadByteX
     PLA
     BNE iok
     LDA #2
     STA cardsort%

     ;; Set blklen=512
.iok
     LDA #set_blklen
     JSR MMC_SetCommand
     LDA #2
     STA cmdseq%+4
     JSR MMC_DoCommand
     BNE blkerr

     ;; All OK!
     LDA #&40
     STA mmcstate%
     LDA #&00     ;; A=0, EQ=Ok
     RTS

.ifail
     ;; Try again?
     DEC attempts%
     BEQ ifaildone
     JMP iloop

.ifaildone
.blkerr
}
.translate_error
     LDX #&FF
.translate_lp
     INX
     LSR A
     BCC translate_lp
     LDA translate_table,X
     RTS        ;; NE=Failed, return ADFS error code
     ; MMC_DoCommand R1 response codes
.translate_table
     EQUB &00	; b0 = In idle state        -> No error
     EQUB &2F	; b1 = Erase reset          -> Abort
     EQUB &27	; b2 = Illegal command
     EQUB &20	; b3 = Command CRC error
     EQUB &05	; b4 = Erase Sequence error -> Malformed command
     EQUB &21	; b5 = Address error
     EQUB &24	; b6 = Parameter error
     EQUB &7F	; b7 = 0                    -> Unknown


; **** Begin Read Transaction ****
; On exit, EQ=Ok
;          NE, A=translated error code
.MMC_StartRead
     JSR MMC_DoCommand
     BNE translate_error
     JMP MMC_WaitForData

; **** Begin Write Transaction ****
; On exit, EQ=Ok
;          NE, A=translated error code
.MMC_StartWrite
     JSR MMC_DoCommand
     BNE translate_error
     JMP MMC_SendingData


;; **** Set up MMC command sequence ****
;; Cy=0 for read, Cy=1 for write
;; X,Y preserved, A corrupted
.MMC_SetupRW
     LDA #write_block
     BCS MMC_SetCommand
     LDA #read_single_block
        
;; **** Reset MMC Command Sequence ****
;; A=cmd, token=&FF
.MMC_SetCommand
     STA cmdseq%+1
IF USE65C12
     STZ cmdseq%+2
     STZ cmdseq%+3
     STZ cmdseq%+4
     STZ cmdseq%+5
ELSE
     LDA #0
     STA cmdseq%+2
     STA cmdseq%+3
     STA cmdseq%+4
     STA cmdseq%+5
ENDIF
     LDA #&FF
     STA cmdseq%+0
     STA cmdseq%+6                   ;; token
     STA cmdseq%+7
     RTS


;; Set Random/Command Address
;; **************************
;; Translate the sector number into a SPI Command Address
;; Sector number is in 256 bytes sectors which are stretched to become 512 byte sectors
;; For SDHC cards this is in blocks (which are also sectors)
;; For SD cards this needs converting to bytes by multiplying by 512

;; (&B0) + 8 is the LSB
;; (&B0) + 6 is the MSB
;; cmdseq%+5 is the LSB
;; cmdseq%+2 is the MSB

;; Set MMC Command Address from random access index
;; ************************************************
;; On entry, X=>offset from &C200 to random access info
;; On exit,  EQ A=0  - ok
;;           NE A<>0 - failed, returns ADFS error code
;; Corrupts X,Y
.setRandomAddress
{
    LDA #0         ;; b24-b31 of sector number
    PHA
    LDY #3         ;; 3 bytes for remainder of sector number
.loop
    LDA &C203,X    ;; byte 2/1/0 of sector number
    PHA            ;; stack it
    DEX
    DEY
    BNE loop
    BRA setAddressFromStack
}

;; Set MMC Command Address from (&B0),control block
;; ************************************************
;; On exit,  EQ A=0  - ok
;;           NE A<>0 - failed
;; Corrupts X,Y
.setCommandAddress
{
    LDA #0         ;; b24-b31 of sector number
    PHA
    LDY #6         ;; Point to sector b16-b23 in the control block
.loop
    LDA (&B0), Y    ;; Stack the MSB first, LSB last
    PHA
    INY
    CPY #9
    BNE loop
}    

; Stack now has -> b0-b7, b8-b15, b16-b23+drive, &00
.setAddressFromStack
{
;; Process the drive number
     TSX
     LDA &103,X     ;; Bits 7-5 are the drive number
     PHA
     ORA &C317      ;; Add in current drive
     STA &C333      ;; Store for any error

     CLC            ;; Rotate into bits 0-2
     ROL A
     ROL A
     ROL A
     ROL A
     AND #&07
     CMP numdrives% ;; check against number of ADFS partitions found 
     BCS invalidDrive

     ASL A          ;; Shift into bits 4-2 to index the drive table
     ASL A
     TAY            ;; Y will be used to index the drive table

     PLA            ;; Mask out the drive number, leaving just the MS sector
     AND #&1F
     STA &103, X    ;; Store back into sector on stack

     CLC
.addDriveOffset
     LDA &101, X
     ADC drivetable%, Y
     STA &101, X
     INX
     INY
     TYA
     AND #&03
     BNE addDriveOffset
     ;; Usefully, X now points to end of stacked data

     LDA cardsort%   ;; Need to skip multiply for SDHC cards (cardsort = 01)
     TAY
     DEY             ;; Y=&00 no multiply needed, Y<>&00 multiply needed
     LDX #4          ;; sector number is 4 bytes
     CLC
.loop
     PLA
     INY
     DEY
     BEQ nomult      ;; Multiply not needed
     ROL A
.nomult
     STA cmdseq%+1, X
     DEX
     BNE loop
     BCS overflow    ;; if carry is set, overflow has occurred
     LDA #&00        ;; A=0, EQ, Ok
     STA cmdseq%+5   ;; LSB is always 0
     RTS

.invalidDrive
      TXS           ; Step past stacked data
      LDA #&25      ; A='Invalid drive number'
      RTS

.overflow
      LDA #&21      ; A='Sector out of range'
      RTS
}


;; Update sector address
;; *********************
.incCommandAddress
{
     LDA cardsort%
     CMP #2
     BEQ incAddr    ; &02   - add &200
     LDA #1         ; <>&02 - add &100
.incAddr
     CLC
     ADC cmdseq%+5
     STA cmdseq%+5
     BCC incDone
     INC cmdseq%+4
     BNE incDone
     INC cmdseq%+3
     BNE incDone
     INC cmdseq%+2
.incDone
     RTS
}


.initializeDriveTable
{
; Load 512b sector 0 (MBR) to &C000-&C1FF
; Normally MBR resides here, but we do this before MBR is loaded
; We can't use OSWORD &72 to do this, as we don't want alternative bytes skipped
; This is done during filing system selection, so generating errors would leave
; system in an inconsistant state.
;
; This MUST be able to terminate if the hardware is absent.
;
     JSR MMC_BEGIN      ; Initialize the card, if not already initialized
     BNE init_exit	; Couldn't initialise
     CLC                ; C=0 for Read
     JSR MMC_SetupRW
     JSR MMC_StartRead
     BNE init_exit	; Couldn't read
     LDA #<mbrsector%
     STA datptr% + 0
     LDA #>mbrsector%
     STA datptr% + 1
     JSR MMC_Read512
     JSR MMC_16Clocks	;; ignore CRC

     LDA mbrsector% + &1FE
     CMP #&55
     BNE noMBR
     LDA mbrsector% + &1FF
     CMP #&AA
     BNE noMBR

;; Partition entry 0 is 1BE
;; Partition entry 1 is 1CE
;; Partition entry 2 is 1DE
;; Partition entry 3 is 1EE
        
;; Partition entry has following structure
;; 00 = status (whether bootable)
;; 01-03 = CHS address of first absolute sector in partition
;; 04 = partition type (AD for ADFS)
;; 05-07 = CHS address of last absolute sector in partition
;; 08-0B = LBA of first absolute sector in partition
;; 0C-0F = Number of sectors in partition

     LDA #<(mbrsector% + &1BE)  ;; The start of the first partition entry
     STA datptr%+0              ;; is offset &1BE into the MBR
     LDA #>(mbrsector% + &1BE)
     STA datptr%+1

     LDX #(MAX_DRIVES * 4)      ;; Clear the drive table
.loop
     STZ drivetable% - 1, X     ;; all zeros is treated as an invalid drive
     DEX
     BNE loop
     STX numdrives%             ;; clear the number of drives
        
.testPartition
     LDY #&04
     LDA (datptr%),Y
     CMP #&AD                   ;; ADFS = partition type AD
     BNE nextPartition
     INC numdrives%
     LDY #&08
.copyLBA
     LDA (datptr%),Y            ;; Read the LBA from the partition entry
     STA drivetable%, X         ;; Store it in the drive table
     INX
     INY
     CPY #&0C
     BNE copyLBA     
     CPX #(MAX_DRIVES * 4)
     BEQ done

.nextPartition
     CLC
     LDA datptr%               ;; Move to the next partition entry
     ADC #&10
     STA datptr%
     CMP #&FE                   ;; &FE = &BE + &10 * 4
     BNE testPartition

.done
     TXA                        ;; Did we find any ADFS partitions?
     BEQ noADFS                 ;; No, then fatal error
     LDA #&00			;; A='Ok'
.init_exit
     RTS

.noMBR
     LDA #&01			;; A='No Master Boot Record'
     RTS
.noADFS
     LDA #&1C			;; A='No ADFS partitions'
     RTS
}
