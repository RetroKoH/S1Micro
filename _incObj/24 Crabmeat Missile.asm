; ---------------------------------------------------------------------------
; Object 24 - missile that Crabmeat throws
; ---------------------------------------------------------------------------

CrabMissile:
		tst.b	obRoutine(a0)
		bne.w	Crab_BallMove

Crab_BallMain:	; Routine 6
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Crab,obMap(a0)
		move.w	#make_art_tile(ArtTile_Crabmeat,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#8,obActWid(a0)
		move.w	#-$400,obVelY(a0)
		move.b	#7,obAnim(a0)

Crab_BallMove:	; Routine 8
		lea	(Ani_Crab).l,a1
		bsr.w	AnimateSprite
		bsr.w	ObjectFall
		move.w	(v_limitbtm2).w,d0
		addi.w	#$E0,d0
		cmp.w	obY(a0),d0	; has object moved below the level boundary?
		blo.s	Crab_Delete
		bra.w	DisplaySprite