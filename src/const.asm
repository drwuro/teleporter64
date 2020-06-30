
;-------------------------------
;-- constant values

DEBUG_MODE  = 0

DIR_LEFT    = 0
DIR_RIGHT   = 1
DIR_UP      = 2
DIR_DOWN    = 3
DIR_STOP    = 4

JOY_LEFT    = %00000100
JOY_RIGHT   = %00001000
JOY_UP      = %00000001
JOY_DOWN    = %00000010
JOY_FIRE    = %00010000

;-- vic banks
VICBANK0    = $0000
VICBANK1    = $4000
VICBANK2    = $8000
VICBANK3    = $C000

;-- c64 memory locations
SCR_BASE    = $0000 + VICBANK1  ;-- screen ram
CHR_BASE    = $0800 + VICBANK1  ;-- char ram
COL_BASE    = $D800             ;-- color ram
SPR_BASE    = $1000 + VICBANK1  ;-- sprite ram
MUS_BASE    = $9000             ;-- music

VIC_BASE    = $D000             ;-- graphic chip area

;-- sid models
SID_6581    = 6
SID_8580    = 8

;-- sprite pointers
SPRITE_0    = SCR_BASE +$0400 -8
SPRITE_1    = SCR_BASE +$0400 -7
SPRITE_2    = SCR_BASE +$0400 -6
SPRITE_3    = SCR_BASE +$0400 -5
SPRITE_4    = SCR_BASE +$0400 -4
SPRITE_5    = SCR_BASE +$0400 -3
SPRITE_6    = SCR_BASE +$0400 -2
SPRITE_7    = SCR_BASE +$0400 -1

;-- sprite positions
SPRITE_0X   = VIC_BASE +0
SPRITE_0Y   = VIC_BASE +1
SPRITE_1X   = VIC_BASE +2
SPRITE_1Y   = VIC_BASE +3
SPRITE_2X   = VIC_BASE +4
SPRITE_2Y   = VIC_BASE +5
SPRITE_3X   = VIC_BASE +6
SPRITE_3Y   = VIC_BASE +7
SPRITE_4X   = VIC_BASE +8
SPRITE_4Y   = VIC_BASE +9
SPRITE_5X   = VIC_BASE +10
SPRITE_5Y   = VIC_BASE +11
SPRITE_6X   = VIC_BASE +12
SPRITE_6Y   = VIC_BASE +13
SPRITE_7X   = VIC_BASE +14
SPRITE_7Y   = VIC_BASE +15

SPRITE_XF   = VIC_BASE +16

;-- sprite colors
SPRITE_0C   = VIC_BASE +39
SPRITE_1C   = VIC_BASE +40
SPRITE_2C   = VIC_BASE +41
SPRITE_3C   = VIC_BASE +42
SPRITE_4C   = VIC_BASE +43
SPRITE_5C   = VIC_BASE +44
SPRITE_6C   = VIC_BASE +45
SPRITE_7C   = VIC_BASE +46

SPRITE_MC   = VIC_BASE +28
SPRITE_C1   = VIC_BASE +37
SPRITE_C2   = VIC_BASE +38

;-- sprite offsets relative to screen border
SPR_XOFF    = 24
SPR_YOFF    = 50

;-- sprite size
SPR_W       = 24
SPR_H       = 21

;-- sprite stuff
SPR_ENAB    = VIC_BASE +21
SPR_PRIO    = VIC_BASE +27
SPR_ZOOMX   = VIC_BASE +29
SPR_ZOOMY   = VIC_BASE +23

SPR_OV   !byte %00000001, %00000010, %00000100, %00001000, %00010000, %00100000, %01000000, %10000000
SPR_NO   !byte %11111110, %11111101, %11111011, %11110111, %11101111, %11011111, %10111111, %01111111

;-- colors
BLK         = $00
WHT         = $01
RED         = $02
CYN         = $03
PUR         = $04
GRN         = $05
BLU         = $06
YEL         = $07
ORG         = $08
BRN         = $09
LRD         = $0A
GR1         = $0B
GR2         = $0C
LGN         = $0D
LBL         = $0E
GR3         = $0F

;-- special keys
KEY_RUNSTOP = $03


