/*********************************************/
/*   Les accessoires se parlent (�metteur)   */
/*   Laser C           ENVOIE.C   */
/*********************************************/

#include "gem_inex.c"

int  ac_id,
     typ,
     listen_id,
     tampon[8];
     
long *longs;

char message[100];
     
main()
{
  longs = (long *) tampon;
  
  gem_init();
  
  ac_id = menu_register (ap_id, "  �metteur");
  
  while (1)       /* Boucle sans fin */
  {
    evnt_mesag (tampon);

    /* Cet accessoire ne peut �tre activ� que par un clic dans le menu */
    /* Bureau. Nous pouvons donc nous contenter de comparer simplement */
    /* le message au type 40: */

    /* Test: Notre accessoire? */
    if (tampon[0] == 40 && tampon[4] == ac_id) 
    {
      /* Le message sera affich� plus tard par appl_write. Nous devons      */
      /* donc conna�tre l'ID d'application du r�cepteur. appl_find s'en     */
      /* chargera. Cela nous permet d'ailleurs de v�rifier que l'accessoire */
      /* �metteur a bien �t� charg�. */
      
      listen_id = appl_find ("RECOIT  "); 
      
      if (listen_id == -1)     /* Pas trouv�? */
        form_alert (1, "[3][Le recepteur n'est pas |encore charg� en m�moire][Ah bon?]");
      else
      {
        typ = form_alert (0, "[2][Quel message d�sirez-vous?| |1. Salut r�cepteur|2. Beau temps aujourd'hui!|3. ATARI est super!][1|2|3]");
        switch (typ)
        {
          case 1: strcpy (message, "Salut r�cepteur");
                  break;
           
          case 2: strcpy (message, "Beau temps aujourd'hui!");
                  break;
            
          case 3: strcpy (message, "ATARI est super!");
                  break;
        }

        /* Nous pouvons maintenant envoyer le message. Nous �crivons    */
        /* notre "code secret" (99) dans le tampon[0]. Le code indique  */
        /* � l'�metteur ce que nous voulons faire. L'adresse du message */
        /* est stock�e dans le tampon[2] et [3] (par longs, voir        */
        /* commentaire dans le listing de LISTEN.C). */

        tampon[0]  = 99;              /* Code de communication priv�e */
        *(longs+1) = (long) message;  /* identique � tampon[2] et [3] */
      
        appl_write (listen_id, 16, tampon);  /* Envoyer 16 octets */
      }
    }
  }
}
