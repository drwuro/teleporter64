

!macro INIT_MUSIC {
    jsr MUS_BASE + 9
}
    
    
!macro PLAY_MUSIC {
    jsr MUS_BASE + 3
}
    

!macro PLAY_SFX {
    lda #<sfx_teleport
    ldy #>sfx_teleport
    ldx #$0E
    jsr MUS_BASE + 6
}



