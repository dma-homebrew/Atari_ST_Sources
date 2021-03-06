								.DATA
								
SC_INIT:        DC.L $00,$01000000,$02000000,$03000000
                DC.L $04000000,$05000000,$06000000,$0700FF00
                DC.L $08000000,$09000000,$0A000000,$0B000000
                DC.L $0C000000,$0D000000

; *******************************
; * Sound data (STE-Sounddaten) *
; *******************************
SND_DATA:
                DC.W $0800,$0E00,$0900,$0900,$0A00,$0300,0,0
                DC.W $0800,$0E00,$0900,$0900,$0A00,$0600,0,0
                DC.W $0800,$0E00,$0900,$0900,$0A00,$0700,0,0
                DC.W $0800,$0E00,$0900,$0900,$0A00,$0800,0,0
                DC.W $0800,$0E00,$0900,$0900,$0A00,$0800,0,0
                DC.W $0800,$0E00,$0900,$0A00,$0A00,$0200,0,0
                DC.W $0800,$0E00,$0900,$0A00,$0A00,$0600,0,0
                DC.W $0800,$0E00,$0900,$0A00,$0A00,$0700,0,0
                DC.W $0800,$0E00,$0900,$0A00,$0A00,$0800,0,0
                DC.W $0800,$0E00,$0900,$0A00,$0A00,$0900,0,0
                DC.W $0800,$0E00,$0900,$0A00,$0A00,$0900,0,0
                DC.W $0800,$0E00,$0900,$0A00,$0A00,$0900,0,0
                DC.W $0800,$0E00,$0900,$0B00,$0A00,$0300,0,0
                DC.W $0800,$0E00,$0900,$0B00,$0A00,$0700,0,0
                DC.W $0800,$0E00,$0900,$0B00,$0A00,$0800,0,0
                DC.W $0800,$0E00,$0900,$0B00,$0A00,$0900,0,0
                DC.W $0800,$0E00,$0900,$0B00,$0A00,$0900,0,0
                DC.W $0800,$0E00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,0,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,0,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,0,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0700,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0700,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0800,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0800,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0900,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0B00,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0B00,0,0
                DC.W $0800,$0E00,$0900,$0C00,$0A00,$0B00,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,0,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,0,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,0,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0700,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0700,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0700,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0900,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0900,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0900,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0A00,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0B00,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0B00,0,0
                DC.W $0800,$0E00,$0900,$0D00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,0,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,0,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,0,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0700,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0700,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0900,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0900,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0900,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0A00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0A00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0A00,$0A00,$0900,0,0
                DC.W $0800,$0F00,$0900,$0B00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0B00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0B00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0F00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0900,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0900,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0A00,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0A00,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0A00,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0C00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0B00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0D00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,0,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0C00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0D00,0,0
                DC.W $0800,$0F00,$0900,$0E00,$0A00,$0D00,0,0

                DC.W $0800,0,$0900,0,$0A00,0,0,0
                DC.W $0800,$0200,$0900,0,$0A00,0,0,0
                DC.W $0800,$0200,$0900,$0100,$0A00,0,0,0
                DC.W $0800,$0300,$0900,$0100,$0A00,0,0,0
                DC.W $0800,$0400,$0900,$0100,$0A00,0,0,0
                DC.W $0800,$0500,$0900,$0100,$0A00,0,0,0
                DC.W $0800,$0600,$0900,0,$0A00,0,0,0
                DC.W $0800,$0600,$0900,$0100,$0A00,0,0,0
                DC.W $0800,$0600,$0900,$0300,$0A00,0,0,0
                DC.W $0800,$0700,$0900,$0100,$0A00,0,0,0
                DC.W $0800,$0700,$0900,$0200,$0A00,0,0,0
                DC.W $0800,$0700,$0900,$0300,$0A00,$0100,0,0
                DC.W $0800,$0700,$0900,$0400,$0A00,$0100,0,0
                DC.W $0800,$0800,$0900,$0100,$0A00,0,0,0
                DC.W $0800,$0800,$0900,$0200,$0A00,0,0,0
                DC.W $0800,$0800,$0900,$0300,$0A00,$0100,0,0
                DC.W $0800,$0800,$0900,$0400,$0A00,$0100,0,0
                DC.W $0800,$0900,$0900,0,$0A00,0,0,0
                DC.W $0800,$0900,$0900,$0100,$0A00,0,0,0
                DC.W $0800,$0900,$0900,$0300,$0A00,0,0,0
                DC.W $0800,$0900,$0900,$0400,$0A00,0,0,0
                DC.W $0800,$0900,$0900,$0500,$0A00,0,0,0
                DC.W $0800,$0900,$0900,$0500,$0A00,$0100,0,0
                DC.W $0800,$0900,$0900,$0500,$0A00,$0300,0,0
                DC.W $0800,$0900,$0900,$0600,$0A00,$0200,0,0
                DC.W $0800,$0900,$0900,$0600,$0A00,$0300,0,0
                DC.W $0800,$0A00,$0900,$0100,$0A00,0,0,0
                DC.W $0800,$0A00,$0900,$0300,$0A00,0,0,0
                DC.W $0800,$0A00,$0900,$0300,$0A00,$0100,0,0
                DC.W $0800,$0A00,$0900,$0500,$0A00,0,0,0
                DC.W $0800,$0A00,$0900,$0500,$0A00,$0200,0,0
                DC.W $0800,$0A00,$0900,$0500,$0A00,$0300,0,0
                DC.W $0800,$0A00,$0900,$0600,$0A00,$0200,0,0
                DC.W $0800,$0A00,$0900,$0700,$0A00,0,0,0
                DC.W $0800,$0A00,$0900,$0700,$0A00,$0200,0,0
                DC.W $0800,$0B00,$0900,$0100,$0A00,0,0,0
                DC.W $0800,$0B00,$0900,$0300,$0A00,0,0,0
                DC.W $0800,$0B00,$0900,$0300,$0A00,$0100,0,0
                DC.W $0800,$0B00,$0900,$0400,$0A00,$0100,0,0
                DC.W $0800,$0B00,$0900,$0500,$0A00,$0100,0,0
                DC.W $0800,$0B00,$0900,$0500,$0A00,$0300,0,0
                DC.W $0800,$0B00,$0900,$0600,$0A00,$0200,0,0
                DC.W $0800,$0B00,$0900,$0600,$0A00,$0300,0,0
                DC.W $0800,$0B00,$0900,$0700,$0A00,$0200,0,0
                DC.W $0800,$0B00,$0900,$0700,$0A00,$0400,0,0
                DC.W $0800,$0B00,$0900,$0800,$0A00,0,0,0
                DC.W $0800,$0B00,$0900,$0800,$0A00,$0100,0,0
                DC.W $0800,$0B00,$0900,$0800,$0A00,$0300,0,0
                DC.W $0800,$0B00,$0900,$0800,$0A00,$0400,0,0
                DC.W $0800,$0B00,$0900,$0800,$0A00,$0500,0,0
                DC.W $0800,$0B00,$0900,$0900,$0A00,$0100,0,0
                DC.W $0800,$0B00,$0900,$0900,$0A00,$0300,0,0
                DC.W $0800,$0B00,$0900,$0900,$0A00,$0400,0,0
                DC.W $0800,$0C00,$0900,$0200,$0A00,0,0,0
                DC.W $0800,$0C00,$0900,$0200,$0A00,$0100,0,0
                DC.W $0800,$0C00,$0900,$0400,$0A00,$0100,0,0
                DC.W $0800,$0C00,$0900,$0500,$0A00,$0100,0,0
                DC.W $0800,$0C00,$0900,$0500,$0A00,$0300,0,0
                DC.W $0800,$0C00,$0900,$0600,$0A00,$0200,0,0
                DC.W $0800,$0C00,$0900,$0700,$0A00,0,0,0
                DC.W $0800,$0C00,$0900,$0700,$0A00,$0200,0,0
                DC.W $0800,$0C00,$0900,$0700,$0A00,$0400,0,0
                DC.W $0800,$0C00,$0900,$0700,$0A00,$0500,0,0
                DC.W $0800,$0C00,$0900,$0800,$0A00,$0200,0,0
                DC.W $0800,$0C00,$0900,$0800,$0A00,$0400,0,0
                DC.W $0800,$0C00,$0900,$0800,$0A00,$0500,0,0
                DC.W $0800,$0C00,$0900,$0900,$0A00,0,0,0
                DC.W $0800,$0C00,$0900,$0900,$0A00,$0200,0,0
                DC.W $0800,$0C00,$0900,$0900,$0A00,$0400,0,0
                DC.W $0800,$0C00,$0900,$0900,$0A00,$0500,0,0
                DC.W $0800,$0C00,$0900,$0900,$0A00,$0600,0,0
                DC.W $0800,$0C00,$0900,$0900,$0A00,$0700,0,0
                DC.W $0800,$0C00,$0900,$0900,$0A00,$0700,0,0
                DC.W $0800,$0C00,$0900,$0A00,$0A00,0,0,0
                DC.W $0800,$0C00,$0900,$0A00,$0A00,$0300,0,0
                DC.W $0800,$0D00,$0900,$0200,$0A00,0,0,0
                DC.W $0800,$0D00,$0900,$0300,$0A00,$0100,0,0
                DC.W $0800,$0D00,$0900,$0500,$0A00,0,0,0
                DC.W $0800,$0D00,$0900,$0500,$0A00,$0200,0,0
                DC.W $0800,$0D00,$0900,$0600,$0A00,$0100,0,0
                DC.W $0800,$0D00,$0900,$0700,$0A00,0,0,0
                DC.W $0800,$0D00,$0900,$0700,$0A00,$0200,0,0
                DC.W $0800,$0D00,$0900,$0700,$0A00,$0400,0,0
                DC.W $0800,$0D00,$0900,$0700,$0A00,$0500,0,0
                DC.W $0800,$0D00,$0900,$0800,$0A00,$0200,0,0
                DC.W $0800,$0D00,$0900,$0800,$0A00,$0400,0,0
                DC.W $0800,$0D00,$0900,$0900,$0A00,0,0,0
                DC.W $0800,$0D00,$0900,$0900,$0A00,$0100,0,0
                DC.W $0800,$0D00,$0900,$0900,$0A00,$0400,0,0
                DC.W $0800,$0D00,$0900,$0900,$0A00,$0500,0,0
                DC.W $0800,$0D00,$0900,$0900,$0A00,$0600,0,0
                DC.W $0800,$0D00,$0900,$0900,$0A00,$0700,0,0
                DC.W $0800,$0D00,$0900,$0A00,$0A00,0,0,0
                DC.W $0800,$0D00,$0900,$0A00,$0A00,0,0,0
                DC.W $0800,$0D00,$0900,$0A00,$0A00,$0300,0,0
                DC.W $0800,$0D00,$0900,$0A00,$0A00,$0500,0,0
                DC.W $0800,$0D00,$0900,$0A00,$0A00,$0600,0,0
                DC.W $0800,$0D00,$0900,$0A00,$0A00,$0700,0,0
                DC.W $0800,$0D00,$0900,$0A00,$0A00,$0800,0,0
                DC.W $0800,$0D00,$0900,$0A00,$0A00,$0800,0,0
                DC.W $0800,$0D00,$0900,$0A00,$0A00,$0800,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0100,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0400,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0600,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0700,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0700,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0800,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0800,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0900,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0900,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0900,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0D00,$0900,$0B00,$0A00,$0A00,0,0
                DC.W $0800,$0D00,$0900,$0C00,$0A00,$0200,0,0
                DC.W $0800,$0D00,$0900,$0C00,$0A00,$0500,0,0
                DC.W $0800,$0D00,$0900,$0C00,$0A00,$0600,0,0
                DC.W $0800,$0E00,$0900,0,$0A00,0,0,0
                DC.W $0800,$0E00,$0900,$0300,$0A00,$0100,0,0
                DC.W $0800,$0E00,$0900,$0500,$0A00,$0200,0,0
                DC.W $0800,$0E00,$0900,$0600,$0A00,$0200,0,0
                DC.W $0800,$0E00,$0900,$0700,$0A00,$0200,0,0
                DC.W $0800,$0E00,$0900,$0700,$0A00,$0500,0,0
                DC.W $0800,$0E00,$0900,$0800,$0A00,$0100,0,0
                DC.W $0800,$0E00,$0900,$0800,$0A00,$0500,0,0
                DC.W $0800,$0E00,$0900,$0900,$0A00,0,0,0
