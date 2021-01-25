`timescale 1ns / 1ps
module seq_det_tb ();
    // params
    parameter CLOCK_PERIOD = 10;
    parameter FSM_MODE = 1;
        
    // UUT Signals
    logic clk, rst;
    wire seq_detected, ser_data;

    seq_det_if UUT_if(.clk(clk),
                      .rst(rst));
    assign seq_detected = UUT_if.seq_detected;
    assign ser_data     = UUT_if.ser_data;

    // Clocks
    initial clk = 1'b1;
    always #(CLOCK_PERIOD/2) clk = ~clk;
    
    // UUT instantiation
    generate
        case (FSM_MODE)
        0: 
            seq_det UUT (
            .clk(UUT_if.clk),
            .rst(UUT_if.rst),
            .intf(UUT_if.slave)
            );
        1: 
            seq_det_fsm UUT (
            .clk(UUT_if.clk),
            .rst(UUT_if.rst),
            .intf(UUT_if.slave)
            );
        endcase
    endgenerate
    
    // Test
    initial begin
        reset();
        $display("[%0t] BEGIN seq_det test", $time);
        
        UUT_if.send_byte_verify(8'b10011001, 1'b1);
        UUT_if.send_byte_verify(8'b10011101, 1'b0);
        UUT_if.send_byte_verify(8'b11011001, 1'b0);
        
        UUT_if.send_byte_verify(8'b10011001, 1'b1);
        UUT_if.send_byte_verify(8'b11111111, 1'b0);
        UUT_if.send_byte_verify(8'b10000001, 1'b0);

        repeat (5) @(posedge clk);
        $finish;
    end
    
    // Helper Tasks
    task reset ();
        rst = 1'b1;
        UUT_if.ser_data = 'b0;
        repeat (5) @(posedge clk);
        rst = 1'b0;
        repeat (5) @(posedge clk);
    endtask

endmodule