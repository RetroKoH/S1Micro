; ---------------------------------------------------------------------------
; Object 27 - explosion from a destroyed enemy or monitor
; ---------------------------------------------------------------------------

ExplosionItem:
		move.b	obRoutine(a0),d0
		subq.b	#2,d0
		beq.s	ExItem_Main
		bpl.w	ExItem_Animate

ExItem_Animal:	; Routine 0
		addq.b	#2,obRoutine(a0)
		bsr.w	FindFreeObj
		bne.s	ExItem_Main
		_move.b	#id_Animals,obID(a1) ; load animal object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	objoff_3E(a0),objoff_3E(a1)

ExItem_Main:	; Routine 2
		move.l	#Map_ExplodeItem,obMap(a0)
		bsr.s	Explosion
		move.w	#sfx_BreakItem,d0
		jsr	(QueueSound2).l	; play breaking enemy sound

ExItem_Animate:	; Routine 4 (2 for ExplosionBomb)
		subq.b	#1,obTimeFrame(a0) ; subtract 1 from frame duration
		bpl.s	.display
		move.b	#7,obTimeFrame(a0) ; set frame duration to 7 frames
		addq.b	#1,obFrame(a0)	; next frame
		cmpi.b	#5,obFrame(a0)	; is the final frame (05) displayed?
		beq.w	DeleteObject	; if yes, branch

.display:
		bra.w	DisplaySprite
; ===========================================================================

Explosion:
		addq.b	#2,obRoutine(a0)
		move.w	#make_art_tile(ArtTile_Explosion,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		clr.b	obColType(a0)
		move.b	#$C,obActWid(a0)
		move.b	#7,obTimeFrame(a0) ; set frame duration to 7 frames
		clr.b	obFrame(a0)
		rts


; ---------------------------------------------------------------------------
; Object 3F - explosion from a destroyed boss, bomb or cannonball
; ---------------------------------------------------------------------------

ExplosionBomb:
		tst.b	obRoutine(a0)
		bne.s	ExItem_Animate

ExBom_Main:	; Routine 0
		move.l	#Map_ExplodeBomb,obMap(a0)
		bsr.s	Explosion
		move.w	#sfx_Bomb,d0
		jmp	(QueueSound2).l	; play exploding bomb sound