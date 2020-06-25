
    ;-- ##################################
    ;-- ###                            ###
    ;-- ###   A DAY IN THE LIFE OF A   ###
    ;-- ###                            ###
    ;-- ###        TELEPORTER          ###
    ;-- ###                            ###
    ;-- ##################################
    ;--
    ;-- a game by ZeHa
    ;--
    ;-- originally developed as a PICO-8 game
    ;-- during a gamejam called Mid-Jam 2020
    ;--     -> https://drwuro.itch.io/a-day-in-the-life-of-a-teleporter
    ;--
    ;-- C64 version developed shortly after
    ;-- for Reset64 Craptastic 4K Game Compo 2020
    ;--     -> https://csdb.dk/event/?id=2958
    

    ;-- output file and start address
    !to "out.prg", cbm
    *=  $0801
    
    ;-- basic starter
    !byte $17, $08, $0a, $00, $8f, $20          ;-- 10 REM
    !text "*** TELEPORTER ***"
    !byte $00
    
    !byte $3a, $08, $14, $00, $8f, $20          ;-- 20 REM
    !text "(C) 2020 DR. WURO INDUSTRIES"
    !byte $00
    
    !byte $45, $08, $1e, $00, $9e, $20          ;-- 30 SYS
    !text "2128"
    
    !byte $00, $00, $00                         ;-- end of basic program
    
    ;-- address 2128 decimal, program entry point
    *= $0850
    jmp main
    
    ;-- code includes
    !src "const.asm"
    !src "global.asm"
    !src "macros.asm"
    !src "tools.asm"
    !src "joystick.asm"
    !src "game.asm"
    !src "irq.asm"
    
;-------------------------------
!zone

main
    jsr turn_off_basic
    jsr turn_off_screen
    jsr turn_off_runstop_restore
    ;-- jsr turn_off_charset_toggle
    jsr clear_screen
    jsr init_screen
    
;--    +MEMCOPY_HUGE SPRTBASE, SPRTBASE + $4000, SPR_BASE   ;-- not needed anymore (see sprites.asm)
    +MEMCOPY_HUGE CHARBASE, CHARBASE + $0800, CHR_BASE
    
    jsr prepare_sprites
    
    jsr init_joysticks
    jsr irq_setup
    jsr turn_on_screen
    
    jsr init_game
    
    
.mainloop
    lda irqTrigger
    beq .no_irq
    
    inc tick
    jsr update
    
    lda #0
    sta irqTrigger
    
.no_irq
    jsr $FFE4       ;-- GETIN
    beq .nokey
    sta key
.nokey
    jmp .mainloop

;-------------------------------
!zone

    ;-- resource includes
    
SPRTBASE
    !src "sprites.asm"
CHARBASE
    !src "font.asm"
    !src "tiles.asm"
MUSIBASE
    !src "sound.asm"
    
    