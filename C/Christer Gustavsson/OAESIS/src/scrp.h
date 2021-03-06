#ifndef __SCRP__
#define __SCRP__

#include "types.h"

/****************************************************************************
 * Scrp_read                                                                *
 *  0x0050 scrp_read()                                                      *
 ****************************************************************************/
void              /*                                                        */
Scrp_read(        /*                                                        */
AES_PB *apb);     /* AES parameter block.                                   */
/****************************************************************************/

/****************************************************************************
 * Scrp_write                                                               *
 *  0x0051 scrp_write()                                                     *
 ****************************************************************************/
void              /*                                                        */
Scrp_write(       /*                                                        */
AES_PB *apb);     /* AES parameter block.                                   */
/****************************************************************************/

#endif