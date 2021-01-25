`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2021 06:34:25 PM
// Design Name: 
// Module Name: seq_det_fsm
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


module seq_det_fsm
    #(
    parameter bit [7:0] seq = 8'b10011001)
    (
    input  wire clk,
    input  wire rst,
    
    seq_det_if.slave intf
    );
    typedef enum {S0, S1, S2, S3, S4, S5, S6, S7, S8} t_state; 
    
    t_state state, state_next;
    
    logic ser_data;
    assign ser_data = intf.ser_data;
    assign intf.seq_detected = (state == S7);
    
    always_comb begin
        state_next = S0;
        case (state)
            S0: state_next = (ser_data == seq[7]) ? S1 : S0;
            S1: state_next = (ser_data == seq[6]) ? S2 : S0;
            S2: state_next = (ser_data == seq[5]) ? S3 : S0;
            S3: state_next = (ser_data == seq[4]) ? S4 : S0;
            S4: state_next = (ser_data == seq[3]) ? S5 : S0;
            S5: state_next = (ser_data == seq[2]) ? S6 : S0;
            S6: state_next = (ser_data == seq[1]) ? S7 : S0;
            S7: state_next = (ser_data == seq[0]) ? S8 : S0;
        endcase
    end
    
    always_ff @(posedge clk) begin
        if (rst)
            state <= S0;
        else
            state <= state_next;
    end
    
endmodule
