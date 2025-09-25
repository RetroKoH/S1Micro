; ---------------------------------------------------------------------------
; Object 40 - Moto Bug enemy (GHZ)
; ---------------------------------------------------------------------------

MotoBug:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		jmp		Moto_Index(pc,d0.w)
; ===========================================================================
Moto_Index:
		bra.s	Moto_Main
		bra.s	Moto_Action
		bra.s	Moto_Animate
		bra.w	DeleteObject
; ===========================================================================

Moto_Main:	; Routine 0
		move.l	#Map_Moto,obMap(a0)
		move.w	#make_art_tile(ArtTile_Moto_Bug,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#$14,obActWid(a0)
		tst.b	obAnim(a0)	; is object a smoke trail?
		bne.s	.smoke		; if yes, branch
		move.w	#$0E08,obHeight(a0)	; Height and Width
		move.b	#$C,obColType(a0)
		bsr.w	ObjectFall
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	.notonfloor
		add.w	d1,obY(a0)	; match object's position with the floor
		clr.w	obVelY(a0)
		addq.b	#2,obRoutine(a0) ; goto Moto_Action next
		bchg	#0,obStatus(a0)

.notonfloor:
		rts	
; ===========================================================================

.smoke:
		addq.b	#4,obRoutine(a0) ; goto Moto_Animate next

Moto_Animate:	; Routine 4
		lea		Ani_Moto(pc),a1
		jsr		(AnimateSprite).l
		bra.w	DisplaySprite
; ===========================================================================

moto_time = objoff_30
moto_delay = objoff_33

Moto_Action:	; Routine 2
		tst.b	ob2ndRout(a0)
		bne.s	Moto_FindFloor

Moto_Move:
		subq.w	#1,moto_time(a0)	; subtract 1 from pause time
		bpl.s	Moto_Animate		; if time remains, branch
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$100,obVelX(a0) ; move object to the left
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)
		bne.s	Moto_Animate
		neg.w	obVelX(a0)	; change direction
		bsr.s	Moto_Animate
; ===========================================================================

Moto_FindFloor:
		bsr.w	SpeedToPos
		jsr	(ObjFloorDist).l
		cmpi.w	#-8,d1
		blt.s	.pause
		cmpi.w	#$C,d1
		bge.s	.pause
		add.w	d1,obY(a0)	; match object's position with the floor
		subq.b	#1,moto_delay(a0)
		bpl.s	Moto_Animate
		move.b	#$F,moto_delay(a0)
		bsr.w	FindFreeObj
		bne.s	Moto_Animate
		_move.b	#id_MotoBug,obID(a1) ; load exhaust smoke object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.b	#2,obAnim(a1)
		bra.w	Moto_Animate

.pause:
		subq.b	#2,ob2ndRout(a0)
		move.w	#59,moto_time(a0)	; set pause time to 1 second
		clr.w	obVelX(a0)			; stop the object moving
		clr.b	obAnim(a0)
		bra.w	Moto_Animate

		include	"_incObj/sub RememberState.asm" ; Moto_Action terminates in this file
