
levels = ["rrrrrrrrrruuuuuuuuulllluuuuuurrrrrrrrrr$",
          "rrrrrrrrrrdddddlllldddrrrrrrrruuuuurrrrdddddddddd$",
          "uuuuuuurrrrrrrrrrruuulllldddddddrrrrrrruuuuuuuuurrrrr$",
          "rrrrrdddddddddddddddddddllluuuuurrrrrrrrruuuuuuuullluuuurrrrrrrrrrrrrddddddlllddddd$",
          "uuuuuuuurrrrrrrruuulllddddddrrrrrrrrdddddrrruuuuuuuuuuuuuullldddddrrrrrrrrddddd$",
          "uuuurrrrrrrrrrrrrdddlllluuuuuulllllllddddddddrrrrrrrrrrrrrrruuuuuuuuuuurrrrdd$",
          "rrrrrddddddddddddddddddllluuurrrrrrrrrruuuuuuuuuullldddrrrrrrruuuuulllllllllllllldddddddrrrrrrrrrrrrrrrrdd$",
          "uuuurrrrrruuuuuuuuullldddddrrrrrrdddddddddddddddlllluuurrrrrrrrruuuuurrrrrrrrrdddllllluuuuuuuu"
          + "llllllllllllllllllllluuuurrrrrrrrrrrrrruurrrrrrrr$",
          ]
          

def pack(s):
    cnt = 1
    prv = ''
    cur = ''

    result = '!byte '

    for i in range(len(s)):
        cur = s[i]
        if cur == prv:
            cnt += 1
        else:
            if prv:
                result += "%i, '%s', " % (cnt, prv)
            prv = cur
            cnt = 1

    result += '$FF'
    print result


for level in levels:
    pack(level)


