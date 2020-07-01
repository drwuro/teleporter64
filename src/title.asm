
;-------------------------------
;-- title and menu screens
;--
;-- NOTE: this has been quickly hacked together on the last evening
;--       so don't expect super-nice code here
;--
!zone

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
    !scr "craptastic 4k 2020 entry"
    !byte $FF
    
;--
    
.str_instr1
    !scr "how to play"
    !byte $FF
    
.str_instr2
    !scr "you are the teleporter  "
    !byte $FF
    
.str_instr3
    ;--  "1234567812345678123456781234567812345678" ;-- reference for max length
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
    
;--
    
.str_instr11
    !scr "the vortex path is displayed"
    !byte $FF
    
.str_instr12
    !scr "briefly while the guy is walking"
    !byte $FF
    
.str_instr13
    !scr "towards the teleporter"
    !byte $FF

.str_instr14
    !scr "it is your job as a responsible"
    !byte $FF
    
.str_instr15
    !scr "teleporter to memorize it thoroughly,"
    !byte $FF
    
.str_instr16
    !scr " as you will otherwise kill the"
    !byte $FF
    
.str_instr17
    !scr "person on his teleportation journey"
    !byte $FF
    
.str_instr18
    !scr "good luck"
    !byte $FF
    
;--
    
.str_menu1
    !scr "select game mode"
    !byte $FF

.str_menu2
    !scr "challenge mode"
    !byte $FF
    
.str_menu3
    !scr "tourist mode"
    !byte $FF
    
;--


.block_fire   = $20     ;-- used to debounce fire button
.block_move   = $21     ;-- used to debounce joystick movements
.temp         = $22

.cursorpos    !byte 0


;-- init and switch to "TITLE" state
;--
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
    

;-- draw title screen
;--
draw_title
    +STRING_OUTPUT .str_title1, 9, 3, LBL
    +STRING_OUTPUT .str_title2, 15, 5, LBL
    
    +STRING_OUTPUT .str_credits1, 13, 19, GR2
    +STRING_OUTPUT .str_credits2, 8, 21, GR2
    
    ;-- draw small wall segment
    ldx #0
-   lda #TL_WALL
    sta SCR_BASE + 40 * 14 + 17, x
    lda #BRN
    sta COL_BASE + 40 * 14 + 17, x
    inx
    cpx #5
    bne -
    
    rts
    
    
;-- draw instructions screen
;--
TEXT_COLOR = GR2
draw_instructions

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
    
    
;-- draw second instructions screen
;--
draw_more_instructions
    +STRING_OUTPUT .str_instr11, 5, 1, TEXT_COLOR
    +STRING_OUTPUT .str_instr12, 4, 3, TEXT_COLOR
    +STRING_OUTPUT .str_instr13, 9, 5, TEXT_COLOR
    
    +STRING_OUTPUT .str_instr14, 4, 13, TEXT_COLOR
    +STRING_OUTPUT .str_instr15, 2, 15, TEXT_COLOR
    +STRING_OUTPUT .str_instr16, 4, 17, TEXT_COLOR
    +STRING_OUTPUT .str_instr17, 2, 19, TEXT_COLOR
    
    +STRING_OUTPUT .str_instr18, 15, 23, LBL
    
    rts
    
    
;-- draw menu screen
;--
draw_menu
    +STRING_OUTPUT .str_menu1, 12, 6, WHT
    +STRING_OUTPUT .str_menu2, 13, 11, LBL
    +STRING_OUTPUT .str_menu3, 13, 13, LBL

    ;-- set cursor colors
    lda #GRN
    sta COL_BASE + 40 * 11 + 11
    sta COL_BASE + 40 * 13 + 11

    rts


;-- the title update function which gets called once per frame
;--
update_title

    !if DEBUG_MODE { inc $D020 }
    
    ;-- jump to current title state handler
    lda titlestate
    cmp #TS_TITLE
    bne +
    jmp .ts_title
+   cmp #TS_INSTR
    bne +
    jmp .ts_instr
+   cmp #TS_MORE
    bne +
    jmp .ts_more
+   cmp #TS_MENU
    bne +
    jmp .ts_menu
+    
    jmp .ts_end


    ;-- TITLE: display title screen
    ;--
.ts_title
    ;-- display teleporter
    jsr get_teleporter_tile
    
    sta SCR_BASE + 40 * 13 + 19
    lda #LBL
    sta COL_BASE + 40 * 13 + 19
    
    jmp .ts_end


    ;-- INSTR: display first instructions screen
    ;--
.ts_instr
    ;-- display teleporter
    jsr get_teleporter_tile
    
    sta SCR_BASE + 40 * 4 + 31
    lda #LBL
    sta COL_BASE + 40 * 4 + 31
    
    ;-- display guy
    lda tick
    lsr
    lsr
    and #%00000011
    clc
    adc #TL_GUY
    
    sta SCR_BASE + 40 * 6 + 15
    lda #GRN
    sta COL_BASE + 40 * 6 + 15

    ;-- color cycle for arrows
    lda tick
    lsr
    lsr
    and #%00000111
    sta .temp
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
    
    
    ;-- MORE: display second instructions screen
    ;--
.ts_more
    ;-- display vortex
    lda #70
    sta SCR_BASE + 40 * 9 + 17
    lda #69
    sta SCR_BASE + 40 * 9 + 18
    sta SCR_BASE + 40 * 9 + 19
    sta SCR_BASE + 40 * 9 + 20
    lda #73
    sta SCR_BASE + 40 * 9 + 21
    
    lda #68
    sta SCR_BASE + 40 * 8 + 21
    sta SCR_BASE + 40 * 10 + 17
    
    ;-- cycle vortex colors
    lda tick
    lsr
    lsr
    and #%00000111
    tax
    lda T_PATHCOLOR, x

    sta COL_BASE + 40 * 9 + 17
    sta COL_BASE + 40 * 9 + 18
    sta COL_BASE + 40 * 9 + 19
    sta COL_BASE + 40 * 9 + 20
    sta COL_BASE + 40 * 9 + 21
    
    sta COL_BASE + 40 * 8 + 21
    sta COL_BASE + 40 * 10 + 17

    jmp .ts_end


    ;-- MENU: display menu screen with both game modes as options
    ;--
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

    ;-- check joystick to move cursor
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
    and #%00000001              ;-- cursor pos can only be 0 or 1
    sta .cursorpos
    
    lda #1
    sta .block_move


.ts_end
    ;-- check for fire button
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
    
    
;-- switch to next titlestate
;--
next_titlestate
    ;-- increment title state
    inc titlestate
    lda titlestate
    cmp #TS_INSTR
    beq .switch_instr
    cmp #TS_MORE
    beq .switch_more
    cmp #TS_MENU
    beq .switch_menu
    
    ;-- start the game
    lda .cursorpos
    sta game_mode
    jsr reset_game
    rts

    ;-- switch to instructions screen
.switch_instr
    jsr clear_screen
    jsr draw_instructions
    rts

    ;-- switch to second instructions screen
.switch_more
    jsr clear_screen
    jsr draw_more_instructions
    rts

    ;-- switch to menu
.switch_menu
    jsr clear_screen
    jsr draw_menu

    rts
    
   
;-- get teleporter tile number with correct animation
;-- this is used a few times in the title, and also in the game 
;--
get_teleporter_tile    
    lda tel_anim
    lsr
    lsr
    lsr
    and #%00000011              ;-- choose correct animation phase tile
    clc
    adc #TL_TELE
    
    rts
    
