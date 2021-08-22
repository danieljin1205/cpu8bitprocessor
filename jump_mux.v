`timescale 1ns / 1ps
module jump_mux(
    input wb_stage,
    input startbit,
    input [7:0] pc,
    input [7:0] jump_address_extended,
    input jump_flag,
    output [7:0] mux_jump_output
    );
    
    reg [7:0] mux_jump_output_temp;
    reg [7:0] added1;
    
    initial
    begin
        mux_jump_output_temp = 0;
        added1 = 0;
    end
    
    always @(wb_stage)
    begin
        if(startbit==1)
        begin
            added1 = pc + 1;
        end
    end
    
    always @(added1)
    begin
        case (jump_flag)
            0: mux_jump_output_temp = added1;
            1: mux_jump_output_temp = jump_address_extended;
        endcase
    end
    assign mux_jump_output = mux_jump_output_temp;
endmodule
