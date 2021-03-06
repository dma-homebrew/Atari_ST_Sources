var anzahl,zahl,i : integer;  {  ANZAHL : 26906  Min 0.  Max 26904  }
                        {  ZAHL : 2  Min 200  Max 200  }
                        {  I : 0.  Min ---  Max ---  }
    muenze : array [1..8] of integer;  {  MUENZE : 54924  }
procedure zerlege (zahl : integer;maximum : integer);  { 26905 }
                                  { Max. Rekursion: 100 }
                        {  ZAHL : 54916  Min 0.  Max 200  }
                        {  MAXIMUM : 26905  Min 2  Max 8  }
  var i,m : integer;  {  I : 81821  Min 2  Max 9  }
                        {  M : 0.  Min ---  Max ---  }
  begin
    for i:=2 to maximum do  { 28012 }
      if zahl-muenze[i]>=0 then  { 26904 }
      BEGIN
        anzahl:=anzahl+1;
        zerlege(zahl-muenze[i],i);
      END;
  end;
begin
  muenze[1]:=1;muenze[2]:=2;muenze[3]:=5;muenze[4]:=10;muenze[5]:=50;
  muenze[6]:=100;muenze[7]:=200;muenze[8]:=500;
  write('-> Summe in Pf ');readln(zahl);anzahl:=0; 
  zerlege(zahl,8);
  writeln('<- Es gibt ',anzahl+1,' M�glichkeiten ');
end.
{ Problemstellung :
  
  Wenn Sie gen�gend viele 1pf,2pf,5pf,10pf,50pf,1dm,5dm-St�cke zu Verf�gung
  haben, so k�nnen Sie einen bestimmten Betrag mit mehreren M�glichkeiten
  bezahlen. Z.B. 10 Pf : Es gibt 11 M�glichkeiten : 1*10;2*5;1*5+2*2+1*1;
  1*5+1*2+3*2;1*5+5*1;5*2;4*2+2*1;3*2+4*1;2*2+8*1;1*2+8*1;10*1 (sonst geht
  nix mehr). Die Anzahl M�glichkeiten w�chst �berproportional zum Geldwert.
  Maximal k�nnen 499 Pf berechnet werden (!).
  
  Beispiel :
  
  200 Pf (=2 DM-St�ck !) ergibt 29605 M�lichkeiten.
  
  Hinweise :
  
   Rekursion, Variablenz�hlung. 
}
 
