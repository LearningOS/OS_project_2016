          .text                         
          .globl main                   

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING0                # class name

          .data                         
          .align 2                      
_Fibonacci:                             # virtual table
          .word 0                       # parent
          .word _STRING1                # class name
          .word _Fibonacci.get


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

_Fibonacci_New:                         # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L18:                                   
          li    $t0, 4                  
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          la    $t1, _Fibonacci         
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
          addiu $sp, $sp, -28           
_L19:                                   
          jal   _Fibonacci_New          
          nop                           
          move  $t0, $v0                
          move  $t1, $t0                
          li    $t0, 0                  
          move  $t2, $t0                
          sw    $t2, -8($fp)            
          sw    $t1, -12($fp)           
_L20:                                   
          li    $t0, 10                 
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L22               
          nop                           
_L21:                                   
          lw    $t0, -12($fp)           
          sw    $t0, 4($sp)             
          lw    $t1, -8($fp)            
          sw    $t1, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 8($t2)             
          sw    $t1, -8($fp)            
          sw    $t0, -12($fp)           
          jalr  $t3                     
          nop                           
          move  $t2, $v0                
          lw    $t1, -8($fp)            
          lw    $t0, -12($fp)           
          sw    $t2, 4($sp)             
          sw    $t1, -8($fp)            
          sw    $t0, -12($fp)           
          jal   _PrintInt               
          nop                           
          lw    $t1, -8($fp)            
          lw    $t0, -12($fp)           
          la    $t2, _STRING2           
          sw    $t2, 4($sp)             
          sw    $t1, -8($fp)            
          sw    $t0, -12($fp)           
          jal   _PrintString            
          nop                           
          lw    $t1, -8($fp)            
          lw    $t0, -12($fp)           
          li    $t2, 1                  
          addu  $t3, $t1, $t2           
          move  $t1, $t3                
          sw    $t1, -8($fp)            
          sw    $t0, -12($fp)           
          b     _L20                    
          nop                           
_L22:                                   
          jal   _ReadInteger            
          nop                           
          move  $t0, $v0                
          move  $t1, $t0                
          lw    $t0, -12($fp)           
          sw    $t0, 4($sp)             
          sw    $t1, 8($sp)             
          lw    $t1, 0($t0)             
          lw    $t0, 8($t1)             
          jalr  $t0                     
          nop                           
          move  $t1, $v0                
          sw    $t1, 4($sp)             
          jal   _PrintInt               
          nop                           
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Fibonacci.get:                         # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L23:                                   
          li    $t0, 2                  
          lw    $t1, 8($fp)             
          slt   $t2, $t1, $t0           
          sw    $t1, 8($fp)             
          beqz  $t2, _L25               
          nop                           
_L24:                                   
          li    $t0, 1                  
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L25:                                   
          li    $t0, 1                  
          lw    $t1, 8($fp)             
          subu  $t2, $t1, $t0           
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          sw    $t2, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 8($t2)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jalr  $t3                     
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          li    $t3, 2                  
          subu  $t4, $t1, $t3           
          sw    $t0, 4($sp)             
          sw    $t4, 8($sp)             
          lw    $t3, 0($t0)             
          lw    $t4, 8($t3)             
          sw    $t0, 4($fp)             
          sw    $t2, -8($fp)            
          sw    $t1, 8($fp)             
          jalr  $t4                     
          nop                           
          move  $t3, $v0                
          lw    $t0, 4($fp)             
          lw    $t2, -8($fp)            
          lw    $t1, 8($fp)             
          addu  $t4, $t2, $t3           
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          move  $v0, $t4                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           




          .data                         
_STRING2:
          .asciiz "\n"                  
_STRING1:
          .asciiz "Fibonacci"           
_STRING0:
          .asciiz "Main"                
