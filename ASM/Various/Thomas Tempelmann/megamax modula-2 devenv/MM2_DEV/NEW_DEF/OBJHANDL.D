DEFINITION MODULE ObjHandler;


(*      Megamax Modula-2 GEM-Library: ObjectHandler
 *
 *      geschrieben von Manuel Chakravarty
 *
 *      Version 2.1     V#0068      Created 30.06.1987
 *)


                    (*  Operationen auf Objektb�ume  *)
                    (*  ===========================  *)
                        
                        
  (*  Die folgenden Routinen stellen ein Paket dar, das die M�glichkeit
   *  bieten soll in eleganter Art und Weise auf die Objektbaumstrukturen
   *  des GEM zuzugreifen. Die Sammlung wurde notwendig, da es die Struk-
   *  tur des Baumes nicht erlaubt, ihn 'anst�ndig' in Modula-Datentypen
   *  zu fassen und andererseits Zugriffe �ber GEM-Funktionen nur unzu-
   *  reichend m�glich sind.
   *  Die Routinen fangen Fehler, soweit es m�glich ist ab und melden sie
   *  bei Anfrage �ber 'ObjTreeError' an das aufrufende Modul. Allerdings
   *  k�nnen Fehler, wie falsch �bergebene Baumadressen und Zugriff auf un-
   *  definierte Elemente in der Regel nicht erkannt werden.
   *  Folgende Situationen l�sen immer einen Fehler aus:
   *
   *     -- Zugriff auf ein Objekt w�hrend der momentane Baum mit 'NIL'
   *        besetzt ist.
   *     -- Zugriff auf ein Objekt, dessen Index gr��er als der des letzten
   *        Objekts ist
   *     -- Zugriff auf ein Objekt mit einer Prozedur, die mit dem Objekt-
   *        typ nicht vertr�glich ist.
   *
   *  Die Operationen werden immer auf einen vorher festgelegten Baum ange-
   *  wendet, dieser Baum wird im folgenden mit 'momentaner Baum' bezeich-
   *  net. Die Ermittlung des momentanen Baumes geschieht mit Hilfe von
   *  'CurrObjTree', mit einer entsprechenden Prozedur kann er auch gesetzt
   *  werden.
   *  Der erste Parameter der meisten Proceduren ist das Objekt, auf das die
   *  Routine angewendet werden soll. Dieser Parameter hei�t immer 'obj'
   *  und ist vom Typ 'CARDINAL'.
   *  Es bedeutet ein Wert von 'NIL', da� kein Baum vorhanden ist.
   *  Die Objektbaumstruktur ist in 'GEMGlobals' definiert.
   *)
                        
                        
FROM SYSTEM     IMPORT WORD, LONGWORD;

FROM MOSGlobals IMPORT MemArea;

FROM GrafBase   IMPORT Point, Rectangle, PtrBitPattern;

FROM GEMGlobals IMPORT PtrObjTree, ObjType, OStateSet, OFlagSet, PtrObjSpec,
                       THorJust, PtrMaxStr;


PROCEDURE ObjTreeError (): BOOLEAN;

        (*  Es wird 'TRUE' geliefert, falls bei der LETZTEN Baumoperation
         *  ein Fehler auftratt (zum Beispiel Aufruf w�hrend der momen-
         *  tane Baum 'NIL' ist).
         *)

PROCEDURE CreateObjTree (    noElements: CARDINAL;
                             sys       : BOOLEAN;
                         VAR success   : BOOLEAN);

        (*  Erzeugt einen Objektbaum, der 'noElements' Elemente enth�lt.
         *  Der erzeugte Baum ist danach der momentane Baum und alle Ele-
         *  mente des Baumes befinden sich in einem undefinierten Zustand.
         *  Ist nicht genug Speicher vorhanden, so ist 'success = FALSE'.
         *
         *  Ist 'sys = TRUE', so wird ein Systembaum erzeugt, das hei�t
         *  alle Speicheranforderungen laufen �ber 'Storage.SysAlloc'.
         *)
         
PROCEDURE DeleteObjTree;

        (*  Gibt den Speicher des mom. Baumes und all seiner Objektspezi-
         *  fikationen frei. Spezifikationen die 'NIL' sind werden ignoriert.
         *)

PROCEDURE SetCurrObjTree (tree: PtrObjTree; sys: BOOLEAN);

        (*  Danach ist 'tree' der momentane Baum. Ist 'sys = TRUE', so
         *  wird angenommen, das ein Systembaum �bergeben wurde (Siehe
         *  'CreateObjTree').
         *  Das letzte Objekt (das mit dem h�chsten Index) mu� das Objekt-
         *  flag 'lastObjFlg' besitzen!
         *)
         
PROCEDURE CurrObjTree (): PtrObjTree;

        (*  Liefert einen Zeiger auf den momentanen Baum.
         *)
        
PROCEDURE LastObject (): CARDINAL;

        (*  Liefert den Index des letzten Baumelements, d.h das welches den
         *  h�chsten Index besitzt.
         *)
         
PROCEDURE SetObjType (obj: CARDINAL; type: ObjType);

        (*  Legt Objekttyp des Objektes 'obj' fest.
         *)
        
PROCEDURE ObjectType (obj: CARDINAL): ObjType;

        (*  Liefert Objekttyp des Objektes 'obj'.
         *)
         
PROCEDURE SetObjFlags (obj: CARDINAL; flags: OFlagSet);

        (*  Setzt die Flags des Objektes 'obj' auf 'flags'.
         *)
        
PROCEDURE ObjectFlags (obj: CARDINAL): OFlagSet;

        (*  Liefert die Flags des Objektes 'obj'.
         *)
        
PROCEDURE SetObjState (obj: CARDINAL; state: OStateSet);

        (*  Setzt den Objektstatus auf 'state'.
         *)
        
PROCEDURE ObjectState (obj: CARDINAL): OStateSet;

        (*  Liefert den Objektstatus des Objektes 'obj'.
         *)
        
PROCEDURE SetObjSpace (obj: CARDINAL; space: Rectangle);

        (*  Legt den Bereich den das Objekt ausf�llt fest.
         *)
        
PROCEDURE ObjectSpace (obj: CARDINAL): Rectangle;

        (*  Ermittelt den vom momentanen Objekt belegten Bildschirmbereich.
         *)
        
PROCEDURE SetObjRelatives (obj: CARDINAL; next, head, tail: CARDINAL);

        (*  Legt die 3 Zeiger auf verwandte Objekte fest. 'next' zeigt auf
         *  den n�chsten Bruder (oder falls keiner vorhanden ist auf den
         *  Vorg�nger), 'head' zeigt auf den ersten Nachfolger und 'tail'
         *  auf den Letzte. 'NoObject' zeigt dabei jeweils an, da� das ent-
         *  sprechende Objekt nicht existiert (z.B. 'next = NoObject' bedeu-
         *  tet, es existiert weder Bruder noch Vorg�nger, das Objekt ist al-
         *  so die Baumwurzel).
         *)
         
PROCEDURE GetObjRelatives (obj: CARDINAL; VAR next, head, tail: CARDINAL);

        (*  Liest die von 'SetObjRelatives' gesetzten Werte.
         *)
        
PROCEDURE Parent (obj: CARDINAL): CARDINAL;

        (*  Es wird der Vorg�nger des Objektes 'obj' zur�ckgegeben.
         *  Ein Fehler tritt auf, falls 'obj' die Wurzel des Baumes ist.
         *)
         
PROCEDURE LeftSister (obj: CARDINAL): CARDINAL;

        (*  Es wird der linke Nachbar des Objektes 'obj' ermittelt.
         *  Ist 'obj' das erste Element der Nachfolgerliste des Vorg�ngers,
         *  so tritt ein Fehler auf.
         *)
         
PROCEDURE RightSister (obj: CARDINAL): CARDINAL;

        (*  Es wird der rechte Nachbar ermittelt.
         *  Ist 'obj' das letzte Element der Nachfolgerliste, so tritt ein
         *  Fehler auf.
         *)
         
PROCEDURE CreateSpecification (obj: CARDINAL; spec: PtrObjSpec);

        (*  Die Objektspezifikation des Objekts 'obj' wird erzeugt.
         *  Die Routine arbeitet in zwei Modi:
         *
         *  'spec=NIL' -- Falls die Objektspezifikation des Objekts ein
         *                Zeiger auf eine Struktur ist, z.B. 'TEdInfo',
         *                so wird diese Struktur alloziert und ihre Adres-
         *                se eingetragen, sonst wird die Objektspezifika-
         *                tion einfach gel�scht.
         *                Ist das 'indirectFlg'-Flag des Objekts gesetzt,
         *                so wird zuerst eine neue Spezifikation alloziert
         *                und dann wie oben verfahren.
         *  'spec#NIL' -- Es wird 'spec^' als zu setzende Spezifikation be-
         *                trachted und somit in das Objekt eingetragen. Ist
         *                das 'indirectFlg'-Flag gesetzt, so wird 'spec',
         *                eingtragen ('spec' ist ein Zeiger auf eine Spezi-
         *                fikation).
         *                Hinweis: Die Routine ist w�hrend der Laufzeit
         *                         nicht in der Lage zu �berpr�fen, ob die
         *                         gesetzte Objektspezifikation mit dem
         *                         Objekttyp vertr�glich ist.
         *
         *  Achtung: Zum Zeitpunkt des Aufrufs dieser Routine mu� der Typ
         *           des Objekts 'obj' und der Wert des 'indirectFlg', aus
         *           den Objektflags, schon gesetzt sein.
         *)

PROCEDURE SetBoxChar (obj: CARDINAL; ch: CHAR);

        (*  Es wird das Zeichen eines 'boxCharObj'-Objekts mit 'ch' besetzt.
         *)
         
PROCEDURE BoxChar (obj: CARDINAL): CHAR;

        (*  Das Zeichen des 'boxCharObj'-Objekts wird ermittelt.
         *)
        
        
TYPE    SignedByte      = [-128..127];

PROCEDURE SetBorderThickness (obj: CARDINAL; thick: SignedByte);

        (*  Die Randst�rke des Objektes wird auf 'thick' gesetzt.
         *)
         
PROCEDURE BorderThickness (obj: CARDINAL): SignedByte;

        (*  Die Randst�rke eines Objekts wird ermittelt.
         *)
        
PROCEDURE SetComplexColor (obj        : CARDINAL;
                           borderCol,
                           textCol,
                           fillCol,
                           fillDensity: CARDINAL;
                           opaque     : BOOLEAN);
                           
        (*  Mit dieser Routine wird die Farbgebung aller Objekttypen, aus-
         *  genommen 'imageObj', 'iconObj', 'progDefObj', 'stringObj' und
         *  'titleObj', 'buttonObj', festgelegt.
         *  Dabei ist 'borderCol' die Farbe des Randes, 'textCol' die, in
         *  der Text erscheinen soll und 'fillCol' die F�llfarbe.
         *  'fillDensity' gibt die Intensit�t des F�llmusters an, dabei be-
         *  deutet 0 keine F�llung und 7 vollst�ndige F�llung. Mit 1 bis 6
         *  erzeugt man ein immer dichter werdendes Punktmuster.
         *  'opaque' gibt den Schreibmodus des Textes an, dabei es steht
         *  'TRUE' f�r �berdeckend und 'FALSE' f�r transparent.
         *)
         
PROCEDURE GetComplexColor (    obj        : CARDINAL;
                           VAR borderCol,
                               textCol,
                               fillCol,
                               fillDensity: CARDINAL;
                           VAR opaque     : BOOLEAN);
                          
        (*  Erfragt die mit 'SetComplexColor' gesetzten Werte.
         *)
        
PROCEDURE SetIconColor (obj: CARDINAL; foreGround, backGround: CARDINAL);

        (*  Setzt die Vordergrund 'foreGround' und Hintergrund 'backGround'
         *  Farben von Objekten des Typs 'iconObj'.
         *)
         
PROCEDURE GetIconColor (obj: CARDINAL; VAR foreGround, backGround: CARDINAL);

        (*  Ermittelt die mit 'SetIconColor' gesetzten Farben.
         *)
        
PROCEDURE SetImageColor (obj: CARDINAL; color: CARDINAL);

        (*  Legt die Farbe fest, in der die gesetzten Punkte des Bitmusters
         *  eines 'imageObj'-Objekts dargestellt werden sollen.
         *)
         
PROCEDURE GetImageColor (obj: CARDINAL; VAR color: CARDINAL);

        (*  Liefert die mit 'SetImageColor' festgelegte Farbe.
         *)
        
PROCEDURE SetTextForm (obj: CARDINAL; font: CARDINAL; just: THorJust);

        (*  Legt den Zeichensatz 'font' und die Textausrichtung 'just' des
         *  Objektes 'obj' fest, welches als Spezifikation eine 'TEdInfo'-
         *  Struktur besitzen mu�.
         *  Als Zeichensatz kann man 'SmallFont' oder 'StandardFont' w�hlen.
         *  Wird aus 'GEMGlobals' importiert.
         *)
         
PROCEDURE GetTextForm (obj: CARDINAL; VAR font: CARDINAL; VAR just: THorJust);

        (*  Liefert die mit 'SetTextForm' gesetzten Parameter.
         *)
        
PROCEDURE SetIconForm (obj      : CARDINAL;
                       charPos  : Point;
                       iconFrame,
                       textFrame: Rectangle);
                       
        (*  Hiermit bestimmt man bei Objekten vom Typ 'iconObj' die Position
         *  des Zeichens mit 'charPos', den Rahmen in dem das Piktogramm
         *  liegt mit 'iconFrame' und das Rechteck, das den Text umschlie�t,
         *  mit 'textFrame'.
         *  Alle Angaben werden in Pixeln gemacht und sind relativ zu dem
         *  Rahmen des Gesamtobjekts.
         *)
         
PROCEDURE GetIconForm (    obj      : CARDINAL;
                       VAR charPos  : Point;
                       VAR iconFrame,
                           textFrame: Rectangle);
                       
        (*  Ermittelt die mit 'SetIconForm' festgelegten Werte.
         *)
        
PROCEDURE SetImageForm (obj      : CARDINAL;
                        byteWidth,
                        height,
                        deltaX,
                        deltaY   : INTEGER);

        (*  F�r Objekte vom Typ 'imageObj gibt 'byteWidth' die Breite des
         *  Bitmusters in Bytes an und mu� eine gerade Zahl sein. 'height'
         *  ist die H�he des Bitmusters in Pixeln und 'deltaX' bzw. 'deltaY'
         *  geben je einen Offset an, der festlegt wieviel Pixel, vom linken
         *  bzw. oberen Rand des Bitmusters entfernt mit dem Darstellen des-
         *  selbigen begonnen werden soll.
         *)
         
PROCEDURE GetImageForm (    obj      :CARDINAL;
                        VAR byteWidth,
                            height,
                            deltaX,
                            deltaY   :INTEGER);
                        
        (*  Erfragt die mit 'SetImageForm' festgelegten Werte.
         *)
        
TYPE    SetPtrChoice    = (create, setOnly, reCreate, noChange);

         (*  Beim Setzen von Pointervariblen kann man mit einem Parameter
          *  des obigen Typs w�hlen, ob die Variable neu alloziert werden
          *  oder ob sie nur einen neuen Wert erhalten soll.
          *
          *  'create'   -- Variable neu allozieren
          *  'setOnly'  -- Nur Wert zuweisen
          *  'reCreate' -- Alte Variable deallozieren und dann
          *                wie bei 'create' verfahren
          *  'noChange' -- Die Variable wird nicht beeinflu�t
          *)

PROCEDURE AssignTextStrings
                       ( obj: CARDINAL;
                         textChoice : SetPtrChoice; REF textS: ARRAY OF CHAR;
                         tmpltChoice: SetPtrChoice; REF tmplt: ARRAY OF CHAR;
                         validChoice: SetPtrChoice; REF valid: ARRAY OF CHAR );

        (*  Hiermit werden die Strings einer 'TEdInfo'-Struktur gesetzt, dabei
         *  kann mit Hilfe der '...Choice'-Parameter gew�hlt werden, ob der
         *  String neu allociert werden oder nur mit einem Wert besetzt werden
         *  soll (Siehe oben).
         *  Es wird 'textS' der Zeichenkette zugewiesen, die den Text enth�lt;
         *  'tmplt' ist f�r die Maske und 'valid' f�r den String, der die
         *  erlaubten Zeichen enth�lt.
         *  'TEdInfo.tmpltLen' bekommt die L�nge von 'tmplt' zugewiesen und
         *  'TedInfo.textLen' die von 'valid'.
         *  Au�erdem kann mit dieser Routine die Zeichenkette von Objekten
         *  des Typ 'buttonObj', 'stringObj' oder 'titleObj' gesetzt werden,
         *  dazu m�ssen aber 'tmpltChoice' und 'validChoice' den Wert
         *  'noChange' enthalten, sonst wird ein Fehler ausgel�st (Siehe
         *  'ObjTreeError').
         *)
         
PROCEDURE LinkTextString (obj: CARDINAL; str: PtrMaxStr);

        (*  Diese Routine wei�t der Textzeichenkette eines 'TEdInfo'-RECORDs
         *  nicht einfach einen Wert zu, sondern es wird die Adresse des
         *  angegebene Strings 'str' eingetragen.
         *  Ist das so ver�nderte Objekt edierbar, so werden alle �nderungen
         *  direkt in dieser Zeichenkette vorgenommen.
         *)

PROCEDURE GetTextStrings (    obj  : CARDINAL;
                          VAR textS,
                              tmplt,
                              valid: ARRAY OF CHAR);

        (*  Liefert die mit 'AssignTextStrings' gesetzten Strings zur�ck.
         *)
        
PROCEDURE SetStringLength (obj: CARDINAL; textLen, tmpltLen: CARDINAL);

        (*  Erlaubt es 'TedInfo.textLen/tmpltLen' zu setzen.
         *)
        
PROCEDURE GetStringLength (obj: CARDINAL; VAR textLen, tmpltLen: CARDINAL);

        (*  Erfragt die von 'SetStringLength' gesetzten Werte.
         *)
        
PROCEDURE SetImagePattern (obj: CARDINAL; pattern: PtrBitPattern);

        (*  Legt das Bitmuster des Objekts 'obj', welches vom typ 'imageObj'
         *  sein mu� fest.
         *)
         
PROCEDURE GetImagePattern (obj: CARDINAL; VAR pattern: PtrBitPattern);

        (*  Liefert einen Zeiger auf das Bitmuster von 'obj'.
        *)
        
PROCEDURE SetIconLook (    obj   : CARDINAL;
                           data,
                           mask  : PtrBitPattern;
                           choice: SetPtrChoice;
                       REF str   : ARRAY OF CHAR;
                           ch    : CHAR);

        (*  Einem Objekt vom Typ 'iconObj' wird der Zeiger auf das Daten-
         *  bitmuster ('data') und die Maske ('mask') zugewiesen. Au�erdem
         *  wird die Bildunterschrift des Icons mit 'str' besetzt. Dabei
         *  bestimmt 'choice' auf welche Art die Zeichenkette eingetragen
         *  wird (Siehe 'SetPtrChoice'). Schlu�endlich wird 'ch' zu dem
         *  im Piktogramm erscheienden Zeichen.
         *)
                      
PROCEDURE GetIconLook (    obj :CARDINAL;
                       VAR data,
                           mask:PtrBitPattern;
                       VAR str :ARRAY OF CHAR;
                       VAR ch  :CHAR);
                      
        (*  Erfragt die von 'SetIconLook' gesetzten Parameter.
         *)
         
         
(*      Die folgenden Routinen sind f�r eine ganz besondere Sorte von
 *      Objekten gedacht, f�r die vom Programmierer selbstdefinierten
 *      Objekte ("user defined objects").
 *      Wann immer ein solches Objekt auf dem Bildschirm dargestellt wird oder
 *      dessen Objektstatus ver�ndert werden soll, wird eine selbstdefinier-
 *      bare Routine aufgerufen. Diese kann, mit Hilfe der VDI-Funktionen,
 *      die Gestaltung des Objektes in eigener Regie �bernehmen. Dazu werden
 *      der Prozedur, die vom Typ 'ProgDefProc' sein mu�, der Baum 'tree'
 *      und der Objektindex ('index') des darzustellenden Objekts �berge-
 *      ben. Au�erdem werden ihr, falls nur der Objektstatus ge�ndert werden
 *      soll, der alte ('prevState') und der neue Status ('curState') �bergeben.
 *      Sind die beiden gleich, so hei�t dies, da� das Objekt komplett neu
 *      gezeichnet werden mu�. 'space' gibt die Gr��e des Objekts an und
 *      'clip' sagt, welcher Bereich beim Zeichnen nicht verlassen werden darf.
 *      Letztlich wird in 'parm' ein Langwort geliefert, das beim Baumaufbau
 *      angegeben werden mu� und dessen Verwendung dem Programmierer �berlas-
 *      sen ist. Als R�ckgabewert mu� die selbstdefinierte Routine die Zust�nde
 *      liefern, die noch vom AES gesetzt werden sollen (Es wird dann die
 *      normale Vorgehensweise gew�hlt, wird zum Beispiel 'selectFlg' gelie-
 *      fert, so wird die Zeichnung invertiert).
 *
 *      Hinweis: Da das AES nicht reentrant-f�hig ist, sollte auf AES-Aufrufe
 *               in einer solchen Objektbaumprozedur verzichtet werden.
 *
 *      Eine Demo-Anwendung hierf�r findet sich im DEMO-Ordner (PROGDEFD.M).
 *)
        
        
TYPE    ProgDefProc     = PROCEDURE((* tree     : *) PtrObjTree,
                                    (* index    : *) CARDINAL,
                                    (* prevState: *) OStateSet,
                                    (* curState : *) OStateSet,
                                    (* space    : *) Rectangle,
                                    (* clip     : *) Rectangle,
                                    (* parm     : *) LONGWORD  ): OStateSet;
                                    
        ProgDefCarrier  = ARRAY[0..15] OF WORD;


PROCEDURE MakeProgDefProc (VAR hdl : ProgDefCarrier;
                               proc: ProgDefProc;
                               wsp : MemArea       );
                           
        (*  Macht die Prozedur 'proc' zu einer Routine, die in einer Objekt-
         *  baumstruktur angegeben werden kann. Dieser Vorgang mu� nicht
         *  r�ckg�nig gemacht werden (auch nicht bei der Programmterminierung)
         *  und beeinflu�t die Funktionweise von 'proc' in keiner Weise.
         *  Es ist 'hdl' nach dem Aufruf Kennung f�r die Prozedur und Spei-
         *  cherbereich f�r systeminterne Daten. 'hdl' mu� global definiert
         *  sein und darf weder anderweitig benutzt, noch irgendwie freige-
         *  geben werden. Erst wenn kein Objektbaum mehr existiert, der 'proc'
         *  enth�lt und auch kein solcher mehr erstellt werden soll, ist 'hdl'
         *  wieder frei.
         *  Das Gleiche gilt f�r den in 'wsp' beschriebenen Speicherbereich,
         *  der von 'proc' als Stack benutzt wird.
         *  Eine Demo hierf�r findet sich im DEMO-Ordner (PROGDEFD.M).
         *)
                           
PROCEDURE SetProgDefSpec (    obj : CARDINAL;
                          VAR hdl : ProgDefCarrier;
                              parm: LONGWORD);

        (*  Das Objekt 'obj', welches vom Typ 'progDefObj' sein mu�, bekommt
         *  die durch 'hdl' beschriebene Prozedur und den Parameter 'parm'
         *  zugewiesen.
         *  Zu 'hdl' siehe 'MakeProgDefProc'.
         *  Eine Demo hierf�r findet sich im DEMO-Ordner (PROGDEFD.M).
         *)

PROCEDURE GetProgDefSpec (    obj : CARDINAL;
                          VAR proc: ProgDefProc;
                          VAR parm: LONGWORD);
        
        (*  Erfragt die mit 'SetProgDefSpec' gesetzten Werte, dabei wird al-
         *  lerdings statt des 'ProgDefCarrier's die Procedure 'proc' �ber-
         *  geben, mit welcher der 'ProgDefCarrier' initialisiert wurde.
         *)


END ObjHandler.
