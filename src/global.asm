
;-- global variables (and also some constants which are more game-specific)

tick                !byte 0

state               !byte STATE_GAME
state_cnt           !byte 0
state_flag          !byte 1
state_next          !byte 0
_state_next         !byte $FF

irqLine             !byte 255
irqTrigger          !byte 0

seed                !byte 64    ;-- must not be 0

key                 !byte 0

num_lives           !byte 3
level_number        !byte 0

pathcolor           !byte GR1
tel_anim            !byte 0

playerx             !word 0
playery             !byte 0
playerdir           !byte DIR_RIGHT
playerspeed         !byte 4

game_mode           !byte 0     ;-- 0 = challenge, 1 = tourist

gamestate           !byte 0     ;-- 0 = walk, 1 = play, 2 = next, 3 = lost, 4 = won
GS_WALK = 0
GS_PLAY = 1
GS_NEXT = 2
GS_LOST = 3
GS_WON  = 4

titlestate          !byte 0     ;-- title, 1 = instructions, 2 = more instructions, 3 = menu
TS_TITLE = 0
TS_INSTR = 1
TS_MORE  = 2
TS_MENU  = 3

tele_delay          !byte 0     ;-- delay until teleportation really starts
TELE_DELAY          = 16

JOY_LIST            = $C000     ;-- the list of joystick input states
joy_index           !byte $FF   ;-- current write index of JOY_LIST
curve_index         !byte 0     ;-- current read index of JOY_LIST

num_attempts        !byte 0     ;-- number of attempts the player took


STATE_GAME          = 0
STATE_TITLE         = 1

LEFT_PLAT_X         = 5         ;-- x position of left platform
RIGHT_PLAT_X        = 30        ;-- x position of right platform
PLAT_W              = 5         ;-- platform width

;-- tiles
TL_WALL             = 64
TL_TELE             = 65
TL_COMP             = 74
TL_LEFT             = 75
TL_RIGHT            = 76
TL_UP               = 77
TL_DOWN             = 78
TL_GUY              = 79
TL_SCHWURBEL        = 83

;-- sprites
SP_GUY              = <SPR_BASE / 64
SP_TELE             = <SPR_BASE / 64 + 4


T_SCREENLINES_L
    !for i, 0, 24 { !byte <SCR_BASE + i * 40 }
T_SCREENLINES_H
    !for i, 0, 24 { !byte >SCR_BASE + i * 40 }
    
T_COLORLINES_L
    !for i, 0, 24 { !byte <COL_BASE + i * 40 }
T_COLORLINES_H
    !for i, 0, 24 { !byte >COL_BASE + i * 40 }

    
T_PATHCOLOR
    !byte GR1, GR2, GR3, WHT, WHT, GR3, GR2, GR1
    

