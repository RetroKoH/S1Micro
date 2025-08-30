; ---------------------------------------------------------------------------
; Object 12 - lamp (SYZ)
; ---------------------------------------------------------------------------

SpinningLight:
		tst.b	obRoutine(a0)
		bne.s	Light_Animate

Light_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Light,obMap(a0)
		move.w	#make_art_tile(ArtTile_Level,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.b	#6,obPriority(a0)

Light_Animate:	; Routine 2
		move.b	(v_ani2_frame).w,d0
		move.b	d0,obFrame(a0)	; change current frame

.chkdel:
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
