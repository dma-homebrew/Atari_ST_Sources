 ; Ausgabe eines 8*16 Zeichens    a0=Fontadr, a1=Screenpos

QUICK_aus: move.b     (a0),   (a1)
           move.b $100(a0), 80(a1)
           move.b $200(a0),160(a1)
           move.b $300(a0),240(a1)
           move.b $400(a0),320(a1)
           move.b $500(a0),400(a1)
           move.b $600(a0),480(a1)
           move.b $700(a0),560(a1)
           move.b $800(a0),640(a1)
           move.b $900(a0),720(a1)
           move.b $A00(a0),800(a1)
           move.b $B00(a0),880(a1)
           move.b $C00(a0),960(a1)
           move.b $D00(a0),1040(a1)
           move.b $E00(a0),1120(a1)
           move.b $F00(a0),1200(a1)
           rts

 end
 