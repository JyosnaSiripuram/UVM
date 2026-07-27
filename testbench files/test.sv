class ALU_test extends uvm_test;
  `uvm_component_utils(ALU_test)
  
  ALU_env env;
  //ALU_agent agent;
  ALU_sequence test_seq;
  
  //constructor 
  function new (string name="ALU_test",uvm_component parent);
    super.new(name,parent);
   // `uvm_info("ALU_test class","constructor",UVM_MEDIUM)
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("Test Class","Build phase",UVM_MEDIUM);
    env = ALU_env::type_id::create("env",this);
    //agent = ALU_agent::type_id::create("agent",this);
  endfunction
  //connect phase
  
  //run phase
  task run_phase (uvm_phase phase);
    
    super.run_phase(phase);
    phase.raise_objection(this);
    repeat(50) begin
      test_seq =  ALU_sequence::type_id::create("test_seq",this);
      test_seq.start(env.agent.sequencer);
    end
    phase.drop_objection(this);
  endtask
  
endclass