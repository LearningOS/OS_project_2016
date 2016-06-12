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
_L13:                                   
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
          addiu $sp, $sp, -24           
_L14:                                   
          la    $t0, _STRING1           
          move  $t1, $t0                
          li    $t0, 4                  
          li    $t2, 5                  
          sw    $t0, 4($sp)             
          sw    $t2, 8($sp)             
          sw    $t1, -8($fp)            
          jal   _Main.test              
          nop                           
          move  $t0, $v0                
          lw    $t1, -8($fp)            
          move  $t2, $t0                
          sw    $t2, 4($sp)             
          sw    $t1, -8($fp)            
          jal   _PrintInt               
          nop                           
          lw    $t1, -8($fp)            
          sw    $t1, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Main.test:                             # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L15:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          addu  $t2, $t0, $t1           
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          move  $v0, $t2                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           




          .data                         
_STRING1:
          .asciiz "hello"               
_STRING0:
          .asciiz "Main"                
