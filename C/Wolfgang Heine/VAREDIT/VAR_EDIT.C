/*****************************************************************/
/* Var_edit produces Dialogue-boxes with Edit fields of          */
/*  variable length.                                             */
/*             Author: Wolfgang Heine, 8111 Urfeld               */
/*         (c) 1992 MAXON Computer GmbH                          */
/*****************************************************************/

#include  <stdio.h>
#include  <string.h>
#include <aes.h>

#define TITLE     1
#define TXT_1     2
#define TXT_2     3
#define TXT_3     4
#define OUT       5
#define OK        6

int contrl[12], intin[128], intout[128], ptsin[128], ptsout[128];


char *var_edit(OBJECT tree[], int index, int n, char *pt, char *tx, char *val)
    /* OBJECT tree[]:       Object passed                     */
    /* int index:           Object index                      */
    /* int n:               Length of the Edit fields         */
    /* char *pt, *tx, *val: Pointer to the Mask text and Text */
{                                         /* and Validity characters  */
  register  OBJECT *obj;
  register TEDINFO *ted;
  register char *s, *t;
  obj = (OBJECT*) &tree[index];           /* Address of the Objects in Tree */
  obj->ob_width = 8*n;                    /* Obj.width = 8 * Letter number  */
  obj->ob_x = (tree[0].ob_width           /* Object centred                 */
            - obj->ob_width)/2;
  ted = obj->ob_spec.tedinfo;             /* Determine Tedinfo address      */
  ted->te_tmplen = n + 1;                 /* Length of the Text mask        */
                                          /* Don't forget Nullbyte          */   
  strcpy (s = ted->te_ptmplt, pt);        /* Mask text entered              */
  while( strlen(ted->te_ptmplt) < n )     /* Fill out the rest with "_"     */ 
    strcat(ted->te_ptmplt, "_");

  t = ted->te_pvalid;                     /* For each "_" in the Mask text */  
  while(*s)                               /* will be the Validity string  */
    if (*s++ == '_')                      /* in val of the characters     */
      *t++ = *val;                        /* entered.                     */
  *t= '\0';                               /* Conclude with Nullbyte       */
  ted->te_txtlen=strlen(ted->te_pvalid)+1;/* Textlength=Validlength+Nullb.*/
  return strcpy (ted->te_ptext, tx);      /* Text entered and Address     */
                                          /* reported in return           */
}


/*----------------------*/
/* Dialogue field calls */
/*----------------------*/

int hndl_dial (OBJECT tree[],int cur,int x,int y,int w,int h)
    /* OBJECT tree []:  Tree address                   */
    /* int cur,x,y,w,h: Where should the Cursor sit?   */
{
  int xd, yd, wd, hd;
  int exit_objc;                                /* Number of Exit-Buttons */
  form_center (tree, &xd, &yd, &wd, &hd);       /* Form centred    */
  form_dial(FMD_START, x,y,w,h, xd,yd,wd,hd);   /* Reserve screen area    */
  form_dial(FMD_GROW,  x,y,w,h, xd,yd,wd,hd);   /* Growbox                */

  objc_draw(tree,ROOT,MAX_DEPTH, xd,yd,wd,hd);  /* Draw Dialogue-box      */
  exit_objc = form_do (tree, cur ) & 0x7FFF;    /* Dialog abhandeln       */

  form_dial(FMD_SHRINK, x,y,w,h, xd,yd,wd,hd);  /* Shrinkbox              */
  form_dial(FMD_FINISH, x,y,w,h, xd,yd,wd,hd);  /* release screen area    */
                                                /* and put background     */
                                                /* here.                  */
  objc_change(tree,exit_objc, 0, 0,0,639,399,NORMAL, 0);
                           /* selected head again portrayed normal        */
  return (exit_objc);                           /* Exitbutton report      */
} 
