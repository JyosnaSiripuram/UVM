//agent can have multiple sequences --> sequences generates stimulus
class ALU_sequence extends uvm_sequence#(ALU_seq_item);
  `uvm_object_utils(ALU_sequence)
 
   ALU_seq_item req;
 
  //constructor
  function new(string name = "ALU_sequence");
    super.new(name);
    //`uvm_info("ALU_sequence","Constructor",UVM_MEDIUM)
  endfunction
  
  //logic to generate is written inside body 
  virtual task body();
    
    req = ALU_seq_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    
    //req.print(); 
    
    wait_for_item_done();
   
  endtask
  
endclass