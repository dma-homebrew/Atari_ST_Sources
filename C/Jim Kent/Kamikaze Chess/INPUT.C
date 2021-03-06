
#include <gemdefs.h>
#include <osbind.h>
#include "kamikaze.h"

extern WORD *aline;
extern WORD handle;
extern long beam_peek();

WORD mouse_button, omouse_button;
WORD mouse_x, mouse_y;
WORD lastx, lasty;
WORD mouse_moved;	/* mouse not same as last time - x,y or buttons */
WORD key_hit;
long key_in;
WORD mouse_on = 1;

static WORD reuse;

reuse_input()
{
reuse = 1;
}

check_input()
{
unsigned WORD w;
register WORD *a;
unsigned long l;
WORD mouse_color;

if (reuse)
	{
	reuse = 0;
	return;
	}
lastx = mouse_x;
lasty = mouse_y;
a = aline;
omouse_button = mouse_button;
mouse_x = *(a-301);
mouse_y = *(a-300);
mouse_button = *(a-174);
if (Cconis())
	{
	key_hit = 1;
	l = Crawcin();
	w = l>>8;
	w += l;
	key_in = w;
	}
else
	{
	key_hit = 0;
	}
if (mouse_x == lastx && mouse_y == lasty && mouse_button == omouse_button)
	mouse_moved = 0;
else
	{
	mouse_moved = 1;
	}
if (mouse_on)
	{
	if (mouse_moved)
		{
#ifdef JIM_CURSOR
		restore_m();
		save_m();
		draw_m();
#endif JIM_CURSOR
		}
	}
}


#ifdef JIM_CURSOR
hide_mouse()
{
if (mouse_on)
	{
	restore_m();
	mouse_on = 0;
	}
}

show_mouse()
{
if (!mouse_on)
	{
	save_m();
	draw_m();
	mouse_on = 1;
	}
}
#endif JIM_CURSOR

hide_mouse()
{
v_hide_c(handle, 0);
}

show_mouse()
{
v_show_c(handle, 0);
}

black_hand()
{
graf_mouse(4, 0L);
}

white_hand()
{
graf_mouse(3, 0L);
}

bee_cursor()
{
graf_mouse(2, 0L);
}

wait_penup()
{
for (;;)
	{
	check_input();
	if (!PDN)
		break;
	}
}

wait_click()
{
for (;;)
	{
	check_input();
	if (key_hit || PJSTDN || RJSTDN)
		break;
	}
}

wait_ednkey()
{
for (;;)
	{
	check_input();
	if (EDN || key_hit)
		break;
	}
}


