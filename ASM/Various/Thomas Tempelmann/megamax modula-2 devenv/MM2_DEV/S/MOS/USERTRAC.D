DEFINITION MODULE UserTrace;

  (*
   * Von Thomas Tempelmann, August 1988, f�r Megamax Modula-2
   *
   * Dies ist ein alternatives Debug-Modul.
   * Anstatt alle Zeilen, die mit (*$D+*) �bersetzt wurden, anzuzeigen,
   * kann eine Funktion im eigenen Programm erstellt werden, die regel-
   * m��ig aufgerufen wird und Bedingungen pr�ft, worauf ggf. das feh-
   * lerhafte Programm gestoppt werden kann, um die fehlerverursachende
   * Stelle anzuzeigen.
   * Achtung: Wird dieses Modul importiert, darf nicht 'Debug' importiert
   * werden, da sich beide Module in ihrer Funktion gegenseitig ausschlie�en.
   *)

TYPE    TraceProc = PROCEDURE (): BOOLEAN;

VAR     Stop: TraceProc;
          (* Diese Funktion wird vor jeder mit $D+ �bersetzten Zeile     *)
          (* ausgef�hrt. Liefert diese Funktion TRUE, wird eine Scan-Box *)
          (* angezeigt, von der aus das Programm verlassen werden kann.  *)

END UserTrace.

(* Beispielprogramm:

   Die Aufgabe ist es, herauszufinden, wann eine Variable einen illegalen
   Wert zugewiesen bekommt. Hier sei dies der Fall, wenn der Wert 14 auf n
   zugewiesen wird (im Beispiel ist das nat�rlich nicht wirklich ein
   Fehler, es soll nur daran die Funktion erl�utert werden).

  MODULE Fehler;

  (*$ D+  Debug-Modus einschalten *)

  IMPORT UserTrace;

  VAR n: CARDINAL;  (* diese Variable ist zu �berwachen *)

  PROCEDURE add (i: CARDINAL);
    BEGIN
      n:= n + i;
      IF i > 0 THEN add (i-1) END
    END add;

  PROCEDURE stop (): BOOLEAN;
    BEGIN
      RETURN (n = 14)   (* stoppe, wenn der gesuchte Wert in 'n' steht *)
    END stop;

  BEGIN
    UserTrace.Stop:= stop;
    n:= 1;
    add (3);  (* 3, 2, 1 auf n addieren *)
    add (4);  (* 4, 3, 2, 1 auf n addieren *)
  END Fehler.
*)
 