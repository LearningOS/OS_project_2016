          .text                         
          .globl main                   

          .data                         
          .align 2                      
_rndModule:                             # virtual table
          .word 0                       # parent
          .word _STRING0                # class name
          .word _rndModule.Init         
          .word _rndModule.Random       
          .word _rndModule.RndInt       

          .data                         
          .align 2                      
_Deck:                                  # virtual table
          .word 0                       # parent
          .word _STRING1                # class name
          .word _Deck.Init              
          .word _Deck.Shuffle           
          .word _Deck.GetCard           

          .data                         
          .align 2                      
_BJDeck:                                # virtual table
          .word 0                       # parent
          .word _STRING2                # class name
          .word _BJDeck.Init            
          .word _BJDeck.DealCard        
          .word _BJDeck.Shuffle         
          .word _BJDeck.NumCardsRemaining

          .data                         
          .align 2                      
_Player:                                # virtual table
          .word 0                       # parent
          .word _STRING3                # class name
          .word _Player.Init            
          .word _Player.Hit             
          .word _Player.DoubleDown      
          .word _Player.TakeTurn        
          .word _Player.HasMoney        
          .word _Player.PrintMoney      
          .word _Player.PlaceBet        
          .word _Player.GetTotal        
          .word _Player.Resolve         
          .word _Player.GetYesOrNo      

          .data                         
          .align 2                      
_Dealer:                                # virtual table
          .word _Player                 # parent
          .word _STRING4                # class name
          .word _Dealer.Init            
          .word _Player.Hit             
          .word _Player.DoubleDown      
          .word _Dealer.TakeTurn        
          .word _Player.HasMoney        
          .word _Player.PrintMoney      
          .word _Player.PlaceBet        
          .word _Player.GetTotal        
          .word _Player.Resolve         
          .word _Player.GetYesOrNo      

          .data                         
          .align 2                      
_House:                                 # virtual table
          .word 0                       # parent
          .word _STRING5                # class name
          .word _House.SetupGame        
          .word _House.SetupPlayers     
          .word _House.TakeAllBets      
          .word _House.TakeAllTurns     
          .word _House.ResolveAllPlayers
          .word _House.PrintAllMoney    
          .word _House.PlayOneGame      

          .data                         
          .align 2                      
_Main:                                  # virtual table
          .word 0                       # parent
          .word _STRING6                # class name



          .text                         
_rndModule_New:                         # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L173:                                  
          li    $t0, 8                  
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          la    $t1, _rndModule         
          sw    $t1, 0($t0)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Deck_New:                              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L174:                                  
          li    $t0, 16                 
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          sw    $t1, 8($t0)             
          sw    $t1, 12($t0)            
          la    $t1, _Deck              
          sw    $t1, 0($t0)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_BJDeck_New:                            # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L175:                                  
          li    $t0, 16                 
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          sw    $t1, 8($t0)             
          sw    $t1, 12($t0)            
          la    $t1, _BJDeck            
          sw    $t1, 0($t0)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Player_New:                            # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -32           
_L176:                                  
          li    $t0, 28                 
          sw    $t0, 4($sp)             
          sw    $t0, -8($fp)            
          jal   _Alloc                  
          nop                           
          move  $t1, $v0                
          lw    $t0, -8($fp)            
          li    $t2, 0                  
          li    $t3, 4                  
          addu  $t4, $t1, $t0           
          sw    $t0, -8($fp)            
          sw    $t2, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t4, -20($fp)           
_L177:                                  
          lw    $t0, -20($fp)           
          lw    $t1, -16($fp)           
          subu  $t2, $t0, $t1           
          move  $t0, $t2                
          lw    $t2, -8($fp)            
          subu  $t3, $t2, $t1           
          move  $t2, $t3                
          sw    $t2, -8($fp)            
          sw    $t1, -16($fp)           
          sw    $t0, -20($fp)           
          beqz  $t2, _L179              
          nop                           
_L178:                                  
          lw    $t0, -20($fp)           
          lw    $t1, -12($fp)           
          sw    $t1, 0($t0)             
          sw    $t1, -12($fp)           
          sw    $t0, -20($fp)           
          b     _L177                   
          nop                           
_L179:                                  
          la    $t0, _Player            
          lw    $t1, -20($fp)           
          sw    $t0, 0($t1)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Dealer_New:                            # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -32           
_L180:                                  
          li    $t0, 28                 
          sw    $t0, 4($sp)             
          sw    $t0, -8($fp)            
          jal   _Alloc                  
          nop                           
          move  $t1, $v0                
          lw    $t0, -8($fp)            
          li    $t2, 0                  
          li    $t3, 4                  
          addu  $t4, $t1, $t0           
          sw    $t2, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t4, -20($fp)           
          sw    $t0, -8($fp)            
_L181:                                  
          lw    $t0, -20($fp)           
          lw    $t1, -16($fp)           
          subu  $t2, $t0, $t1           
          move  $t0, $t2                
          lw    $t2, -8($fp)            
          subu  $t3, $t2, $t1           
          move  $t2, $t3                
          sw    $t1, -16($fp)           
          sw    $t0, -20($fp)           
          sw    $t2, -8($fp)            
          beqz  $t2, _L183              
          nop                           
_L182:                                  
          lw    $t0, -20($fp)           
          lw    $t1, -12($fp)           
          sw    $t1, 0($t0)             
          sw    $t1, -12($fp)           
          sw    $t0, -20($fp)           
          b     _L181                   
          nop                           
_L183:                                  
          la    $t0, _Dealer            
          lw    $t1, -20($fp)           
          sw    $t0, 0($t1)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_House_New:                             # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L184:                                  
          li    $t0, 16                 
          sw    $t0, 4($sp)             
          jal   _Alloc                  
          nop                           
          move  $t0, $v0                
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          sw    $t1, 8($t0)             
          sw    $t1, 12($t0)            
          la    $t1, _House             
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
_L185:                                  
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

_rndModule.Init:                        # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L186:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t1, 8($fp)             
          sw    $t1, 4($t0)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_rndModule.Random:                      # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -40           
_L187:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t1, 15625              
          lw    $t2, 4($t0)             
          li    $t3, 10000              
          sw    $t2, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
_L188:                                  
          lw    $t0, -12($fp)           
          sw    $t0, 4($sp)             
          lw    $t0, -16($fp)           
          sw    $t0, 8($sp)             
          jal   _Mod                    
          nop                           
          move  $t0, $v0                
          lw    $t1, -8($fp)            
          mult  $t1, $t0                
          mflo  $t2                     
          li    $t0, 22221              
          addu  $t1, $t2, $t0           
          lui   $t0, 1                  
          sw    $t1, -20($fp)           
          sw    $t0, -24($fp)           
_L189:                                  
          lw    $t0, -20($fp)           
          sw    $t0, 4($sp)             
          lw    $t0, -24($fp)           
          sw    $t0, 8($sp)             
          jal   _Mod                    
          nop                           
          move  $t0, $v0                
          lw    $t1, 4($fp)             
          sw    $t0, 4($t1)             
          lw    $t0, 4($t1)             
          sw    $t1, 4($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_rndModule.RndInt:                      # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L190:                                  
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 12($t1)            
          sw    $t0, 4($fp)             
          jalr  $t2                     
          nop                           
          move  $t1, $v0                
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
_L191:                                  
          lw    $t0, -8($fp)            
          sw    $t0, 4($sp)             
          lw    $t0, 8($fp)             
          sw    $t0, 8($sp)             
          sw    $t0, 8($fp)             
          jal   _Mod                    
          nop                           
          move  $t1, $v0                
          lw    $t0, 8($fp)             
          sw    $t0, 8($fp)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Deck.Init:                             # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -36           
_L192:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          li    $t1, 52                 
          li    $t2, 0                  
          slt   $t3, $t1, $t2           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          beqz  $t3, _L194              
          nop                           
_L193:                                  
          la    $t0, _STRING7           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L194:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t0, $t1                
          mflo  $t2                     
          addu  $t3, $t0, $t2           
          sw    $t3, 4($sp)             
          sw    $t0, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t1, -8($fp)            
          jal   _Alloc                  
          nop                           
          move  $t2, $v0                
          lw    $t0, -12($fp)           
          lw    $t3, -16($fp)           
          lw    $t1, -8($fp)            
          sw    $t1, 0($t2)             
          li    $t1, 0                  
          addu  $t2, $t2, $t3           
          sw    $t0, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t2, -20($fp)           
          sw    $t1, -24($fp)           
_L195:                                  
          lw    $t0, -16($fp)           
          lw    $t1, -12($fp)           
          subu  $t0, $t0, $t1           
          sw    $t1, -12($fp)           
          sw    $t0, -16($fp)           
          beqz  $t0, _L197              
          nop                           
_L196:                                  
          lw    $t0, -20($fp)           
          lw    $t1, -12($fp)           
          subu  $t0, $t0, $t1           
          lw    $t2, -24($fp)           
          sw    $t2, 0($t0)             
          sw    $t1, -12($fp)           
          sw    $t0, -20($fp)           
          sw    $t2, -24($fp)           
          b     _L195                   
          nop                           
_L197:                                  
          lw    $t0, 4($fp)             
          lw    $t1, -20($fp)           
          sw    $t1, 8($t0)             
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

_Deck.Shuffle:                          # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -68           
_L198:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t1, 1                  
          sw    $t1, 4($t0)             
          sw    $t0, 4($fp)             
_L200:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t2, 52                 
          slt   $t3, $t2, $t1           
          xori  $t3, $t3, 1             
          sw    $t0, 4($fp)             
          beqz  $t3, _L206              
          nop                           
_L201:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          lw    $t2, 4($t0)             
          li    $t3, 1                  
          subu  $t4, $t2, $t3           
          lw    $t2, -4($t1)            
          slt   $t3, $t4, $t2           
          sw    $t1, -8($fp)            
          sw    $t4, -12($fp)           
          sw    $t0, 4($fp)             
          beqz  $t3, _L203              
          nop                           
_L202:                                  
          li    $t0, 0                  
          lw    $t1, -12($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -12($fp)           
          beqz  $t2, _L204              
          nop                           
_L203:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L204:                                  
          li    $t0, 4                  
          lw    $t1, -12($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -8($fp)            
          addu  $t3, $t0, $t2           
          lw    $t2, 0($t3)             
          lw    $t2, 4($fp)             
          lw    $t3, 4($t2)             
          li    $t4, 13                 
          sw    $t0, -8($fp)            
          sw    $t1, -12($fp)           
          sw    $t2, 4($fp)             
          sw    $t3, -16($fp)           
          sw    $t4, -20($fp)           
_L205:                                  
          lw    $t0, -16($fp)           
          sw    $t0, 4($sp)             
          lw    $t0, -20($fp)           
          sw    $t0, 8($sp)             
          jal   _Mod                    
          nop                           
          move  $t0, $v0                
          li    $t1, 4                  
          lw    $t2, -12($fp)           
          mult  $t2, $t1                
          mflo  $t3                     
          lw    $t1, -8($fp)            
          addu  $t2, $t1, $t3           
          sw    $t0, 0($t2)             
_L199:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t1, 4($t0)             
          li    $t2, 1                  
          addu  $t3, $t1, $t2           
          sw    $t3, 4($t0)             
          sw    $t0, 4($fp)             
          b     _L200                   
          nop                           
_L206:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t1, 4($t0)             
          li    $t2, 1                  
          subu  $t3, $t1, $t2           
          sw    $t3, 4($t0)             
          sw    $t0, 4($fp)             
_L207:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t2, 0                  
          slt   $t3, $t2, $t1           
          sw    $t0, 4($fp)             
          beqz  $t3, _L221              
          nop                           
_L208:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 12($t0)            
          lw    $t2, 4($t0)             
          sw    $t1, 4($sp)             
          sw    $t2, 8($sp)             
          lw    $t2, 0($t1)             
          lw    $t1, 16($t2)            
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          move  $t1, $t2                
          lw    $t2, 4($t0)             
          lw    $t2, 4($t0)             
          li    $t3, 1                  
          subu  $t4, $t2, $t3           
          sw    $t4, 4($t0)             
          lw    $t2, 8($t0)             
          lw    $t3, 4($t0)             
          lw    $t4, -4($t2)            
          slt   $t5, $t3, $t4           
          sw    $t2, -28($fp)           
          sw    $t0, 4($fp)             
          sw    $t3, -32($fp)           
          sw    $t1, -24($fp)           
          beqz  $t5, _L210              
          nop                           
_L209:                                  
          li    $t0, 0                  
          lw    $t1, -32($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -32($fp)           
          beqz  $t2, _L211              
          nop                           
_L210:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L211:                                  
          li    $t0, 4                  
          lw    $t1, -32($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -28($fp)           
          addu  $t1, $t0, $t2           
          lw    $t0, 0($t1)             
          move  $t1, $t0                
          lw    $t0, 4($fp)             
          lw    $t2, 8($t0)             
          lw    $t3, 4($t0)             
          lw    $t4, -4($t2)            
          slt   $t5, $t3, $t4           
          sw    $t2, -40($fp)           
          sw    $t3, -44($fp)           
          sw    $t0, 4($fp)             
          sw    $t1, -36($fp)           
          beqz  $t5, _L213              
          nop                           
_L212:                                  
          li    $t0, 0                  
          lw    $t1, -44($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -44($fp)           
          beqz  $t2, _L214              
          nop                           
_L213:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L214:                                  
          li    $t0, 4                  
          lw    $t1, -44($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -40($fp)           
          addu  $t3, $t0, $t2           
          lw    $t2, 0($t3)             
          lw    $t2, 4($fp)             
          lw    $t3, 8($t2)             
          lw    $t4, -4($t3)            
          lw    $t5, -24($fp)           
          slt   $t6, $t5, $t4           
          sw    $t0, -40($fp)           
          sw    $t1, -44($fp)           
          sw    $t2, 4($fp)             
          sw    $t5, -24($fp)           
          sw    $t3, -48($fp)           
          beqz  $t6, _L216              
          nop                           
_L215:                                  
          li    $t0, 0                  
          lw    $t1, -24($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -24($fp)           
          beqz  $t2, _L217              
          nop                           
_L216:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L217:                                  
          li    $t0, 4                  
          lw    $t1, -24($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -48($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          li    $t2, 4                  
          lw    $t3, -44($fp)           
          mult  $t3, $t2                
          mflo  $t4                     
          lw    $t2, -40($fp)           
          addu  $t3, $t2, $t4           
          sw    $t0, 0($t3)             
          lw    $t0, 4($fp)             
          lw    $t2, 8($t0)             
          lw    $t3, -4($t2)            
          slt   $t4, $t1, $t3           
          sw    $t0, 4($fp)             
          sw    $t2, -52($fp)           
          sw    $t1, -24($fp)           
          beqz  $t4, _L219              
          nop                           
_L218:                                  
          li    $t0, 0                  
          lw    $t1, -24($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -24($fp)           
          beqz  $t2, _L220              
          nop                           
_L219:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L220:                                  
          li    $t0, 4                  
          lw    $t1, -24($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -52($fp)           
          addu  $t3, $t0, $t2           
          lw    $t2, 0($t3)             
          li    $t2, 4                  
          mult  $t1, $t2                
          mflo  $t3                     
          addu  $t1, $t0, $t3           
          lw    $t0, -36($fp)           
          sw    $t0, 0($t1)             
          b     _L207                   
          nop                           
_L221:                                  
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Deck.GetCard:                          # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L222:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t2, 52                 
          slt   $t3, $t1, $t2           
          xori  $t3, $t3, 1             
          sw    $t0, 4($fp)             
          beqz  $t3, _L224              
          nop                           
_L223:                                  
          li    $t0, 0                  
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L224:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          lw    $t2, 4($t0)             
          lw    $t3, -4($t1)            
          slt   $t4, $t2, $t3           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          sw    $t2, -12($fp)           
          beqz  $t4, _L226              
          nop                           
_L225:                                  
          li    $t0, 0                  
          lw    $t1, -12($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -12($fp)           
          beqz  $t2, _L227              
          nop                           
_L226:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L227:                                  
          li    $t0, 4                  
          lw    $t1, -12($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -8($fp)            
          addu  $t1, $t0, $t2           
          lw    $t0, 0($t1)             
          move  $t1, $t0                
          lw    $t0, 4($fp)             
          lw    $t2, 4($t0)             
          lw    $t2, 4($t0)             
          li    $t3, 1                  
          addu  $t4, $t2, $t3           
          sw    $t4, 4($t0)             
          sw    $t0, 4($fp)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_BJDeck.Init:                           # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -52           
_L228:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t1, 8                  
          li    $t2, 0                  
          slt   $t3, $t1, $t2           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          beqz  $t3, _L230              
          nop                           
_L229:                                  
          la    $t0, _STRING7           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L230:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t0, $t1                
          mflo  $t2                     
          addu  $t3, $t0, $t2           
          sw    $t3, 4($sp)             
          sw    $t0, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t1, -8($fp)            
          jal   _Alloc                  
          nop                           
          move  $t2, $v0                
          lw    $t0, -12($fp)           
          lw    $t3, -16($fp)           
          lw    $t1, -8($fp)            
          sw    $t1, 0($t2)             
          li    $t1, 0                  
          addu  $t2, $t2, $t3           
          sw    $t0, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t2, -20($fp)           
          sw    $t1, -24($fp)           
_L231:                                  
          lw    $t0, -16($fp)           
          lw    $t1, -12($fp)           
          subu  $t0, $t0, $t1           
          sw    $t1, -12($fp)           
          sw    $t0, -16($fp)           
          beqz  $t0, _L233              
          nop                           
_L232:                                  
          lw    $t0, -20($fp)           
          lw    $t1, -12($fp)           
          subu  $t0, $t0, $t1           
          lw    $t2, -24($fp)           
          sw    $t2, 0($t0)             
          sw    $t1, -12($fp)           
          sw    $t0, -20($fp)           
          sw    $t2, -24($fp)           
          b     _L231                   
          nop                           
_L233:                                  
          lw    $t0, 4($fp)             
          lw    $t1, -20($fp)           
          sw    $t1, 4($t0)             
          li    $t1, 0                  
          move  $t2, $t1                
          sw    $t0, 4($fp)             
          sw    $t2, -28($fp)           
_L235:                                  
          li    $t0, 8                  
          lw    $t1, -28($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -28($fp)           
          beqz  $t2, _L243              
          nop                           
_L236:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t3, -28($fp)           
          slt   $t4, $t3, $t2           
          sw    $t0, 4($fp)             
          sw    $t3, -28($fp)           
          sw    $t1, -32($fp)           
          beqz  $t4, _L238              
          nop                           
_L237:                                  
          li    $t0, 0                  
          lw    $t1, -28($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -28($fp)           
          beqz  $t2, _L239              
          nop                           
_L238:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L239:                                  
          li    $t0, 4                  
          lw    $t1, -28($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -32($fp)           
          addu  $t3, $t0, $t2           
          lw    $t2, 0($t3)             
          sw    $t1, -28($fp)           
          sw    $t0, -32($fp)           
          jal   _Deck_New               
          nop                           
          move  $t2, $v0                
          lw    $t1, -28($fp)           
          lw    $t0, -32($fp)           
          li    $t3, 4                  
          mult  $t1, $t3                
          mflo  $t4                     
          addu  $t3, $t0, $t4           
          sw    $t2, 0($t3)             
          lw    $t0, 4($fp)             
          lw    $t2, 4($t0)             
          lw    $t3, -4($t2)            
          slt   $t4, $t1, $t3           
          sw    $t2, -36($fp)           
          sw    $t0, 4($fp)             
          sw    $t1, -28($fp)           
          beqz  $t4, _L241              
          nop                           
_L240:                                  
          li    $t0, 0                  
          lw    $t1, -28($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -28($fp)           
          beqz  $t2, _L242              
          nop                           
_L241:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L242:                                  
          li    $t0, 4                  
          lw    $t1, -28($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -36($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          sw    $t0, 4($sp)             
          lw    $t2, 8($fp)             
          sw    $t2, 8($sp)             
          lw    $t3, 0($t0)             
          lw    $t0, 8($t3)             
          sw    $t2, 8($fp)             
          sw    $t1, -28($fp)           
          jalr  $t0                     
          nop                           
          lw    $t2, 8($fp)             
          lw    $t1, -28($fp)           
          sw    $t2, 8($fp)             
          sw    $t1, -28($fp)           
_L234:                                  
          li    $t0, 1                  
          lw    $t1, -28($fp)           
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -28($fp)           
          b     _L235                   
          nop                           
_L243:                                  
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

_BJDeck.DealCard:                       # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -32           
_L244:                                  
          li    $t0, 0                  
          move  $t1, $t0                
          lw    $t0, 4($fp)             
          lw    $t2, 8($t0)             
          li    $t3, 8                  
          li    $t4, 52                 
          mult  $t3, $t4                
          mflo  $t5                     
          slt   $t3, $t2, $t5           
          xori  $t3, $t3, 1             
          sw    $t1, -8($fp)            
          sw    $t0, 4($fp)             
          beqz  $t3, _L246              
          nop                           
_L245:                                  
          li    $t0, 11                 
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L246:                                  
          li    $t0, 0                  
          lw    $t1, -8($fp)            
          subu  $t2, $t1, $t0           
          sltu  $t2, $zero, $t2         
          xori  $t2, $t2, 1             
          sw    $t1, -8($fp)            
          beqz  $t2, _L251              
          nop                           
_L247:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 12($t0)            
          li    $t2, 8                  
          sw    $t1, 4($sp)             
          sw    $t2, 8($sp)             
          lw    $t2, 0($t1)             
          lw    $t1, 16($t2)            
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          move  $t1, $t2                
          lw    $t2, 4($t0)             
          lw    $t3, -4($t2)            
          slt   $t4, $t1, $t3           
          sw    $t2, -16($fp)           
          sw    $t0, 4($fp)             
          sw    $t1, -12($fp)           
          beqz  $t4, _L249              
          nop                           
_L248:                                  
          li    $t0, 0                  
          lw    $t1, -12($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -12($fp)           
          beqz  $t2, _L250              
          nop                           
_L249:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L250:                                  
          li    $t0, 4                  
          lw    $t1, -12($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -16($fp)           
          addu  $t1, $t0, $t2           
          lw    $t0, 0($t1)             
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t0, 16($t1)            
          jalr  $t0                     
          nop                           
          move  $t1, $v0                
          move  $t0, $t1                
          sw    $t0, -8($fp)            
          b     _L246                   
          nop                           
_L251:                                  
          li    $t0, 10                 
          lw    $t1, -8($fp)            
          slt   $t2, $t0, $t1           
          sw    $t1, -8($fp)            
          beqz  $t2, _L253              
          nop                           
_L252:                                  
          li    $t0, 10                 
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L255:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          lw    $t1, 8($t0)             
          li    $t2, 1                  
          addu  $t3, $t1, $t2           
          sw    $t3, 8($t0)             
          lw    $t0, -8($fp)            
          sw    $t0, 4($fp)             
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L253:                                  
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          subu  $t2, $t1, $t0           
          sltu  $t2, $zero, $t2         
          xori  $t2, $t2, 1             
          sw    $t1, -8($fp)            
          beqz  $t2, _L255              
          nop                           
_L254:                                  
          li    $t0, 11                 
          move  $t1, $t0                
          sw    $t1, -8($fp)            
          b     _L255                   
          nop                           

_BJDeck.Shuffle:                        # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L256:                                  
          la    $t0, _STRING9           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $t0, 0                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L258:                                  
          li    $t0, 8                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L263              
          nop                           
_L259:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t3, -8($fp)            
          slt   $t4, $t3, $t2           
          sw    $t1, -12($fp)           
          sw    $t0, 4($fp)             
          sw    $t3, -8($fp)            
          beqz  $t4, _L261              
          nop                           
_L260:                                  
          li    $t0, 0                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L262              
          nop                           
_L261:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L262:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -12($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          sw    $t0, 4($sp)             
          lw    $t2, 0($t0)             
          lw    $t0, 12($t2)            
          sw    $t1, -8($fp)            
          jalr  $t0                     
          nop                           
          lw    $t1, -8($fp)            
          sw    $t1, -8($fp)            
_L257:                                  
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -8($fp)            
          b     _L258                   
          nop                           
_L263:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          li    $t1, 0                  
          sw    $t1, 8($t0)             
          la    $t1, _STRING10          
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

_BJDeck.NumCardsRemaining:              # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L264:                                  
          li    $t0, 8                  
          li    $t1, 52                 
          mult  $t0, $t1                
          mflo  $t2                     
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          subu  $t3, $t2, $t1           
          sw    $t0, 4($fp)             
          move  $v0, $t3                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Player.Init:                           # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L265:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 20($t0)            
          li    $t1, 1000               
          sw    $t1, 20($t0)            
          la    $t1, _STRING11          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          la    $t2, _STRING12          
          sw    $t2, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 24($t0)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jal   _ReadLine               
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          sw    $t2, 24($t0)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Player.Hit:                            # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -20           
_L266:                                  
          lw    $t0, 8($fp)             
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 12($t1)            
          sw    $t0, 8($fp)             
          jalr  $t2                     
          nop                           
          move  $t1, $v0                
          lw    $t0, 8($fp)             
          move  $t2, $t1                
          lw    $t1, 4($fp)             
          lw    $t3, 24($t1)            
          sw    $t3, 4($sp)             
          sw    $t1, 4($fp)             
          sw    $t0, 8($fp)             
          sw    $t2, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t1, 4($fp)             
          lw    $t0, 8($fp)             
          lw    $t2, -8($fp)            
          la    $t3, _STRING13          
          sw    $t3, 4($sp)             
          sw    $t1, 4($fp)             
          sw    $t0, 8($fp)             
          sw    $t2, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t1, 4($fp)             
          lw    $t0, 8($fp)             
          lw    $t2, -8($fp)            
          sw    $t2, 4($sp)             
          sw    $t1, 4($fp)             
          sw    $t0, 8($fp)             
          sw    $t2, -8($fp)            
          jal   _PrintInt               
          nop                           
          lw    $t1, 4($fp)             
          lw    $t0, 8($fp)             
          lw    $t2, -8($fp)            
          la    $t3, _STRING14          
          sw    $t3, 4($sp)             
          sw    $t1, 4($fp)             
          sw    $t0, 8($fp)             
          sw    $t2, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t1, 4($fp)             
          lw    $t0, 8($fp)             
          lw    $t2, -8($fp)            
          lw    $t3, 4($t1)             
          lw    $t3, 4($t1)             
          addu  $t4, $t3, $t2           
          sw    $t4, 4($t1)             
          lw    $t3, 12($t1)            
          lw    $t3, 12($t1)            
          li    $t4, 1                  
          addu  $t5, $t3, $t4           
          sw    $t5, 12($t1)            
          li    $t3, 11                 
          subu  $t4, $t2, $t3           
          sltu  $t4, $zero, $t4         
          xori  $t4, $t4, 1             
          sw    $t1, 4($fp)             
          sw    $t0, 8($fp)             
          beqz  $t4, _L268              
          nop                           
_L267:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          lw    $t1, 8($t0)             
          li    $t2, 1                  
          addu  $t3, $t1, $t2           
          sw    $t3, 8($t0)             
          sw    $t0, 4($fp)             
_L268:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t2, 21                 
          slt   $t3, $t2, $t1           
          lw    $t1, 8($t0)             
          li    $t2, 0                  
          slt   $t4, $t2, $t1           
          and   $t1, $t3, $t4           
          sw    $t0, 4($fp)             
          beqz  $t1, _L270              
          nop                           
_L269:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t1, 4($t0)             
          li    $t2, 10                 
          subu  $t3, $t1, $t2           
          sw    $t3, 4($t0)             
          lw    $t1, 8($t0)             
          lw    $t1, 8($t0)             
          li    $t2, 1                  
          subu  $t3, $t1, $t2           
          sw    $t3, 8($t0)             
          sw    $t0, 4($fp)             
          b     _L268                   
          nop                           
_L270:                                  
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Player.DoubleDown:                     # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -20           
_L271:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t2, 10                 
          subu  $t3, $t1, $t2           
          sltu  $t3, $zero, $t3         
          lw    $t1, 4($t0)             
          li    $t2, 11                 
          subu  $t4, $t1, $t2           
          sltu  $t4, $zero, $t4         
          and   $t1, $t3, $t4           
          sw    $t0, 4($fp)             
          beqz  $t1, _L273              
          nop                           
_L272:                                  
          li    $t0, 0                  
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L273:                                  
          la    $t0, _STRING15          
          lw    $t1, 4($fp)             
          sw    $t1, 4($sp)             
          sw    $t0, 8($sp)             
          lw    $t0, 0($t1)             
          lw    $t2, 44($t0)            
          sw    $t1, 4($fp)             
          jalr  $t2                     
          nop                           
          move  $t0, $v0                
          lw    $t1, 4($fp)             
          sw    $t1, 4($fp)             
          beqz  $t0, _L275              
          nop                           
_L274:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 16($t0)            
          lw    $t1, 16($t0)            
          li    $t2, 2                  
          mult  $t1, $t2                
          mflo  $t3                     
          sw    $t3, 16($t0)            
          sw    $t0, 4($sp)             
          lw    $t1, 8($fp)             
          sw    $t1, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 12($t2)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jalr  $t3                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 24($t0)            
          sw    $t2, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          la    $t2, _STRING16          
          sw    $t2, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          lw    $t2, 4($t0)             
          sw    $t2, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          la    $t2, _STRING14          
          sw    $t2, 4($sp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          li    $t2, 1                  
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          move  $v0, $t2                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L275:                                  
          li    $t0, 0                  
          move  $v0, $t0                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Player.TakeTurn:                       # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L277:                                  
          la    $t0, _STRING17          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING18          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          lw    $t1, 8($t0)             
          li    $t1, 0                  
          sw    $t1, 8($t0)             
          lw    $t1, 12($t0)            
          li    $t1, 0                  
          sw    $t1, 12($t0)            
          sw    $t0, 4($sp)             
          lw    $t1, 8($fp)             
          sw    $t1, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 12($t2)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jalr  $t3                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          sw    $t0, 4($sp)             
          sw    $t1, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 12($t2)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jalr  $t3                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          sw    $t0, 4($sp)             
          sw    $t1, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 16($t2)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jalr  $t3                     
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          nor   $t3, $t2, $zero         
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          beqz  $t3, _L282              
          nop                           
_L278:                                  
          li    $t0, 1                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L279:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t2, 21                 
          slt   $t3, $t2, $t1           
          xori  $t3, $t3, 1             
          lw    $t1, -8($fp)            
          and   $t2, $t3, $t1           
          sw    $t0, 4($fp)             
          beqz  $t2, _L282              
          nop                           
_L280:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING16          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING14          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING19          
          sw    $t0, 4($sp)             
          sw    $t1, 8($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 44($t1)            
          sw    $t0, 4($fp)             
          jalr  $t2                     
          nop                           
          move  $t1, $v0                
          lw    $t0, 4($fp)             
          move  $t2, $t1                
          sw    $t0, 4($fp)             
          sw    $t2, -8($fp)            
          beqz  $t2, _L279              
          nop                           
_L281:                                  
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          lw    $t1, 8($fp)             
          sw    $t1, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 12($t2)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jalr  $t3                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          b     _L279                   
          nop                           
_L282:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t2, 21                 
          slt   $t3, $t2, $t1           
          sw    $t0, 4($fp)             
          beqz  $t3, _L284              
          nop                           
_L283:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING20          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING21          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
_L285:                                  
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L284:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING22          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING14          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
          b     _L285                   
          nop                           

_Player.HasMoney:                       # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L286:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 20($t0)            
          li    $t2, 0                  
          slt   $t3, $t2, $t1           
          sw    $t0, 4($fp)             
          move  $v0, $t3                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Player.PrintMoney:                     # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L287:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING23          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 20($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING14          
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

_Player.PlaceBet:                       # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L288:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 16($t0)            
          li    $t1, 0                  
          sw    $t1, 16($t0)            
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 28($t1)            
          sw    $t0, 4($fp)             
          jalr  $t2                     
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
_L289:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 16($t0)            
          li    $t2, 0                  
          slt   $t3, $t2, $t1           
          xori  $t3, $t3, 1             
          lw    $t1, 16($t0)            
          lw    $t2, 20($t0)            
          slt   $t4, $t2, $t1           
          or    $t1, $t3, $t4           
          sw    $t0, 4($fp)             
          beqz  $t1, _L291              
          nop                           
_L290:                                  
          la    $t0, _STRING24          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 16($t0)            
          sw    $t0, 4($fp)             
          jal   _ReadInteger            
          nop                           
          move  $t1, $v0                
          lw    $t0, 4($fp)             
          sw    $t1, 16($t0)            
          sw    $t0, 4($fp)             
          b     _L289                   
          nop                           
_L291:                                  
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Player.GetTotal:                       # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L292:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          sw    $t0, 4($fp)             
          move  $v0, $t1                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Player.Resolve:                        # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L293:                                  
          li    $t0, 0                  
          move  $t1, $t0                
          li    $t0, 0                  
          move  $t2, $t0                
          lw    $t0, 4($fp)             
          lw    $t3, 4($t0)             
          li    $t4, 21                 
          subu  $t5, $t3, $t4           
          sltu  $t5, $zero, $t5         
          xori  $t5, $t5, 1             
          lw    $t3, 12($t0)            
          li    $t4, 2                  
          subu  $t6, $t3, $t4           
          sltu  $t6, $zero, $t6         
          xori  $t6, $t6, 1             
          and   $t3, $t5, $t6           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          sw    $t2, -12($fp)           
          beqz  $t3, _L295              
          nop                           
_L294:                                  
          li    $t0, 2                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L303:                                  
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          xori  $t2, $t2, 1             
          sw    $t1, -8($fp)            
          beqz  $t2, _L305              
          nop                           
_L304:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING25          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 16($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING14          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
_L308:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 16($t0)            
          lw    $t2, -8($fp)            
          mult  $t2, $t1                
          mflo  $t3                     
          move  $t2, $t3                
          lw    $t1, 16($t0)            
          lw    $t3, -12($fp)           
          mult  $t3, $t1                
          mflo  $t4                     
          move  $t3, $t4                
          lw    $t1, 20($t0)            
          lw    $t1, 20($t0)            
          addu  $t4, $t1, $t2           
          subu  $t1, $t4, $t3           
          sw    $t1, 20($t0)            
          sw    $t0, 4($fp)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L305:                                  
          li    $t0, 1                  
          lw    $t1, -12($fp)           
          slt   $t2, $t1, $t0           
          xori  $t2, $t2, 1             
          sw    $t1, -12($fp)           
          beqz  $t2, _L307              
          nop                           
_L306:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING26          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 16($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING14          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
          b     _L308                   
          nop                           
_L307:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING27          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
          b     _L308                   
          nop                           
_L295:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t2, 21                 
          slt   $t3, $t2, $t1           
          sw    $t0, 4($fp)             
          beqz  $t3, _L297              
          nop                           
_L296:                                  
          li    $t0, 1                  
          move  $t1, $t0                
          sw    $t1, -12($fp)           
          b     _L303                   
          nop                           
_L297:                                  
          li    $t0, 21                 
          lw    $t1, 8($fp)             
          slt   $t2, $t0, $t1           
          sw    $t1, 8($fp)             
          beqz  $t2, _L299              
          nop                           
_L298:                                  
          li    $t0, 1                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
          b     _L303                   
          nop                           
_L299:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, 8($fp)             
          slt   $t3, $t2, $t1           
          sw    $t0, 4($fp)             
          sw    $t2, 8($fp)             
          beqz  $t3, _L301              
          nop                           
_L300:                                  
          li    $t0, 1                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
          b     _L303                   
          nop                           
_L301:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, 8($fp)             
          slt   $t3, $t1, $t2           
          sw    $t0, 4($fp)             
          sw    $t2, 8($fp)             
          beqz  $t3, _L303              
          nop                           
_L302:                                  
          li    $t0, 1                  
          move  $t1, $t0                
          sw    $t1, -12($fp)           
          b     _L303                   
          nop                           

_Player.GetYesOrNo:                     # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L309:                                  
          lw    $t0, 8($fp)             
          sw    $t0, 4($sp)             
          sw    $t0, 8($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 8($fp)             
          la    $t1, _STRING28          
          sw    $t1, 4($sp)             
          sw    $t0, 8($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 8($fp)             
          sw    $t0, 8($fp)             
          jal   _ReadInteger            
          nop                           
          move  $t1, $v0                
          lw    $t0, 8($fp)             
          li    $t2, 0                  
          subu  $t3, $t1, $t2           
          sltu  $t3, $zero, $t3         
          sw    $t0, 8($fp)             
          move  $v0, $t3                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Dealer.Init:                           # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -12           
_L310:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t1, 0                  
          sw    $t1, 4($t0)             
          lw    $t1, 8($t0)             
          li    $t1, 0                  
          sw    $t1, 8($t0)             
          lw    $t1, 12($t0)            
          li    $t1, 0                  
          sw    $t1, 12($t0)            
          la    $t1, _STRING4           
          move  $t2, $t1                
          lw    $t1, 24($t0)            
          sw    $t2, 24($t0)            
          sw    $t0, 4($fp)             
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Dealer.TakeTurn:                       # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -20           
_L311:                                  
          la    $t0, _STRING17          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING18          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
_L312:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t2, 16                 
          slt   $t3, $t2, $t1           
          xori  $t3, $t3, 1             
          sw    $t0, 4($fp)             
          beqz  $t3, _L314              
          nop                           
_L313:                                  
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          lw    $t1, 8($fp)             
          sw    $t1, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t3, 12($t2)            
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          jalr  $t3                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($fp)             
          sw    $t0, 4($fp)             
          sw    $t1, 8($fp)             
          b     _L312                   
          nop                           
_L314:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          li    $t2, 21                 
          slt   $t3, $t2, $t1           
          sw    $t0, 4($fp)             
          beqz  $t3, _L316              
          nop                           
_L315:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING20          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING21          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
_L317:                                  
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           
_L316:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 24($t0)            
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING22          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintInt               
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING14          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
          b     _L317                   
          nop                           

_House.SetupGame:                       # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L318:                                  
          la    $t0, _STRING29          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          la    $t0, _STRING30          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _rndModule_New          
          nop                           
          move  $t0, $v0                
          move  $t1, $t0                
          la    $t0, _STRING31          
          sw    $t0, 4($sp)             
          sw    $t1, -8($fp)            
          jal   _PrintString            
          nop                           
          lw    $t1, -8($fp)            
          sw    $t1, -8($fp)            
          jal   _ReadInteger            
          nop                           
          move  $t0, $v0                
          lw    $t1, -8($fp)            
          sw    $t1, 4($sp)             
          sw    $t0, 8($sp)             
          lw    $t0, 0($t1)             
          lw    $t2, 8($t0)             
          sw    $t1, -8($fp)            
          jalr  $t2                     
          nop                           
          lw    $t1, -8($fp)            
          lw    $t0, 4($fp)             
          lw    $t2, 12($t0)            
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          jal   _BJDeck_New             
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          lw    $t1, -8($fp)            
          sw    $t2, 12($t0)            
          lw    $t2, 8($t0)             
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          jal   _Dealer_New             
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          lw    $t1, -8($fp)            
          sw    $t2, 8($t0)             
          lw    $t2, 12($t0)            
          sw    $t2, 4($sp)             
          sw    $t1, 8($sp)             
          lw    $t1, 0($t2)             
          lw    $t2, 8($t1)             
          sw    $t0, 4($fp)             
          jalr  $t2                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 12($t0)            
          sw    $t1, 4($sp)             
          lw    $t2, 0($t1)             
          lw    $t1, 16($t2)            
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

_House.SetupPlayers:                    # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -52           
_L319:                                  
          la    $t0, _STRING32          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _ReadInteger            
          nop                           
          move  $t0, $v0                
          move  $t1, $t0                
          lw    $t0, 4($fp)             
          lw    $t2, 4($t0)             
          li    $t2, 0                  
          slt   $t3, $t1, $t2           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          beqz  $t3, _L321              
          nop                           
_L320:                                  
          la    $t0, _STRING7           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L321:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t0, $t1                
          mflo  $t2                     
          addu  $t3, $t0, $t2           
          sw    $t3, 4($sp)             
          sw    $t0, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t1, -8($fp)            
          jal   _Alloc                  
          nop                           
          move  $t2, $v0                
          lw    $t0, -12($fp)           
          lw    $t3, -16($fp)           
          lw    $t1, -8($fp)            
          sw    $t1, 0($t2)             
          li    $t1, 0                  
          addu  $t2, $t2, $t3           
          sw    $t0, -12($fp)           
          sw    $t3, -16($fp)           
          sw    $t2, -20($fp)           
          sw    $t1, -24($fp)           
_L322:                                  
          lw    $t0, -16($fp)           
          lw    $t1, -12($fp)           
          subu  $t0, $t0, $t1           
          sw    $t1, -12($fp)           
          sw    $t0, -16($fp)           
          beqz  $t0, _L324              
          nop                           
_L323:                                  
          lw    $t0, -20($fp)           
          lw    $t1, -12($fp)           
          subu  $t0, $t0, $t1           
          lw    $t2, -24($fp)           
          sw    $t2, 0($t0)             
          sw    $t1, -12($fp)           
          sw    $t0, -20($fp)           
          sw    $t2, -24($fp)           
          b     _L322                   
          nop                           
_L324:                                  
          lw    $t0, 4($fp)             
          lw    $t1, -20($fp)           
          sw    $t1, 4($t0)             
          li    $t1, 0                  
          move  $t2, $t1                
          sw    $t0, 4($fp)             
          sw    $t2, -28($fp)           
_L326:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t1, -28($fp)           
          slt   $t3, $t1, $t2           
          sw    $t0, 4($fp)             
          sw    $t1, -28($fp)           
          beqz  $t3, _L334              
          nop                           
_L327:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t3, -28($fp)           
          slt   $t4, $t3, $t2           
          sw    $t0, 4($fp)             
          sw    $t3, -28($fp)           
          sw    $t1, -32($fp)           
          beqz  $t4, _L329              
          nop                           
_L328:                                  
          li    $t0, 0                  
          lw    $t1, -28($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -28($fp)           
          beqz  $t2, _L330              
          nop                           
_L329:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L330:                                  
          li    $t0, 4                  
          lw    $t1, -28($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -32($fp)           
          addu  $t3, $t0, $t2           
          lw    $t2, 0($t3)             
          sw    $t1, -28($fp)           
          sw    $t0, -32($fp)           
          jal   _Player_New             
          nop                           
          move  $t2, $v0                
          lw    $t1, -28($fp)           
          lw    $t0, -32($fp)           
          li    $t3, 4                  
          mult  $t1, $t3                
          mflo  $t4                     
          addu  $t3, $t0, $t4           
          sw    $t2, 0($t3)             
          lw    $t0, 4($fp)             
          lw    $t2, 4($t0)             
          lw    $t3, -4($t2)            
          slt   $t4, $t1, $t3           
          sw    $t0, 4($fp)             
          sw    $t1, -28($fp)           
          sw    $t2, -36($fp)           
          beqz  $t4, _L332              
          nop                           
_L331:                                  
          li    $t0, 0                  
          lw    $t1, -28($fp)           
          slt   $t2, $t1, $t0           
          sw    $t1, -28($fp)           
          beqz  $t2, _L333              
          nop                           
_L332:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L333:                                  
          li    $t0, 4                  
          lw    $t1, -28($fp)           
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -36($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          li    $t2, 1                  
          addu  $t3, $t1, $t2           
          sw    $t0, 4($sp)             
          sw    $t3, 8($sp)             
          lw    $t2, 0($t0)             
          lw    $t0, 8($t2)             
          sw    $t1, -28($fp)           
          jalr  $t0                     
          nop                           
          lw    $t1, -28($fp)           
          sw    $t1, -28($fp)           
_L325:                                  
          li    $t0, 1                  
          lw    $t1, -28($fp)           
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -28($fp)           
          b     _L326                   
          nop                           
_L334:                                  
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_House.TakeAllBets:                     # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -28           
_L335:                                  
          la    $t0, _STRING33          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $t0, 0                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L337:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t1, -8($fp)            
          slt   $t3, $t1, $t2           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          beqz  $t3, _L346              
          nop                           
_L338:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t3, -8($fp)            
          slt   $t4, $t3, $t2           
          sw    $t1, -12($fp)           
          sw    $t0, 4($fp)             
          sw    $t3, -8($fp)            
          beqz  $t4, _L340              
          nop                           
_L339:                                  
          li    $t0, 0                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L341              
          nop                           
_L340:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L341:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -12($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          sw    $t0, 4($sp)             
          lw    $t2, 0($t0)             
          lw    $t0, 24($t2)            
          sw    $t1, -8($fp)            
          jalr  $t0                     
          nop                           
          move  $t2, $v0                
          lw    $t1, -8($fp)            
          sw    $t1, -8($fp)            
          beqz  $t2, _L336              
          nop                           
_L342:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t3, -8($fp)            
          slt   $t4, $t3, $t2           
          sw    $t1, -16($fp)           
          sw    $t0, 4($fp)             
          sw    $t3, -8($fp)            
          beqz  $t4, _L344              
          nop                           
_L343:                                  
          li    $t0, 0                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L345              
          nop                           
_L344:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L345:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -16($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          sw    $t0, 4($sp)             
          lw    $t2, 0($t0)             
          lw    $t0, 32($t2)            
          sw    $t1, -8($fp)            
          jalr  $t0                     
          nop                           
          lw    $t1, -8($fp)            
          sw    $t1, -8($fp)            
_L336:                                  
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -8($fp)            
          b     _L337                   
          nop                           
_L346:                                  
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_House.TakeAllTurns:                    # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -32           
_L347:                                  
          li    $t0, 0                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L349:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t1, -8($fp)            
          slt   $t3, $t1, $t2           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          beqz  $t3, _L358              
          nop                           
_L350:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t3, -8($fp)            
          slt   $t4, $t3, $t2           
          sw    $t1, -12($fp)           
          sw    $t0, 4($fp)             
          sw    $t3, -8($fp)            
          beqz  $t4, _L352              
          nop                           
_L351:                                  
          li    $t0, 0                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L353              
          nop                           
_L352:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L353:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -12($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          sw    $t0, 4($sp)             
          lw    $t2, 0($t0)             
          lw    $t0, 24($t2)            
          sw    $t1, -8($fp)            
          jalr  $t0                     
          nop                           
          move  $t2, $v0                
          lw    $t1, -8($fp)            
          sw    $t1, -8($fp)            
          beqz  $t2, _L348              
          nop                           
_L354:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t3, -8($fp)            
          slt   $t4, $t3, $t2           
          sw    $t1, -16($fp)           
          sw    $t0, 4($fp)             
          sw    $t3, -8($fp)            
          beqz  $t4, _L356              
          nop                           
_L355:                                  
          li    $t0, 0                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L357              
          nop                           
_L356:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L357:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -16($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          lw    $t2, 4($fp)             
          lw    $t3, 12($t2)            
          sw    $t0, 4($sp)             
          sw    $t3, 8($sp)             
          lw    $t3, 0($t0)             
          lw    $t0, 20($t3)            
          sw    $t2, 4($fp)             
          sw    $t1, -8($fp)            
          jalr  $t0                     
          nop                           
          lw    $t2, 4($fp)             
          lw    $t1, -8($fp)            
          sw    $t2, 4($fp)             
          sw    $t1, -8($fp)            
_L348:                                  
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -8($fp)            
          b     _L349                   
          nop                           
_L358:                                  
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_House.ResolveAllPlayers:               # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -36           
_L359:                                  
          la    $t0, _STRING34          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $t0, 0                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L361:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t1, -8($fp)            
          slt   $t3, $t1, $t2           
          sw    $t0, 4($fp)             
          sw    $t1, -8($fp)            
          beqz  $t3, _L370              
          nop                           
_L362:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t3, -8($fp)            
          slt   $t4, $t3, $t2           
          sw    $t1, -12($fp)           
          sw    $t0, 4($fp)             
          sw    $t3, -8($fp)            
          beqz  $t4, _L364              
          nop                           
_L363:                                  
          li    $t0, 0                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L365              
          nop                           
_L364:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L365:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -12($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          sw    $t0, 4($sp)             
          lw    $t2, 0($t0)             
          lw    $t0, 24($t2)            
          sw    $t1, -8($fp)            
          jalr  $t0                     
          nop                           
          move  $t2, $v0                
          lw    $t1, -8($fp)            
          sw    $t1, -8($fp)            
          beqz  $t2, _L360              
          nop                           
_L366:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t3, -8($fp)            
          slt   $t4, $t3, $t2           
          sw    $t1, -16($fp)           
          sw    $t0, 4($fp)             
          sw    $t3, -8($fp)            
          beqz  $t4, _L368              
          nop                           
_L367:                                  
          li    $t0, 0                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L369              
          nop                           
_L368:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L369:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -16($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          lw    $t2, 4($fp)             
          lw    $t3, 8($t2)             
          sw    $t3, 4($sp)             
          lw    $t4, 0($t3)             
          lw    $t3, 36($t4)            
          sw    $t2, 4($fp)             
          sw    $t0, -20($fp)           
          sw    $t1, -8($fp)            
          jalr  $t3                     
          nop                           
          move  $t4, $v0                
          lw    $t2, 4($fp)             
          lw    $t0, -20($fp)           
          lw    $t1, -8($fp)            
          sw    $t0, 4($sp)             
          sw    $t4, 8($sp)             
          lw    $t3, 0($t0)             
          lw    $t0, 40($t3)            
          sw    $t2, 4($fp)             
          sw    $t1, -8($fp)            
          jalr  $t0                     
          nop                           
          lw    $t2, 4($fp)             
          lw    $t1, -8($fp)            
          sw    $t2, 4($fp)             
          sw    $t1, -8($fp)            
_L360:                                  
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -8($fp)            
          b     _L361                   
          nop                           
_L370:                                  
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_House.PrintAllMoney:                   # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -24           
_L371:                                  
          li    $t0, 0                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
_L373:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t1, -8($fp)            
          slt   $t3, $t1, $t2           
          sw    $t1, -8($fp)            
          sw    $t0, 4($fp)             
          beqz  $t3, _L378              
          nop                           
_L374:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 4($t0)             
          lw    $t2, -4($t1)            
          lw    $t3, -8($fp)            
          slt   $t4, $t3, $t2           
          sw    $t3, -8($fp)            
          sw    $t0, 4($fp)             
          sw    $t1, -12($fp)           
          beqz  $t4, _L376              
          nop                           
_L375:                                  
          li    $t0, 0                  
          lw    $t1, -8($fp)            
          slt   $t2, $t1, $t0           
          sw    $t1, -8($fp)            
          beqz  $t2, _L377              
          nop                           
_L376:                                  
          la    $t0, _STRING8           
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          jal   _Halt                   
          nop                           
_L377:                                  
          li    $t0, 4                  
          lw    $t1, -8($fp)            
          mult  $t1, $t0                
          mflo  $t2                     
          lw    $t0, -12($fp)           
          addu  $t3, $t0, $t2           
          lw    $t0, 0($t3)             
          sw    $t0, 4($sp)             
          lw    $t2, 0($t0)             
          lw    $t0, 28($t2)            
          sw    $t1, -8($fp)            
          jalr  $t0                     
          nop                           
          lw    $t1, -8($fp)            
          sw    $t1, -8($fp)            
_L372:                                  
          li    $t0, 1                  
          lw    $t1, -8($fp)            
          addu  $t2, $t1, $t0           
          move  $t1, $t2                
          sw    $t1, -8($fp)            
          b     _L373                   
          nop                           
_L378:                                  
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_House.PlayOneGame:                     # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -20           
_L379:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 12($t0)            
          sw    $t1, 4($sp)             
          lw    $t2, 0($t1)             
          lw    $t1, 20($t2)            
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          move  $t2, $v0                
          lw    $t0, 4($fp)             
          li    $t1, 26                 
          slt   $t3, $t2, $t1           
          sw    $t0, 4($fp)             
          beqz  $t3, _L381              
          nop                           
_L380:                                  
          lw    $t0, 4($fp)             
          lw    $t1, 12($t0)            
          sw    $t1, 4($sp)             
          lw    $t2, 0($t1)             
          lw    $t1, 16($t2)            
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
_L381:                                  
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 16($t1)            
          sw    $t0, 4($fp)             
          jalr  $t2                     
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING35          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          li    $t2, 0                  
          sw    $t1, 4($sp)             
          sw    $t2, 8($sp)             
          lw    $t2, 0($t1)             
          lw    $t1, 8($t2)             
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          lw    $t2, 12($t0)            
          sw    $t1, 4($sp)             
          sw    $t2, 8($sp)             
          lw    $t2, 0($t1)             
          lw    $t1, 12($t2)            
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 20($t1)            
          sw    $t0, 4($fp)             
          jalr  $t2                     
          nop                           
          lw    $t0, 4($fp)             
          lw    $t1, 8($t0)             
          lw    $t2, 12($t0)            
          sw    $t1, 4($sp)             
          sw    $t2, 8($sp)             
          lw    $t2, 0($t1)             
          lw    $t1, 20($t2)            
          sw    $t0, 4($fp)             
          jalr  $t1                     
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 24($t1)            
          sw    $t0, 4($fp)             
          jalr  $t2                     
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
          addiu $sp, $sp, -24           
_L382:                                  
          li    $t0, 1                  
          move  $t1, $t0                
          sw    $t1, -8($fp)            
          jal   _House_New              
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
          sw    $t2, 4($sp)             
          lw    $t0, 0($t2)             
          lw    $t3, 12($t0)            
          sw    $t1, -8($fp)            
          sw    $t2, -12($fp)           
          jalr  $t3                     
          nop                           
          lw    $t1, -8($fp)            
          lw    $t2, -12($fp)           
          sw    $t1, -8($fp)            
          sw    $t2, -12($fp)           
_L383:                                  
          lw    $t0, -8($fp)            
          beqz  $t0, _L385              
          nop                           
_L384:                                  
          lw    $t0, -12($fp)           
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t2, 32($t1)            
          sw    $t0, -12($fp)           
          jalr  $t2                     
          nop                           
          lw    $t0, -12($fp)           
          la    $t1, _STRING36          
          sw    $t1, 4($sp)             
          sw    $t0, -12($fp)           
          jal   _Main.GetYesOrNo        
          nop                           
          move  $t1, $v0                
          lw    $t0, -12($fp)           
          move  $t2, $t1                
          sw    $t2, -8($fp)            
          sw    $t0, -12($fp)           
          b     _L383                   
          nop                           
_L385:                                  
          lw    $t0, -12($fp)           
          sw    $t0, 4($sp)             
          lw    $t1, 0($t0)             
          lw    $t0, 28($t1)            
          jalr  $t0                     
          nop                           
          la    $t0, _STRING37          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          la    $t0, _STRING38          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          la    $t0, _STRING39          
          sw    $t0, 4($sp)             
          jal   _PrintString            
          nop                           
          li    $v0, 0                  
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           

_Main.GetYesOrNo:                       # function entry
          sw $fp, 0($sp)                
          sw $ra, -4($sp)               
          move $fp, $sp                 
          addiu $sp, $sp, -16           
_L386:                                  
          lw    $t0, 4($fp)             
          sw    $t0, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          la    $t1, _STRING28          
          sw    $t1, 4($sp)             
          sw    $t0, 4($fp)             
          jal   _PrintString            
          nop                           
          lw    $t0, 4($fp)             
          sw    $t0, 4($fp)             
          jal   _ReadInteger            
          nop                           
          move  $t1, $v0                
          lw    $t0, 4($fp)             
          li    $t2, 0                  
          subu  $t3, $t1, $t2           
          sltu  $t3, $zero, $t3         
          sw    $t0, 4($fp)             
          move  $v0, $t3                
          move  $sp, $fp                
          lw    $ra, -4($fp)            
          lw    $fp, 0($fp)             
          jr    $ra                     
          nop                           




          .data                         
_STRING9:
          .asciiz "Shuffling..."        
_STRING12:
          .asciiz "? "                  
_STRING2:
          .asciiz "BJDeck"              
_STRING19:
          .asciiz "Would you like a hit?"
_STRING22:
          .asciiz " stays at "          
_STRING21:
          .asciiz "!\n"                 
_STRING37:
          .asciiz "Thank you for playing...come again soon.\n"
_STRING17:
          .asciiz "\n"                  
_STRING35:
          .asciiz "\nDealer starts. "   
_STRING13:
          .asciiz " was dealt a "       
_STRING27:
          .asciiz ", you push!\n"       
_STRING34:
          .asciiz "\nTime to resolve bets.\n"
_STRING32:
          .asciiz "How many players do we have today? "
_STRING38:
          .asciiz "\nCS143 BlackJack Copyright (c) 1999 by Peter Mork.\n"
_STRING14:
          .asciiz ".\n"                 
_STRING3:
          .asciiz "Player"              
_STRING7:
          .asciiz "Decaf runtime error: Cannot create negative-sized array\n"
_STRING24:
          .asciiz "How much would you like to bet? "
_STRING31:
          .asciiz "Please enter a random number seed: "
_STRING11:
          .asciiz "What is the name of player #"
_STRING1:
          .asciiz "Deck"                
_STRING25:
          .asciiz ", you won $"         
_STRING5:
          .asciiz "House"               
_STRING10:
          .asciiz "done.\n"             
_STRING30:
          .asciiz "---------------------------\n"
_STRING0:
          .asciiz "rndModule"           
_STRING39:
          .asciiz "(2001 mods by jdz)\n"
_STRING15:
          .asciiz "Would you like to double down?"
_STRING26:
          .asciiz ", you lost $"        
_STRING36:
          .asciiz "\nDo you want to play another hand?"
_STRING33:
          .asciiz "\nFirst, let's take bets.\n"
_STRING16:
          .asciiz ", your total is "    
_STRING23:
          .asciiz ", you have $"        
_STRING28:
          .asciiz " (0=No/1=Yes) "      
_STRING6:
          .asciiz "Main"                
_STRING18:
          .asciiz "'s turn.\n"          
_STRING20:
          .asciiz " busts with the big "
_STRING4:
          .asciiz "Dealer"              
_STRING8:
          .asciiz "Decaf runtime error: Array subscript out of bounds\n"
_STRING29:
          .asciiz "\nWelcome to CS143 BlackJack!\n"
