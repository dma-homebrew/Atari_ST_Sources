DEFINITION MODULE VDIOutputs;


(*  Megamax Modula-2 GEM-Library :  Die VDI Ausgabefunktionen
 *
 *  Autor: Manuel Chakravarty           Erstellt :  31.10.87
 *
 *  Version   2.2     V#0015
 *)
 
 
(*      Dieses Modul enth�lt die Ausgaberoutinen des VDI. Darunter fallen
 *      zehn besonders auf, dies sind die GDP (Generalized Drawing Primi-
 *      tives), was soviel wie 'Allgemeine Zeichengrundfunktionen' hei�t.
 *      Ob diese Funktionen auf dem jeweiligen Ger�t vorhanden sind, kann
 *      aus den von 'GEMEnv.DeviceParameter' gelieferten Werten ersehen
 *      werden.
 *)


FROM GrafBase   IMPORT Point, Rectangle, WritingMode;
 
FROM GEMEnv     IMPORT DeviceHandle;
 
 
(*  HINWEIS  zu den folgenden 3 Routinen:
 *           Die maximale Anzahl der Punkte, die bei einem Aufruf im
 *           jeweiligen Open Array-Parameter angegeben werden kann,
 *           kann mit 'GEMEnv.MaxPoints' erfragt werden.
 *)

PROCEDURE PolyLine (    handle : DeviceHandle;
                    REF pts    : ARRAY OF Point;
                        noLines: CARDINAL);

        (*  Zeichnet einen Linienzug.
         *
         *  Die St�tzpunkte werden in 'pts' �bergeben und 'noLines' ent-
         *  h�lt die Anzahl der Linien. Ist 'noLines = 0', so wird das
         *  gesamte 'pts'-Array ausgewertet.
         *
         *  Achtung: Das VDI l��t nur eine begrenzte Anzahl Punkte zu!
         *  Die Anzahl ist TOS-abh�ngig und kann �ber 'GEMEnv.MaxPoints ()'
         *  ermittelt werden.
         *
         *  Es werden die mit 'VDIAttributes' gesetzten Linienattribute
         *  ausgewertet.
         *)

PROCEDURE PolyMarker (    handle   : DeviceHandle;
                      REF marks    : ARRAY OF Point;
                          noMarks  : CARDINAL);
                     
        (*  Diese Funktion zeichnet im Gegensatz zur vorherigen nicht den
         *  vollst�ndigen Linienzug, sondern nur dessen Eckpunkte. Das Aus-
         *  sehen dieser Punkte wird mit den Makierungsattributen bestimmt.
         *  Die Bedeutung von 'noMarks' entspricht der von 'noLines' bei
         *  'PolyLine'.
         *
         *  Achtung: Das VDI l��t nur eine begrenzte Anzahl Punkte zu!
         *  Die Anzahl ist TOS-abh�ngig und kann �ber 'GEMEnv.MaxPoints ()'
         *  ermittelt werden.
         *)
         
PROCEDURE Polygon (    handle : DeviceHandle;
                   REF pts    : ARRAY OF Point;
                       noEdges: CARDINAL);

        (*  Hier wird nicht einfach ein Polygonzug wie bei 'PolyLine' ge-
         *  zeichnet, sondern die beschriebene Innenfl�che gef�llt, dabei
         *  werden die aktuellen F�llattribute ber�cksichtigt. Zur Aufgabe
         *  von 'noEdges', siehe 'noLines' bei 'PolyLine'.
         *
         *  Achtung: Das VDI l��t nur eine begrenzte Anzahl Punkte zu!
         *  Die Anzahl ist TOS-abh�ngig und kann �ber 'GEMEnv.MaxPoints ()'
         *  ermittelt werden.
         *)


PROCEDURE Line (handle: DeviceHandle; p, q: Point);

        (*  Dies ist lediglich ein vereinfachter Aufruf von 'PolyLine'.
         *  Es wird eine Linie von 'p' nach 'q' gezogen.
         *)
        
PROCEDURE Mark (handle: DeviceHandle; p: Point);

        (*  Diese Routine f�hrt ein 'PolyMarker'-Aufruf durch, bei dem
         *  eine einzelne Makierung auf den Punkt 'p' gesetzt wird.
         *)

PROCEDURE GrafText (    handle: DeviceHandle;
                        start : Point;
                    REF text  : ARRAY OF CHAR);

        (*  Hiermit wird ein Text auf dem Grafikbildschirm ausgegeben.
         *
         * 'text'       -- der auszugebende Text
         * 'start'      -- hier beginnt die Textausgabe
         *
         *  Die Textausgabe wird mit den eingestellten Textattributen
         *  vorgenommen. Standardm��ig wird der Text am linken Rand
         *  und der Grundlinie (base line) justiert, dies ist bei der
         *  Wahl von 'start' zu beachten.
         *  Die Lage der Grundlinie kann mit 'VDIInquires.GetFaceInfo' er-
         *  fragt werden.
         *)
         
PROCEDURE CellArray (    handle                      : DeviceHandle;
                         frame                       : Rectangle;
                         rowLength, usedElems, noRows: CARDINAL;
                         mode                        : WritingMode;
                     REF colArray                    : ARRAY OF CARDINAL);

         (*  Diese Routine teilt eine Bildschirmbereich in einzelne Felder,
          *  die unterschiedlich gef�rbt werden.
          *  'frame'      -- der Bildschirmbereich
          *  'rowlength'  -- die Anzahl der Spalten pro Zeile
          *  'noRows'     -- die Anzahl der Zeilen
          *  'mode'       -- gibt den Schreibmodus
          *  'colArray'   -- enth�lt die einzelnen Farben
          *
          *  HINWEIS: Diese Routine ist im aktuellen TOS nicht implementiert.
          *
          *           Au�erdem ist sie in der aktuellen Modulversion noch
          *           nicht implementiert.
          *)
        
PROCEDURE ContourFill (handle  : DeviceHandle;
                       start   : Point;
                       tagColor: CARDINAL;
                       useTag  : BOOLEAN);
                      
        (*  Diese Procedur f�llt einen beliebig geformten Bereich,
         *  der entweder durch eine Randfarbe bestimmt wird oder des-
         *  sen Form durch die Verteilung der Innenfarbe definiert ist
         *
         *  'tagColor'  -- die Randfarbe
         *  'useTag'    -- '=TRUE': Bereich wird durch Randfarbe bestimmt
         *                 '=FALSE': ..wird durch die Verteilung der In-
         *                 nenfarbe bestimmt
         *  'start'     -- Punkt in Inneren des zu F�llenden Bereichs.
         *                 Die Farbe dieses Punktes legt die Innenfar-
         *                 be fest.
         *)
        
PROCEDURE FillRectangle (handle: DeviceHandle; frame: Rectangle);

        (*  Es wird ein Rechteck mit den durch 'frame' bestimmten Aus-
         *  ma�en gezeichnet. Das Aussehen wird durch die F�llattribute
         *  festgelegt.
         *)

        
                (*  Generalized Drawing Primitives  *)
                (*  ==============================  *)
                
(*  Alle Winkelangaben, die in einem Teil der folgenden zehn Routinen vor-
 *  kommen, m�ssen in 1/10 Grad gemacht werden. Dabei gilt:
 *
 *                              900
 *                               |
 *                               |
 *                      1800 ----+---- 0
 *                               |
 *                               |
 *                              2700
 
 *  Bei allen gef�llten Objekten werden die F�llattribute F�lltyp, F�ll-
 *  index, F�llfarbe und Begrenzungslinie ausgewertet.
 *
 *  Bei allen linierten Objekten (z.B. Arc) werden die Linienattribute
 *  Linienst�rke, Linientyp, Linienfarbe und das Aussehen der Linienenden
 *  ber�cksichtigt.
 *
 *  Bei der Textausgabe werden die Textattribute ausgewertet, dies sind
 *  Textgr��e, Winkel des Textes, Textfarbe, Texteffekte und die Textaus-
 *  richtung.
 *
 *  Zus�tzlich wird bei jeder Routine noch der Zeichenmodus beachtet.
 *
 *  Jedes oben aufgef�hrte Attribut kann mit Routinen des Moduls
 *  'VDIAttributes' eingestellt werden.
 *)


PROCEDURE Bar (handle: DeviceHandle; frame: Rectangle);

        (*  Diese Routine zeichnet einen ausgef�llten Balken. Es werden
         *  alle F�llattribute ber�cksichtigt.
         *)

PROCEDURE Arc (handle          : DeviceHandle;
               middle          : Point;
               radius, beg, end: CARDINAL);

        (*  Damit zeichnet man einen Kreisbogen, dessen Mittelpunkt
         *  durch 'middle' und dessen Radius durch 'radius' festge-
         *  legt wird. Der Bogen beginnt bei 'beg' (Winkelangabe)
         *  und endet bei 'end' (ebenfalls in Grad).
         *)
        
PROCEDURE Pie (handle           : DeviceHandle;
                middle          : Point;
                radius, beg, end: CARDINAL);

        (*  Diese Routine arbeitet genauso wie 'Arc', nur da� statt des
         *  Kreisbogens ein ganzer Kreisausschnitt, gef�llt, gezeichnet
         *  wird. Kann z.B. in Tortengrafiken verwendet werden.
         *)
        
PROCEDURE Circle (handle: DeviceHandle;
                  middle: Point;
                  radius: CARDINAL);

        (*  Diese Prozedur zeichnet nun einen vollst�ndig gef�llten
         *  Kreis, mit 'middle' als Mittelpunkt und 'radius' als Radius.
         *)
        
PROCEDURE Ellipse (handle          : DeviceHandle;
                   middle          : Point;
                   xradius, yradius: CARDINAL);

        (*  Zeichnet eine gef�llte Ellipse, deren Mittelpunkt 'middle' ist.
         *  'xradius' gibt die L�nge der horizontalen und 'yradius' die der
         *  vertikalen Halbachse an.
         *)
        
PROCEDURE ElliptArc (handle                    : DeviceHandle;
                     middle                    : Point;
                     xradius, yradius, beg, end: CARDINAL);
            
        (*  Es wird ein elliptischer Bogen, von 'beg' bis 'end' (Winkel-
         *  angabe), gezeichnet. 'middle', 'xradius' und 'yradius' geben
         *  den Mittelpunkt bzw. die horizontale und vertikale Halbachse
         *  der zu Grunde liegenden Ellipse an.
         *)
        
PROCEDURE ElliptPie (handle                    : DeviceHandle;
                     middle                    : Point;
                     xradius, yradius, beg, end: CARDINAL);
                     
        (*  Entspricht 'ElliptArc', nur wird statt des Bogens ein ge-
         *  f�llte Ellipsenausschnitt gezeichnet.
         *)
        
PROCEDURE RoundRect (handle: DeviceHandle; frame: Rectangle);

        (*  Damit kann man ein Rechteck zeichnen, dessen Ecken abgerundet
         *  sind. Die Ausma�e werden durch 'frame' bestimmt.
         *)
        
PROCEDURE FillRoundRect (handle: DeviceHandle; frame: Rectangle);

        (*  Entspricht 'RoundRect', nur wird das Innere des Rechtecks,
         *  entsprechend der aktuellen F�llattribute gef�llt.
         *)
        
PROCEDURE JustifiedText (    handle        : DeviceHandle;
                             start         : Point;
                             length        : CARDINAL;
                             wSpace, cSpace: BOOLEAN;
                         REF str           : ARRAY OF CHAR);
                         
        (*  Diese Routine gibt eine formatierte Textzeile aus.
         *
         *  'str'
         *  'start'     -- bestimmt, wo der Text erscheint. Bei der
         *                 Festlegung mu� auf die aktuelle Textaus-
         *                 richtung geachtet werden. Standardm��ig ist
         *                 sie so eingestellt, da� 'start' das linke Ende
         *                 der Grundlinie (base line) angibt.
         *  'length'    -- gibt an, wie breit (in Pixel) er sein soll
         *  'wSpace' bzw.
         *  'cSpace'    -- geben an, ob eine Dehnung in Wort- bzw.
         *                 Zeichenzwischenr�umen erlaubt ist.Ist sie
         *                 erlaubt, so versucht die Routine den Text so
         *                 zu dehnen, da� er die in 'length' angegebene
         *                 Breite hat.
         *
         *)

END VDIOutputs.