; ---------------------------------------------------------------------------
; Object 2E - contents of monitors
; ---------------------------------------------------------------------------

PowerUp:
		move.b	obRoutine(a0),d0
		subq.b	#2,d0
		beq.s	Pow_Move
		bpl.w	Pow_Delete

Pow_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#make_art_tile(ArtTile_Monitor,0,0),obGfx(a0)
		move.b	#$24,obRender(a0)
		move.b	#3,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.w	#-$300,obVelY(a0)
		moveq	#0,d0
		move.b	obAnim(a0),d0	; get subtype
		addq.b	#2,d0
		move.b	d0,obFrame(a0)	; use correct frame
		movea.l	#Map_Monitor,a1
		add.b	d0,d0
		adda.w	(a1,d0.w),a1
		addq.w	#1,a1
		move.l	a1,obMap(a0)

Pow_Move:	; Routine 2
		tst.w	obVelY(a0)	; is object moving?
		bpl.w	Pow_Checks	; if not, branch
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)	; reduce object speed
		bra.w	DisplaySprite
; ===========================================================================

Pow_Checks:
		addq.b	#2,obRoutine(a0)
		move.w	#29,obTimeFrame(a0) ; display icon for half a second

		move.b	obAnim(a0),d0
		add.w	d0,d0
		move.w	Pow_Types(pc,d0.w),d0
		jsr		Pow_Types(pc,d0.w)
		bra.w	DisplaySprite
; ===========================================================================
Pow_Types:
		dc.w Pow_Null-Pow_Types
		dc.w Pow_Eggman-Pow_Types
		dc.w Pow_Sonic-Pow_Types
		dc.w Pow_Shoes-Pow_Types
		dc.w Pow_Shield-Pow_Types
		dc.w Pow_Invinc-Pow_Types
		dc.w Pow_Rings-Pow_Types
		dc.w Pow_S-Pow_Types
		dc.w Pow_Goggles-Pow_Types
; ===========================================================================

Pow_Sonic:
ExtraLife:
		addq.b	#1,(v_lives).w	; add 1 to the number of lives you have
		addq.b	#1,(f_lifecount).w ; update the lives counter
		move.w	#bgm_ExtraLife,d0
		jmp	(QueueSound1).l	; play extra life music
; ===========================================================================

Pow_Shoes:
		move.b	#1,(v_shoes).w	; speed up the BG music
		move.w	#$4B0,(v_player+$34).w	; time limit for the power-up
		move.w	#$C00,(v_sonspeedmax).w ; change Sonic's top speed
		move.w	#$18,(v_sonspeedacc).w	; change Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w	; change Sonic's deceleration
		move.w	#bgm_Speedup,d0
		jmp	(QueueSound1).l		; Speed up the music
; ===========================================================================

Pow_Shield:
		move.b	#1,(v_shield).w	; give Sonic a shield
		move.b	#id_ShieldItem,(v_shieldobj).w ; load shield object ($38)
		move.w	#sfx_Shield,d0
		jmp	(QueueSound1).l	; play shield sound
; ===========================================================================

Pow_Invinc:
		move.b	#1,(v_invinc).w	; make Sonic invincible
		move.w	#$4B0,(v_player+$32).w ; time limit for the power-up
		move.b	#id_ShieldItem,(v_starsobj1).w ; load stars object ($3801)
		move.b	#1,(v_starsobj1+obAnim).w
		move.b	#id_ShieldItem,(v_starsobj2).w ; load stars object ($3802)
		move.b	#2,(v_starsobj2+obAnim).w
		move.b	#id_ShieldItem,(v_starsobj3).w ; load stars object ($3803)
		move.b	#3,(v_starsobj3+obAnim).w
		move.b	#id_ShieldItem,(v_starsobj4).w ; load stars object ($3804)
		move.b	#4,(v_starsobj4+obAnim).w
		tst.b	(f_lockscreen).w ; is boss mode on?
		bne.s	Pow_NoMusic	; if yes, branch
		cmpi.w	#$C,(v_air).w
		bls.s	Pow_NoMusic
		move.w	#bgm_Invincible,d0
		jmp	(QueueSound1).l ; play invincibility music
; ===========================================================================

Pow_Null:
Pow_Eggman:
Pow_S:
Pow_Goggles:
Pow_NoMusic:
		rts		; these monitors do nothing
; ===========================================================================

Pow_Rings:
		addi.w	#10,(v_rings).w	; add 10 rings to the number of rings you have
		ori.b	#1,(f_ringcount).w ; update the ring counter
		cmpi.w	#100,(v_rings).w ; check if you have 100 rings
		blo.s	Pow_RingSound
		bset	#1,(v_lifecount).w
		beq.w	ExtraLife
		cmpi.w	#200,(v_rings).w ; check if you have 200 rings
		blo.s	Pow_RingSound
		bset	#2,(v_lifecount).w
		beq.w	ExtraLife

Pow_RingSound:
		move.w	#sfx_Ring,d0
		jmp	(QueueSound1).l	; play ring sound
; ===========================================================================

Pow_Delete:	; Routine 4
		subq.w	#1,obTimeFrame(a0)
		bmi.w	DeleteObject	; delete after half a second
		bra.w	DisplaySprite	
