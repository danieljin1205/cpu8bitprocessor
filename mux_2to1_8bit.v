`timescale 1ns / 1ps

module mux_2to1_8bit(
    input stage_wait,
    input [7:0] d0,
    input [7:0] d1,
    input select_bit,
    output [7:0] data_out
    );
    
    reg [7:0] data_out_temp;
    
    initial
    begin
        data_out_temp = 0;
    end
    
    always @(stage_wait)
    begin
        #5
        case(select_bit)
            0: data_out_temp = d0;
            1: data_out_temp = d1;
        endcase
    end
    assign data_out = data_out_temp;
endmodule