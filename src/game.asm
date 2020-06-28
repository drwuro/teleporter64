
str_lost
    !scr "you failed"
    !byte $FF

str_won
    !scr "congratulations"
    !byte $FF


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
;-- game functions
!zone


init_game

    lda #0
    sta SPR_ENAB        ;-- turn off sprites

    jsr clear_screen
    lda #LBL
    jsr clear_color_ram

    jsr init_level
    
    ;-- clear joy list
    lda #0
    ldx #0
.clearloop
    sta JOY_LIST, x
    dex
    bne .clearloop
    
    ;-- reset game related variables
    lda #0
    sta gamestate
    sta curve_index
    sta tele_delay
    
    lda #DIR_RIGHT
    sta playerdir
    
    lda #$FF
    sta joy_index
    
    ;-- init player sprite
    lda #SP_GUY
    sta SPRITE_0
    
    lda #GRN
    sta SPRITE_0C
    
    rts



next_level
    inc level_number
    lda level_number
    cmp #NUM_LEVELS
    bne +
    lda #0
    sta level_number
+   jsr init_game
    
    rts



.tempx  !word 0

update_game
    +DEBUG_BORDER RED

    ;-- choose pathcolor
    lda #0
    sta pathcolor       ;-- black path is default
    lda gamestate
    bne .no_color
    
    ;-- change pathcolor if gamestate is 0 (GS_WALK)
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
+   cmp #GS_PLAY
    bne +
    jmp .gs_play
+   cmp #GS_NEXT
    bne +
    jmp .gs_next
+   cmp #GS_LOST
    bne +
    jmp .gs_lost
+   cmp #GS_WON
    bne +
    jmp .gs_won
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
    and #%01111111  ;-- check if we're on a space char, but inverted is ok too
    cmp #' '
    beq .not_reached
    
    inc gamestate           ;-- switch to next gamestate (GS_PLAY)
    
    lda #0
    sta tele_delay
    
    +PLAY_SFX
    
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
    
    ;-- only write if it's a clear direction (no diagonals)
    cmp #%00011011
    beq .write_left
    cmp #%00010111
    beq .write_right
    cmp #%00011110
    beq .write_up
    cmp #%00011101
    beq .write_down
    
    jmp .no_joy
    
    ;-- choose direction value according to joy state
.write_left
    lda #DIR_LEFT
    jmp .write_joy
.write_right
    lda #DIR_RIGHT
    jmp .write_joy
.write_up
    lda #DIR_UP
    jmp .write_joy
.write_down
    lda #DIR_DOWN
    
.write_joy
    cmp JOY_LIST, x             ;-- check if state is different than previously
    beq .no_joy

    ;-- add direction to list
    inx
    sta JOY_LIST, x
    stx joy_index
    
    ;-- add arrow symbol to screen
    clc
    adc #TL_LEFT                ;-- direction + left arrow = arrow tile number
    sta SCR_BASE + 40 * 24, x
    
.no_joy
    ;-- player movement
    lda tele_delay              ;-- check if we're still in waiting phase
    cmp #TELE_DELAY
    beq .move_player

    ;-- waiting phase
    inc tele_delay
    lda JOY_LIST
    sta playerdir               ;-- set initial player direction
    
    lda #WHT
    sta COL_BASE + 40 * 24, x   ;-- make first arrow white
    
    jmp .update_sprite_pos
    
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

    ;-- check for tile collision
    
    ;-- make sure player is exactly on a tile (xy position / 8)
    lda playerx
    and #%00000111
    bne .no_curve
    lda playery
    and #%00000111
    bne .no_curve
    
    jsr get_tile_at_playerpos
    
    ;-- check if player is located on a curve
    cmp #70
    beq .curve
    cmp #71
    beq .curve
    cmp #72
    beq .curve
    cmp #73
    beq .curve
    ;-- check if player is located on a teleporter
    cmp #TL_TELE
    beq .on_teleporter
    cmp #TL_TELE +1
    beq .on_teleporter
    cmp #TL_TELE +2
    beq .on_teleporter

    jmp .no_curve
    
.on_teleporter
    ;-- make sure it's the teleporter on the right
    cpx #RIGHT_PLAT_X   ;-- x is still playerx / 8 at this point so we can utilize this
    bne .no_curve
    
    inc gamestate       ;-- switch to next gamestate (GS_NEXT)
    rts
    
.curve
    ldx curve_index
    
    ;-- get next value from joy list and apply to player's moving direction
    inx
    lda JOY_LIST, x
    sta playerdir

    ;-- make arrow white on screen
    lda #WHT
    sta COL_BASE + 40*24, x
    stx curve_index

.no_curve

    ;-- check if player leaves the screen
    lda playerx +1
    clc
    ror
    lda playerx
    ror
    beq .dead           ;-- x = 0
    cmp #160
    beq .dead
    
    lda playery
    cmp #0
    beq .dead
    cmp #200
    beq .dead
    
    jmp .no_border

.dead
    ;-- player is dead
    lda #GS_LOST
    sta gamestate

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
    
    lda #%00000000
    sta SPR_PRIO            ;-- during teleportation phase, sprite shall be in front of chars
    
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
    
    ;-- check if player is standing next to a computer
    lda playerx +1
    clc
    ror
    lda playerx
    ror
    lsr
    lsr
    tax
    inx
    
    lda playery
    lsr
    lsr
    lsr
    tay
    
    jsr get_tile
    cmp #TL_COMP
    bne .no_computer

    lda #GS_WON
    sta gamestate
    jmp .gs_end
    
.no_computer
    ;-- check if player reached end of screen
    lda playerx +1
    beq .gs_end
    lda playerx
    cmp #<(RIGHT_PLAT_X + PLAT_W) * 8
    bne .gs_end
    
    ;-- go to next level
    jsr next_level
    rts
    
    ;--
    ;-- LOST: show message, wait for fire, restart
.gs_lost
    +STRING_OUTPUT str_lost, 14, 12, LBL
    
    lda #%00000000
    sta SPR_ENAB
    
    lda $DC00       ;-- read joystick in port 2
    and #JOY_FIRE
    bne .no_fire
    
    ;-- restart level
    jsr init_game
    
.no_fire
    rts

    ;--
    ;-- WON: show message
.gs_won
    +STRING_OUTPUT str_won, 12, 10, LBL

    lda $DC00       ;-- read joystick in port 2
    and #JOY_FIRE
    bne .gs_end
    
    ;-- restart game    TODO
    lda #0
    sta level_number
    jsr init_game
    
.gs_end

    ;-- draw player as guy
    lda tick
    lsr
    lsr
    and #%00000011
    clc
    adc #SP_GUY
    sta SPRITE_0
    
    lda #%00000001
    sta SPR_PRIO            ;-- during walking phase, sprite shall be behind chars
    sta SPR_ENAB            ;-- make sure sprite is visible
    
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

    +DEBUG_BORDER BLK
    
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
    lda level_number
    asl
    tax

    ;-- load level address
    lda T_LEVELS, x
    sta .levaddr
    lda T_LEVELS +1, x
    sta .levaddr +1
    
    ;-- unpack level path
    jsr unpack_path
    
    ;-- set player x pos
    lda #(LEFT_PLAT_X -1) * 8
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
    
    
    
.count  = $27
    
unpack_path
    ldy #4                  ;-- offset of path start in level data
    ldx #0
    
.read
    lda (.levaddr), y        ;-- read number
    cmp #$FF
    beq .end_unpack
    sta .count
    
    iny
    lda (.levaddr), y       ;-- read direction (l, r, u, d)
    
.writeloop
    sta UNPACKED_PATH, x    ;-- write direction number of times
    inx
    dec .count
    bne .writeloop
    
    iny
    jmp .read
    
.end_unpack
    lda #'$'
    sta UNPACKED_PATH, x    ;-- write end character ($)
    
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
    
    ;-- note: the following code is a bit messy

    ;-- draw teleporter
    +SUB_16_8C .scraddr, 40     ;-- teleporter is 1 char row above walls
    +SUB_16_8C .coladdr, 40
    
    lda tel_anim
    lsr
    lsr
    lsr
    and #%00000011              ;-- choose correct animation phase tile
    clc
    adc #TL_TELE

    cpx #LEFT_PLAT_X        ;-- check whether drawing left or right teleporter
    bne +
    !for i, 0, PLAT_W -2 { iny }    ;-- move a few chars to the right for left teleporter
+   sta (.scraddr), y
    lda #LBL
    sta (.coladdr), y
    
    ;-- draw black square (to make player sprite disappear behind)
    txa
    tay
    dey
    
    cpx #LEFT_PLAT_X        ;-- check whether drawing left or right teleporter
    beq +
    !for i, 0, PLAT_W { iny }       ;-- move a few chars to the right for right teleporter
    
    ;-- check if we have to draw a computer instead (last level)
    lda level_number
    cmp #NUM_LEVELS -1
    bne +
    
    ;-- draw computer
    dey
    lda #TL_COMP
    sta (.scraddr), y
    lda #WHT
    sta (.coladdr), y
    rts
    
    ;-- draw black square
+   lda #' ' + 128          ;-- inverted space char
    sta (.scraddr), y
    lda #BLK
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
    ;-- +ADD_16_8C .levaddr, 4, .o1 +1
    
    ;-- draw path loop
    ldx #$FF
    
.loop
    inx
    lda .curdir
    sta .olddir             ;-- store previous direction
.o1 lda UNPACKED_PATH, x
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
    
    ;-- divide x by 8
    lda playerx +1  ;-- high bit needs to be taken along
    clc
    ror
    lda playerx
    ror
    lsr
    lsr
    tax             ;-- x is now playerx / 8
    
    ;-- divide y by 8
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


    
