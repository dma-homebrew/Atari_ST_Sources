/****************************/
/*-------- IMG_IO.C --------*/
/* Chargement et sauvegarde */
/* D'images au format IMG   */
/****************************/
#include <stdlib.h>
#include <string.h>

#include     "..\tools\xgem.h"
#include "..\tools\packbits.h"
#include "..\tools\image_io.h"
#include "..\tools\rasterop.h"



typedef struct
{
  int version ;       /* Version du format IMG           */
  int header_length ; /* Taille du header en mots        */
  int nb_plane ;      /* Nombre de plans de l'image      */
  int pattern_run ;   /* Taille du pattern_run en octets */
  int widthm ;        /* Largeur d'un pixel en microns   */
  int heigthm ;       /* Hauteur du pixel en microns     */
  int pixel_line ;    /* Nombre de pixels par ligne      */
  int nb_line ;       /* Nombre de lignes de l'image     */
} IMG_HEADER ;


/* Variables � initialiser pour la routine assembleur */
void *adr_src ;  /* Adresse de la source           */
void *adr_dest ; /* Adresse de la destination      */
int  nb_plan ;   /* Nombre de plans de l'image     */
int  octet_run ; /* Nombre d'octets du pattern_run */
int  nb_pixel ;  /* Nombre de pixels par ligne     */
int  nb_ligne ;  /* Nombre de lignes               */
int  mot_larg ;  /* Nombre de mot par ligne        */

extern void img_dcmps(void) ; /* D�finie dans IMG_IO.S */

#pragma warn -par
int img_load(char *name, MFDB *out, GEM_WINDOW *wprog)
{
  IMG_HEADER header ;
  FILE       *stream ;
  long       fsize ;
  
  perf_start( PERF_DISK, &PerfInfo ) ;
  fsize   = file_size(name) ;
  stream = fopen(name, "rb") ;
  if (stream == NULL) return EIMG_FILENOEXIST ;
  
  fread(&header, sizeof(IMG_HEADER), 1, stream) ;
  adr_src = Xalloc(fsize-header.header_length*2) ;
  if (adr_src == NULL)
  {
    fclose(stream) ;
    return EIMG_NOMEMORY ;
  }
  
  fseek(stream, header.header_length*2, SEEK_SET) ;
  fread(adr_src, fsize-header.header_length*2, 1, stream) ;
  fclose(stream) ;
  perf_stop( PERF_DISK, &PerfInfo ) ;

  /* Initialisation des variables pour la routine assembleur */
  nb_plan   = header.nb_plane ;
  octet_run = header.pattern_run ;
  nb_pixel  = header.pixel_line ;
  nb_ligne  = header.nb_line;
  mot_larg  = nb_pixel >> 4 ;
  if (nb_pixel % 16) mot_larg++ ;

  mot_larg *= nb_plan ;
  adr_dest  = img_alloc(nb_pixel, 1+nb_ligne, nb_plan) ;
  if (adr_dest == NULL)
  {
    Xfree(adr_src) ;
    return EIMG_NOMEMORY ;
  }

  /* On initialise alors le MFDB associ� */
  out->fd_addr      = adr_dest ;
  if (nb_pixel % 16) out->fd_w = (nb_pixel & 0xFFF0)+16 ;
  else               out->fd_w = nb_pixel ;
  out->fd_h         = nb_ligne ;
  out->fd_wdwidth   = mot_larg/nb_plan ;
  out->fd_stand     = 0 ;      /* Format propre � l'Atari */
  out->fd_nplanes   = nb_plan ;
  
  /* Remise � z�ro de l'image */
  img_raz( out ) ;

  /* Et on d�compacte les donn�es */
  perf_start( PERF_COMPRESS, &PerfInfo ) ;
  img_dcmps() ;
  perf_stop( PERF_COMPRESS, &PerfInfo ) ;

  Xfree(adr_src) ;

  return EIMG_SUCCESS ;
}

int img_sauve(char *name, MFDB *img, INFO_IMAGE *info, GEM_WINDOW *wprog)
{
  IMG_HEADER inf ;
  FILE       *stream ;
  long       long_lplan ; /* Longueur en octets d'un plan par ligne */
  long       long_ligne ; /* Longueur en octets d'une ligne */   
  int        num_ligne ;
  int        dif_line ;
  int        i, j ;
  int        *pt1, *pt2 ;
  int        *cl1, *cl2 ;
  int        *img_ligne ;
  int        *pt_img ;
  int        nb ;
  char       *buf ;
  
  stream = fopen(name, "wb") ;
  if (stream == NULL) return EIMG_FILENOEXIST ;

  if (img->fd_nplanes > 8)
  {
    fclose(stream) ;
    return EIMG_OPTIONNOTSUPPORTED ;
  }
  long_ligne = 2*img->fd_wdwidth*img->fd_nplanes ;
  long_lplan = long_ligne/img->fd_nplanes ;
  img_ligne  = (int *) Xalloc(long_ligne) ;
  if (img_ligne == NULL)
  {
    fclose(stream) ;
    return EIMG_NOMEMORY ;
  }
  
  buf = (char *) Xalloc(10+long_ligne) ;
  if (buf == NULL)
  {
    Xfree(img_ligne) ;
    fclose(stream) ;
    return EIMG_NOMEMORY ;
  }
  
  inf.version       = 1 ;
  inf.header_length = 8 ;
  if ((info->palette != NULL) && (info->nplans > 1))
    inf.header_length += 3+3*(int)info->nb_cpal ;
  inf.nb_plane      = img->fd_nplanes ;
  inf.pattern_run   = 2 ;
  inf.widthm        = info->lpix;
  inf.heigthm       = info->hpix ;
  inf.pixel_line    = img->fd_w;
  inf.nb_line       = img->fd_h;
  fwrite(&inf, sizeof(IMG_HEADER), 1, stream) ;
  if ((info->palette != NULL) && (info->nplans > 1))
  {
    int  pal[256*3] ;
    int  ind, i ;
    int  *pt ;
    char buf[6] ;

    strcpy(buf, "XIMG") ;
    buf[4] = buf[5] = 0 ;
    fwrite(buf, 6, 1, stream) ;
    pt = (int *) info->palette ;
    for (i = 0; i < info->nb_cpal; i++)
    {
      ind        = 3*i ;
      pal[ind]   = pt[3*i] ;
      pal[1+ind] = pt[1+3*i] ;
      pal[2+ind] = pt[2+3*i] ;
    }
    fwrite(pal, 6, info->nb_cpal, stream) ;
  }
  pt1 = (int *) img->fd_addr ;
  for (num_ligne = 0; num_ligne < img->fd_h;)
  {
    nb_ligne  = 1 ;
    dif_line  = 0 ;
    pt2       = pt1 ;
    pt2      += long_ligne/2 ;
    while (!dif_line)
    {
      dif_line = memcmp(pt1, pt2, long_ligne) ;
      if (!dif_line) nb_ligne++ ;
      pt2 += long_ligne/2 ;
      if (nb_ligne == 255)      break ;
      if (nb_ligne > img->fd_h) break ;
    }
    
    if (nb_ligne > 1)
    {
      buf[0] = 0 ;    buf[1] = 0 ;
      buf[2] = 0xFF ; buf[3] = nb_ligne ;
      if (fwrite(buf, 4, 1, stream) != 1)
      {
        fclose(stream) ;
        Xfree(buf) ;
        Xfree(img_ligne) ;
        return EIMG_DATAINCONSISTENT ;
      }
    }
    
    raster2imgline(pt1, img_ligne, long_ligne, img->fd_nplanes) ;
    
    for (j = 0; j < img->fd_nplanes; j++)
    {
      pt_img = img_ligne + (j*long_lplan)/2 ;
      i      = 0 ;
      while (i < long_lplan) /* Tant que la ligne du plan j */
                             /* N'est pas enti�rement cod�e */
      {
        /* On recherche d'abord si au moins 2 mots se r�p�tent */
        cl1 = pt_img ;
        cl2 = pt_img + 1 ;
        nb  = 0 ;
        while ((*cl1 == *cl2) && (i+nb < long_lplan))
        {
          cl1++;
          cl2++;
          nb += 2 ;
          if (nb == 124) break ;
        }
    
        if (nb > 0)   /* 2 mots se r�p�tent : on d�cide alors d'un compactage */
        {
          if (*pt_img == 0)
          {
            buf[0] = 2+nb ;             /* SOLID_RUN */
            if (fwrite(buf, 1, 1, stream) != 1)
            {
              fclose(stream) ;
              Xfree(buf) ;
              Xfree(img_ligne) ;
              return EIMG_DATAINCONSISTENT ;
            }
          }
          else
          {
            if (*pt_img == -1)
            {
              buf[0] = (2+nb) | 0x80 ; /* SOLID_RUN */
              if (fwrite(buf, 1, 1, stream) != 1)
              {
                fclose(stream) ;
                Xfree(buf) ;
                Xfree(img_ligne) ;
                return EIMG_DATAINCONSISTENT ;
              }
            }
            else
            {
              buf[0] = 0 ;
              buf[1] = (2+nb)/2 ;
              memcpy(&buf[2], pt_img, 2) ;  /* PATTERN_RUN */
              if (fwrite(buf, 4, 1, stream) != 1)
              {
                fclose(stream) ;
                Xfree(buf) ;
                Xfree(img_ligne) ;
                return EIMG_DATAINCONSISTENT ;
              }
            }
          }
        }
        else       /* Il n'y a r�p�tition : on ne peut pas compacter */
        {
          buf[0] = 0x80 ; /* BIT_STRING */
          cl1 = pt_img ;
          cl2 = pt_img + 1 ;
          nb  = 0 ;
          /* On cherche alors l'�ventuelle prochaine r�p�tition */
          while ((*cl1 != *cl2) && (i+nb < long_lplan))
          {
            cl1++;
            cl2++;
            nb += 2 ;
            if (nb == 254) break ;
          }
          buf[1] = nb ;
          memcpy(&buf[2], pt_img, nb) ;
          if (fwrite(buf, nb+2, 1, stream) != 1)
          {
            fclose(stream) ;
            Xfree(buf) ;
            Xfree(img_ligne) ;
            return EIMG_DATAINCONSISTENT ;
          }
          nb -= 2 ;
        }
    
        pt_img += nb/2 ;
        pt_img++ ;
        i += nb ;
        i += 2 ;
      
        if (i == long_lplan-2)
        {
          buf[0] = 0x80 ; /* BIT_STRING */
          buf[1] = 2 ;
          memcpy(&buf[2], pt_img, 2) ;
          if (fwrite(buf, 4, 1, stream) != 1)
          {
            fclose(stream) ;
            Xfree(buf) ;
            Xfree(img_ligne) ;
            return EIMG_DATAINCONSISTENT ;
          }
          i += 2 ;
          pt_img++ ;
        }
      }
    }
    
    pt1       += nb_ligne*long_ligne/2 ;  
    num_ligne += nb_ligne ;    
  }
  
  Xfree(buf) ;
  Xfree(img_ligne) ;
  if (fclose(stream)) return EIMG_DATAINCONSISTENT ;

  return EIMG_SUCCESS ;
}
#pragma warn +par

int img_identify(char *nom, INFO_IMAGE *inf)
{
  IMG_HEADER img_inf ;
  FILE       *stream ;
  int        ret = EIMG_SUCCESS ;
  long       tcol ;
  char       buf[6] ;

  stream = fopen(nom, "rb") ;
  if (stream == NULL) return EIMG_FILENOEXIST ;

  fread(&img_inf, sizeof(IMG_HEADER), 1, stream) ;

  inf->version  = img_inf.version ;
  inf->compress = 1 ;               /* Sans signification ici */
  inf->largeur  = img_inf.pixel_line ;
  inf->hauteur  = img_inf.nb_line ;
  inf->nplans   = img_inf.nb_plane ;
  if (inf->nplans > 8)
  {
    fclose(stream) ;
    return EIMG_OPTIONNOTSUPPORTED ;
  }
  inf->lpix     = img_inf.widthm ;
  inf->hpix     = img_inf.heigthm ;

  inf->palette = NULL ;
  inf->nb_cpal = 0 ;
  if (2*img_inf.header_length != sizeof(IMG_HEADER))
  {
    size_t nb ;

    fread(buf, 6, 1, stream) ;
    if (memcmp(buf, "XIMG", 5) == 0)
    {
      int buf[256*3] ;
      int i, ind ;
      int *pt ;

      nb           = 2*img_inf.header_length-sizeof(IMG_HEADER)-6 ;
      nb           = 6*(nb/6) ;   /* M�me si ce n'est pas le cas, ce */
      inf->nb_cpal = nb/6 ;       /* Nombre DOIT �tre multiple de 6  */
      tcol         = nb_colors ;
      if (inf->nb_cpal > tcol) tcol = inf->nb_cpal ;
      inf->palette = Xalloc(6*tcol) ;
      if (inf->palette)
      {
        fread(buf, nb, 1, stream) ;
        get_tospalette(inf->palette) ;
        pt = inf->palette ;
        for (i = 0; i < inf->nb_cpal; i++)
        {
          ind       = 3*i ;
          pt[ind]   = buf[3*i] ;
          pt[1+ind] = buf[1+3*i] ;
          pt[2+ind] = buf[2+3*i] ;
        }
      }
      else ret = EIMG_NOMEMORY ;
    }
    else ret = EIMG_DATAINCONSISTENT ;
  }
  fclose(stream) ;

  return ret ;
}

void img_getdrvcaps(INFO_IMAGE_DRIVER *caps)
{
  char kext[] = "IMG\0\0" ;

  caps->iid = IID_IMG ;
  strcpy( caps->short_name, "(X)-IMG" ) ;
  strcpy( caps->file_extension, "IMG" ) ;
  strcpy( caps->name, "Standard GEM IMG" ) ;
  caps->version = 0x0402 ;

  caps->import = IEF_P1 | IEF_P2 | IEF_P4 | IEF_P8 | IEF_PBIT ; 
  caps->export = IEF_P1 | IEF_P2 | IEF_P4 | IEF_P8 | IEF_PBIT ;
  
  memcpy( caps->known_extensions, kext, sizeof(kext) ) ;
}
