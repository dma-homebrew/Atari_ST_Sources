PROGRAM Erbteilung; { 7. Bundeswettbewerb Informatik 1988/1989 }
                    { 1. Runde, Aufgabe 3 ; Autor M. Berger    }
                    {     Bitte Hinweise am Ende beachten !    }

CONST Max_Anzahl_Goldstuecke  = 100;
      Max_Anzahl_Erben        = 10;
      
TYPE  Geldkiste          = ARRAY [1..Max_Anzahl_Goldstuecke] OF
                                 INTEGER;

VAR   Goldstuecke        : Geldkiste; 
      Anzahl_Goldstuecke : INTEGER;
      Anzahl_Erben       : INTEGER;
      
  PROCEDURE Eingabe;
    BEGIN
      CLRSCR;WRITELN('Erbteilung  (bwINF 7 [88/89];Aufgabe 2)');WRITELN;
      WRITELN;WRITE('  Bitte Anzahl Erben(Erbinnen) eingeben : ');
      REPEAT
        READLN(Anzahl_Erben);
      UNTIL Anzahl_Erben<Max_Anzahl_Erben;
      WRITELN;WRITELN('  Bitte Werte der M�nzen eingeben (Ende mit <RETURN>)');
      Anzahl_Goldstuecke:=0;
      REPEAT
        Anzahl_Goldstuecke:=Anzahl_Goldstuecke+1;
        WRITE('     ->');
        READLN(Goldstuecke[Anzahl_Goldstuecke]);
      UNTIL (Goldstuecke[Anzahl_Goldstuecke]=0) OR 
            (Anzahl_Goldstuecke>Max_Anzahl_Goldstuecke);
      Anzahl_Goldstuecke:=Anzahl_Goldstuecke-1;
      WRITELN;WRITELN;CLRSCR;
    END;
    
  PROCEDURE Aufteilung;
          
    VAR i,u                : INTEGER;
        jeder_erbt         : INTEGER;
        Akt_Erbe           : INTEGER;
        Ergebniss_gefunden : BOOLEAN;
        HILFSarray         : Geldkiste;
    
    FUNCTION ermittle_durchschnittl_Erbe : REAL;
      VAR i         : INTEGER;
          hilfsumme : REAL;
      BEGIN
        hilfsumme:=0;
        FOR i:=1 TO Anzahl_Goldstuecke DO
        BEGIN
          hilfsumme:=hilfsumme+Goldstuecke[i];
        END;
        hilfsumme:=hilfsumme/Anzahl_Erben;
        ermittle_durchschnittl_Erbe:=hilfsumme;
      END;
      
    PROCEDURE teste (Uebrige    : Geldkiste;
                     Genommene  : Geldkiste;
                     Anz_Genomm : INTEGER;
                     Summe      : INTEGER;
                     Stelle     : INTEGER);
     
      VAR  i    : INTEGER;
           Zahl : INTEGER;
      
      PROCEDURE Ausgabe;
        VAR i,u : INTEGER;
        BEGIN
          WRITELN('Es erbt Erbe Nr. ',akt_Erbe,' die M�nzen :  ');
          WRITE('  ');
          FOR i:=1 TO Anz_Genomm DO
          BEGIN
            IF i>1 THEN WRITE(',');
            WRITE(Genommene[i]);
          END;
          WRITELN('.  Summe = ',Summe);WRITELN;
          FOR i:=1 TO Anzahl_Goldstuecke DO
            Goldstuecke[i]:=Uebrige[i];
        END;
      
      BEGIN
        Zahl:=Uebrige[Stelle];
        IF NOT(Ergebniss_Gefunden) THEN
        BEGIN
          Summe:=Summe+Zahl;
          IF Summe<=jeder_erbt THEN
          BEGIN
            Uebrige[Stelle]:=0;
            Anz_Genomm:=Anz_Genomm+1;
            Genommene[Anz_Genomm]:=Zahl;
            IF Summe<jeder_erbt THEN
            BEGIN
              FOR i:=Stelle+1 TO Anzahl_Goldstuecke DO
                IF Uebrige[i]>0 THEN
                  teste(Uebrige,Genommene,Anz_Genomm,Summe,i);
            END
            ELSE
            BEGIN
              Ergebniss_gefunden:=TRUE;
              Ausgabe;
            END;
          END;
        END;
      END;
    
    BEGIN
      IF ermittle_durchschnittl_Erbe=INT(ermittle_durchschnittl_Erbe) THEN
      BEGIN
        jeder_erbt:=ROUND(ermittle_durchschnittl_Erbe);
        Akt_Erbe:=0;
        REPEAT
          Akt_Erbe:=Akt_Erbe+1;
          Ergebniss_gefunden:=FALSE;
          u:=0;
          FOR i:=1 TO Anzahl_Goldstuecke DO
            u:=u+Goldstuecke[i];
          IF u>=jeder_erbt THEN
          BEGIN
            i:=0; 
            REPEAT
              i:=i+1;
            UNTIL Goldstuecke[i]>0;
            teste(Goldstuecke,HILFSarray,0,0,i);
          END;
        UNTIL (Ergebniss_gefunden=FALSE) OR (Akt_Erbe=Anzahl_Erben);
        IF Ergebniss_gefunden=FALSE THEN
        BEGIN
          WRITELN;WRITE(' Erbe Nr. ',Akt_Erbe,' w�rde nicht das richtige ');
          WRITE('Erbe erhalten. Es erbt das Kloster. ');
        END;
      END
      ELSE
      BEGIN
        WRITELN;WRITELN(' Eine Aufteilung geht nicht. Das Kloster erbt. ');
      END;
    END;
  
  BEGIN
    Eingabe;
    Aufteilung;
  END.

{
 Problemstellung :
 
 Die Baronin von Birlinghoven hat ihren beiden T�chtern eine Truhe voller
 Goldm�nzen hinterlassen. Ihr Testament bestimmt, da� das Gold einem benach-
 barten Kloster zukommt, falls es den T�chtern nicht gelingt, den Ihnalt der
 Truhe wertm��ig genau in zwei H�lften aufzuteilen. Die Goldm�nzen haben nur
 ganzzahlige Werte.
 Eine Truhe Goldm�nzen mit den Werten 1,9,5,3,8 Taler k�nnten die
 T�chter in die H�lften 1,9,3 Taler und 5,8 Taler teilen.
 Eine Truhe Goldm�nzen mit den Werten 1,9,7,3,8 Taler fiele an das Kloster,
 weil die Aufteilung nicht m�glich ist.
 Schreibe ein Programm, das bei Eingabe einer Folge ganzer Zahlen f�r die in
 der Truhe vorkommenden Werte die Erbteile genau aufz�hlt, andernfalls das 
 Erbe dem Kloster zuspricht, falls eine Aufteilung nicht m�glich ist.
 
 Beispiel :
  
  M�nzwerte : 17,3,7,6,8,10,10,5,5,4,10,9,8
  Erbinnen  : 2
  Ergebnis  : Erbin 1 erbt 51 Taler, n�mlich 17,3,7,6,8,10
                    2      51                10,5,4,10,9,8
                    
 Besonderheiten :
 
  Rekursion
  
}
  