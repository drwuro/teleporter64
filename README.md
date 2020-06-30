# A Day In The Life Of A Teleporter (C64 version)
a small teleportation game for the Commodore C64

this game was originally developed as a PICO-8 game during a gamejam called Mid-Jam 2020:
https://drwuro.itch.io/a-day-in-the-life-of-a-teleporter

the C64 version was developed shortly after for Reset64 Craptastic 4K Game Compo 2020:
https://csdb.dk/event/?id=2958

### how to build
- you need ACME (a 6502/C64 cross assembler) in your path
- run build.sh to build the project (out.prg will appear in bin/)
- run run_and_build.sh to build and in case of success run directly with VICE (a C64 emulator)

**note:** the reason why it's called "run_and_build.sh" (and not the other way round) is to make it easier to type and autocomplete on the cmdline

### how to play
 - the basic idea is to "redraw" (i.e. trace) the path, which is shown briefly on the screen, with your joystick
 - you are allowed to do this as fast as you can by wiggling the joystick into the corresponding directions - it's NOT intended to be done in realtime like in a racing game (it's theoretically possible, but you would probably be too slow and fail)
 - you are allowed to start wiggling once the guy has entered the teleporter, but you can set the initial direction already while he's still walking towards it

### further notes / license
 - you are allowed to use this source code freely to learn/study and also as a basis for your own games or projects
 - if you create something new from it, you're free to do so without any need for attribution of the original source/author (though you're welcome to do so if you wish)
 - if you create a variant of the original game, such as an enhanced version, or a sequel, or a port for a different platform (much appreciated btw), you're obliged to mention the original game title and the author
