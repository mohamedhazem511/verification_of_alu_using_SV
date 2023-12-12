/*
  ##################################################################################
  ###   File:      [test.sv]                                                     ###
  ###   Author:    [Mohamed Hazem Mamdouh]                                       ###
  ###   Date:      [3 / 12 / 2023]                                               ###
  ###   Brief:     [test which contain our verification environment  ]           ###
  ###                                                                            ###
  ##################################################################################
*/

`include "environment.sv"
program test(aluifc vif);

environment env;
  
initial begin
    env = new (vif);
    env.run();
end
  
endprogram