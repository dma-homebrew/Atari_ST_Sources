/*
 * accents.c
 *
 * Purpose:
 * --------
 * Routines de gestion des caract�res accentu�s et
 * conversions de jeux de caract�res:
 *
 * History:
 * --------
 * 23.05.94: Created by flanque
 */

	#include "!OPTIONS.H"				/* Options de compilation */         
	#define	THIS_FILE	"ACCENTS.C v1.00 - 03.95"
          
/*
 * System headers:
 */
	#include	<stdio.h>
	
/*
 * Custom headers:
 */
	#include	"SPEC_PU.H"
	#include	"MINITEL.H"
	#include	"REZO.H"

	/*
	 * ASC2VDT_EQU: Equivalence de caract�re ASCII -> VIDEOTEX
	 */                           
	typedef
		struct			
		{
			char		c_ascii;
			char		c_equ1;
			char		c_equ2;
			char		c_equ3;
		}
		ASC2VDT_EQU;
	

	/*
	 * VDT2ASC_EQU: Equivalence de caract�re VDT -> ASCII
	 */                           
	typedef
		struct			
		{
			char		c_vdt;
			char		c_ascii;
		}
		VDT2ASC_EQU;

/*
 * ------------------------ PROTOTYPES -------------------------
 */
	/*
	 * EXTernal prototypes:
	 */
	void	ping( void );

	/*
	 * PUBlic INTernal prototypes:
	 */
	char	*convert_Asc2Vdt( 				/* Out: Ptr sur tampon de caract�res �quivalents */
							char	c_ascii );	/* In:  caract�re � traduire */
	char	convert_G2toAsc( 					/* Out: caract�re �quivalent */
							char	c_ascii );	/* In:  caract�re � traduire */
	char	convert_Compose2Asc( 			/* Out: caract�re �quivalent */
							char	c_accent,	/* In:  accent � composer */
							char	c_car );		/* In:  caract�re � composer */

/*
 * ------------------------ VARIABLES -------------------------
 */

/*
 * Internal variables: 
 */
	/*
	 * Equivalences ASCII PC8 -> VDT:
	 */
	static	ASC2VDT_EQU		M_Tasc2vdt[] =
					{
						128,		'C',		0,			0,			/* C c�dille */
						'�',		SS2,		TREMA,	'u',
						'�',		SS2,		AIGU,		'e',
						'�',		SS2,		CIRC,		'a',
						132,		SS2,		TREMA,	'a',
						'�',		SS2,		GRAVE,	'a',
						134,		'a',		0,			0,			/* a avec rond */
						'�',		SS2,		CEDILLE,	'c',
						'�',		SS2,		CIRC,		'e',
						'�',		SS2,		TREMA,	'e',
						'�',		SS2,		GRAVE,	'e',
						'�',		SS2,		TREMA,	'i',
						'�',		SS2,		CIRC,		'i',
						141,		'i',		0,			0,			/* i grave */
						142,		'A',		0,			0,			/* A trema */
						143,		'A',		0,			0,			/* A rond */
						144,		'E',		0,			0,			/* E aigu */
						145,		'a',		0,			0,			/* ae */
						146,		'A',		0,			0,			/* AE */
						'�',		SS2,		CIRC,		'o',
						148,		SS2,		TREMA,	'o',		
						149,		'o',		0,			0,			/* o grave */
						'�',		SS2,		CIRC,		'u',
						151,		SS2,		GRAVE,	'u',
						152,		'y',		0,			0,			/* y trema */
						153,		'O',		0,			0,			/* O trema */
						154,		'U',		0,			0,			/* U trema */
						155,		'c',		0,			0,			/* symbole cent */
						'�',		SS2,		LIVRE,	0,
						157,		'Y',		0,			0,			/* Yen */
/* ATARI ONLY */	158,		SS2,		BETA,		0,
						159,		'f',		0,			0,			/* f inclin� */
						160,		'a',		0,			0,			/* a aigu */
						161,		'i',		0,			0,			/* i aigu */						
						162,		'o',		0,			0,			/* o aigu */
						163,		'u',		0,			0,			/* u aigu */
						164,		'n',		0,			0,			/* n tilda */
						165,		'N',		0,			0,			/* N tilda */
						166,		'a',		0,			0,			/* a soulign� */
						167,		'o',		0,			0,			/* o soulign� */
						PC8_DEMI,		SS2,		DEMI,		0,			/* 1/2 */
						PC8_QUART,		SS2,		QUART,	0,			/* 1/4 */
						REZO_OE_MIN,	SS2,	OE_MIN,	0,
						REZO_OE_MAJ,	SS2,	OE_MAJ,	0,
						RESO_TRAIT_HAUT,		0x7E,	0,	0,
						RESO_TRAIT_HORIZ,		0x60,	0,	0,
						RESO_TRAIT_BAS,		0x5F, 0, 0,
						RESO_TRAIT_GAUCHE,	0x7B, 0,	0,
						RESO_TRAIT_VERT,		0x7C, 0, 0,
						RESO_TRAIT_DROIT,		0x7D, 0,	0,
						REZO_FLECHE_GAUCHE,	SS2,	FLECHE_GAUCHE, 0,
						REZO_FLECHE_HAUT,		SS2,	FLECHE_HAUT, 0,
						REZO_FLECHE_DROITE,	SS2,	FLECHE_DROITE, 0,
						REZO_FLECHE_BAS,		SS2,	FLECHE_BAS, 0,
						REZO_PARAGRAPHE,		SS2,	PARAGRPH, 0,
						PC8_BETA,	SS2,	BETA,		0,
						PC8_PLUSMOINS,	SS2,	PLUSMOINS,	0,	/* +- */
						PC8_DIVISE,	SS2,	DIVISE,	0,
						PC8_DEGRE,	SS2,	DEGRE,	0,
						'\0',		0,			0,			0
					};
	static	int		M_nb_equivAsc2Vdt;		/* Nbre d'�quivalences */
	static	char		M_Tc_equiv[ 4 ];			/* Buffer ds lequel on �crir l'�quivalence d'accent */

	static	VDT2ASC_EQU 	M_TjeuG2[]=
					{
						LIVRE,			'�',
						DOLLAR,			'$',
						DIESE,			'#',
						PARAGRPH,		REZO_PARAGRAPHE,
						FLECHE_GAUCHE,	REZO_FLECHE_GAUCHE,
						FLECHE_HAUT,	REZO_FLECHE_HAUT,
						FLECHE_DROITE,	REZO_FLECHE_DROITE,
						FLECHE_BAS,		REZO_FLECHE_BAS,
						DEGRE,			PC8_DEGRE,
						PLUSMOINS,		PC8_PLUSMOINS,
						DIVISE,			PC8_DIVISE,
						QUART,			PC8_QUART,
						DEMI,				PC8_DEMI,
						TROISQUARTS,	PC8_INVALID,
						OE_MAJ,			REZO_OE_MAJ,
						OE_MIN,			REZO_OE_MIN,
						BETA,				PC8_BETA,
						'\0',				0
					};
	static	int		M_nb_equivVdt2Asc;		/* Nbre d'�quivalences */

/*
 * ------------------------ FUNCTIONS -------------------------
 */

/*
 * init_accents(-)
 *
 * Purpose:
 * --------
 * Init des routines d'accents
 *
 * Algorythm:
 * ----------  
 *	compte le nbre d'�quivalences
 *
 * Notes:
 * ------
 *
 * History:
 * --------
 * 23.05.94: fplanque: Created
 */
void	init_accents( void )
{
	M_nb_equivAsc2Vdt = 0;
	while( M_Tasc2vdt[ M_nb_equivAsc2Vdt ] .c_ascii != '\0' )
	{
		M_nb_equivAsc2Vdt ++;
	}

	M_nb_equivVdt2Asc = 0;
	while( M_TjeuG2[ M_nb_equivVdt2Asc ] .c_ascii != '\0' )
	{
		M_nb_equivVdt2Asc ++;
	}

}


/*
 * convert_Asc2Vdt(-)
 *
 * Purpose:
 * --------
 * Convertit un caract�re ascii PC8 en vid�otex
 *
 * Algorythm:
 * ----------  
 *	retourne car invalid si pas trouv�.
 *
 * Suggest:
 * --------
 * On peut am�liorer l'�fficacit� avec un binary search
 * NE GERE PAS LES CODES <128!  (FLECHES, BARRES...)
 *
 * History:
 * --------
 * 23.05.94: fplanque: Created
 */
char	*convert_Asc2Vdt( 	/* Out: Ptr sur tampon de caract�res �quivalents */
			char	c_ascii )	/* In:  caract�re � traduire */
{
	int 	i;

	for( i=0; i < M_nb_equivAsc2Vdt; i++ )
	{
		if( M_Tasc2vdt[ i ] .c_ascii == c_ascii )
		{
			M_Tc_equiv[0] = M_Tasc2vdt[ i ] .c_equ1;
			M_Tc_equiv[1] = M_Tasc2vdt[ i ] .c_equ2;
			M_Tc_equiv[2] = M_Tasc2vdt[ i ] .c_equ3;
			M_Tc_equiv[3] = '\0';
			
			return	M_Tc_equiv;		/* Ptr sur buffer */
		}
	}

	/*
	 * On a pas trouv�:
	 */
	M_Tc_equiv[0] = INVALID;
	M_Tc_equiv[1] = '\0';
	
	return	M_Tc_equiv;		/* Ptr sur buffer */

}



/*
 * convert_G2toAsc(-)
 *
 * Purpose:
 * --------
 * Convertit un caract�re vid�otex du jeu G2 en ascii
 *
 * Algorythm:
 * ----------  
 *	retourne car pc8_invalid si pas trouv�.
 *
 * Suggest:
 * --------
 * On peut am�liorer l'�fficacit� avec un binary search
 *
 * History:
 * --------
 * 23.05.94: fplanque: Created
 */
char	convert_G2toAsc( 		/* Out: caract�re �quivalent */
			char	c_vdt )		/* In:  caract�re � traduire */
{
	int 	i;

	for( i=0; i < M_nb_equivVdt2Asc; i++ )
	{
		if( M_TjeuG2[ i ] .c_vdt == c_vdt )
		{
			return	M_TjeuG2[ i ] .c_ascii;		
		}
	}

	/*
	 * On a pas trouv�:
	 */
	return	PC8_INVALID;
}




/*
 * convert_Compose2Asc(-)
 *
 * Purpose:
 * --------
 * Convertit un caract�re vid�otex compos� en ascii
 *
 * Algorythm:
 * ----------  
 *	retourne car pc8_invalid si pas trouv�.
 *
 * Suggest:
 * --------
 * Impl�menter sous forme de tableau
 *
 * History:
 * --------
 * 23.05.94: fplanque: Created
 */
char	convert_Compose2Asc( 		/* Out: caract�re �quivalent */
			char	c_accent,			/* In:  accent � composer */
			char	c_car )				/* In:  caract�re � composer */
{
	switch( c_accent )
	{
		case	GRAVE:
			switch( c_car )
			{
				case	'a':
					return	'�';
				case	'e':
					return	'�';
				case	'i':
					return	REZO_INGRAVE;
				case	'o':
					return	0x95;
				case	'u':
					return	0x97;
				default:
					return	c_car;
			}
						
		case	AIGU:
			switch( c_car )
			{
				case	'e':
					return	'�';
				case	'i':
					return	0xA1;
				case	'o':
					return	0xA2;
				case	'u':
					return	0xA3;
				case	'E':
					return	'�';
				default:
					return	c_car;
			}
						
		case	CIRC:
			switch( c_car )
			{
				case	'a':
					return	'�';
				case	'e':
					return	'�';
				case	'i':
					return	'�';
				case	'o':
					return	'�';
				case	'u':
					return	'�';
				default:
					return	c_car;
			}
						
		case	TREMA:
			switch( c_car )
			{
				case	'a':
					return	0x84;
				case	'e':
					return	'�';
				case	'i':
					return	'�';
				case	'o':
					return	0x94;
				case	'u':
					return	'�';
				case	'y':
					return	0x98;
				case	'A':
					return	0x8E;
				case	'O':
					return	0x99;
				case	'U':
					return	0x9A;
				default:
					return	c_car;
			}
						
		case	CEDILLE:
			switch( c_car )
			{
				case	'c':
					return	'�';
				case	'C':							/* Non Minitel */
					return	REZO_CJCEDIL;
				default:
					return	c_car;
			}
	
	}

	/*
	 * On a pas trouv�:
	 * Ne devrait jamais arriver!
	 */
	ping();
	return	PC8_INVALID;
}


