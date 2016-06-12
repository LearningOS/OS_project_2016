          .text                         
          .globl main                   

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING0                # class name



          .text                         
_Main_New:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L17:                                   
          li    $t0, 4                  
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          la    $t1, _Main              
          sw    $t1, 0($t0)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

main:                                   # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -44           
_L18:                                   
          li    $t0, 2                  
          li    $t1, 0                  
          slt   $t2, $t0, $t1           
          sw    $t0, -8($fp)            
          beqz  $t2, _L20               
          nop                           
_L19:                                   
          la    $t0, _STRING1           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L20:                                   
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t0, $t1                
          mflo  $t2                     
          addu  $t3, $t0, $t2           
          sw    $t3, 4($sp)             
          sw    $t1, -8($fp)            
          sw    $t0, -12($fp)           
          sw    $t3, -16($fp)           
          jal   _Alloc                  
          nop                           
          move  $t2, $v0                
          lw    $t1, -8($fp)            
          lw    $t0, -12($fp)           
          lw    $t3, -16($fp)           
          sw    $t1, 0($t2)             
          li    $t1, 0                  
          addu  $t2, $t2, $t3           
          sw    $t0, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t2, -20($fp)           
          sw    $t1, -24($fp)           
_L21:                                   
          lw    $t0, -16($fp)           
          lw    $t1, -12($fp)           
          subu  $t0, $t0, $t1           
          sw    $t1, -12($fp)           
          sw    $t0, -16($fp)           
          beqz  $t0, _L23               
          nop                           
_L22:                                   
          lw    $t0, -20($fp)           
          lw    $t1, -12($fp)           
          subu  $t0, $t0, $t1           
          lw    $t2, -24($fp)           
          sw    $t2, 0($t0)             
          sw    $t1, -12($fp)           
          sw    $t0, -20($fp)           
          sw    $t2, -24($fp)           
          b     _L21                    
          nop                           
_L23:                                   
          lw    $t0, -20($fp)           
          move  $t1, $t0                
          li    $t0, 2                  
          lw    $t2, -4($t1)            
          slt   $t3, $t0, $t2           
          sw    $t1, -28($fp)           
          sw    $t0, -32($fp)           
          beqz  $t3, _L25               
          nop                           
_L24:                                   
          li    $t0, 0                  
          lw    $t1, -32($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -32($fp)           
          beqz  $t2, _L26               
          nop                           
_L25:                                   
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L26:                                   
          li    $t0, 4                  
          lw    $t1, -32($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -28($fp)           
          addu  $t3, $t0, $t2           
          lw    $t2, 0($t3)             
          li    $t2, 0                  
          li    $t3, 4                  
          mult  $t1, $t3                
          mflo  $t4                     
          addu  $t1, $t0, $t4           
          sw    $t2, 0($t1)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           




          .data                         
_STRING1:
          .asciiz "Decaf runtime error: Cannot create negative-sized array\n"
_STRING0:
          .asciiz "Main"                
_STRING2:
          .asciiz "Decaf runtime error: Array subscript out of bounds\n"
