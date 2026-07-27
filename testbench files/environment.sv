class ALU_env extends uvm_env;
  `uvm_component_utils(ALU_env)
  
  ALU_agent agent;
  ALU_scoreboard scoreboard;
  //ALU_coverage coverage;
  //constructor 
  function new (string name="ALU_env",uvm_component parent);
    super.new(name,parent);
    //`uvm_info("ALU_env class","constructor",UVM_MEDIUM)
  endfunction
  //Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV class","build phase",UVM_MEDIUM);
    agent = ALU_agent::type_id::create("agent",this);
    scoreboard = ALU_scoreboard::type_id::create("scoreboard",this);
    
  endfunction
  
  //connect_phase
  function void connect_phase(uvm_phase phase);	
    super.connect_phase(phase);
	if(agent != null && agent.monitor != null && scoreboard != null)
      agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
    //agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
     else
       `uvm_fatal("ENV_CONNECT", "Agent or monitor or scoreboard is null")	
  endfunction
  
endclass