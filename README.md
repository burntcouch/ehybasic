# Microsoft BASIC for the [Hydra-16](https://github.com/danstruthers/hydra-16) hardware project:

Thanks to Ben Eater's project [here](https://github.com/beneater/msbasic) and his wonderful 6502 breadboard YouTube projects [here](https://www.youtube.com/@BenEater/videos). 

And of course this would be impossible without [mist64's](https://github.com/mist64/msbasic) and collaborators' work on the most ancient and hoary versions of MS-BASIC known to man...

---------------------------------------------------------------------------------------------------
# HOWTO:  Installing BASIC on the Hydra-16

As noted below, you will need to have the [CC65 compiler/assembler](https://cc65.github.io/) suite installed on your machine, either Linux or Windows.
I have include a 'makebas.bat' file to do the build in Windows, and you can use 'make.sh' in Linux.

The Hydra's shared ROM space for expansion occupies $A000-DFFF, and that is where BASIC ends up after the assembly; currently BASIC is slighly under 8K after some ham-fisted hacking I did to reduce the size of error messages and some other eye candy.

Due to a bug in the 1.8x hardware, you will have to load the 8K image to the SECOND 8K ($02000-$04000) bank on your ROM if you want it to show up at $A000 when you plug it in.  If your modifications of the source result in a binary of MORE than 8K, you will have to figure out how to copy the 8K+ section to the FIRST 8K segment manually, so that the two halves will mate up properly...  (Hardware will be fixed in version 2.x; meanwhile we can cope.)

Once you have the ROM in place, make sure you are 'switched' to Bank 0 (if you burned onto the first 16K of the first chip) by making sure ZP $01 is set to $00, and then in WozMon you run 'A000R' to start.  Off you go from there; no other changes so far.<p>

-----------------------------------------

# Usage: differences from 'standard' MS-BASIC
My very first programming language, when velociraptors stalked the dark, Bigfoot-ridden woods of Eastern Oregon, was Applesoft BASIC, so some of my modifications attempt to recapture that experience.  But I also want this particular port to be useful as a utility language for the Hydra, so I have already added some basic debugging tools (disassbler and mini-assembler are in the works).
<p>
Apple II's allowed you to interrupt or pause a running program by hitting ctrl-c / ctrl-s; the first was included in the original [mist64's](https://github.com/mist64/msbasic) port and I've added the second.  There is also an 'examine' mode; you can hit 'x' when in pause and break right out into an embedded version of WozMon and examine the running environment in place.  I've also added a BRK keyword (this version uses 'WOZ' instead, but...) in order to pause execution automatically and fall into WozMon.  You can hit '^' to return to BASIC from this version of the monitor.
<p>
The main differences in keywords are as follows:
  
|   Old command         |  New command      |   |    Old command          |   New command    |
| ----------------------|:-----------------:|:-:|:-----------------------:|:-----------------|
|  IF x THEN y STEP -1  |  IF x DO y BY -1  |   |  PRINT "fred"           |   ? "fred"       |
|  GOSUB 50 : RETURN    |  JSR 50 : RTN     |   |  END                    |   DIE            |
|  GOTO 100             |  JMP 100          |   |  RSTR                   |   RESTORE        |
|  CLEAR                |  CLR              |   |  MID$,STR$,LEFT$,RIGHT$ |  MD$,ST$,LT$,RT$ |
|  AND, OR, NOT         |  &,  \|,  \!      |   |                         |                  |


new commands:<p>
EXIT - exits basic and returns to BIOS WozMon.  Prints 'warm start' address if you want to 
  keep BASIC programs and variables using '<warm addr>R'.<p>
WOZ or BRK - stop execution and shell out to WozMon ']' prompt; enter '^' to return to BASIC.<p>
CLS - clear the screen with ANSI escape codes<p>
<p>
  
# To do: What's next for EhyBASIC

Long term...I am learning from Ben Eater's example and hacking away at the basic infrastructure of BASIC in order to extend it for I/O purposes; the Hydra has a lot of built-in peripheral capability, include I2C / SPI, 6 IO slots, tons of RAM and ROM, and hardware-based task switching.  If anyone is going to build the Hydra hardware they are going to want a easy to use, well documented scripting language at first.  Hopefully some version of BASIC will be both fast (enough) and small enough to be useful as an introduction to the platform.
  
----------------------------------------------------------------------------------------------------

I forked this over from Ben Eater's fork; see below for Ben's brief comments and the chain of custody....

-----------------------------------------------------------------------------------------------------

This code was forked from [mist64/msbasic](https://github.com/mist64/msbasic) and I've added the code from my YouTube videos describing how to port MSBASIC to my 6502 project. The latest commit will match the code from the latest video.



Below is the original README:

# Microsoft BASIC for 6502

This is a single integrated assembly source tree that can generate nine different versions of Microsoft BASIC for 6502.

By running ./make.sh, this will generate all versions and compare them to the original files byte by byte. The CC65 compiler suite is need to build this project.

These are the first ten (known) versions of Microsoft BASIC for 6502:

| Name                | Release  | MS Version   | ROM  | 9digit | INPUTBUFFER  | extensions  | .define    |
| ------------------- |:--------:| ------------ |:----:|:------:|:------------:|:-----------:| ---------- |
| Commodore BASIC 1   |  1977    |              |  Y   |   Y    |      ZP      |    CBM      |            |
| OSI BASIC           |  1977    | 1.0 REV 3.2  |  Y   |   N    |      ZP      |      -      | CONFIG_10A |
| AppleSoft I         |  1977    | 1.1          |  N   |   Y    |    $0200     |    Apple    | CONFIG_11  |
| KIM BASIC           |  1977    | 1.1          |  N   |   Y    |      ZP      |      -      | CONFIG_11A |
| AppleSoft II        |  1978    |              |  Y   |   Y    |    $0200     |    Apple    | CONFIG_2   |
| AIM-65 BASIC        |  1978    | 1.1?         |  Y   |   N    |      ZP      |     AIM     | CONFIG_2A  |
| SYM-1 BASIC         |  1978    | 1.1?         |  Y   |   N    |      ZP      |     SYM     | CONFIG_2A  |
| Commodore BASIC 2   |  1979    |              |  Y   |   Y    |    $0200     |     CBM     | CONFIG_2A  |
| KBD BASIC           |  1982    |              |  Y   |   N    |    $0700     |     KBD     | CONFIG_2B  |
| MicroTAN            |  1980    |              |  Y   |   Y    |      ZP      |      -      | CONFIG_2C  |

(Note that this assembly source cannot (yet) build AppleSoft II.)

This lists the versions in the order in which they were forked from the Microsoft source base. Commodore BASIC 1, as used on the original PET is the oldest known version of Microsoft BASIC for 6502. It contains some additions to Microsoft's version, like Commodore-style file I/O.

The CONFIG_n defines specify what Microsoft-version the OEM version is based on. If CONFIG_2B is defined, for example, CONFIG_2A, CONFIG_2, CONFIG_11A, CONFIG_11 and CONFIG_10A will be defined as well, and all bugfixes up to version 2B will be enabled.

The following symbols can be defined in addition:

| Configuration Symbol              | Description
| --------------------------------- | --------------------------------------------------------------------------------
| CONFIG_CBM1_PATCHES               | jump out into CBM1's binary patches instead of doing the right thing inline
| CONFIG_CBM_ALL                    | add all Commodore-specific additions except file I/O
| CONFIG_DATAFLG                    | ?
| CONFIG_EASTER_EGG                 | include the CBM2 "WAIT 6502" easter egg
| CONFIG_FILE                       | support Commodore PRINT#, INPUT#, GET#, CMD
| CONFIG_IO_MSB                     | all I/O has bit #7 set
| CONFIG_MONCOUT_DESTROYS_Y         | Y needs to be preserved when calling MONCOUT
| CONFIG_NO_CR                      | terminal doesn't need explicit CRs on line ends
| CONFIG_NO_LINE_EDITING            | disable support for Microsoft-style "@", "_", BEL etc.
| CONFIG_NO_POKE                    | don't support PEEK, POKE and WAIT
| CONFIG_NO_READ_Y_IS_ZERO_HACK     | don't do a very volatile trick that saves one byte
| CONFIG_NULL                       | support for the NULL statement
| CONFIG_PEEK_SAVE_LINNUM           | preserve LINNUM on a PEEK
| CONFIG_PRINTNULLS                 | whether PRINTNULLS does anything
| CONFIG_PRINT_CR                   | print CR when line end reached
| CONFIG_RAM                        | optimizations for RAM version of BASIC, only use on 1.x
| CONFIG_ROR_WORKAROUND             | use workaround for buggy 6502s from 1975/1976; not safe for CONFIG_SMALL!
| CONFIG_SAFE_NAMENOTFOUND          | check both bytes of the caller's address in NAMENOTFOUND
| CONFIG_SCRTCH_ORDER               | where in the init code to call SCRTCH
| CONFIG_SMALL                      | use 6 digit FP instead of 9 digit, use 2 character error messages, don't have GET
| CONFIG_SMALL_ERROR                | use 2 character error messages

Changing symbol definitions can alter an existing base configuration, but it not guaranteed to assemble
or work correctly.

## More Information

More information on the differences of the respective versions can be found on this blog entry: [Create your own Version of Microsoft BASIC for 6502](http://www.pagetable.com/?p=46).

## License

2-clause BSD

## Credits

* Main work by Michael Steil <mist64@mac.com>.
* AIM-65 and SYM-1 by Martin Hoffmann-Vetter
* Function names and all uppercase comments taken from Bob Sander-Cederlof's excellent [AppleSoft II disassembly](http://www.txbobsc.com/scsc/scdocumentor/).
* [Applesoft lite](http://cowgod.org/replica1/applesoft/) by Tom Greene helped a lot, too.
* Thanks to Joe Zbicak for help with Intellision Keyboard BASIC
* This work is dedicated to the memory of my dear hacking pal Michael "acidity" Kollmann.
