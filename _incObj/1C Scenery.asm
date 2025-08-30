; ---------------------------------------------------------------------------
; Object 1C - scenery (GHZ bridge stump, SLZ lava thrower)
; ---------------------------------------------------------------------------

Scenery:
		tst.b	obRoutine(a0)
		bne.s	Scen_ChkDel

Scen_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		lea		Scen_Cannon,a1
		tst.b	obSubtype(a0)
		beq.s	.notbridge
		lea		Scen_Bridge,a1

.notbridge:
		move.l	(a1)+,obMap(a0)
		move.w	(a1)+,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	(a1)+,obFrame(a0)
		move.b	(a1)+,obActWid(a0)
		move.b	(a1)+,obPriority(a0)
		move.b	(a1)+,obColType(a0)		; Find a way to remove this cleanly

Scen_ChkDel:	; Routine 2
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
; ---------------------------------------------------------------------------
; Variables for object $1C are stored in an array
; ---------------------------------------------------------------------------
Scen_Cannon:
		dc.l Map_Scen                                     		; mappings address
		dc.w make_art_tile(ArtTile_SLZ_Fireball_Launcher,2,0)	; VRAM setting
		dc.b 0,	8, 2, 0                                  		; frame, width, priority, collision response

Scen_Bridge:
		dc.l Map_Bri
		dc.w make_art_tile(ArtTile_GHZ_Bridge,2,0)
		dc.b 1,	$10, 1,	0

		even
