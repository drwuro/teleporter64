
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


;-------------------------------
;-- game specific

num_lives           !byte 3

pathcolor           !byte GR1
tel_anim            !byte 0

playerx             !word 0
playery             !byte 0
playerdir           !byte DIR_RIGHT
playerspeed         !byte 4

gamestate           !byte 0     ;-- 0 = walk, 1 = play, 2 = next


JOY_LIST            = $C000     ;-- the list of joystick input states
joy_index           !byte $FF
curve_index         !byte 0
tele_delay          !byte 0
TELE_DELAY          = 16


STATE_GAME          = 0
STATE_TITLE         = 1

LEFT_PLAT_X         = 4
RIGHT_PLAT_X        = 30
PLAT_W              = 6

TL_WALL             = 64
TL_TELE             = 65

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


LEVEL
    !byte 20        ;-- y of left platform
    !byte 5         ;-- y of right platform
    !byte 12, 19    ;-- start x/y of path
    
    ;-- !text "rrrrddllddddddddrrrrrrrruuuuuuurrrrrrrrrrdddd"
    ;-- !text "rrrruuuurrrrddddllddrrrrrrrruurrulllllldddddddddddddrrrrruu"
    ;-- !text "lllllllluuuuuulllllllllllldddrrrruuuuuuullllllluuuuuu$"
    
    !text "rrrrrrrruuuuuuuuullllluuuuuurrrrrrrrrrrrr$"
    
T_PATHCOLOR
    !byte GR1, GR2, GR3, WHT, WHT, GR3, GR2, GR1
    

