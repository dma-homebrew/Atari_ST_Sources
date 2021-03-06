DEFINITION MODULE SFP004;

(*
 * Spezialfunktionen f�r die FPU im ST / STE.
 *
 * Normalerweise sind eher die Routinen des Moduls 'FPUSupport' zu verwenden!
 *)

PROCEDURE FPUInit;
  (*
   * Initialisiert die externe FPU. Zeigt einen Fehler an und terminiert
   * das Programm, wenn keine externe FPU vorhanden ist.
   *
   * Wird im Modulk�rper von 'Runtime' aufgerufen, braucht deshalb in
   * der Regel nicht nochmal extra von der Anwendung aufgerufen werden.
   *)

PROCEDURE FPUReset;
  (*
   * Reinitialisiert die externe FPU.
   *
   * Wird z.B. intern aufgerufen, wenn die FPU einen Fehler gemeldet hat.
   * Kann auch z.B. verwendet werden, um nach �nderung der FPU-Konfiguration
   * den normalen Status wiederherzustellen.
   *)

PROCEDURE FPUError;
  (*
   * Nach dem Low-Byte im FPSR wird ein passender Laufzeitfehler ausgel�st.
   * Zudem wird der FPU-Status zur�ckgesetzt.
   * Vor dem Aufruf sollte eine LINK-Instruktion ausgef�hrt werden, denn
   * diese Routine signalisiert 'callerCaused' (siehe ErrBase).
   *)

END SFP004.
