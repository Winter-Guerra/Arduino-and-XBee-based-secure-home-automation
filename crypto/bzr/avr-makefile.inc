
MCU_TARGET     = atmega644
OPTIMIZE       = -Os # -Os
DEBUG          = -gdwarf-2
WARNING        = -pedantic -Wall -Wstrict-prototypes
PROGRAMMER     = avr911
DEFS           = -D$(call uc, $(MCU_TARGET))
FLASHCMD       = avrdude -p $(MCU_TARGET) -P /dev/ttyUSB0 -c $(PROGRAMMER) -U flash:w:# no space at the end
#FLASHCMD       = avrdude -p $(MCU_TARGET) -c usbasp -U flash:w:# no space at the end
DEP_DIR        = deps/
TEST_DIR       = test/
BIN_DIR        = bin/
TESTSRC_DIR    = test_src/
#uisp -dprog=bsd -dlpt=/dev/parport1 --upload if=$(PRG).hex
ERASECMD       =
TESTPORT       = /dev/ttyUSB1
TESTPORTBAUDR  = 115200
TESTLOG_DIR    = testlog/#
TESTPREFIX     = nessie-
SPEEDTOOL      = host/get_performance.rb
SPEEDLOG_DIR   = speed_log/
SPEEDPREFIX    =
SPEEDCMD       = performance
SIZE_DIR       = size_log/#
LIST_DIR       = listings/#
STAT_DIR       = stats/#
AUTOASM_DIR    = autoasm/#
AUTOASM_OPT    = -S
CC	       = avr-gcc
CSTD           = c99

override CFLAGS_A	= -MMD -MF$(DEP_DIR)$(patsubst %.o,%.d,$(notdir $(1))) $(DEBUG) $(WARNING) -std=$(CSTD) $(OPTIMIZE) -mmcu=$(MCU_TARGET) $(DEFS)
override CFLAGS 	= -MMD -MF$(DEP_DIR)$(patsubst %.o,%.d,$(notdir $@))   $(DEBUG) $(WARNING) -std=$(CSTD) $(OPTIMIZE) -mmcu=$(MCU_TARGET) $(DEFS)

override LDFLAGS       = -gdwarf-2 -Wl,-Map,
override ASFLAGS	   = -mmcu=$(MCU_TARGET) -Wa,--gdwarf-2

SIZESTAT_FILE = sizestats.txt

OBJCOPY         = avr-objcopy
OBJDUMP         = avr-objdump
SIZE            = avr-size
READELF         = readelf
RUBY            = ruby
GET_TEST        = host/get_test.rb
MAKE            = make
MAKE2GRAPH      = ~/bin/make2graph.rb
TWOPI           = twopi
