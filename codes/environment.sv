/*
  ##################################################################################
  ###   File:      [environment.sv]                                              ###
  ###   Author:    [Mohamed Hazem Mamdouh]                                       ###
  ###   Date:      [3 / 12 / 2023]                                               ###
  ###   Brief:     [Contains all the verification components ]                   ###
  ###                                                                            ###
  ##################################################################################
*/ 
  /******************************* Environment ********************************/
//`include "alu_pkg.sv"
 import alu_pkg::*;

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv" 
`include "monitor.sv"
`include "scoreboard.sv"

  
  class environment;

   generator  gen;
   driver     drv;
   monitor    mon;
   scoreboard scb;

   //mailbox handle's
   mailbox gen2driv;
   mailbox mon2scb;
    
   virtual aluifc vif;
    
  function new (virtual aluifc vif);
    this.vif = vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    mon2scb = new();

    gen = new(gen2driv);
    drv = new(vif,gen2driv);
    mon = new(vif,mon2scb);
    scb = new(vif,mon2scb); 
    
  endfunction

  task run();
  
    fork 
    gen.main();
    drv.main();
    mon.main();
    scb.main();      
    join
   
  endtask
  
  endclass