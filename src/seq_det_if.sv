`timescale 1ns / 1ps

interface seq_det_if (input clk, input reg rst);
    logic ser_data;
    logic seq_detected;
    
    task send_byte (input bit [7:0] data);
        for (int i = 0; i < 8; i++) begin
            ser_data = data[i];
            @(posedge clk);
        end
        ser_data = 1'b0;
    endtask
    
    task send_byte_verify ( input bit [7:0] data,
                            input bit seq_exp);
        send_byte(data);
        if (seq_exp != seq_detected)
            $strobe("[%0t] ERROR: seq_detected=%0d, expected=%0d", $time, seq_detected, seq_exp);
        else
            $strobe("[%0t] PASS", $time);
    endtask
    
    clocking cb @(posedge clk);
        default input #2ns;
        input ser_data; 
    endclocking
    
    modport master (
        output ser_data,
        input  seq_detected
    );
    
    modport slave (
        input  ser_data,
        output seq_detected
    );
    
endinterface
