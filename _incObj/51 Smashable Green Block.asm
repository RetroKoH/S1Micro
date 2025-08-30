; ---------------------------------------------------------------------------
; Object 51 - smashable green block (MZ)
; ---------------------------------------------------------------------------

sonicAniFrame = objoff_32		; Sonic's current animation number
hitcount = objoff_34		; number of blocks hit + previous stuff

SmashBlock:
		move.b	obRoutine(a0),d0
		subq.b	#2,d0
		beq.s	Smab_Solid
		bpl.w	Smab_Points

Smab_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Smab,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Block,2,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#4,obPriority(a0)
		move.b	obSubtype(a0),obFrame(a0)

Smab_Solid:	; Routine 2
		move.w	(v_itembonus).w,objoff_34(a0)
		move.b	(v_player+obAnim).w,sonicAniFrame(a0) ; load Sonic's animation number
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject
		btst	#3,obStatus(a0)	; has Sonic landed on the block?
		bne.w	RememberState	; if not, branch
		cmpi.b	#id_Roll,sonicAniFrame(a0) ; is Sonic rolling/jumping?
		bne.w	RememberState	; if not, branch

		move.w	hitcount(a0),(v_itembonus).w
		bset	#2,obStatus(a1)
		move.w	#$E07,obHeight(a1)	; Height and Width
		move.b	#id_Roll,obAnim(a1) ; make Sonic roll
		move.w	#-$300,obVelY(a1) ; rebound Sonic
		bset	#1,obStatus(a1)
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a1)
		bclr	#3,obStatus(a0)
		clr.b	obSolid(a0)
		move.b	#1,obFrame(a0)
		lea	(Smab_Speeds).l,a4 ; load broken fragment speed data
		moveq	#3,d1		; set number of fragments to 4
		move.w	#$38,d2
		bsr.w	SmashObject
		bsr.w	FindFreeObj
		bne.s	Smab_Points
		_move.b	#id_Points,obID(a1) ; load points object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	(v_itembonus).w,d2
		addq.w	#2,(v_itembonus).w ; increment bonus counter
		cmpi.w	#6,d2		; have fewer than 3 blocks broken?
		blo.s	.bonus		; if yes, branch
		moveq	#6,d2		; set cap for points

.bonus:
		moveq	#0,d0
		move.w	Smab_Scores(pc,d2.w),d0
		cmpi.w	#$20,(v_itembonus).w ; have 16 blocks been smashed?
		blo.s	.givepoints	; if not, branch
		move.w	#1000,d0	; give higher points for 16th block
		moveq	#10,d2

.givepoints:
		jsr	(AddPoints).l
		lsr.w	#1,d2
		move.b	d2,obFrame(a1)

Smab_Points:	; Routine 4
		bsr.w	SpeedToPos
		addi.w	#$38,obVelY(a0)
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
Smab_Speeds:
		dc.w -$200, -$200	; x-speed, y-speed
		dc.w -$100, -$100
		dc.w $200, -$200
		dc.w $100, -$100

Smab_Scores:	dc.w 10, 20, 50, 100
