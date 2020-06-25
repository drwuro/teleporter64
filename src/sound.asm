

music_pal    
    !binary "../res/teleport2a_9000.bin"
    
;!align 256, 0
music_ntsc
    ;-- !binary "../res/asia7-ntsc.bin"
    
END_OF_MUSIC


;-------------------------------
!zone

music_volume    !byte $0F
current_music   !byte $00
sid_model       !byte $00
music_enabled   !byte $01
fx_channel      !byte $0E   ;-- $00 for channel 1, $07 for channel 2, $0E for channel 3

!macro PLAY_SOUND .addr {
    +SAVE_XY
    lda music_enabled
    bne .play
    
    ;-- cycle through voices if no music is playing
    lda fx_channel
    clc
    adc #7
    sta fx_channel
    cmp #$0E + 7
    bne .play
    
    lda #0
    sta fx_channel
    
.play
    lda #<.addr
    ldy #>.addr
    ldx fx_channel
    jsr MUS_BASE + 6
    +RESTORE_XY
}

!macro PLAY_MUSIC {
    jsr MUS_BASE + 3
}

!macro INIT_MUSIC .subtune {
    lda #$0F
    sta music_volume
    jsr MUS_BASE + 9
    
    lda music_enabled
    beq .no_music
    
    lda #$0E
    sta fx_channel
    
    lda #.subtune
    cmp current_music
    beq .no_change
    
    jmp .music
    
.no_music
    lda #$FF
.music
    sta current_music
    tax
    tay
    jsr MUS_BASE
    
.no_change
}


!macro REDUCE_VOL {
    dec music_volume
    lda music_volume
    cmp #$FF
    bne .do

    lda #00
    sta music_volume
    
.do
    lda music_volume
    jsr MUS_BASE + 9
}


!eof



detect_sid_model
	;-- SID DETECTION ROUTINE
	
	;-- By SounDemon - Based on a tip from Dag Lem.
	;-- Put together by FTC after SounDemons instructions
	;-- ...and tested by Rambones and Jeff.
	
	;-- - Don't run this routine on a badline
	;-- - Won't work in VICE (always detects 6581) unless resid-fp emulation is enabled
	
	sei		    ;-- No disturbing interrupts
	lda #$ff
	cmp $d012	;-- Don't run it on a badline.
	bne *-3
	
	;-- Detection itself starts here	
	lda #$ff	;-- Set frequency in voice 3 to $ffff 
	sta $d412	;-- ...and set testbit (other bits doesn't matter) in $d012 to disable oscillator
	sta $d40e
	sta $d40f
	lda #$20	;-- Sawtooth wave and gatebit OFF to start oscillator again.
	sta $d412
	lda $d41b	;-- Accu now has different value depending on sid model (6581=3/8580=2)
	lsr		    ;-- ...that is: Carry flag is set for 6581, and clear for 8580.
	bcc model_8580
	
model_6581
	lda #SID_6581
	sta sid_model
	rts

model_8580
	lda #SID_8580
	sta sid_model
	rts

    
prepare_music

.l1 lda $d012
.l2 cmp $d012
    beq .l2
    bmi .l1
    cmp #$20
    bcs .pal
    
.loop
    dec .o1 +1
    dec .o2 +1
    
.o1 lda END_OF_MUSIC
.o2 sta MUS_BASE + (END_OF_MUSIC - music_ntsc)
    
    lda .o2 +1
    bne .loop
    
    dec .o1 +2
    dec .o2 +2
    
    lda .o2 +2
    cmp #>MUS_BASE -1
    bne .loop
    
    lda #<FILTER_OFFSET_NTSC
    sta .o4 +1
    lda #>FILTER_OFFSET_NTSC
    sta .o4 +2
    
    jmp .sid_model
    
.pal
    lda #<FILTER_OFFSET_PAL
    sta .o4 +1
    lda #>FILTER_OFFSET_PAL
    sta .o4 +2

.sid_model
    jsr detect_sid_model
    
    lda sid_model
    cmp #SID_6581
    beq .sid_6581
    
.sid_8580
    lda #<T_FILTER_8580
    sta .o3 +1
    lda #>T_FILTER_8580
    sta .o3 +2
    jmp .filter

.sid_6581
    lda #<T_FILTER_6581
    sta .o3 +1
    lda #>T_FILTER_6581
    sta .o3 +2
    
.filter
    ;-- apply filter values
    ldx #6
.loop1
    dex
.o3 lda $FFFF, x
.o4 sta $FFFF, x
    cpx #0
    bne .loop1
    
    rts
    

    
    
T_FILTER_6581
    !byte $7F, $79, $6F, $69, $5F, $59
    
T_FILTER_8580
    !byte $2F, $29, $1F, $19, $0F, $09
    
FILTER_OFFSET_PAL   = $04E8 + MUS_BASE
FILTER_OFFSET_NTSC  = $04EE + MUS_BASE

;-------------------------------


