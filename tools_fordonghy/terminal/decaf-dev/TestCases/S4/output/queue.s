          .text                         
          .globl main                   

          .data                         
          .align 2                      
_QueueItem:                             # virtual table
          .word 0                       # parent
          .word _STRING0                # class name
          .word _QueueItem.Init         
          .word _QueueItem.GetData      
          .word _QueueItem.GetNext      
          .word _QueueItem.GetPrev      
          .word _QueueItem.SetNext      
          .word _QueueItem.SetPrev      

          .data                         
          .align 2                      
_Queue:                                 # virtual table
          .word 0                       # parent
          .word _STRING1                # class name
          .word _Queue.Init             
          .word _Queue.EnQueue          
          .word _Queue.DeQueue          

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING2                # class name



          .text                         
_QueueItem_New:                         # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L37:                                   
          li    $t0, 16                 
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          sw    $t1, 8($t0)             
          sw    $t1, 12($t0)            
          la    $t1, _QueueItem         
          sw    $t1, 0($t0)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Queue_New:                             # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L38:                                   
          li    $t0, 12                 
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          sw    $t1, 8($t0)             
          la    $t1, _Queue             
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
_L39:                                   
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

_QueueItem.Init:                        # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L40:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t1, 8($fp)             
          sw    $t1, 4($t0)             
          lw    $t2, 8($t0)             
          lw    $t2, 12($fp)            
          sw    $t2, 8($t0)             
          lw    $t3, 12($t2)            
          sw    $t0, 12($t2)            
          lw    $t3, 12($t0)            
          lw    $t3, 16($fp)            
          sw    $t3, 12($t0)            
          lw    $t4, 8($t3)             
          sw    $t0, 8($t3)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          sw    $t2, 12($fp)            
          sw    $t3, 16($fp)            
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_QueueItem.GetData:                     # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L41:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          sw    $t0, 4($fp)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_QueueItem.GetNext:                     # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L42:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          sw    $t0, 4($fp)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_QueueItem.GetPrev:                     # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L43:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 12($t0)            
          sw    $t0, 4($fp)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_QueueItem.SetNext:                     # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L44:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          lw    $t1, 8($fp)             
          sw    $t1, 8($t0)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_QueueItem.SetPrev:                     # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L45:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 12($t0)            
          lw    $t1, 8($fp)             
          sw    $t1, 12($t0)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Queue.Init:                            # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -28           
_L46:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          sw    $t0, 4($fp)             
          jal   _QueueItem_New          
          nop                           
          move  $t1, $v0                
          lw    $t0, 4($fp)             
          sw    $t1, 8($t0)             
          lw    $t1, 8($t0)             
          li    $t2, 0                  
          lw    $t3, 8($t0)             
          lw    $t4, 8($t0)             
          sw    $t1, 4($sp)             
          sw    $t2, 8($sp)             
          sw    $t3, 12($sp)            
          sw    $t4, 16($sp)            
          lw    $t2, 0($t1)             
          lw    $t1, 8($t2)             
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Queue.EnQueue:                         # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -32           
_L47:                                   
          jal   _QueueItem_New          
          nop                           
          move  $t0, $v0                
          move  $t1, $t0                
          lw    $t0, 4($fp)             
          lw    $t2, 8($t0)             
          sw    $t2, 4($sp)             
          lw    $t3, 0($t2)             
          lw    $t2, 16($t3)            
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          jalr  $t2                     
          nop                           
          move  $t3, $v0                
          lw    $t0, 4($fp)             
          lw    $t1, -8($fp)            
          lw    $t2, 8($t0)             
          sw    $t1, 4($sp)             
          lw    $t4, 8($fp)             
          sw    $t4, 8($sp)             
          sw    $t3, 12($sp)            
          sw    $t2, 16($sp)            
          lw    $t2, 0($t1)             
          lw    $t1, 8($t2)             
          sw    $t0, 4($fp)             
          sw    $t4, 8($fp)             
          jalr  $t1                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t4, 8($fp)             
          sw    $t0, 4($fp)             
          sw    $t4, 8($fp)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Queue.DeQueue:                         # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -36           
_L48:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          sw    $t1, 4($sp)             
          lw    $t2, 0($t1)             
          lw    $t1, 20($t2)            
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          subu  $t3, $t2, $t1           
          sltu  $t3, $zero, $t3         
          xori  $t3, $t3, 1             
          sw    $t0, 4($fp)             
          beqz  $t3, _L50               
          nop                           
_L49:                                   
          la    $t0, _STRING3           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $t0, 0                  
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L50:                                   
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          sw    $t1, 4($sp)             
          lw    $t2, 0($t1)             
          lw    $t1, 20($t2)            
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          move  $t1, $t2                
          sw    $t1, 4($sp)             
          lw    $t2, 0($t1)             
          lw    $t3, 12($t2)            
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          jalr  $t3                     
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          lw    $t1, -8($fp)            
          move  $t3, $t2                
          sw    $t1, 4($sp)             
          lw    $t2, 0($t1)             
          lw    $t4, 20($t2)            
          sw    $t3, -12($fp)           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          jalr  $t4                     
          nop                           
          move  $t2, $v0                
          lw    $t3, -12($fp)           
          lw    $t0, 4($fp)             
          lw    $t1, -8($fp)            
          sw    $t1, 4($sp)             
          lw    $t4, 0($t1)             
          lw    $t5, 16($t4)            
          sw    $t3, -12($fp)           
          sw    $t2, -16($fp)           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          jalr  $t5                     
          nop                           
          move  $t4, $v0                
          lw    $t3, -12($fp)           
          lw    $t2, -16($fp)           
          lw    $t0, 4($fp)             
          lw    $t1, -8($fp)            
          sw    $t2, 4($sp)             
          sw    $t4, 8($sp)             
          lw    $t4, 0($t2)             
          lw    $t2, 24($t4)            
          sw    $t3, -12($fp)           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          jalr  $t2                     
          nop                           
          lw    $t3, -12($fp)           
          lw    $t0, 4($fp)             
          lw    $t1, -8($fp)            
          sw    $t1, 4($sp)             
          lw    $t2, 0($t1)             
          lw    $t4, 16($t2)            
          sw    $t3, -12($fp)           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          jalr  $t4                     
          nop                           
          move  $t2, $v0                
          lw    $t3, -12($fp)           
          lw    $t0, 4($fp)             
          lw    $t1, -8($fp)            
          sw    $t1, 4($sp)             
          lw    $t4, 0($t1)             
          lw    $t1, 20($t4)            
          sw    $t2, -20($fp)           
          sw    $t3, -12($fp)           
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          move  $t4, $v0                
          lw    $t2, -20($fp)           
          lw    $t3, -12($fp)           
          lw    $t0, 4($fp)             
          sw    $t2, 4($sp)             
          sw    $t4, 8($sp)             
          lw    $t1, 0($t2)             
          lw    $t2, 28($t1)            
          sw    $t3, -12($fp)           
          sw    $t0, 4($fp)             
          jalr  $t2                     
          nop                           
          lw    $t3, -12($fp)           
          lw    $t0, 4($fp)             
          sw    $t3, -12($fp)           
          sw    $t0, 4($fp)             
_L51:                                   
          lw    $t0, -12($fp)           
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
_L52:                                   
          jal   _Queue_New              
          nop                           
          move  $t0, $v0                
          move  $t1, $t0                
          sw    $t1, 4($sp)             
          lw    $t0, 0($t1)             
          lw    $t2, 8($t0)             
          sw    $t1, -8($fp)            
          jalr  $t2                     
          nop                           
          lw    $t1, -8($fp)            
          li    $t0, 0                  
          move  $t2, $t0                
          sw    $t1, -8($fp)            
          sw    $t2, -12($fp)           
_L54:                                   
          li    $t0, 10                 
          lw    $t1, -12($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -12($fp)           
          beqz  $t2, _L56               
          nop                           
_L55:                                   
          lw    $t0, -8($fp)            
          sw    $t0, 4($sp)             
          lw    $t1, -12($fp)           
          sw    $t1, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 12($t2)            
          sw    $t0, -8($fp)            
          sw    $t1, -12($fp)           
          jalr  $t3                     
          nop                           
          lw    $t0, -8($fp)            
          lw    $t1, -12($fp)           
          sw    $t0, -8($fp)            
          sw    $t1, -12($fp)           
_L53:                                   
          li    $t0, 1                  
          lw    $t1, -12($fp)           
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -12($fp)           
          b     _L54                    
          nop                           
_L56:                                   
          li    $t0, 0                  
          move  $t1, $t0                
          sw    $t1, -12($fp)           
_L58:                                   
          li    $t0, 4                  
          lw    $t1, -12($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -12($fp)           
          beqz  $t2, _L60               
          nop                           
_L59:                                   
          lw    $t0, -8($fp)            
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 16($t1)            
          sw    $t0, -8($fp)            
          jalr  $t2                     
          nop                           
          move  $t1, $v0                
          lw    $t0, -8($fp)            
          sw    $t1, 4($sp)             
          sw    $t0, -8($fp)            
          jal   _PrintInt               
          nop                           
          lw    $t0, -8($fp)            
          la    $t1, _STRING4           
          sw    $t1, 4($sp)             
          sw    $t0, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t0, -8($fp)            
          sw    $t0, -8($fp)            
_L57:                                   
          li    $t0, 1                  
          lw    $t1, -12($fp)           
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -12($fp)           
          b     _L58                    
          nop                           
_L60:                                   
          la    $t0, _STRING5           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $t0, 0                  
          move  $t1, $t0                
          sw    $t1, -12($fp)           
_L62:                                   
          li    $t0, 10                 
          lw    $t1, -12($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -12($fp)           
          beqz  $t2, _L64               
          nop                           
_L63:                                   
          lw    $t0, -8($fp)            
          sw    $t0, 4($sp)             
          lw    $t1, -12($fp)           
          sw    $t1, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 12($t2)            
          sw    $t0, -8($fp)            
          sw    $t1, -12($fp)           
          jalr  $t3                     
          nop                           
          lw    $t0, -8($fp)            
          lw    $t1, -12($fp)           
          sw    $t0, -8($fp)            
          sw    $t1, -12($fp)           
_L61:                                   
          li    $t0, 1                  
          lw    $t1, -12($fp)           
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -12($fp)           
          b     _L62                    
          nop                           
_L64:                                   
          li    $t0, 0                  
          move  $t1, $t0                
          sw    $t1, -12($fp)           
_L66:                                   
          li    $t0, 17                 
          lw    $t1, -12($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -12($fp)           
          beqz  $t2, _L68               
          nop                           
_L67:                                   
          lw    $t0, -8($fp)            
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 16($t1)            
          sw    $t0, -8($fp)            
          jalr  $t2                     
          nop                           
          move  $t1, $v0                
          lw    $t0, -8($fp)            
          sw    $t1, 4($sp)             
          sw    $t0, -8($fp)            
          jal   _PrintInt               
          nop                           
          lw    $t0, -8($fp)            
          la    $t1, _STRING4           
          sw    $t1, 4($sp)             
          sw    $t0, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t0, -8($fp)            
          sw    $t0, -8($fp)            
_L65:                                   
          li    $t0, 1                  
          lw    $t1, -12($fp)           
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -12($fp)           
          b     _L66                    
          nop                           
_L68:                                   
          la    $t0, _STRING5           
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
_STRING4:
          .asciiz " "                   
_STRING3:
          .asciiz "Queue Is Empty"      
_STRING5:
          .asciiz "\n"                  
_STRING0:
          .asciiz "QueueItem"           
_STRING1:
          .asciiz "Queue"               
_STRING2:
          .asciiz "Main"                
