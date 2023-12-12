/*
  ##################################################################################
  ###   File:      [monitor.sv]                                                  ###
  ###   Author:    [Mohamed Hazem Mamdouh]                                       ###
  ###   Date:      [3 / 12 / 2023]                                               ###
  ###   Brief:     [Samples the interface signals and                            ###
  ###               converts the signal level activity to the transaction level. ###
  ###              Send the sampled transaction to Scoreboard via Mailbox.]      ###
  ###                                                                            ###
  ##################################################################################
*/


class monitor;
  
  //creating virtual interface handle
  virtual aluifc vif;
  
  //creating mailbox handle
  mailbox mon2scb;
  
  //constructor
  function new(virtual aluifc vif, mailbox mon2scb);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main();
    forever begin
      Transaction tr;
      tr = new();
      
      repeat (2) @(posedge vif.alu_clk);
      tr.alu_in_a    = vif.alu_in_a;
      tr.alu_in_b    = vif.alu_in_b;
      tr.alu_mode    = vif.alu_mode;
      tr.alu_irq_clr = vif.alu_irq_clr;
      tr.alu_op_a    = vif.alu_op_a;
      tr.alu_op_b    = vif.alu_op_b;
      tr.alu_out     = vif.alu_out;
      tr.alu_irq     = vif.alu_irq;
      
      
      mon2scb.put(tr);
      
      $display("[ monitor ] alu_in_a = %h , alu_in_b = %h , alu_irq_clr = %d , alu_op_a = %s , alu_op_b = %s , alu_operation_mode  = %s \n",
                   tr.alu_in_a ,tr.alu_in_b , tr.alu_irq_clr , tr.alu_op_a , tr.alu_op_b , tr.alu_mode );
     
    end
  endtask
  
endclass