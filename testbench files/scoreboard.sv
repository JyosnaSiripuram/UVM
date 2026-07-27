class ALU_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(ALU_scoreboard)
  
  ALU_seq_item pkt_q[$];
  //declaring port
  uvm_analysis_imp#(ALU_seq_item,ALU_scoreboard) item_collected_export;
  
  //constructor
  function new (string name="ALU_scoreboard",uvm_component parent);
    super.new(name,parent);
    //`uvm_info("ALU_scoreboard class","constructor",UVM_MEDIUM)
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export",this);
  endfunction
  
  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB Class","Connect phase",UVM_HIGH);
  endfunction
  
  //write
  virtual function void write(ALU_seq_item pkt);
    pkt_q.push_back(pkt);
  endfunction
  
  //run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("scoreboard class","run phase",UVM_MEDIUM)
    repeat(50) begin
      ALU_seq_item curr_pkt;
      wait ((pkt_q.size()!=0));
      curr_pkt = pkt_q.pop_front();
      compare(curr_pkt);
   
    end
  endtask
  
  task compare(ALU_seq_item curr_pkt);
    logic [31:0]expected; //calculated value
    logic [31:0]actual;// output from dut
    
    case(curr_pkt.ALU_C)
      0:begin
        expected = curr_pkt.A & curr_pkt.B;
      end
      1:begin
        expected = curr_pkt.A | curr_pkt.B;
      end
      2:begin
        expected = curr_pkt.A ^ curr_pkt.B;
        end 
      3: begin
        expected = {16'd0,curr_pkt.B[7:0],8'd0}; //LUI
      end
        
      4:begin
        expected = curr_pkt.A + curr_pkt.B;
      	end 
      /*5:begin
        expected = curr_pkt.A + curr_pkt.B + 1'b0;
      	end */
      6:begin
        case({curr_pkt.ALU_C[0],curr_pkt.ALU_C[2]})
          0:begin
            expected = curr_pkt.B << curr_pkt.A[4:0];
          end
          1:begin 
            expected = curr_pkt.B >> curr_pkt.A[4:0];
          end
          2:begin 
            expected = curr_pkt.B <<< curr_pkt.A[4:0];
          end
          3:begin
            expected = curr_pkt.B >>> curr_pkt.A[4:0];
          end
          default: expected = curr_pkt.B;
        endcase
      	end
      /*7:begin
       case({curr_pkt.ALU_C[0],curr_pkt.ALU_C[2]})
          0:begin
            expected = curr_pkt.B << curr_pkt.A[4:0];
          end
          1:begin 
            expected = curr_pkt.B >> curr_pkt.A[4:0];
          end
          2:begin 
            expected = curr_pkt.B <<< curr_pkt.A[4:0];
          end
          3:begin
            expected = curr_pkt.B >>> curr_pkt.A[4:0];
          end
          default: expected = curr_pkt.B;
        endcase
      	end */
      default :
        expected = 32'd0;
    endcase
    actual = curr_pkt.OUT;
    
    if(actual !=expected) begin
      `uvm_error("Compare SCB",$sformatf("Transaction failed! Act=%d, Exp=%d",actual,expected))
      	 //`uvm_info("SCB",$sformatf("A=%0d,B=%0d,ALU_C=%0d,DUT_OUT(Act)=%0d",curr_pkt.A,curr_pkt.B,curr_pkt.ALU_C,curr_pkt.OUT),UVM_MEDIUM)
    end
    else begin
      `uvm_info("Compare SCB",$sformatf("Transaction passed Act=%d, Exp=%d",actual,expected),UVM_MEDIUM)
     //`uvm_info("SCB",$sformatf("A=%0d,B=%0d,ALU_C=%0d,DUT_OUT(Act)=%0d",curr_pkt.A,curr_pkt.B,curr_pkt.ALU_C,curr_pkt.OUT),UVM_MEDIUM)
    end
        
  endtask
  
endclass