/*
  ##################################################################################
  ###   File:      [alu_pkg.sv]                                                  ###
  ###   Author:    [Mohamed Hazem Mamdouh]                                       ###
  ###   Date:      [3 / 12 / 2023]                                               ###
  ###   Brief:     [ package file which all component can show ]                 ###
  ###                                                                            ###
  ##################################################################################
*/
   package alu_pkg;
    parameter int num = 400;
    int passed = 0;
    int failed = 0;
    bit Running ;
    event ev_1,ev_2;

//********* enum operation_mode = {alu_enable_a,alu_enable_b,alu_enable} ********* // 
    typedef enum bit [2:0]  {
    operation_mode_0 = 3'b000,
    operation_mode_1 = 3'b001,
    operation_mode_2 = 3'b010,
    operation_mode_b = 3'b011,
    operation_mode_4 = 3'b100,
    operation_mode_a = 3'b101,
    operation_mode_6 = 3'b110,
    operation_mode_7 = 3'b111
  } operation_mode;

    typedef enum bit [1:0]  {
    and_a  = 2'b00,
    nand_a = 2'b01,
    or_a   = 2'b10,
    xor_a  = 2'b11
    } alu_op_a;

    typedef enum bit [1:0]  {
    xnor_b = 2'b00,
    and_b  = 2'b01,
    nor_b  = 2'b10,
    or_b   = 2'b11
    } alu_op_b;

endpackage