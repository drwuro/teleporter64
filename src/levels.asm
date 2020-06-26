

LEVEL1
    !byte 20        ;-- y of left platform
    !byte 5         ;-- y of right platform
    !byte 12, 19    ;-- start x/y of path

    !text "rrrrrrrrrruuuuuuuuulllluuuuuurrrrrrrrrr$"
    
LEVEL2
    !byte 5         ;-- y of left platform
    !byte 20        ;-- y of right platform
    !byte 12, 4     ;-- start x/y of path

    !text "rrrrrrrrrrdddddlllldddrrrrrrrruuuuurrrrdddddddddd$"
    
LEVEL3
    !byte 20        ;-- y of left platform
    !byte 5         ;-- y of right platform
    !byte 9, 16    ;-- start x/y of path

    !text "uuuuuuurrrrrrrrrrruuulllldddddddrrrrrrruuuuuuuuurrrrr$"
    
LEVEL4
    !byte 5         ;-- y of left platform
    !byte 20        ;-- y of right platform
    !byte 12, 4     ;-- start x/y of path

    !text "rrrrrddddddddddddddddddddllluuurrrrrrrrruuuuuuuullluuuurrrrrrrrrrrrrdddddlllddd$"
    
LEVEL5
    !byte 20        ;-- y of left platform
    !byte 15        ;-- y of right platform
    !byte 9, 16     ;-- start x/y of path

    !text "uuuuuuuurrrrrrrruuulllddddddrrrrrrrrdddddrrruuuuuuuuuuuuuullldddddrrrrrrrrddddd$"
    
LEVEL6
    !byte 15        ;-- y of left platform
    !byte 6         ;-- y of right platform
    !byte 9, 11     ;-- start x/y of path

    !text "uuuurrrrrrrrrrrrrdddlllluuuuuulllllllddddddddrrrrrrrrrrrrrrruuuuuuuuuuurrrrdd$"
    
LEVEL7
    !byte 6         ;-- y of left platform
    !byte 20        ;-- y of right platform
    !byte 12, 5    ;-- start x/y of path

    !text "rrrrrdddddddddddddddddddllluuurrrrrrrrrruuuuuuuuuuullldddrrrrrrruuuuulllllllllllllldddddddrrrrrrrrrrrrrrrrdd$"
    
LEVEL8
    !byte 20         ;-- y of left platform
    !byte 5        ;-- y of right platform
    !byte 9, 16     ;-- start x/y of path

    !text "uuuurrrrrruuuuuuuuullldddddrrrrrrdddddddddddddddlllluuurrrrrrrrruuuuurrrrrrrrrdddllllluuuuuuuu"
    !text "llllllllllllllllllllluuuurrrrrrrrrrrrrruurrrrrrrr$"
    
    
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


