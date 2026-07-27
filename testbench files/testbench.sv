

`timescale 1ns/1ns

//importing uvm package & macros

import uvm_pkg::* ;
`include "uvm_macros.svh"


// inlcuding all test classes in order
`include "interface.sv"
`include "sequence_item.sv"
`include "sequencer.sv"
`include "sequence.sv"
`include "driver.sv"
`include "monitor.sv"
`include "coverage.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"

module ALU_top();
 
  logic [31:0]A,B;
  logic [2:0]ALU_C;
  logic [31:0]OUT;
  
  //create interface instance 
  ALU_intf intf();
  
  //dut inteface & inteface signals are connected
  ALU dut(.A(intf.A),.B(intf.B),.ALU_C(intf.ALU_C),.OUT(intf.OUT));
  
  //set interface as physical quantity
  initial begin
    uvm_config_db#(virtual ALU_intf)::set(null,"*","intf",intf);
    uvm_config_db#(int)::set(null, "*", "uvm_verbosity", UVM_DEBUG);
  end

  
  initial begin 
    run_test("ALU_test");
    $finish;
  end
  
endmodule
      
     
      #1000 $finish;
    end
  
endmodule
*/
