          .text                         
          .globl main                   

          .data                         
          .align 2                      
_Hanoi:                                 # virtual table
          .word 0                       # parent
          .word _STRING0                # class name
          .word _Hanoi.init             
          .word _Hanoi.move             

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING1                # class name



          .text                         
_Hanoi_New:                             # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L16:                                   
          li    $t0, 8                  
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          la    $t1, _Hanoi             
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

_Hanoi.init:                            # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L18:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          sw    $t0, 4($fp)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Hanoi.move:                            # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -36           
_L19:                                   
          li    $t0, 0                  
          lw    $t1, 8($fp)             
          subu  $t2, $t1, $t0           
          sltu  $t2, $zero, $t2         
          xori  $t2, $t2, 1             
          sw    $t1, 8($fp)             
          beqz  $t2, _L21               
          nop                           
_L20:                                   
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L21:                                   
          li    $t0, 1                  
          lw    $t1, 8($fp)             
          subu  $t2, $t1, $t0           
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          sw    $t2, 8($sp)             
          lw    $t2, 12($fp)            
          sw    $t2, 12($sp)            
          lw    $t3, 20($fp)            
          sw    $t3, 16($sp)            
          lw    $t4, 16($fp)            
          sw    $t4, 20($sp)            
          lw    $t5, 0($t0)             
          lw    $t6, 12($t5)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          jalr  $t6                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          lw    $t5, 4($t0)             
          move  $t6, $t5                
          la    $t5, _STRING2           
          sw    $t5, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          sw    $t6, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          lw    $t6, -8($fp)            
          sw    $t6, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          sw    $t6, -8($fp)            
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          lw    $t6, -8($fp)            
          la    $t5, _STRING3           
          sw    $t5, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          sw    $t6, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          lw    $t6, -8($fp)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          sw    $t6, -8($fp)            
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          lw    $t6, -8($fp)            
          la    $t5, _STRING4           
          sw    $t5, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          sw    $t6, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          lw    $t6, -8($fp)            
          sw    $t2, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          sw    $t6, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          lw    $t6, -8($fp)            
          la    $t5, _STRING5           
          sw    $t5, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          sw    $t6, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          lw    $t6, -8($fp)            
          sw    $t4, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          sw    $t6, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          lw    $t6, -8($fp)            
          la    $t5, _STRING6           
          sw    $t5, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          sw    $t6, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          lw    $t6, -8($fp)            
          lw    $t5, 4($t0)             
          li    $t5, 1                  
          addu  $t7, $t6, $t5           
          sw    $t7, 4($t0)             
          li    $t5, 1                  
          subu  $t6, $t1, $t5           
          sw    $t0, 4($sp)             
          sw    $t6, 8($sp)             
          sw    $t3, 12($sp)            
          sw    $t4, 16($sp)            
          sw    $t2, 20($sp)            
          lw    $t5, 0($t0)             
          lw    $t6, 12($t5)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
          jalr  $t6                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 12($fp)            
          lw    $t4, 16($fp)            
          lw    $t3, 20($fp)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t4, 16($fp)            
          sw    $t3, 20($fp)            
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
          addiu $sp, $sp, -40           
_L22:                                   
          li    $t0, 5                  
          move  $t1, $t0                
          la    $t0, _STRING7           
          sw    $t0, 4($sp)             
          sw    $t1, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t1, -8($fp)            
          sw    $t1, 4($sp)             
          sw    $t1, -8($fp)            
          jal   _PrintInt               
          nop                           
          lw    $t1, -8($fp)            
          la    $t0, _STRING6           
          sw    $t0, 4($sp)             
          sw    $t1, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t1, -8($fp)            
          sw    $t1, -8($fp)            
          jal   _Hanoi_New              
          nop                           
          move  $t0, $v0                
          lw    $t1, -8($fp)            
          move  $t2, $t0                
          sw    $t2, 4($sp)             
          lw    $t0, 0($t2)             
          lw    $t3, 8($t0)             
          sw    $t1, -8($fp)            
          sw    $t2, -12($fp)           
          jalr  $t3                     
          nop                           
          lw    $t1, -8($fp)            
          lw    $t2, -12($fp)           
          la    $t0, _STRING8           
          la    $t3, _STRING9           
          la    $t4, _STRING10          
          sw    $t2, 4($sp)             
          sw    $t1, 8($sp)             
          sw    $t0, 12($sp)            
          sw    $t3, 16($sp)            
          sw    $t4, 20($sp)            
          lw    $t0, 0($t2)             
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
_STRING3:
          .asciiz ": move "             
_STRING8:
          .asciiz "A"                   
_STRING10:
          .asciiz "B"                   
_STRING2:
          .asciiz "#"                   
_STRING9:
          .asciiz "C"                   
_STRING5:
          .asciiz " to "                
_STRING6:
          .asciiz "\n"                  
_STRING0:
          .asciiz "Hanoi"               
_STRING4:
          .asciiz " from "              
_STRING1:
          .asciiz "Main"                
_STRING7:
          .asciiz "number of disks is " 
