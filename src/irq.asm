
;-------------------------------
!zone

;-- setup irq handling at irqLine
;--
irq_setup
    sei                 ; turn off interrupts
    
    lda #$7F
    ldx #$01
    sta $DC0D           ; turn off CIA 1 interrupts
    sta $DD0D           ; turn off CIA 2 interrupts
    stx $D01A           ; turn on raster interrupts
    
    lda #$1B
    sta $D011           ; clear high bit of $D011, set text mode
    
    lda #<irq_handler   ; low part of move address (irq handler)
    ldx #>irq_handler   ; high part of move address (irq handler)
    ldy irqLine         ; raster line number
    
    sta $0314           ; store irq handler
    stx $0315           
    sty $D012           ; store raster line
    
    lda $DC0D           ; ACK CIA 1 interrupts
    lda $DD0D           ; ACK CIA 2 interrupts
    asl $D019           ; ACK VIC interrupts
    
    cli                 ; turn on interrupts
    
    rts
   
    
;-- turn off C64 basic interpreter
;--
turn_off_basic
    sei
    lda #$36
    sta $01
    cli
    
    rts
    

;-- the irq handler itself
;--
irq_handler
    +DEBUG_BORDER WHT

    ;-- first thing we do is play the music routine
    +PLAY_MUSIC
    
    ;-- set irq trigger flag, so the main loop (main.asm) knows that it's
    ;-- allowed to do stuff now
    lda #1
    sta irqTrigger
    
    ;-- clean up irq
    lda #$01
    sta $D019   ; ACK interrupt to reenable it

    +DEBUG_BORDER BLK
    
    ;-- clean up from stack, same as calling $EA81
    pla
    tay
    pla
    tax
    pla
    
    ;-- return from interrupt
    rti

