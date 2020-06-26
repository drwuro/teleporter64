
;-- level strings are stored in the following format:
;-- "rrrrrrrrrruuuuuuuuulllluuuuuurrrrrrrrrr$"
;-- (r = right, u = up, l = left, d = down, $ or any other char = end)

;-- however, to save some space, they have been compressed like this:
;-- !byte 10, 'r', 9, 'u', 4, 'l', 6, 'u', 10, 'r', $FF

;-- the game unpacks the strings again and then draws the level
;-- according to that unpacked string (as this was the format during
;-- development)

;-- small python script to pack strings:
;-- 


LEVEL1
    !byte 20        ;-- y of left platform
    !byte 5         ;-- y of right platform
    !byte 12, 19    ;-- start x/y of path

    ;-- !text "rrrrrrrrrruuuuuuuuulllluuuuuurrrrrrrrrr$"
    !byte 10, 'r', 9, 'u', 4, 'l', 6, 'u', 10, 'r', $FF
    
LEVEL2
    !byte 5         ;-- y of left platform
    !byte 20        ;-- y of right platform
    !byte 12, 4     ;-- start x/y of path

    ;-- !text "rrrrrrrrrrdddddlllldddrrrrrrrruuuuurrrrdddddddddd$"
    !byte 10, 'r', 5, 'd', 4, 'l', 3, 'd', 8, 'r', 5, 'u', 4, 'r', 10, 'd', $FF
    
LEVEL3
    !byte 20        ;-- y of left platform
    !byte 5         ;-- y of right platform
    !byte 9, 16    ;-- start x/y of path

    ;-- !text "uuuuuuurrrrrrrrrrruuulllldddddddrrrrrrruuuuuuuuurrrrr$"
    !byte 7, 'u', 11, 'r', 3, 'u', 4, 'l', 7, 'd', 7, 'r', 9, 'u', 5, 'r', $FF
    
LEVEL4
    !byte 5         ;-- y of left platform
    !byte 20        ;-- y of right platform
    !byte 12, 4     ;-- start x/y of path

    ;-- !text "rrrrrddddddddddddddddddddllluuurrrrrrrrruuuuuuuullluuuurrrrrrrrrrrrrdddddlllddd$"
    !byte 5, 'r', 20, 'd', 3, 'l', 3, 'u', 9, 'r', 8, 'u', 3, 'l', 4, 'u', 13, 'r', 5, 'd', 3, 'l', 3, 'd', $FF
    
LEVEL5
    !byte 20        ;-- y of left platform
    !byte 15        ;-- y of right platform
    !byte 9, 16     ;-- start x/y of path

    ;-- !text "uuuuuuuurrrrrrrruuulllddddddrrrrrrrrdddddrrruuuuuuuuuuuuuullldddddrrrrrrrrddddd$"
    !byte 8, 'u', 8, 'r', 3, 'u', 3, 'l', 6, 'd', 8, 'r', 5, 'd', 3, 'r', 14, 'u', 3, 'l', 5, 'd', 8, 'r', 5, 'd', $FF
    
LEVEL6
    !byte 15        ;-- y of left platform
    !byte 6         ;-- y of right platform
    !byte 9, 11     ;-- start x/y of path

    ;-- !text "uuuurrrrrrrrrrrrrdddlllluuuuuulllllllddddddddrrrrrrrrrrrrrrruuuuuuuuuuurrrrdd$"
    !byte 4, 'u', 13, 'r', 3, 'd', 4, 'l', 6, 'u', 7, 'l', 8, 'd', 15, 'r', 11, 'u', 4, 'r', 2, 'd', $FF
    
LEVEL7
    !byte 6         ;-- y of left platform
    !byte 20        ;-- y of right platform
    !byte 12, 5    ;-- start x/y of path

    ;-- !text "rrrrrdddddddddddddddddddllluuurrrrrrrrrruuuuuuuuuuullldddrrrrrrruuuuulllllllllllllldddddddrrrrrrrrrrrrrrrrdd$"
    !byte 5, 'r', 19, 'd', 3, 'l', 3, 'u', 10, 'r', 11, 'u', 3, 'l', 3, 'd', 7, 'r', 5, 'u', 14, 'l', 7, 'd', 16, 'r', 2, 'd', $FF
    
LEVEL8
    !byte 20         ;-- y of left platform
    !byte 5        ;-- y of right platform
    !byte 9, 16     ;-- start x/y of path

    ;-- !text "uuuurrrrrruuuuuuuuullldddddrrrrrrdddddddddddddddlllluuurrrrrrrrruuuuurrrrrrrrrdddllllluuuuuuuu"
    ;-- !text "llllllllllllllllllllluuuurrrrrrrrrrrrrruurrrrrrrr$"
    !byte 4, 'u', 6, 'r', 9, 'u', 3, 'l', 5, 'd', 6, 'r', 15, 'd', 4, 'l', 3, 'u', 9, 'r', 5, 'u', 9, 'r', 3, 'd', 5, 'l', 8, 'u'
    !byte 21, 'l', 4, 'u', 14, 'r', 2, 'u', 8, 'r', $FF
    
    
NUM_LEVELS = 8
    
T_LEVELS
    !word LEVEL1
    !word LEVEL2
    !word LEVEL3
    !word LEVEL4
    !word LEVEL5
    !word LEVEL6
    !word LEVEL7
    !word LEVEL8


UNPACKED_PATH = $8000


