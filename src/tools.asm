
;-------------------------------
!zone

;-- clear screen using space characters
;--
clear_screen
    lda #$20    ;-- space character
    ldx #$00
.loop
    sta SCR_BASE, x
    sta SCR_BASE + $100, x
    sta SCR_BASE + $200, x
    sta SCR_BASE + $300, x
    dex
    bne .loop

    rts
    

;-------------------------------
!zone

;-- clear color ram
;-- color has to be in A
;--
clear_color_ram
    ldx #$00
.loop
    sta $D800, x
    sta $D900, x
    sta $DA00, x
    sta $DB00, x
    dex
    bne .loop
    
    rts


;-------------------------------
!zone
;-- initialize screen stuff
;--
init_screen
    ;-- set screen colors to black
    lda #BLK
    sta $D020
    sta $D021
    
    ;-- select VICBANK
    lda $DD00
    and #%11111100
    ora #%00000010      ;-- xxxxxx10 = vic bank 1 at $4000-$7FFF
    sta $DD00

    ;-- memory setup
    lda $D018
    and #%11110001
    ora #%00000010      ;-- xxxx001x = char memory in $0800-$0FFF + VICBANK
    ;--sta $D018
    ;--lda $D018
    and #%00001111
    ora #%00000000      ;-- 0000xxxx = screen memory in $0000-$03FF + VICBANK
    sta $D018
    
    ;-- reset sprites
    lda #0
    sta SPRITE_XF
    sta SPR_ENAB
    
    rts


;-------------------------------
!zone
;-- turn off screen
;--
turn_off_screen
    lda $D011
    and #%01101111  ;-- bit #7 = bit #8 of irq raster line, bit #4 = screen off/on
    sta $D011
    
    rts


;-- turn screen back on
;--
turn_on_screen
    lda $D011
    ora #%00010000
    and #%01111111  ;-- always clear bit #8 of irq raster line
    sta $D011
    
    rts
    
    
;-------------------------------
!zone

turn_off_runstop_restore
    lda #$C1
    sta $0318
    lda #$FE
    sta $0319
    
    rts


turn_off_charset_toggle    ;-- shift + cbm
    lda #$80
    sta $0291
    
    rts


;-------------------------------
!zone

;-- reset sprite position to 0
;-- sprite number has to be in a

hide_sprite  
    sta $20  
    +SAVE_XY
    
    lda $20
    tax

    lda SPRITE_XF
    and SPR_NO, x
    sta SPRITE_XF
    
    txa
    pha
    
    asl
    tax
    lda #$00
    sta SPRITE_0X, x
    
    pla
    tax
    
    +RESTORE_XY
    
    rts


turn_off_sprites
    lda #%00000000
    sta SPR_ENAB
    
    rts


;-------------------------------
!zone

;-- print string on screen
;--
invertmask  !byte 0

print_str
    clc
    adc #<SCR_BASE
    sta .o2 +1
    sta .o3 +1          ;-- delta for LSB is 0
    tya
    adc #>SCR_BASE
    sta .o2 +2

    adc #(>COL_BASE) - (>SCR_BASE)
    sta .o3 +2

    ldx #$00
    
.loop
oo1 lda $FFFF, x
    ora invertmask
    cmp #$FF
    beq .end
.o2 sta SCR_BASE, x
oo2 lda #$FF
.o3 sta COL_BASE, x
    inx
    jmp .loop
    
.end
    rts

!macro STRING_OUTPUT .straddr, .x, .y, .c {
    lda #<.straddr
    sta oo1 +1
    lda #>.straddr
    sta oo1 +2
    
    lda #.c
    sta oo2 +1
    
    lda #<(.x + .y * 40)
    ldy #>(.x + .y * 40)
    
    jsr print_str
}

!macro STRING_OUTPUT_INV .straddr, .x, .y, .c {
    lda #%10000000
    sta invertmask

    +STRING_OUTPUT .straddr, .x, .y, .c
    
    lda #$00
    sta invertmask
}

!macro STRING_OUTPUT .straddr, .x, .y {
    sta oo2 +1              ;-- color
    
    lda #<.straddr
    sta oo1 +1
    lda #>.straddr
    sta oo1 +2
    
    lda #<(.x + .y * 40)
    ldy #>(.x + .y * 40)
    
    jsr print_str
}

straddr     !word 0
.scraddr    !word 0

HIGH = $22
LOW = $21

;-- non-macro version
;-- x and y have to be in x and y
;-- string address has to be put into straddr
;-- color has to be in a
string_output
    sta oo2 +1              ;-- color

    lda #0
    sta HIGH

    lda straddr
    sta oo1 +1
    lda straddr +1
    sta oo1 +2
    
    ;-- y * 40
    tya
    sta LOW     ;-- *1

    asl
    asl         ;-- *4, carry clear (0..24 * 4)
    adc LOW     ;-- *5
    asl
    asl         ;-- *20
    rol HIGH    ;-- save carry
    asl         ;-- *40
    rol HIGH    ;-- save carry

    sta LOW

    txa
    adc LOW     ;-- add X
    sta LOW
    lda HIGH
    adc #$0
    sta HIGH 
    
    ;-- call the string function
    lda LOW
    ldy HIGH
    
    jsr print_str
    rts

