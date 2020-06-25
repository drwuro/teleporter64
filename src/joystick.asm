
joy_state
joy_state1      !byte 0
joy_state2      !byte 0
joy_state3      !byte 0
joy_state4      !byte 0


init_joysticks
    lda #$80
    sta $DD03       ;-- CIA2 PortB Bit7 as OUT
    lda $DD01       ;-- force Clock-Stretching (SuperCPU)
    sta $DD01       ;-- and release joy_state
    
    rts


read_joysticks
    lda $DC01       ;-- read Port1
    and #$1F
    sta joy_state +0

    lda $DC00       ;-- read Port2
    and #$1F
    sta joy_state +1

    lda $DD01       ;-- CIA2 PortB Bit7 = 1
    ora #$80
    sta $DD01

    lda $DD01       ;-- read Port3
    and #$1F
    sta joy_state +2

    lda $DD01       ;-- CIA2 PortB Bit7 = 0
    and #$7F
    sta $DD01

    lda $DD01       ;-- read Port4
    pha             ;-- Attention: FIRE for Port4 on Bit5, NOT 4!
    and #$0F
    sta joy_state +3
    pla
    and #$20
    lsr
    ora joy_state +3
    sta joy_state +3
    
    rts


clear_joysticks    
    lda #$FF
    
    sta joy_state1
    sta joy_state2
    sta joy_state3
    sta joy_state4
    
    rts
