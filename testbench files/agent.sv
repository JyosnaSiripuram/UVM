//agent is a  containcer containing driver,sequencer,monitor
class ALU_agent extends uvm_agent;
  `uvm_component_utils(ALU_agent)
  //declare the instances
  ALU_sequencer sequencer;
  ALU_driver driver;
  ALU_monitor monitor;
  ALU_coverage coverage;
  
  //constructor
  function new (string name="ALU_agent",uvm_component parent);
    super.new(name,parent);
    //`uvm_info("ALU_agent class","constructor",UVM_MEDIUM)
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = ALU_sequencer::type_id::create("sequencer",this);
    driver = ALU_driver::type_id::create("driver",this);
    monitor = ALU_monitor::type_id::create("monitor",this);
    coverage = ALU_coverage::type_id::create("coverage",this);
  endfunction
  
  //connect_phase
  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
   //reference to below line => monitor.analysis_port.connect(coverage.analysis_export);
    monitor.item_collected_port.connect(coverage.analysis_export);
  endfunction
  
endclass