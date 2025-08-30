; ---------------------------------------------------------------------------
; Object 54 - invisible lava tag (MZ)
; ---------------------------------------------------------------------------


LTag_ColTypes:	dc.b $96, $94, $95
		even


LavaTag:
		tst.b	obRoutine(a0)
		bne.s	LTag_ChkDel

LTag_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		move.b	LTag_ColTypes(pc,d0.w),obColType(a0)
		move.l	#Map_LTag,obMap(a0)
		move.b	#$84,obRender(a0)

LTag_ChkDel:	; Routine 2
		move.w	obX(a0),d0
		andi.w	#$FF80,d0
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		bmi.w	DeleteObject
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts	
