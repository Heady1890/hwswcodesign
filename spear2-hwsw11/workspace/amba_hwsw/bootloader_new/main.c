#include <inttypes.h>
#include <machine/UART.h>
#include <machine/modules.h>
#include <drivers/dis7seg.h>

#if defined __SPEAR16__
  #include "gdb/sim-spear16.h"
  #define SPEAR2_ADDR_CTYPE  uint16_t
#elif defined __SPEAR32__
  #include "gdb/sim-spear32.h"
  #define SPEAR2_ADDR_CTYPE  uint32_t
#else
  #error "Unsupported target machine type"
#endif

#define RWSDRAM_BASE (0xFFFFFEA0)
#define RWSDRAM_TEST (*(volatile int8_t *const) (RWSDRAM_BASE))
#define RWSDRAM_START (*(volatile int8_t *const) (RWSDRAM_BASE+3))
#define RWSDRAM_DATA (*(volatile int32_t *const) (RWSDRAM_BASE+4))

#define COUNTER_BASE (0xFFFFFEC0)
#define COUNTER_CONFIG_C (*(volatile uint8_t *const) (COUNTER_BASE+3))
#define CMD_COUNT 0
#define CMD_CLEAR 1

static module_handle_t counterHandle;

void counter_start()
{
  COUNTER_CONFIG_C = (1 << CMD_CLEAR);
  COUNTER_CONFIG_C = (1 << CMD_COUNT);
}

int main (int argc, char *argv[])
{
//RWSDRAM_START = 0xff;
RWSDRAM_DATA = 0x0000FF00;
//counter_start(&counterHandle);

  return 0;
}

