/*
  ##################################################################################
  ###   File:      [top.sv]                                                      ###
  ###   Author:    [Mohamed Hazem Mamdouh]                                       ###
  ###   Date:      [3 / 12 / 2023]                                               ###
  ###   Brief:     [ top module which contain verification env & DUT]            ###
  ###                                                                            ###
  ##################################################################################
*/
/******************************* Top ********************************/
`include "alu_pkg.sv"
  import alu_pkg::*;
`include "interface.sv"
`include "test.sv"

module testbench;
   // clock and reset signal declaration
    bit alu_clk;
    bit rst_n;

   //clock generation
   initial begin
     Running = 1;
  alu_clk = 0;
     while (Running == 1)
    #5 alu_clk = ~alu_clk;
  end

  //reset Generation
   initial begin
    rst_n = 0;
    #5 rst_n =1;
    #30 rst_n = 0;
     $display("############################################### reset #############################################\n ");
    #10
     rst_n = 1;
   end

    aluifc pif(alu_clk,rst_n);
    test tb (pif);
    ALU alu (
      .alu_in_a(pif.alu_in_a),
      .alu_in_b(pif.alu_in_b),
      .alu_irq_clr(pif.alu_irq_clr),
      .alu_enable_a(pif.alu_mode[2]),
      .alu_enable_b(pif.alu_mode[1]),
      .alu_enable(pif.alu_mode[0]),
      .alu_op_a(pif.alu_op_a),
      .alu_op_b(pif.alu_op_b),
      .rst_n(pif.rst_n),
      .alu_clk(pif.alu_clk),
      .alu_out(pif.alu_out),
      .alu_irq(pif.alu_irq)
    );

    Transaction tr = new();

    covergroup cov_op_a;
    op_a :coverpoint alu.alu_op_a {
            bins AND_a  = {and_a};
            bins NAND_a = {nand_a};
            bins OR_a   = {or_a};
            bins XOR_a  = {xor_a};
        }
    endgroup :cov_op_a

    covergroup cov_op_b;
    op_b :coverpoint alu.alu_op_b {
            bins XNOR_b = {xnor_b};
            bins AND_b  = {and_b};
            bins NOR_b  = {nor_b};
            bins OR_b   = {or_b};
        }
    endgroup :cov_op_b

    covergroup cov_in;
        in_a_op_a :coverpoint {alu.alu_enable_a,alu.alu_enable_b,alu.alu_enable, alu.alu_op_a, alu.alu_in_a} {
            illegal_bins  nand_in_a_ff = {{operation_mode_a, nand_a, 8'hFF}};
            wildcard bins in_a_op_a    = {{operation_mode_a, nand_a, 8'h??}};
        }
        in_b_op_a :coverpoint {alu.alu_enable_a,alu.alu_enable_b,alu.alu_enable, alu.alu_op_a, alu.alu_in_b} {
            illegal_bins and_in_b_00   = {{operation_mode_a, and_a, 8'h00}};
            illegal_bins nand_in_b_03  = {{operation_mode_a, nand_a, 8'h03}};
            wildcard bins in_b_op_a    = {{operation_mode_a, nand_a, 8'h??}};
        }
        in_a_op_b :coverpoint {alu.alu_enable_a,alu.alu_enable_b,alu.alu_enable, alu.alu_op_b, alu.alu_in_a} {
            illegal_bins nor_in_a      = {{operation_mode_b, nor_b, 8'hF5}};
            wildcard bins in_a_op_b    = {{operation_mode_b, nor_b, 8'h??}};
        }
        in_b_op_b :coverpoint {alu.alu_enable_a,alu.alu_enable_b,alu.alu_enable, alu.alu_op_b, alu.alu_in_b} {
            illegal_bins and_in_b      = {{operation_mode_b, and_b, 8'h03}};
            wildcard bins in_b_op_b    = {{operation_mode_b, and_b, 8'h??}};
        }
    endgroup :cov_in

    covergroup cov_out;
        out_a :coverpoint {alu.alu_enable_a,alu.alu_enable_b,alu.alu_enable, alu.alu_op_a, alu.alu_out} {
            // for min & max value of alu_out at operations a
            bins out_min_and_a  = {{operation_mode_a,  and_a, 8'h00}};
            bins out_max_and_a  = {{operation_mode_a,  and_a, 8'hFF}};
            bins out_min_nand_a = {{operation_mode_a,  nand_a, 8'h00}};
            bins out_max_nand_a = {{operation_mode_a,  nand_a, 8'hFF}};
            bins out_min_or_a   = {{operation_mode_a,  or_a, 8'h00}};
            bins out_max_or_a   = {{operation_mode_a,  or_a, 8'hFF}};
            bins out_min_xor_a  = {{operation_mode_a,  xor_a, 8'h00}};
            bins out_max_xor_a  = {{operation_mode_a,  xor_a, 8'hFF}};
            // for alu_irq at operation a
            bins out_and_a_irq  = {{operation_mode_a,  and_a, 8'hFF}};
            bins out_nand_a_irq = {{operation_mode_a,  nand_a, 8'h00}};
            bins out_or_a_irq   = {{operation_mode_a,  or_a, 8'hF8}};
            bins out_xor_a_irq  = {{operation_mode_a,  xor_a, 8'h83}};
            bins other_a        = default;
        }
        out_b :coverpoint {alu.alu_enable_a,alu.alu_enable_b,alu.alu_enable, alu.alu_op_b, alu.alu_out} {
            // for min & max value of alu_out at operations b
            bins out_min_xnor_b  = {{operation_mode_b, xnor_b, 8'h00}};
            bins out_max_xnor_b  = {{operation_mode_b, xnor_b, 8'hFF}};
            bins out_min_and_b   = {{operation_mode_b, and_b, 8'h00}};
            bins out_max_and_b   = {{operation_mode_b, and_b, 8'hFF}};
            bins out_min_nor_b   = {{operation_mode_b, nor_b, 8'h00}};
            bins out_max_nor_b   = {{operation_mode_b, nor_b, 8'hFF}};
            bins out_min_or_b    = {{operation_mode_b, or_b, 8'h00}};
            bins out_max_or_b    = {{operation_mode_b, or_b, 8'hFF}};
            // for alu_irq at operation b
            bins out_xnor_b_irq = {{operation_mode_b, xnor_b, 8'hF1}};
            bins out_and_b_irq  = {{operation_mode_b, and_b, 8'hF4}};
            bins out_nor_b_irq  = {{operation_mode_b, nor_b, 8'hF5}};
            bins out_or_b_irq   = {{operation_mode_b, or_b, 8'hFF}};
            bins other_b        = default;
        }
    endgroup :cov_out 

            cov_op_a  cov_op_a_h ;
            cov_op_b  cov_op_b_h ;
            cov_in    cov_in_h   ;
            cov_out   cov_out_h  ;
  
  
    initial begin
            cov_op_a_h = new();
            cov_op_b_h = new();
            cov_in_h   = new();
            cov_out_h  = new();
      
      forever @(ev_1) begin
            cov_op_a_h.sample();
            cov_op_b_h.sample();
            cov_in_h.sample();
            cov_out_h.sample();
      end
     
    end
  
    initial begin
      
            $dumpfile ("ALU.vcd");
            $dumpvars(1);
      
        @(ev_2) begin
            $display ("Coverage of cov_op_a = %.2f%% \n",cov_op_a_h.get_coverage());
            $display ("Coverage of cov_op_b = %.2f%% \n",cov_op_b_h.get_coverage());
            $display ("Coverage of cov_in   = %.2f%% \n",cov_in_h.get_coverage());
            $display ("Coverage of cov_out  = %.2f%% \n",cov_out_h.get_coverage());
            
        Running = 0;
        $finish;
        end
     
    end
  
endmodule 
