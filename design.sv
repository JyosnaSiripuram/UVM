// Code your design here
module ALU(
  input [31:0]A,B,
  input [2:0]ALU_C,
  output [31:0]OUT
);
  wire [31:0]I0,I1,I2,I3,I4;
  wire [31:0]AND_Out,OR_Out,XOR_Out;
  wire [31:0]LUI_Out;
  wire cout;
  
  assign AND_Out = A & B;
  assign OR_Out  = A | B;
  assign XOR_Out = A ^ B;
  
  mux2to1 U1(.in0(AND_Out),.in1(OR_Out),.sel(ALU_C[0]),.out(I0));
  
 
  LUI U2(.B(B[31:0]),.out(LUI_Out));

  mux2to1 U3(.in0(XOR_Out),.in1(LUI_Out),.sel(ALU_C[0]),.out(I1));
    
  adder_32bit U4(.A(A),.B(B),.Cin(ALU_C[0]),.S(I2),.cout(cout));
    
  barrel_shifter U5(.B(B),.sv(A[4:0]),.cntr(ALU_C[2]),.opr(ALU_C[0]),.y(I3));
  
  mux4to1 U6(.i0(I0),.i1(I1),.i2(I2),.i3(I3),.s(ALU_C[2:1]),.out(OUT));
  
//ALU_c  4 bit number
  /*	ALU_C (select line)   Operation
 			0					and/or	
        	1					xor/lui
       		2					adder
        	3					shifter
 */
  
endmodule


module LUI(
  input [31:0]B,
  output [31:0]out 
);
  assign out[31:16] = 16'b0;
  assign out[7:0] = 8'h00;
  assign out[15:8]= B[7:0];
  
endmodule

module mux2to1(
  input [31:0]in0,in1,
  input sel,
  output reg [31:0]out);
  
  always @ (in0 or in1 or sel)
    begin 
      case(sel)
        1'b0 : out = in0;
        1'b1 : out = in1;
      endcase
    end
endmodule



module mux4to1(
  input [31:0]i0,i1,i2,i3,
  input [1:0]s,
  output reg [31:0]out);
  
  always @ (i0 or i1 or i2 or i3 or s)
    begin 
      case(s)
        2'b00 : out = i0;
        2'b01 : out = i1;
        2'b10 : out = i2;
        2'b11 : out = i3;
      endcase
    end
endmodule

module barrel_shifter(
  input signed [31:0]B,
  input [4:0]sv,
	input cntr,
    input opr,
  output reg signed[31:0]y);
  
  //if opr => logical  cntr =>left
  always @(*)
    begin
  		case ({opr,cntr})
 			0: y = B<<sv;
  			1: y = B>>sv;
          	2: y = B<<<sv;
    		3: y = B>>>sv;
          default: y = B;
  		endcase
      end
endmodule

module adder_32bit(A,B,Cin,S,cout);
  input [31:0]A,B;
  input Cin;
  output [31:0]S;
  output cout;
  
  wire c1;
  cla_16bit CLA1(.A(A[15:0]),.B(B[15:0]),.Cin(Cin),.S(S[15:0]),.cout(c1));
  cla_16bit CLA2(.A(A[31:16]),.B(B[31:16]),.Cin(c1),.S(S[31:16]),.cout(cout));
  
endmodule

module cla_16bit(A,B,Cin,S,cout);
  input [15:0]A,B;
  input Cin;
  output [15:0]S;
  output cout;
  
  wire c1,c2,c3;
  
  cla_4bit cla1(.A(A[3:0]),.B(B[3:0]),.Cin(Cin),.S(S[3:0]),.cout(c1));
  cla_4bit cla2(.A(A[7:4]),.B(B[7:4]),.Cin(c1),.S(S[7:4]),.cout(c2));
  cla_4bit cla3(.A(A[11:8]),.B(B[11:8]),.Cin(c2),.S(S[11:8]),.cout(c3));
  cla_4bit cla4(.A(A[15:12]),.B(B[15:12]),.Cin(c3),.S(S[15:12]),.cout(cout));
    //initial begin
    //$display("Adder 16bit : A=%d.B=%d,Cin=%d,S=%d,Cout=%d",A,B,Cin,S,cout);
   // end
endmodule

module cla_4bit(
  input [3:0]A,B,
  input Cin,
  output [3:0]S,
  output cout);
  
  wire [3:0]p,g,c;
  
  assign g = A & B;
  assign p = A ^ B;
  
  assign c[0]=Cin;
  assign c[1]= g[0] | (p[0]&c[0]);
  assign c[2]= g[1] | (p[1]&g[0]) | (p[1]&p[0]&c[0]);
  assign c[3]= g[2] | (p[2]&g[1]) | (p[2]&p[1]&g[0]) | (p[2]&p[1]&p[0]&c[0]);
  assign cout= g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]) | (p[3]&p[2]&p[1]&p[0]&c[0]);
      
  assign S = p^c; 
  //initial begin
 //   $display("Adder 4bit : A=%d.B=%d,Cin=%d,S=%d,Cout=%d",A,B,Cin,S,cout);
    //end
endmodule