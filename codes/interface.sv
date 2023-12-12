/*
  ##################################################################################
  ###   File:      [interface.sv]                                                ###
  ###   Author:    [Mohamed Hazem Mamdouh]                                       ###
  ###   Date:      [3 / 12 / 2023]                                               ###
  ###   Brief:     [ interface between the DUT & our verification env of alu ]   ###
  ###                                                                            ###
  ##################################################################################
*/

interface aluifc (input logic alu_clk,rst_n);

   // declaring the signals

    logic [7:0]    alu_in_a;
    logic [7:0]    alu_in_b;
    logic          alu_irq_clr;
    operation_mode alu_mode;
    alu_op_a       alu_op_a;
    alu_op_b       alu_op_b;
    logic [7:0]    alu_out;
    logic          alu_irq;




endinterface


 