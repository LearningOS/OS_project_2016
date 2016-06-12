          .text                         
          .globl main                   

          .data                         
          .align 2                      
_Cow:                                   # virtual table
          .word 0                       # parent
          .word _STRING0                # class name
          .word _Cow.Init               
          .word _Cow.Moo                

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING1                # class name



          .text                         
_Cow_New:                               # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L15:                                   
          li    $t0, 12                 
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          sw    $t1, 8($t0)             
          la    $t1, _Cow               
          sw    $t1, 0($t0)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Main_New:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L16:                                   
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

_Cow.Init:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L17:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          lw    $t1, 8($fp)             
          sw    $t1, 8($t0)             
          lw    $t2, 4($t0)             
          lw    $t2, 12($fp)            
          sw    $t2, 4($t0)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Cow.Moo:                               # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L18:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING2           
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING3           
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

main:                                   # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -28           
_L19:                                   
          jal   _Cow_New                
          nop                           
          move  $t0, $v0                
          move  $t1, $t0                
          li    $t0, 100                
          li    $t2, 122                
          sw    $t1, 4($sp)             
          sw    $t0, 8($sp)             
          sw    $t2, 12($sp)            
          lw    $t0, 0($t1)             
          lw    $t2, 8($t0)             
          sw    $t1, -8($fp)            
          jalr  $t2                     
          nop                           
          lw    $t1, -8($fp)            
          sw    $t1, 4($sp)             
          lw    $t0, 0($t1)             
          lw    $t1, 12($t0)            
          jalr  $t1                     
          nop                           
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           




          .data                         
_STRING2:
          .asciiz " "                   
_STRING0:
          .asciiz "Cow"                 
_STRING3:
          .asciiz "\n"                  
_STRING1:
          .asciiz "Main"                
