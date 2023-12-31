# verification of alu using system verilog

    ####################################################################################
    ###     File:      [work_flow]                                                   ###
    ###     Author:    [Mohamed Hazem Mamdouh ]                                      ###
    ###     Date:      [9 / 12 / 2023]                                               ###
    ###     Brief:     [work flow about "alu verification project"                   ###
    ###                 Graduation Project of Information Technology Institute (ITI) ###
    ###                 Digital IC Verification Track ]                              ###
    ####################################################################################

 [1] create our Verification plan of our project " alu ".
 
 [2] start to build our verification environment:-
 
 - create transaction class , which also contain our constrains on transaction.
 - create interface which we use to connect our verification environment with dut.
 - testbench (top) -->> contain environment { generator , driver , monitor , scoreboard }.
 - each component we pass the alu interface virtual function and object of transaction (alu_ifc tr) and create new handels.
 - use generator class to generate stimuls and sent to driver by gen2drv mailbox to drive this stimulus on interface.
 - use monitor to display the inputs on the interface , and sent to scoreboard to check the testcase pass or fail.
 - scoreboard will trigger event to generator to generate the next stimulus & to testbench to to sample inputs & output to calculate the coverage.
 - get the log from eda playground and coverage report , and show the number of passed & failed  cases.
 - create alu_pkg file which contain enums, variables & events to be accessable for all components in verification environment.

   # Verification Environment Hierarchical

   ![alu_env](https://github.com/mohamedhazem511/verification_of_alu_using_SV/assets/114261199/7d0d8de5-afd1-476c-b362-3b9ac6dd3cc7)




   # ALU
       
  ![alu](https://github.com/mohamedhazem511/verification_of_alu_using_SV/assets/114261199/cf7b3180-e082-4d1c-8373-7de2df1ea403)
