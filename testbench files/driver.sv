class ALU_driver extends uvm_driver#(ALU_seq_item);
  `uvm_component_utils(ALU_driver)
  
  //constructor
  function new (string name="ALU_driver",uvm_component parent);
    super.new(name,parent);
   // `uvm_info("ALU_driver class","constructor",UVM_MEDIUM)
  endfunction
  
  //virtual interface
  virtual ALU_intf intf;
  
  //build phase
    function void build_phase(uvm_phase phase);
  		super.build_phase(phase);
      if(!(uvm_config_db#(virtual ALU_intf)::get(this,"","intf",intf)))
        begin
      		`uvm_fatal("No Virtual interface","Driver class build phase")
      	end
     endfunction
      
   //run phase
   virtual task run_phase(uvm_phase phase);
     repeat(50) begin 
    seq_item_port.get_next_item(req);
    //$display("Driver: Transaction driven:-");
    //req.print();
    drive(req);
    seq_item_port.item_done();
  	end
  endtask
  
  virtual task drive(ALU_seq_item req);
   
    intf.A <= req.A;
    intf.B <= req.B;
    intf.ALU_C <= req.ALU_C;
    #2;
    //`uvm_info("DRV", $sformatf("A=%d B=%d ALU_C=%d OUT=%d",intf.A, intf.B, intf.ALU_C, intf.OUT), UVM_MEDIUM)
    
  endtask
  
endclass