/************************************************************************
 * Datei: MSDOS.h   	Zweck: 	Schnittstelle f�r nicht zu vermeidende	*
 *                              BS-Abh�ngigkeiten                      	*
 * Autor: RSB                                                           *
 * Datum: 30.06.90      Grund: 	exec() f�r MSDOS in Shel_write umsetzen	*
 * Datum: 01.07.90      Grund: 	alloc in dos_alloc() umwandelt, da 		*
 *								Fehler bei der Freispeicherverwaltung	*
 * -------------------------------------------------------------------- *
 * Speicherallozierung funktioniert nicht mit den TC Funktionen. Statt-	*
 * dessen m�ssen die Funktionen aus dem Toolkit verwendet werden.		*
 * DR verwendet historisch bedingt die Datei portab.h. Bei einer Fest-	*
 * legung auf ANSI-Compiler ist es vern�nftiger, die vollen F�higkeiten *
 * des Sprachstandards bez. Typpr�fung auszunutzen. Im Inside GEM		*
 * ist eine erweiterte portab.h enthalten, die diese Anforderungen		*
 * weitgehend erf�llt. Um unn�tigen Aufwand zu vermeiden, werden die 	*
 * Prototypen der ben�tigten Funktionen hier explizit vereinbart.		*
 ************************************************************************/

void ReInstallDesktop(void); /* setzt Desktop.app als Shell */
int exec(char *head, char *tail, char *env, int *rc);
int execDOS(char *head, char *tail, char *env, int *rc);

#define calloc(i,n) 	dos_calloc(i,n)
#define malloc(n) 		dos_alloc(n)
#define free(p) 		dos_free(p)
#define realloc(p,n) 	dos_realloc(p,n)

void *dos_realloc(void *p, long n);
void *dos_calloc(long i, long n);
void *dos_alloc(long nbytes);
void dos_free(void *maddr);

