
;-------------------------------
!zone

update
    lda state
    cmp #STATE_GAME
    bne +
    jsr update_game
+   cmp #STATE_TITLE
    bne +
    ;--jsr update_title
+
    rts
    
    
;-------------------------------
;-- update game
!zone


init_game

    jsr init_level
    
    ;-- init player sprite
    lda #SP_GUY
    sta SPRITE_0
    
    lda #GRN
    sta SPRITE_0C
    
    lda #%00000001
    sta SPR_ENAB
    
    rts
    
    
reset_game
    jsr init_game
    
    lda #0
    sta gamestate
    sta curve_index
    sta tele_delay
    
    lda #$FF
    sta joy_index
    
    rts


.tempx  !word 0

update_game
    +DEBUG_BORDER RED

    ;-- choose pathcolor
    lda #0
    sta pathcolor       ;-- black path is default
    lda gamestate
    bne .no_color
    
    ;-- change pathcolor if gamestate is 0 (= walk)
    lda tick
    lsr
    lsr
    and #%00000111
    tax
    lda T_PATHCOLOR, x
    sta pathcolor
.no_color
    
    ;-- choose teleporter animation
    inc tel_anim
    lda tel_anim
    cmp #24
    bne .no_reset
    lda #0
    sta tel_anim
.no_reset
    
    ;-- draw level on screen
    jsr draw_level
    
    ;-- update game depending on gamestate
    lda gamestate
    bne +
    jmp .gs_walk
+   cmp #1
    bne +
    jmp .gs_play
+   cmp #2
    bne +
    jmp .gs_next
+
    jmp .gs_end
    
    ;--
    ;-- WALK: player walks towards the first teleporter
.gs_walk

    ;-- move player every 4th frame
    lda tick
    and #%00000011
    bne +
    inc playerx
+
    ;-- check if player reached teleporter
    jsr get_tile_at_playerpos
    cmp #' '
    beq .not_reached
    
    inc gamestate   ;-- switch to next gamestate
    
    lda #0
    sta tele_delay
    
.not_reached
    jmp .gs_end

    ;--
    ;-- PLAY: teleportation phase
.gs_play

    ;-- handle joystick input
    ldx joy_index
    
    lda $DC00               ;-- read joystick port 2
    and #%00011111
    cmp #%00011111          ;-- check for neutral position
    beq .no_joy
    cmp JOY_LIST, x         ;-- check if state is different than previous one
    beq .no_joy
    
    ;-- only write if it's a clear direction (no diagonals)
    cmp #%00011110
    beq .write_joy
    cmp #%00011101
    beq .write_joy
    cmp #%00011011
    beq .write_joy
    cmp #%00010111
    beq .write_joy
    
    jmp .no_joy
    
.write_joy
    ;-- add current joystick state to list
    inx
    sta JOY_LIST, x
    stx joy_index
    
.no_joy

    ;-- player movement

    lda tele_delay          ;-- check if we're still in waiting phase
    cmp #TELE_DELAY
    beq .move_player

    inc tele_delay
    lda JOY_LIST
    jmp .curve_left         ;-- set initial direction (a bit hacky)
    
    ;-- move player
.move_player
    lda playerdir

    cmp #DIR_LEFT
    bne .check_right
    +SUB_16_8 playerx, playerspeed
    jmp .endmove

.check_right
    cmp #DIR_RIGHT
    bne .check_up
    +ADD_16_8 playerx, playerspeed
    jmp .endmove
    
.check_up
    cmp #DIR_UP
    bne .check_down
    sec
    lda playery
    sbc playerspeed
    sta playery
    jmp .endmove

.check_down
    cmp #DIR_DOWN
    bne .endmove
    clc
    lda playery
    adc playerspeed
    sta playery

.endmove

    ;-- check if player is located on a curve
    lda playerx
    and #%00000111
    bne .no_curve
    lda playery
    and #%00000111
    bne .no_curve
    
    jsr get_tile_at_playerpos
    cmp #70
    beq .curve
    cmp #71
    beq .curve
    cmp #72
    beq .curve
    cmp #73
    beq .curve
    
    jmp .no_curve
    
.curve
    ;-- get next direction in joy list
    inc curve_index
    ldx curve_index
    lda JOY_LIST, x
    
.curve_left
    cmp #%00011011
    bne .curve_right
    lda #DIR_LEFT
    jmp .change_dir
    
.curve_right
    cmp #%00010111
    bne .curve_up
    lda #DIR_RIGHT
    jmp .change_dir
    
.curve_up
    cmp #%00011110
    bne .curve_down
    lda #DIR_UP
    jmp .change_dir
    
.curve_down
    cmp #%00011101
    bne .no_curve
    lda #DIR_DOWN
    
.change_dir
    sta playerdir
    
.no_curve

    ;-- check if player leaves the screen
    
    lda playerx
    sta .tempx
    lda playerx +1
    ror
    ror .tempx
    lda .tempx
    cmp #0
    beq .left_border
    cmp #320/2 + SPR_XOFF
    beq .right_border
    
    lda playery
    cmp #0
    beq .upper_border
    cmp #200
    beq .lower_border
    
    jmp .no_border
    
.left_border
.right_border
.upper_border
.lower_border

    jsr reset_game
    rts

.no_border    

    ;-- draw player as teleportation schwurbel
    lda tel_anim
    lsr
    lsr
    lsr
    and #%00000011
    clc
    adc #SP_TELE
    sta SPRITE_0
    
    jmp .update_sprite_pos

    ;--
    ;-- NEXT: player walks towards end of screen (next level)
.gs_next

    ;-- move player every 4th frame
    lda tick
    and #%00000011
    bne +
    +INC_16 playerx
+
    ;-- check if player reached end of screen
    lda playerx +1
    beq .gs_end
    lda playerx
    cmp #<(RIGHT_PLAT_X + PLAT_W) * 8
    bne .gs_end
    
    ;-- next level
    inc $D021
    
.gs_end

    ;-- draw player as guy    
    lda tick
    lsr
    lsr
    and #%00000011
    clc
    adc #SP_GUY
    sta SPRITE_0
    
.update_sprite_pos
    ;-- add sprite border offset to playerx
    +ADD_16_8C playerx, SPR_XOFF, .tempx

    ;-- set low byte of sprite x position
    lda .tempx
    sta SPRITE_0X
    
    ;-- set high bit of sprite x position
    lda .tempx +1
    beq .no_overflow
    lda SPRITE_XF
    ora SPR_OV
    jmp .end_overflow
.no_overflow
    lda SPRITE_XF
    and SPR_NO
.end_overflow
    sta SPRITE_XF

    ;-- set sprite y position
    lda playery
    clc
    adc #SPR_YOFF
    sta SPRITE_0Y

    +DEBUG_BORDER BLU
    
    rts

    
;-------------------------------
;-- level functions
!zone


.levaddr = $20
.scraddr = $22
.coladdr = $24

.color   = $26

.curdir !byte 0
.olddir !byte 0
    
    
init_level
    ;-- load level address
    lda #<LEVEL
    sta .levaddr
    lda #>LEVEL
    sta .levaddr +1
    
    ;-- set player x pos
    lda #LEFT_PLAT_X * 8
    sta playerx
    lda #0
    sta playerx +1
    
    ;-- determine player y pos
    ldy #0
    lda (.levaddr), y       ;-- y of left platform
    
    tax
    dex                     ;-- player is 1 row above platform
    txa
    
    asl
    asl
    asl
    sta playery
    
    rts
    

draw_level
    ;-- draw platforms and teleporters
    ldx #LEFT_PLAT_X
    ldy #0
    lda (.levaddr), y       ;-- y of left platform
    jsr draw_platform
    
    ldx #RIGHT_PLAT_X
    ldy #1
    lda (.levaddr), y       ;-- y of right platform
    jsr draw_platform
    
    ;-- draw teleportation path
    lda pathcolor
    sta .color
    
    jsr draw_path
    
    rts
    
    
draw_platform
    tay
    lda T_SCREENLINES_L, y
    sta .scraddr
    lda T_SCREENLINES_H, y
    sta .scraddr +1

    lda T_COLORLINES_L, y
    sta .coladdr
    lda T_COLORLINES_H, y
    sta .coladdr +1
    
    txa
    tay
    lda #TL_WALL

    ;-- draw wall tiles
    sta (.scraddr), y
    
    !for i, 0, PLAT_W -2 {
        iny
        sta (.scraddr), y
    }
    
    ;-- draw color
    lda #BRN
    
    sta (.coladdr), y
    
    !for i, 0, PLAT_W -2 {
        dey
        sta (.coladdr), y
    }

    ;-- draw teleporter
    +SUB_16_8C .scraddr, 40
    +SUB_16_8C .coladdr, 40
    
    lda tel_anim
    lsr
    lsr
    lsr
    and #%00000011
    clc
    adc #TL_TELE

    cpx #LEFT_PLAT_X        ;-- check whether drawing left or right teleporter
    bne .not_left
    
    ;-- go to right end of platform when drawing left teleporter
    !for i, 0, PLAT_W -2 {
        iny
    }
    
.not_left
    sta (.scraddr), y
    lda #LBL
    sta (.coladdr), y    
    
    rts
    

draw_path
    ldy #3
    lda (.levaddr), y       ;-- path start y position
    tay
    
    lda T_SCREENLINES_L, y
    sta .scraddr
    lda T_SCREENLINES_H, y
    sta .scraddr +1
    
    lda T_COLORLINES_L, y
    sta .coladdr
    lda T_COLORLINES_H, y
    sta .coladdr +1
    
    ldy #2
    lda (.levaddr), y       ;-- path start x position
    tay

    ;-- load path start address (level address + 4)
    +ADD_16_8C .levaddr, 4, .o1 +1
    
    ;-- draw path loop
    ldx #$FF
    
.loop
    inx
    lda .curdir
    sta .olddir             ;-- store previous direction
.o1 lda $FFFF, x
    sta .curdir

    ;-- determine path direction from current path char
    cmp #'l'
    beq .left
    cmp #'r'
    beq .right
    cmp #'u'
    beq .up
    cmp #'d'
    beq .down
    
    ;-- if path char is not l, r, u or d, path drawing is finished
    jmp .end
    
    ;-- path goes left
.left
    lda .olddir
    cmp #'u'
    beq .ul                 ;-- previous direction was 'up'
    cmp #'d'
    beq .dl                 ;-- previous direction was 'down'
    
    lda #69
    jmp .writeleft
    
.ul lda #71
    jmp .writeleft
.dl lda #73

.writeleft
    ;-- write char to screen
    sta (.scraddr), y
    lda .color
    sta (.coladdr), y
    ;-- go one char to the left for next char
    dey
    jmp .loop

    ;-- path goes right
.right
    lda .olddir
    cmp #'u'
    beq .ur                 ;-- previous direction was 'up'
    cmp #'d'
    beq .dr                 ;-- previous direction was 'down'
    
    lda #69
    jmp .writeright
    
.ur lda #70
    jmp .writeright
.dr lda #72
    jmp .writeright

.writeright
    ;-- write char to screen
    sta (.scraddr), y
    lda .color
    sta (.coladdr), y
    ;-- go one char to the right for next char
    iny
    jmp .loop

    ;-- path goes up
.up
    lda .olddir
    cmp #'l'                 ;-- previous direction was 'left'
    beq .lu
    cmp #'r'                 ;-- previous direction was 'right'
    beq .ru
    
    lda #68
    jmp .writeup
    
.lu lda #72
    jmp .writeup
.ru lda #73

.writeup
    ;-- write char to screen
    sta (.scraddr), y
    lda .color
    sta (.coladdr), y
    ;-- go one char line up for next char
    jmp .scrlineup

    ;-- path goes down
.down
    lda .olddir
    cmp #'l'                 ;-- previous direction was 'left'
    beq .ld
    cmp #'r'                 ;-- previous direction was 'right'
    beq .rd

    lda #68
    jmp .writedown
    
.ld lda #70
    jmp .writedown
.rd lda #71

.writedown
    ;-- write char to screen
    sta (.scraddr), y
    lda .color
    sta (.coladdr), y
    ;-- go one char line down for next char
    jmp .scrlinedown
    
.scrlineup
    +SUB_16_8C .scraddr, 40
    +SUB_16_8C .coladdr, 40
    jmp .loop

.scrlinedown
    +ADD_16_8C .scraddr, 40
    +ADD_16_8C .coladdr, 40
    jmp .loop

.end
    rts


;-- return tile (char) at pos x/y

.tempaddr   = $29

get_tile_at_playerpos
    lda playerx
    lsr
    lsr
    lsr
    tax             ;-- x is now playerx / 8
    
    ;-- TODO will not work with x > 255!!!
    
    lda playery
    lsr
    lsr
    lsr
    tay             ;-- y is now playery / 8


get_tile

    lda T_SCREENLINES_L, y
    sta .tempaddr
    lda T_SCREENLINES_H, y
    sta .tempaddr +1
    
    txa
    tay
    lda (.tempaddr), y
    
    rts


    
