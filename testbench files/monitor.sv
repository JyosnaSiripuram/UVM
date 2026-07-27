class ALU_monitor extends uvm_monitor;
  `uvm_component_utils(ALU_monitor)
 
  //virtual interface
  virtual ALU_intf intf;
  //declare analysis port
  uvm_analysis_port#(ALU_seq_item) item_collected_port;
  //declare seq_item handle to capture transc info 
  ALU_seq_item trans_collected;
  
  //constructor
  function new (string name="ALU_monitor",uvm_component parent);
    super.new(name,parent);
   // `uvm_info("ALU_monitor class","constructor",UVM_MEDIUM)
  endfunction
 
  //build phase connect intf to vif using get method
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ALU_intf)::get(this,"","intf",intf))
      `uvm_fatal("No virtual interface","monitor class build phase")
    item_collected_port = new("item_collected_port",this);
  endfunction
 
  //run phase
  virtual task run_phase(uvm_phase phase);
   forever begin
     @(intf.A or intf.B or intf.ALU_C);
      #3
      trans_collected = ALU_seq_item::type_id::create("trans_collected");
      
      trans_collected.A = intf.A;
      trans_collected.B = intf.B;
      trans_collected.ALU_C = intf.ALU_C;
      trans_collected.OUT = intf.OUT;
     
     //$display("Monitor:Transaction collected:-");
      //trans_collected.print();
     
     #2 item_collected_port.write(trans_collected);// send to scoreboard
     
    end
    
    endtask
endclass