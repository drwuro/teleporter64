

.str_title1
    !scr "a day in the life of a"
    !byte $FF
    
.str_title2
    !scr "teleporter"
    !byte $FF

.str_credits1
    !scr "a game by zeha"
    !byte $FF
    
.str_credits2
    !scr "2020"
    !byte $FF
    
    
.str_instr1
    !scr "how to play"
    !byte $FF
    
.str_instr2
    !scr "you are the teleporter  "
    !byte $FF
    
.str_instr3
    ;-- !scr "1234567812345678123456781234567812345678"
    !scr "when the guy   enters the teleporter,"
    !byte $FF

.str_instr4
    !scr "your job is to quickly guide him through"
    !byte $FF
    
.str_instr5
    !scr "the teleportation vortex (which humans"
    !byte $FF
    
.str_instr6
    !scr "can't see of course)"
    !byte $FF
    
.str_instr7
    !scr "wiggle your joystick to trace the path"
    !byte $FF
    
.str_instr8
    !scr "as fast as you can right after the"
    !byte $FF
    
.str_instr9
    !scr "teleportation process has started"
    !byte $FF
    
    
.str_menu1
    !scr "select game mode"
    !byte $FF

.str_menu2
    !scr "challenge mode"
    !byte $FF
    
.str_menu3
    !scr "tourist mode"
    !byte $FF


.block_fire   = $20
.block_move   = $21
.temp         = $22

.cursorpos    !byte 0


init_title

    lda #STATE_TITLE
    sta state
    
    lda #0
    sta titlestate
    sta SPR_ENAB
    
    lda #1
    sta .block_fire
    sta .block_move
    
    jsr clear_screen
    jsr draw_title
    
    rts
    

draw_title
    +STRING_OUTPUT .str_title1, 9, 6, LBL
    +STRING_OUTPUT .str_title2, 15, 8, LBL
    
    +STRING_OUTPUT .str_credits1, 13, 16, GR2
    +STRING_OUTPUT .str_credits2, 18, 18, GR2
    
    rts
    
    
draw_instructions
    TEXT_COLOR = GR2

    +STRING_OUTPUT .str_instr1, 15, 1, WHT
    +STRING_OUTPUT .str_instr2, 8, 4, TEXT_COLOR
    +STRING_OUTPUT .str_instr3, 2, 6, TEXT_COLOR
    +STRING_OUTPUT .str_instr4, 0, 8, TEXT_COLOR
    +STRING_OUTPUT .str_instr5, 1, 10, TEXT_COLOR
    +STRING_OUTPUT .str_instr6, 9, 12, TEXT_COLOR
    
    +STRING_OUTPUT .str_instr7, 1, 16, TEXT_COLOR
    +STRING_OUTPUT .str_instr8, 3, 18, TEXT_COLOR
    +STRING_OUTPUT .str_instr9, 3, 20, TEXT_COLOR
    
    rts
    
    
draw_menu
    +STRING_OUTPUT .str_menu1, 12, 6, WHT
    +STRING_OUTPUT .str_menu2, 13, 11, LBL
    +STRING_OUTPUT .str_menu3, 13, 13, LBL

    ;-- set cursor colors
    lda #GRN
    sta COL_BASE + 40 * 11 + 11
    sta COL_BASE + 40 * 13 + 11

    rts


update_title

    !if DEBUG_MODE { inc $D020 }

    lda titlestate
    cmp #TS_TITLE
    bne +
    jmp .ts_title
+   cmp #TS_INSTR
    bne +
    jmp .ts_instr
+   cmp #TS_MENU
    bne +
    jmp .ts_menu
+    
    jmp .ts_end


.ts_title
    jmp .ts_end


.ts_instr
    ;-- display teleporter
    lda tel_anim
    lsr
    lsr
    lsr
    and #%00000011              ;-- choose correct animation phase tile
    clc
    adc #TL_TELE
    
    sta SCR_BASE + 40 * 4 + 31
    lda #LBL
    sta COL_BASE + 40 * 4 + 31
    
    ;-- display guy
    lda tick
    lsr
    lsr
    and #%00000011
    sta .temp
    clc
    adc #TL_GUY
    
    sta SCR_BASE + 40 * 6 + 15
    lda #GRN
    sta COL_BASE + 40 * 6 + 15

    ;-- color cycle for arrows
;--    inc .temp
    ldx #0
-   txa
    clc
    adc #TL_LEFT
    sta SCR_BASE + 40 * 23 + 18, x
    lda #LBL
    cpx .temp
    bpl +
    lda #WHT
+   sta COL_BASE + 40 * 23 + 18, x   
    inx
    cpx #4
    bne -

    jmp .ts_end
    

.ts_menu
    
    ;-- delete cursors
    lda #' '
    sta SCR_BASE + 40 * 11 + 11
    sta SCR_BASE + 40 * 13 + 11
    
    ;-- set cursor
    lda tel_anim
    lsr
    lsr
    lsr
    and #%00000011              ;-- choose correct animation phase tile
    clc
    adc #TL_SCHWURBEL
    
    ldx .cursorpos
    beq +
    ldx #40 * 2                 ;-- move cursor down 2 rows
+   sta SCR_BASE + 40 * 11 + 11, x

    jsr get_joy_dir
    cmp #DIR_UP
    beq .move_cursor
    cmp #DIR_DOWN
    beq .move_cursor
    lda #0
    sta .block_move

    jmp .ts_end

.move_cursor
    lda .block_move
    bne .ts_end

    inc .cursorpos
    lda .cursorpos
    and #%00000001
    sta .cursorpos
    
    lda #1
    sta .block_move

.ts_end
    lda $DC00       ;-- read joystick in port 2
    and #JOY_FIRE
    bne .no_joy
    
    lda .block_fire
    bne .no_joy2
    
    lda #1
    sta .block_fire
    
    jsr next_titlestate
    rts

.no_joy
    lda #0
    sta .block_fire

.no_joy2
    rts
    
    
    
next_titlestate
    
    inc titlestate
    lda titlestate
    cmp #TS_INSTR
    beq .switch_title
    cmp #TS_MENU
    beq .switch_menu
    
    ;-- start the game
    lda .cursorpos
    sta game_mode
    jsr reset_game
    rts

.switch_title
    jsr clear_screen
    jsr draw_instructions
    rts

.switch_menu
    jsr clear_screen
    jsr draw_menu

    rts
    
    
    
