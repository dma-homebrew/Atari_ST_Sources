#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ext.h>
#include <ctype.h>

char string[256];

FILE *file;
struct {	int rdsize,rdnum,rdreset,paramflag;
			char inffile[16];
			long magic2,protect;
			int reset,printflag;
		} info;

void error (char *str)
{	puts(str);
	if (file>0) fclose(file); getch(); exit(1);
}

void editword (int *val, char *str)
{	printf("\n%s %d",str,*val);
	printf("\nNeuer Wert : ");
	gets(string);
	sscanf(string,"%d",val);
}

void editlong (long *val, char *str)
{	printf("\n%s %ld",str,*val);
	printf("\nNeuer Wert : ");
	gets(string);
	sscanf(string,"%ld",val);
}

void editstring (char *s, char *str)
{	printf("\n%s %s",str,s);
	printf("\nNeuer Name : ");
	do
	{	gets(string);
		if (!string[0]) return;
		if (strlen(string)>15) printf("\nZu lang : ");
		else break;
	}	while (1);
	strcpy(s,string);
}

void editchar (char *val, char *str)
{	printf("\n%s %c",str,*val);
	printf("\nNeuer Wert : ");
	gets(string);
	if (string[0]) *val=string[0];
}

void editflag (int *val, char *str)
{	char c;
	c=*val?'j':'n';
	editchar(&c,str);
	c=toupper(c); *val=((c=='J')||(c=='Y'));
}

void edit (void)
{	char c;
	do
		editword(&info.rdsize,
			"Gr��e der Ramdisk in Kilobyte (8<x<4000): ");
	while ((info.rdsize<8)||(info.rdsize>4000));
	do
	{	c=info.rdnum+'A';
		editchar(&c,
			"Laufwerksbuchstabe (a-p): ");
		info.rdnum=toupper(c)-'A';
	} while ((info.rdnum<0)||(info.rdnum>15));
	editflag(&info.rdreset,"Resetfest (j/n): ");
	editflag(&info.paramflag,
		"Sollen immer die Ramdiskparamter abgefragt werden (j/n)"
		"\n(sont nur beim Dr�cken der rechten Shifttaste): ");
	editflag(&info.reset,
		"Soll die Ramdisk sofort hinter Phystop gesichert werden (j/n)"
		"\n(d.h. es wird sofort ein Reset ausgel�st): ");
	editflag(&info.printflag,
		"W�nschen Sie ein Protokoll am Bildschirm (j/n): ");
	editlong(&info.magic2,
		"Magicwert f�r diese Ramdisk: ");
	editlong(&info.protect,
		"Anzahl der Kilobytes, die vor der Ramdisk freigelassen"
		"\nwerden sollen, um die Ramdisk zu sch�tzen: ");
	info.protect=((info.protect/8)*8)*1024l;
	editstring(info.inffile,
		"Name der Infodatei f�r diese Ramdisk : ");
}

int main (void)
{	char fname[80];
	/* Lies Pfadnamen und �ffne File */
	printf("\nZugriffspfad f�r Ramdisk : \n");
	gets(fname);
	file=fopen(fname,"r+");
	if (file<=0) error("\nKonnte Ramdisk nicht finden!");
	
	/* Teste auf Ramdisk */
	fseek(file,32,SEEK_SET);
	fscanf(file,"%8s",string);
	if (strcmp(string,"xbrarram")!=0)
		error("\nDies ist keine Ramdisk!");
	
	/* Bearbeite */
	fseek(file,40,SEEK_SET);
	fread(&info,sizeof(info),(size_t)1,file);
	edit();
	fseek(file,40,SEEK_SET);
	fwrite(&info,sizeof(info),(size_t)1,file);
		
	/* Ende und File shlie�en */
	fclose(file);
	return 0;
}
