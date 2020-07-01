# A Day In The Life Of A Teleporter (C64 version)
a small teleportation game for the Commodore C64

this game was originally developed as a PICO-8 game during a gamejam called Mid-Jam 2020:
https://drwuro.itch.io/a-day-in-the-life-of-a-teleporter

the C64 version was developed shortly after for Reset64 Craptastic 4K Game Compo 2020:
https://csdb.dk/event/?id=2958

### how to build
- you need ACME (a 6502/C64 cross assembler - https://sourceforge.net/projects/acme-crossass/) in your path
- run build.sh to build the project (out.prg will appear in bin/)
- run run_and_build.sh to build and in case of success run directly with VICE (a C64 emulator)
- if you want to compress the game, run pack.sh (this has been used for the final 4K entry, you need exomizer for that - https://bitbucket.org/magli143/exomizer/wiki/Home)

**note:** the reason why it's called "run_and_build.sh" (and not the other way round) is to make it easier to type and autocomplete on the cmdline

### how to play
 - the basic idea is to "redraw" (i.e. trace) the path, which is shown briefly on the screen, with your joystick
 - you are allowed to do this as fast as you can by wiggling the joystick into the corresponding directions - it's NOT intended to be done in realtime like in a racing game (it's theoretically possible, but you would probably be too slow and fail)
 - you are allowed to start wiggling once the guy has entered the teleporter, but you can set the initial direction already while he's still walking towards it
 - if you have troubles understanding the gameplay concept, have a look at the arrows in the lower left corner, they show the directions you enter with the joystick (blue arrows) and as soon as they're used at the next corner of the path, they turn white

### further notes / license
 - this source code has been released to the Public Domain
 - you are allowed to use this source code freely to learn/study and also as a basis for your own games or projects
 - if you create something new from it, you're free to do so without any need for attribution of the original source/author (though you're welcome to do so if you wish)
 - if you create a variant of the original game, such as an enhanced version, or a sequel, or a port for a different platform (much appreciated btw), please mention the original game title and the author (the Public Domain license will not force you to do so though, but if you're part of the scene you will know that it's the way to go ;) )
 
 ### disclaimer
  the game has been quickly hacked together within a week, there might be some unused functions or macros from my usual code base. also, there could be lots of parts which could be optimized of course (e.g. the path is drawn every frame, even while it's invisible etc)
  
