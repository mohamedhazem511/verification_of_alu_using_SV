/*
  ##################################################################################
  ###   File:      [driver.sv]                                                   ###
  ###   Author:    [Mohamed Hazem Mamdouh]                                       ###
  ###   Date:      [3 / 12 / 2023]                                               ###
  ###   Brief:     [gets the packet from generator and                           ###
  ###                drive the transaction paket items into interface]           ###
  ###                                                                            ###
  ##################################################################################
*/
/******************************* Driver ********************************/
  class driver;

  //creating virtual interface handle
    virtual aluifc vif;

    Transaction tr;
  //creating mailbox handle
    mailbox gen2driv;

    function new (virtual aluifc vif , mailbox gen2driv);
     tr = new();
     this.vif = vif;
     this.gen2driv = gen2driv;
    endfunction

    
     

    task main();
     forever  begin
        gen2driv.get(tr);
        
        vif.alu_in_a    = tr.alu_in_a;
        vif.alu_in_b    = tr.alu_in_b;
        vif.alu_irq_clr = tr.alu_irq_clr;
        vif.alu_mode    = tr.alu_mode;
        vif.alu_op_a    = tr.alu_op_a;
        vif.alu_op_b    = tr.alu_op_b;
        
     
      end
    endtask

  endclass