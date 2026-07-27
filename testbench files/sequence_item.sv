class ALU_seq_item extends uvm_sequence_item;
//  `uvm_object_utils(ALU_seq_item)//register class to uvm factory
  
     // input,output fields 
  rand logic [31:0]A,B;
  rand logic [2:0]ALU_C;
  
  logic [31:0]OUT;
  
    //macros - if any
  `uvm_object_utils_begin(ALU_seq_item)
  `uvm_field_int(A,UVM_ALL_ON)
  `uvm_field_int(B,UVM_ALL_ON)
  `uvm_field_int(ALU_C,UVM_ALL_ON)
  `uvm_field_int(OUT,UVM_ALL_ON)
  `uvm_object_utils_end 
  
  //constraints
    constraint exclude {
      ALU_C inside{[0:7]};
    !(ALU_C == 5);   // exclude 5
    !(ALU_C == 7);   // exclude 7
    }
  //constructor
  function new(string name="ALU_seq_item");
    super.new(name);
    //`uvm_info("Sequence item class","constructor",UVM_HIGH)
  endfunction
  
  
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    //$display("seq item class prints:");
    printer.print_field("A",A,32,UVM_DEC,"{0}");
    printer.print_field("B",A,32,UVM_DEC,"{0}");
    printer.print_field("ALU_C",ALU_C,3,UVM_DEC,"{0}");
    printer.print_field("OUT",OUT,32,UVM_DEC,"{0}");
   endfunction
  
  
endclass