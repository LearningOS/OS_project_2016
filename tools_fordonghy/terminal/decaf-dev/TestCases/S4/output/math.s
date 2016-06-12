          .text                         
          .globl main                   

          .data                         
          .align 2                      
_Math:                                  # virtual table
          .word 0                       # parent
          .word _STRING0                # class name

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING1                # class name



          .text                         
_Math_New:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L31:                                   
          li    $t0, 4                  
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          la    $t1, _Math              
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
_L32:                                   
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

_Math.abs:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L33:                                   
          li    $t0, 0                  
          lw    $t1, 4($fp)             
          slt   $t2, $t1, $t0           
          xori  $t2, $t2, 1             
          sw    $t1, 4($fp)             
          beqz  $t2, _L35               
          nop                           
_L34:                                   
          lw    $t0, 4($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L35:                                   
          lw    $t0, 4($fp)             
          subu  $t1, $zero, $t0         
          sw    $t0, 4($fp)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Math.pow:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -20           
_L37:                                   
          li    $t0, 1                  
          move  $t1, $t0                
          li    $t0, 0                  
          move  $t2, $t0                
          sw    $t2, -8($fp)            
          sw    $t1, -12($fp)           
_L39:                                   
          lw    $t0, -8($fp)            
          lw    $t1, 8($fp)             
          slt   $t2, $t0, $t1           
          sw    $t0, -8($fp)            
          sw    $t1, 8($fp)             
          beqz  $t2, _L41               
          nop                           
_L40:                                   
          lw    $t0, -12($fp)           
          lw    $t1, 4($fp)             
          mult  $t0, $t1                
          mflo  $t2                     
          move  $t0, $t2                
          sw    $t1, 4($fp)             
          sw    $t0, -12($fp)           
_L38:                                   
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -8($fp)            
          b     _L39                    
          nop                           
_L41:                                   
          lw    $t0, -12($fp)           
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Math.log:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -28           
_L42:                                   
          li    $t0, 1                  
          lw    $t1, 4($fp)             
          slt   $t2, $t1, $t0           
          sw    $t1, 4($fp)             
          beqz  $t2, _L44               
          nop                           
_L43:                                   
          li    $t0, 1                  
          subu  $t1, $zero, $t0         
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L44:                                   
          li    $t0, 0                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L45:                                   
          li    $t0, 1                  
          lw    $t1, 4($fp)             
          slt   $t2, $t0, $t1           
          sw    $t1, 4($fp)             
          beqz  $t2, _L48               
          nop                           
_L46:                                   
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          li    $t0, 2                  
          sw    $t0, -12($fp)           
          sw    $t1, -8($fp)            
_L47:                                   
          lw    $t1, 4($fp)             
          sw    $t1, 4($sp)             
          lw    $t0, -12($fp)           
          sw    $t0, 8($sp)             
          jal   _Div                    
          nop                           
          move  $t0, $v0                
          move  $t1, $t0                
          sw    $t1, 4($fp)             
          b     _L45                    
          nop                           
_L48:                                   
          lw    $t0, -8($fp)            
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Math.max:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L49:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          slt   $t2, $t1, $t0           
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          beqz  $t2, _L51               
          nop                           
_L50:                                   
          lw    $t0, 4($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L51:                                   
          lw    $t0, 8($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Math.min:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L53:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          slt   $t2, $t0, $t1           
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          beqz  $t2, _L55               
          nop                           
_L54:                                   
          lw    $t0, 4($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L55:                                   
          lw    $t0, 8($fp)             
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
          addiu $sp, $sp, -20           
_L57:                                   
          li    $t0, 1                  
          subu  $t1, $zero, $t0         
          sw    $t1, 4($sp)             
          jal   _Math.abs               
          nop                           
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          jal   _PrintInt               
          nop                           
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $t0, 2                  
          li    $t1, 3                  
          sw    $t0, 4($sp)             
          sw    $t1, 8($sp)             
          jal   _Math.pow               
          nop                           
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          jal   _PrintInt               
          nop                           
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $t0, 16                 
          sw    $t0, 4($sp)             
          jal   _Math.log               
          nop                           
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          jal   _PrintInt               
          nop                           
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $t0, 1                  
          li    $t1, 2                  
          sw    $t0, 4($sp)             
          sw    $t1, 8($sp)             
          jal   _Math.max               
          nop                           
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          jal   _PrintInt               
          nop                           
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $t0, 1                  
          li    $t1, 2                  
          sw    $t0, 4($sp)             
          sw    $t1, 8($sp)             
          jal   _Math.min               
          nop                           
          move  $t0, $v0                
          sw    $t0, 4($sp)             
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




          .data                         
_STRING2:
          .asciiz "\n"                  
_STRING0:
          .asciiz "Math"                
_STRING1:
          .asciiz "Main"                
