
;-------------------------------
;-- add 16 bit value to 16 bit value
!macro ADD_16_16 .addr1, .addr2, .result {
    clc
    lda .addr1
    adc .addr2
    sta .result
    lda .addr1 +1
    adc .addr2 +1
    sta .result+1
}

!macro ADD_16_16 .addr1, .addr2 {
    +ADD_16_16 .addr1, .addr2, .addr1
}


;-------------------------------
;-- add signed 8 bit value to 16 bit value
!zone {
!macro ADD_16_8 .addr1, .addr2, .result {
    lda .addr2
    bpl .positive
    dec .addr1 +1
.positive
    clc
    adc .addr1
    sta .result

    lda #0
    adc .addr1 +1
    sta .result+1
}}

!macro ADD_16_8 .addr1, .addr2 {
    +ADD_16_8 .addr1, .addr2, .addr1
}


;-------------------------------
;-- add 16 bit constant to 16 bit value
!macro ADD_16_16C .addr1, .constl, .consth, .result {
    clc
    lda .addr1
    adc #.constl
    sta .result
    lda .addr1 +1
    adc #.consth
    sta .result+1
}

!macro ADD_16_16C .addr1, .constl, .consth {
    +ADD_16_16C .addr1, .constl, .consth, .addr1
}


;-------------------------------
;-- add signed 8 bit constant to 16 bit value
!zone {
!macro ADD_16_8C .addr1, .const, .result {
    clc
    lda .addr1
    adc #.const
    sta .result
    
    lda .addr1 +1
    adc #(.const >> 7)
    sta .result+1
}}

!macro ADD_16_8C .addr1, .const {
    +ADD_16_8C .addr1, .const, .addr1
}


;-------------------------------
;-- subtract signed 8 bit constant from 16 bit value
!zone {
!macro SUB_16_8C .addr1, .const, .result {
    sec
    lda .addr1
    sbc #.const
    sta .result
    
    lda .addr1 +1
    sbc #(.const >> 7)
    sta .result+1
}}

!macro SUB_16_8C .addr1, .const {
    +SUB_16_8C .addr1, .const, .addr1
}


;-------------------------------
;-- subtract signed 8 bit value from 16 bit value
!zone {
!macro SUB_16_8 .addr1, .addr2, .result {
    sec
    lda .addr1
    sbc .addr2
    sta .result
    
    lda .addr1 +1
    sbc #0
    sta .result+1
}}

!macro SUB_16_8 .addr1, .addr2 {
    +SUB_16_8 .addr1, .addr2, .addr1
}


;-------------------------------
;-- increment and decrement 16 bit values
!zone {
!macro INC_16 .addr {
    inc .addr
    bne .end
    inc .addr +1
.end
}}

!zone {
!macro DEC_16 .addr {
    lda .addr
    bne .end
    dec .addr +1
.end
    dec .addr
}}


;-------------------------------
;-- string output
!macro STRING_OUTPUT2 .straddr, .x, .y, .color {
    lda #<.straddr
    sta .o1 +1
    lda #>.straddr
    sta .o1 +2
    
    lda #<SCR_BASE +40*.y +.x
    sta .o2 +1
    lda #>SCR_BASE +40*.y +.x
    sta .o2 +2
    
    lda #<COL_BASE +40*.y +.x
    sta .o3 +1
    lda #>COL_BASE +40*.y +.x
    sta .o3 +2
    
    ldx #0
    
.loop
.o1 lda $FFFF, x
    cmp #$FF
    beq .cont
.o2 sta $FFFF, x
    lda #.color
.o3 sta $FFFF, x
    
    inx
    jmp .loop
    
.cont

}


!macro CHAR_OUTPUT .x, .y, .c {
    sta SCR_BASE +40*.y +.x
    lda #.c
    sta COL_BASE +40*.y +.x
}


!macro CHAR_OUTPUT .x, .y {
    sta SCR_BASE +40*.y +.x
}

!macro CHAR_OUTPUT_INV .x, .y, .c {
    ora #%10000000
    +CHAR_OUTPUT .x, .y, .c
}

!macro CHAR_OUTPUT_INV .x, .y {
    ora #%10000000
    +CHAR_OUTPUT .x, .y
}


!macro SAVE_XY {
    txa
    pha
    tya
    pha
    
    ;stx $2A
    ;sty $2B
}

!macro RESTORE_XY {
    pla
    tay
    pla
    tax
    
    ;ldx $2A
    ;ldy $2B
}


!zone {
!macro ASL_X .n {
    txa
    !for i, 0, .n-1 {asl}
    tax
}
}

!zone {
!macro ASL_Y .n {
    tya
    !for i, 0, .n-1 {asl}
    tay
}
}

!zone {
!macro LSR_X .n {
    txa
    !for i, 0, .n-1 {lsr}
    tax
}
}

!zone {
!macro LSR_Y .n {
    tya
    !for i, 0, .n-1 {lsr}
    tay
}
}


;-- multiply y with 20 and store in a
;-- konimaru version
!macro MUL_Y_20 {
    tya
    sta $20
    asl
    asl            ;-- * 4 (carry is 0, no clc required)
    adc $20        ;-- * 5
    asl
    asl            ;-- * 20
}

;-- low byte will be in y
;-- high byte will be in a
!macro MUL_Y_40 {
    clc
    +MUL_Y_20
    asl
    sta $20
    lda #$00
    rol
    tay
    lda $20
}


!zone {
!macro MEMCOPY .from, .to, .n {
    ldx #$0
.loop
    lda .from, x
    sta .to, x
    inx
    cpx #.n
    bne .loop
}
}


!zone {
!macro MEMCOPY8 .from, .to, .n {
    ldx #$0
.loop
    lda .from, x
    sta .to, x
    inx
    lda .from, x
    sta .to, x
    inx
    lda .from, x
    sta .to, x
    inx
    lda .from, x
    sta .to, x
    inx
    lda .from, x
    sta .to, x
    inx
    lda .from, x
    sta .to, x
    inx
    lda .from, x
    sta .to, x
    inx
    lda .from, x
    sta .to, x
    inx
    cpx #.n
    bne .loop
}
}


!zone {
!macro MEMCOPY_UNTIL .from, .to, .stop {
    ldx #$0
.loop
    lda .from, x
    cmp #.stop
    beq .end
    sta .to, x
    inx
    jmp .loop
.end
}
}


!zone {
!macro MEMCOPY_HUGE .startaddr, .endaddr, .destaddr {
.loop
.o1 lda .startaddr
.o2 sta .destaddr

    !if DEBUG_MODE { sta $D020 }

    inc .o1 +1
    bne .no_overflow
    inc .o1 +2
.no_overflow

    inc .o2 +1
    bne .no_overflow2
    inc .o2 +2
.no_overflow2

    lda .o1 +2
    cmp #>.endaddr  ;-- end addr is exclusive ("until")
    bne .loop
    lda .o1 +1
    cmp #<.endaddr
    bne .loop
}
}


!zone {
!macro STRCOPY_UNTIL .from, .to, .stop, .color {
    ldx #$0
    ldy #.color
.loop
    lda .from, x
    cmp #.stop
    beq .end
    sta .to, x
    tya
    sta $D800 - $0400 + .to, x
    inx
    jmp .loop
.end
}
}


!zone {
!macro STRCOPY_UNTIL .from, .to, .stop {
    ldx #$0
.loop
    lda .from, x
    cmp #.stop
    beq .end
    sta .to, x
    inx
    jmp .loop
.end
}
}

!zone {
!macro STRCOPY_UNTIL .from, .to, .stop, .color, .backgroundmask {
    ldx #$0
    ldy #.color
.loop
    lda .from, x
    cmp #.stop
    beq .end
    and #%00111111
    ora #.backgroundmask
    sta .to, x
    tya
    sta $D800 - $0400 + .to, x
    inx
    jmp .loop
.end
}
}


!zone {
!macro XCOPY .from, .to, .n {
    !for i, 0, .n-1 {
        lda .from + i
        sta .to + i
    }
}
}


!zone {
!macro MEMFILL .from, .n, .v {
    ldx #$0
    lda #.v
.loop
    sta .from, x
    inx
    cpx #.n
    bne .loop
}
}


!zone {
!macro SIMPLE_RANDOM {
    lda seed
    asl
    bcc .noEor
    eor #$1d
    
.noEor
    sta seed
}
}


!zone {
!macro WAIT_NEXT_FRAME {
    lda tick
    clc
    adc #1
    sta .o1 +1
.loop
    lda tick
.o1 cmp #$FF
    bne .loop
}
}

!zone {
!macro WAIT .v {
    !if DEBUG_MODE { inc $D020 }
    
    txa
    pha
    
    ldx #.v
.wait
    dex
    bne .wait
    
    pla
    tax
    
    !if DEBUG_MODE { dec $D020 }
}
}


!macro WAIT {
    +WAIT 0
}


!macro WAIT_FOR_FIRE {
.wait
    jsr read_joysticks
    lda joy_state2
    and #JOY_FIRE
    bne .wait
}


!zone {
!macro DEBUG_BORDER .color {
    !if DEBUG_MODE {
        lda #.color
        sta $D020
    }
}
}


!zone {
!macro DEBUG_ANIMATION {
    
    ldx #0
    ldy #0
.loopdiloop

.wait
    dey
    cpy #0
    bne .wait

    inc $D020
    dex
    cpx #0
    bne .loopdiloop
}
}



!macro SWITCH_STATE .state {
    lda #.state
    sta state
    lda #0
    sta state_init
}

!macro SWITCH_STATE {
    sta state
    lda #0
    sta state_init
}

