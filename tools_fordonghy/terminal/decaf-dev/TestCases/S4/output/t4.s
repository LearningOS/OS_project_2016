          .text                         
          .globl main                   

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING0                # class name
          .word _Main.tester            
          .word _Main.start             



          .text                         
_Main_New:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L30:                                   
          li    $t0, 12                 
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          sw    $t1, 8($t0)             
          la    $t1, _Main              
          sw    $t1, 0($t0)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Main.tester:                           # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -52           
_L31:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          li    $t1, 1                  
          li    $t2, 0                  
          slt   $t3, $t1, $t2           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          beqz  $t3, _L33               
          nop                           
_L32:                                   
          la    $t0, _STRING1           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L33:                                   
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
          sw    $t1, -24($fp)           
          sw    $t0, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t2, -20($fp)           
_L34:                                   
          lw    $t0, -16($fp)           
          lw    $t1, -12($fp)           
          subu  $t0, $t0, $t1           
          sw    $t1, -12($fp)           
          sw    $t0, -16($fp)           
          beqz  $t0, _L36               
          nop                           
_L35:                                   
          lw    $t0, -20($fp)           
          lw    $t1, -12($fp)           
          subu  $t0, $t0, $t1           
          lw    $t2, -24($fp)           
          sw    $t2, 0($t0)             
          sw    $t2, -24($fp)           
          sw    $t1, -12($fp)           
          sw    $t0, -20($fp)           
          b     _L34                    
          nop                           
_L36:                                   
          lw    $t0, 4($fp)             
          lw    $t1, -20($fp)           
          sw    $t1, 8($t0)             
          li    $t1, 0                  
          lw    $t2, 8($fp)             
          slt   $t3, $t2, $t1           
          sw    $t0, 4($fp)             
          sw    $t2, 8($fp)             
          beqz  $t3, _L38               
          nop                           
_L37:                                   
          la    $t0, _STRING1           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L38:                                   
          li    $t0, 4                  
          lw    $t1, 8($fp)             
          mult  $t0, $t1                
          mflo  $t2                     
          addu  $t3, $t0, $t2           
          sw    $t3, 4($sp)             
          sw    $t1, 8($fp)             
          sw    $t0, -28($fp)           
          sw    $t3, -32($fp)           
          jal   _Alloc                  
          nop                           
          move  $t2, $v0                
          lw    $t1, 8($fp)             
          lw    $t0, -28($fp)           
          lw    $t3, -32($fp)           
          sw    $t1, 0($t2)             
          li    $t4, 0                  
          addu  $t2, $t2, $t3           
          sw    $t1, 8($fp)             
          sw    $t0, -28($fp)           
          sw    $t3, -32($fp)           
          sw    $t2, -36($fp)           
          sw    $t4, -40($fp)           
_L39:                                   
          lw    $t0, -32($fp)           
          lw    $t1, -28($fp)           
          subu  $t0, $t0, $t1           
          sw    $t1, -28($fp)           
          sw    $t0, -32($fp)           
          beqz  $t0, _L41               
          nop                           
_L40:                                   
          lw    $t0, -36($fp)           
          lw    $t1, -28($fp)           
          subu  $t0, $t0, $t1           
          lw    $t2, -40($fp)           
          sw    $t2, 0($t0)             
          sw    $t1, -28($fp)           
          sw    $t0, -36($fp)           
          sw    $t2, -40($fp)           
          b     _L39                    
          nop                           
_L41:                                   
          lw    $t0, -36($fp)           
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Main.start:                            # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -44           
_L42:                                   
          li    $t0, 1                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L43:                                   
          li    $t0, 5                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L48               
          nop                           
_L44:                                   
          li    $t0, 2                  
          sw    $t0, -12($fp)           
_L45:                                   
          lw    $t0, -8($fp)            
          sw    $t0, 4($sp)             
          lw    $t1, -12($fp)           
          sw    $t1, 8($sp)             
          sw    $t0, -8($fp)            
          jal   _Mod                    
          nop                           
          move  $t1, $v0                
          lw    $t0, -8($fp)            
          li    $t2, 0                  
          subu  $t3, $t1, $t2           
          sltu  $t3, $zero, $t3         
          xori  $t3, $t3, 1             
          sw    $t0, -8($fp)            
          beqz  $t3, _L47               
          nop                           
_L46:                                   
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          lw    $t1, -8($fp)            
          sw    $t1, 8($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 8($t1)             
          sw    $t0, 4($fp)             
          jalr  $t2                     
          nop                           
          move  $t1, $v0                
          lw    $t0, 4($fp)             
          move  $t2, $t1                
          sw    $t0, 4($fp)             
          sw    $t2, -16($fp)           
_L48:                                   
          li    $t0, 0                  
          lw    $t1, -16($fp)           
          lw    $t2, -4($t1)            
          slt   $t3, $t0, $t2           
          sw    $t0, -20($fp)           
          sw    $t1, -16($fp)           
          beqz  $t3, _L50               
          nop                           
_L49:                                   
          li    $t0, 0                  
          lw    $t1, -20($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -20($fp)           
          beqz  $t2, _L51               
          nop                           
_L50:                                   
          la    $t0, _STRING4           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L51:                                   
          li    $t0, 4                  
          lw    $t1, -20($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -16($fp)           
          addu  $t3, $t0, $t2           
          lw    $t2, 0($t3)             
          li    $t2, 0                  
          li    $t3, 4                  
          mult  $t1, $t3                
          mflo  $t4                     
          addu  $t1, $t0, $t4           
          sw    $t2, 0($t1)             
          li    $t1, 0                  
          lw    $t2, -4($t0)            
          slt   $t3, $t1, $t2           
          sw    $t1, -24($fp)           
          sw    $t0, -16($fp)           
          beqz  $t3, _L53               
          nop                           
_L52:                                   
          li    $t0, 0                  
          lw    $t1, -24($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -24($fp)           
          beqz  $t2, _L54               
          nop                           
_L53:                                   
          la    $t0, _STRING4           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L54:                                   
          li    $t0, 4                  
          lw    $t1, -24($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -16($fp)           
          addu  $t1, $t0, $t2           
          lw    $t2, 0($t1)             
          lw    $t1, -4($t0)            
          slt   $t3, $t2, $t1           
          sw    $t2, -28($fp)           
          sw    $t0, -16($fp)           
          beqz  $t3, _L56               
          nop                           
_L55:                                   
          li    $t0, 0                  
          lw    $t1, -28($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -28($fp)           
          beqz  $t2, _L57               
          nop                           
_L56:                                   
          la    $t0, _STRING4           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L57:                                   
          li    $t0, 4                  
          lw    $t1, -28($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -16($fp)           
          addu  $t1, $t0, $t2           
          lw    $t2, 0($t1)             
          sw    $t2, 4($sp)             
          sw    $t0, -16($fp)           
          jal   _PrintInt               
          nop                           
          lw    $t0, -16($fp)           
          la    $t1, _STRING3           
          sw    $t1, 4($sp)             
          sw    $t0, -16($fp)           
          jal   _PrintString            
          nop                           
          lw    $t0, -16($fp)           
          lw    $t1, -4($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, -16($fp)           
          jal   _PrintInt               
          nop                           
          lw    $t0, -16($fp)           
          la    $t1, _STRING3           
          sw    $t1, 4($sp)             
          sw    $t0, -16($fp)           
          jal   _PrintString            
          nop                           
          lw    $t0, -16($fp)           
          sw    $t0, -16($fp)           
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L47:                                   
          la    $t0, _STRING2           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          lw    $t0, -8($fp)            
          sw    $t0, 4($sp)             
          sw    $t0, -8($fp)            
          jal   _PrintInt               
          nop                           
          lw    $t0, -8($fp)            
          la    $t1, _STRING3           
          sw    $t1, 4($sp)             
          sw    $t0, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t0, -8($fp)            
          li    $t1, 1                  
          addu  $t2, $t0, $t1           
          move  $t0, $t2                
          sw    $t0, -8($fp)            
          b     _L43                    
          nop                           

main:                                   # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L58:                                   
          jal   _Main_New               
          nop                           
          move  $t0, $v0                
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t0, 12($t1)            
          jalr  $t0                     
          nop                           
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           




          .data                         
_STRING1:
          .asciiz "Decaf runtime error: Cannot create negative-sized array\n"
_STRING3:
          .asciiz "\n"                  
_STRING0:
          .asciiz "Main"                
_STRING2:
          .asciiz "Loop "               
_STRING4:
          .asciiz "Decaf runtime error: Array subscript out of bounds\n"
