/*
  ##################################################################################
  ###   File:      [generator.sv]                                                ###
  ###   Author:    [Mohamed Hazem Mamdouh]                                       ###
  ###   Date:      [3 / 12 / 2023]                                               ###
  ###   Brief:     [generator component which generate stimulus for driver ]     ###
  ###                                                                            ###
  ##################################################################################
*/

  /*********************************** Generator **********************************/

  class generator;

    int x = 0;
    
    Transaction tr;
    mailbox gen2driv;

    function new (mailbox gen2driv);
     this.gen2driv = gen2driv;
    endfunction

    
       
    task main();
      tr=new();
      repeat (num) begin
        x++;
        if (x <= num/4.0) begin
          
        assert(tr.randomize());
        gen2driv.put(tr);
        @(ev_1);
          
        end
        else if ((x> num/4.0) & (x<=num/2.0)) begin
        assert(tr.randomize() with {
                            alu_mode == operation_mode_a;
                            (
                              (alu_in_a == 8'hFF && alu_in_b == 8'hFF && alu_op_a == xnor_b)  || 
                              (alu_in_a == 8'hFF && alu_in_b == 8'hFF && alu_op_a == and_b)   ||
                              (alu_in_a == 8'hF0 && alu_in_b == 8'hF8 && alu_op_a == nor_b)   ||
                              (alu_in_a == 8'h83 && alu_in_b == 8'h00 && alu_op_a == or_b)
                            ); });
          $display(" irq for operation mode a ");
          
        gen2driv.put(tr);
        @(ev_1);
          
        end
        else if ((x> num/2.0) & ( x<= 3*num/4.0)) begin
        assert(tr.randomize() with {
                            alu_mode == operation_mode_b;
                            (
                              (alu_in_a == 8'h0E && alu_in_b == 8'h00 && alu_op_a == and_a)  || 
                              (alu_in_a == 8'hF4 && alu_in_b == 8'hFF && alu_op_a == nand_a) ||
                              (alu_in_a == 8'h0A && alu_in_b == 8'h00 && alu_op_a == or_a)   ||
                              (alu_in_a == 8'hFF && alu_in_b == 8'h00 && alu_op_a == xor_a)
                            ); });  
          $display(" irq for operation mode b ");
        gen2driv.put(tr);
        @(ev_1);
          
        end
        
        else begin
          
        assert(tr.randomize());
        gen2driv.put(tr);
        @(ev_1);
          
        end
    end
      $display("[PASSED] = %0d , [FAILED] = %0d  \n ", passed, failed);
      -> ev_2;
      
    endtask
    
  endclass