`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2021 07:05:53 PM
// Design Name: 
// Module Name: seq_det
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seq_det
    #(
    parameter bit [7:0] seq = 8'b10011001)
    (
    input  wire clk,
    input  wire rst,
    
    seq_det_if.slave intf
    );
    
    logic [7:0] sh_reg;
    
    assign intf.seq_detected = (sh_reg == seq);
                
    always_ff @(posedge clk) begin
        if (rst)
            sh_reg <= 'b0;
        else
            sh_reg <= {sh_reg[6:0], intf.ser_data};
    end
    
endmodule
