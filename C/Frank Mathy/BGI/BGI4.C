/* Beispielprogramm 4 */
/* Von Frank Mathy f�r die TOS 10/90 */
/* F�r Turbo C 2.0 (mit BGI-Bibliothek	*/

#include <stdio.h>
#include <stdlib.h>
#include <ext.h>
#include <graphics.h>			   	/* BGI-Bibliothek */

int treiber=DETECT;						/* Treibertyp	*/
int modus;
int maxx,maxy;								/* Maximale Koordinaten	*/
int maxc;											/* Gr��te Zeichenfarbe */

int p[8] = { 0,0,59,29,35,59,0,0 };	
															/* Dreieckskoordinaten */

void init_all(void)					  /* Initialisierungen */
	{
	initgraph(&treiber,&modus,"");	/* BGI Init */
	graphdefaults();					/* Normaleinstellungen */
	maxx=getmaxx();						/* Maximale X-Koordinate */
	maxy=getmaxy();						/* Maximale Y-Koordinate */
	}

void exit_all(void)					/* Beenden des Programmes */
	{
	setallpalette(getdefaultpalette());
												/* Alte Farbpalette */
	closegraph();					/* BGI-Arbeiten beenden	*/
	}

void main(void)
	{
	unsigned bytes;
	void *block;
	init_all();						/* Alles initialisieren	*/
	srand(1990);					/* Zufallsg. starten */
	
	setfillstyle(HATCH_FILL,1);		/* F�llmuster setzen */
	fillpoly(4,p);				/* Dreieck zeichnen	*/
	
	bytes=imagesize(0,0,59,59);		/* Speichergr��e ber.	*/
	block=_graphgetmem(bytes);		/* Block reservieren	*/
	getimage(0,0,59,59,block);		/* Block einlesen	*/
	
	while(!kbhit())
		putimage(rand()%(maxx-60),rand()%(maxy-60)
						,block,OR_PUT);
	
	_graphfreemem(block,bytes);	/* Speicher zur�ckgeben	*/
	exit_all();									/* Alles abmelden */
	}