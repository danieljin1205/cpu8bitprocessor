`timescale 1ns / 1ps
module memory_block(
    input mem_stage,
    input [7:0] ALUresult_mem_address,
    input [7:0] write_to_mem_data,
    input MemRead,
    input MemWrite,
    output [7:0] mem_data //only only used for lw
    );
    reg [7:0] memory_space [255:0];
    reg [7:0] mem_data_temp;
    integer i;
    
    initial
    begin
        mem_data_temp = 0;
        for(i=0; i<256; i=i+1)
        begin
            memory_space[i] = i*2; // DON'T CHANGE
        end
    end
    
    always @(mem_stage)
    begin
        if(MemRead == 1)
        begin
            mem_data_temp = memory_space[ALUresult_mem_address];
            $display("Reading mem[%d] = %d\n",ALUresult_mem_address,mem_data_temp);
        end
        if(MemWrite == 1)
        begin
            $display("Before storing... mem[%d] = %d\n",ALUresult_mem_address, memory_space[ALUresult_mem_address]);
            memory_space[ALUresult_mem_address] = write_to_mem_data;
            $display("After storing... mem[%d] = %d\n",ALUresult_mem_address, memory_space[ALUresult_mem_address]);
        end
    end
    
    assign mem_data = mem_data_temp;
    
endmodule