`timescale 1ns / 1ps
module instruction_memory(
    input if_stage,
    input [7:0] program_counter,
    output [7:0] instruction
    );

    reg [7:0] mem [255:0];
    reg [7:0] instruction_temp;
    
    initial
    begin
        mem[0] = 8'b10000101; // addi t0 t0 5 
        mem[1] = 8'b10011001; // addi t1 t1 1
        mem[2] = 8'b10101111; // sub t0 t0 t1
        mem[3] = 8'b00110000; // sw t1 0(t0)
        mem[4] = 8'b00001101; // lw t0 5(t1)
        mem[5] = 8'b01000111; // j 7
        mem[6] = 8'b10110000; // sub t1 t1 t0, ignored
        mem[7] = 8'b01110111; // add t1 t1 t0
    end
    
    always @(if_stage)
    begin
        #5
        $display("------\n");
        $display("Program Counter: %d\n", program_counter);
        instruction_temp = mem[program_counter];
        $display("Instruction: %b\n", instruction_temp);
    end
    
    assign instruction = instruction_temp;
endmodule