/*
  ##################################################################################
  ###   File:      [scoreboard.sv]                                               ###
  ###   Author:    [Mohamed Hazem Mamdouh]                                       ###
  ###   Date:      [3 / 12 / 2023]                                               ###
  ###   Brief:     [gets the packet from monitor, Generated the expected result  ###
  ###              and compares with the //actual result recived from Monitor]   ###
  ###                                                                            ###
  ##################################################################################
*/

 import alu_pkg::*;
class scoreboard;
   
 //creating virtual interface handle
    virtual aluifc vif;
  
  //creating mailbox handle
  mailbox mon2scb;
  

  
  //constructor
  function new(virtual aluifc vif ,mailbox mon2scb);
     this.vif = vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //stores 
  task main();
    bit [7:0] exp_alu_out;
    bit       exp_alu_irq;
    
    Transaction tr;
    forever  begin
      mon2scb.get(tr);
      
      if (!vif.rst_n) begin
      exp_alu_out = 8'b0;
      exp_alu_irq = 1'b0;
    end 

else if (tr.alu_mode == operation_mode_a) begin
  case (tr.alu_op_a)
        and_a  : exp_alu_out =   tr.alu_in_a & tr.alu_in_b;
        nand_a : exp_alu_out = ~(tr.alu_in_a & tr.alu_in_b);
        or_a   : exp_alu_out =   tr.alu_in_a | tr.alu_in_b;
        xor_a  : exp_alu_out =   tr.alu_in_a ^ tr.alu_in_b;
      endcase
      if (!tr.alu_irq_clr) begin
        case ({tr.alu_op_a, tr.alu_out})
          {and_a,8'hFF} : exp_alu_irq = 1'b1;
          {nand_a,8'h00}: exp_alu_irq = 1'b1;
          {or_a,8'hF8}  : exp_alu_irq = 1'b1;
          {xor_a,8'h83} : exp_alu_irq = 1'b1;
          default: begin
            exp_alu_irq = 1'b0;
          end
        endcase end 
      else if (tr.alu_irq_clr) begin
        case ({ tr.alu_op_a, tr.alu_out})
          {and_a,8'hFF} : begin
            exp_alu_irq = ~exp_alu_irq;
          end
          {nand_a,8'h00}: begin
            exp_alu_irq = ~exp_alu_irq;
          end
          {or_a,8'hF8}  : begin
           exp_alu_irq  = ~exp_alu_irq;
          end
          {xor_a,8'h83} : begin
           exp_alu_irq  = ~exp_alu_irq;
          end
          default: begin
            exp_alu_irq = 1'b0;
          end
        endcase

      end

    end 
    
else if (tr.alu_mode == operation_mode_b) begin
  case (tr.alu_op_b)
        xnor_b : exp_alu_out = ~(tr.alu_in_a ^ tr.alu_in_b);
        and_b  : exp_alu_out = tr.alu_in_a & tr.alu_in_b;
        nor_b  : exp_alu_out = ~(tr.alu_in_a | tr.alu_in_b);
        or_b   : exp_alu_out = tr.alu_in_a | tr.alu_in_b;
      endcase
      if (!tr.alu_irq_clr) begin
        case ({tr.alu_op_b, tr.alu_out})
          {xnor_b,8'hF1}: exp_alu_irq = 1'b1;
          {and_b,8'hF4} : exp_alu_irq = 1'b1;
          {nor_b,8'hF5} : exp_alu_irq = 1'b1;
          {or_b,8'hFF}  : exp_alu_irq = 1'b1;
          default: begin
            exp_alu_irq = 1'b0;
          end
        endcase
      end 
      else if (tr.alu_irq_clr) begin
        case ({tr.alu_op_b, tr.alu_out})
          {xnor_b,8'hF1}: begin
            exp_alu_irq  = ~exp_alu_irq;
          end
          {and_b,8'hF4}: begin
            exp_alu_irq  = ~exp_alu_irq;
          end
          {nor_b,8'hF5}: begin
            exp_alu_irq  = ~exp_alu_irq;
          end
          {or_b,8'hFF}: begin
            exp_alu_irq  = ~exp_alu_irq;
          end
          default: begin
            exp_alu_irq = 1'b0;
          end
        endcase

      end
    end
     begin
       
        if ((tr.alu_mode != operation_mode_b) && (tr.alu_mode != operation_mode_a)) begin
        $display("************************* [ALU DISABLE ] ******************************");
        $display("******************* ALU MODE NOT OPERATION A OR B *********************\n");
        end
      else if ((exp_alu_out != tr.alu_out) || (exp_alu_irq !=tr.alu_irq)) begin
        $display("[SCB-FAIL]    Expected:: alu_out = %0h , Actual:: alu_out = %0h , Expected alu_irq = %0d , Actual alu_irq = %0d \n",
                exp_alu_out , tr.alu_out , exp_alu_irq , tr.alu_irq);
        failed++;
      end
        else begin 
         $display("[SCB-PASS] Expected:: alu_out = %0h , Actual:: alu_out = %0h , Expected alu_irq = %0d , Actual alu_irq = %0d \n",
                exp_alu_out , tr.alu_out , exp_alu_irq , tr.alu_irq);
         passed++;
        end
        
      end
      
      -> ev_1;
      
    end
  endtask
  
  
endclass