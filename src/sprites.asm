;---------------------------------------------------------------
;-- NOTE: normally, this file would contain plain sprite data.
;--       however, since the sprites are 8x8 pixels only, they
;--       have been moved to tiles.asm in order to save some
;--       space. they get copied to their final memory locations
;--       using the following routines.
;--
;--       during development, they were still stored in this
;--       file as normal sprites, so for documentational purposes,
;--       they are left inside this file, after an end-of-file
;--       command (!eof), so they won't get included into the
;--       program.

;-------------------------------
!zone

;-- TODO overwrite target area with zero

;-- turn some chars into sprites
;--

.srcaddr    = $20
.destaddr   = $22
.temp       = $24

prepare_sprites
    ;-- source address
    lda #<CHR_BASE + 74 * 8
    sta .srcaddr
    lda #>CHR_BASE + 74 * 8
    sta .srcaddr +1

    ;-- destination address
    lda #<SPR_BASE
    sta .destaddr
    lda #>SPR_BASE
    sta .destaddr +1

    ldx #8
.loop
    dex
    jsr clear_sprite
    jsr copy_char_to_sprite

    +ADD_16_8C .srcaddr, 8      ;-- next char
    +ADD_16_8C .destaddr, 64    ;-- next sprite

    cpx #0
    bne .loop
    
    rts


clear_sprite
    lda #0
    ldy #64
    
.clearloop
    dey
    sta (.destaddr), y
    cpy #0
    bne .clearloop
    
    rts
    

copy_char_to_sprite
    +SAVE_XY

    ldx #0
    ldy #0

.copyloop
    sty .temp
    
    txa
    tay
    lda (.srcaddr), y
    
    ldy .temp
    sta (.destaddr), y
    iny
    iny
    iny

    inx
    cpx #8
    bne .copyloop

    +RESTORE_XY

    rts


;--------------------------------------------------------------
!eof
;--------------------------------------------------------------
;-- as said above, the following data is just left in for
;-- documentational purposes. this is how the sprites will
;-- look like in memory after being copied.

!macro SpriteLine .v {
	!by .v >> 16, (.v >> 8) & 255, .v & 255
}

    +SpriteLine %...##...................
    +SpriteLine %...##...................
    +SpriteLine %...#....................
    +SpriteLine %..####..................
    +SpriteLine %.#.##.#.................
    +SpriteLine %...##...................
    +SpriteLine %..#..#..................
    +SpriteLine %.#....#.................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................

    !byte 0
    
    +SpriteLine %...##...................
    +SpriteLine %...##...................
    +SpriteLine %...#....................
    +SpriteLine %..####..................
    +SpriteLine %..####..................
    +SpriteLine %...##...................
    +SpriteLine %...#.#..................
    +SpriteLine %..#..#..................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................

    !byte 0
    
    +SpriteLine %...##...................
    +SpriteLine %...##...................
    +SpriteLine %...#....................
    +SpriteLine %...##...................
    +SpriteLine %...##...................
    +SpriteLine %...##...................
    +SpriteLine %...##...................
    +SpriteLine %...###..................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................

    !byte 0
    
    +SpriteLine %...##...................
    +SpriteLine %...##...................
    +SpriteLine %...#....................
    +SpriteLine %..####..................
    +SpriteLine %..####..................
    +SpriteLine %...##...................
    +SpriteLine %..#.#...................
    +SpriteLine %..#..#..................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................

    !byte 0
    
    +SpriteLine %........................
    +SpriteLine %...#....................
    +SpriteLine %..#..#..................
    +SpriteLine %....#...................
    +SpriteLine %...#....................
    +SpriteLine %..#..#..................
    +SpriteLine %....#...................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................

    !byte 0
    
    +SpriteLine %........................
    +SpriteLine %..#..#..................
    +SpriteLine %....#...................
    +SpriteLine %...#....................
    +SpriteLine %..#..#..................
    +SpriteLine %....#...................
    +SpriteLine %...#....................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................

    !byte 0
    
    +SpriteLine %........................
    +SpriteLine %....#...................
    +SpriteLine %...#....................
    +SpriteLine %..#..#..................
    +SpriteLine %....#...................
    +SpriteLine %...#....................
    +SpriteLine %..#..#..................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................
    +SpriteLine %........................

    !byte 0


