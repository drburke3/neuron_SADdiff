`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Berkeley Neuromorphic
// Engineer: Daniel Burke
// 
// Create Date: 09/14/2022 10:16:27 AM
// Design Name: 
// Module Name: sklansky_adder_8bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 8-bit generated fast adder with black, gray, and generate-propagate included at bottom
//		naming changed, truncated at 8-bits, and 'multiple packed array wires' error fixed.
// 
// Dependencies: self-contained
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// for this applicaton Sklansky fast enough with fewest gates
//////////////////////////////////////////////////////////////////////////////////


/* Generated 8 bit sklansky adder 
In this adder, binary tree of propagate and generate 
cells will first simultaneously generate all the carries, Cin. 
It builds recursively 2-bit adders then 4-bit adders, 8-bit adders, 
16-bit adder and so on by abutting each time two smaller adders. 
*/

module tt_um_drburke3_neuron_sklansky_adder_8bit(ui_in,uo_out,uio_in,uio_out,uio_oe,rst_n,clk,ena);
input [7:0] ui_in;
output [7:0] uo_out;
input [7:0] uio_in;
output [7:0] uio_out;
output [7:0] uio_oe;
input rst_n;
input clk;
input ena;

assign a=ui_in;
assign sum=uio_out;
assign b=ui_in;
assign uio_out=8'b1;
assign uio_oe=8'b0;





// declare array wires
wire [8:0] g [8:0];
wire [8:0] p [8:0];

//reg [7:0] a [7:0] ui_in;
assign g[0][0]=1'b0;
assign p[0][0]=1'b0;
	
	generate_propagate GeneratePropagate_00(a[0],b[0],g[1][1],p[1][1]);
	generate_propagate GeneratePropagate_01(a[1],b[1],g[2][2],p[2][2]);
    generate_propagate GeneratePropagate_02(a[2],b[2],g[3][3],p[3][3]);
	generate_propagate GeneratePropagate_03(a[3],b[3],g[4][4],p[4][4]);
	generate_propagate GeneratePropagate_04(a[4],b[4],g[5][5],p[5][5]);
	generate_propagate GeneratePropagate_05(a[5],b[5],g[6][6],p[6][6]);
	generate_propagate GeneratePropagate_06(a[6],b[6],g[7][7],p[7][7]);
	generate_propagate GeneratePropagate_07(a[7],b[7],g[8][8],p[8][8]);

/// nomenclature is first number is clock level (1 is highest)
/// nomenclature is second number is bit position (0 is rightmost)

/// Level 1:	
	gray_cell GrayCell_1_1(g[1][1],p[1][1],g[0][0],g[1][0]);
	black_cell BlackCell_1_3(g[3][3],p[3][3],g[2][2],p[2][2],g[3][2],p[3][2]);
	black_cell BlackCell_1_5(g[5][5],p[5][5],g[4][4],p[4][4],g[5][4],p[5][4]);
	black_cell BlackCell_1_7(g[7][7],p[7][7],g[6][6],p[6][6],g[7][6],p[7][6]);
	
/// Level 2:
	gray_cell grayCell_2_2(g[2][2],p[2][2],g[1][0],g[2][0]);
	gray_cell grayCell_2_3(g[3][2],p[3][2],g[1][0],g[3][0]);
	black_cell BlackCell_2_6(g[6][6],p[6][6],g[5][4],p[5][4],g[6][4],p[6][4]);
	black_cell BlackCell_2_7(g[7][6],p[7][6],g[5][4],p[5][4],g[7][4],p[7][4]);
	
/// Level 3:
	gray_cell GrayCell_3_4(g[4][4],p[4][4],g[3][0],g[4][0]);
	gray_cell grayCell_3_5(g[5][4],p[5][4],g[3][0],g[5][0]);
	gray_cell grayCell_3_6(g[6][4],p[6][4],g[3][0],g[6][0]);
	gray_cell grayCell_3_7(g[7][4],p[7][4],g[3][0],g[7][0]);
	
/// Level 4: (if carry out needed)
///	gray cell_4_8(g[8][8],p[8][8],g[7][0],g[8][0]);

always @(posedge clk)
begin
	if(rst_n == 1'b0)
        begin
            sum = 8'b00000000;      
        end 
	else if(ena == 1'b0)
        begin
           	sum[0] <= g[0][0]^p[1][1];
		    sum[1] <= g[1][0]^p[2][2];
	       	sum[2] <= g[2][0]^p[3][3];
	      	sum[3] <= g[3][0]^p[4][4];
	       	sum[4] <= g[4][0]^p[5][5];
	       	sum[5] <= g[5][0]^p[6][6];
	       	sum[6] <= g[6][0]^p[7][7];
	       	sum[7] <= g[7][0]^p[8][8];   
        end 
end
	
endmodule

// Generate Propagate code
module generate_propagate(A,B,G,P);
input A,B;
output G,P;
assign G = A&B;
assign P = A^B;
endmodule

// Gray module code
module gray_cell(G4_3,P4_3,G2_2,G4_2);
  input G4_3,P4_3,G2_2;
  output G4_2;
  wire signal;
  assign signal = P4_3 & G2_2;
  assign G4_2=signal | G4_3;
endmodule

// Black module code
module black_cell(G6_8,P6_8,G7_10,P7_10,G6_10,P6_10);
  input G6_8,P6_8,G7_10,P7_10;
  output G6_10,P6_10;
  wire signal;
  assign signal = P6_8 & G7_10;
  assign G6_10=signal | G6_8;
  assign P6_10=P6_8 & P7_10;
endmodule
