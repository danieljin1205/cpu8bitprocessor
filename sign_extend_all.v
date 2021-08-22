`timescale 1ns / 1ps

module sign_extend_all(
    input id_stage,
    input [2:0] opcode,
    input [2:0] immediate,
    input [4:0] jump_addr_short,
    output [7:0] extended
    );
    
    reg [7:0] extended_temp;
    
    initial
    begin
        extended_temp = 8'd0;
    end
    
    always @(id_stage)
    begin
        case(opcode)
            3'b000: begin/* lw */ 
                        extended_temp = { 5'b0, immediate };
                    end
            3'b001: begin/* sw */ 
                        extended_temp = { 5'b0, immediate };
                    end
            3'b100: begin/* addi */ 
                        extended_temp = { 5'b0, immediate };
                    end
            3'b010: begin /* jump */
                        extended_temp = { 3'b0, jump_addr_short };
                    end
        endcase
        
    end
    assign extended = extended_temp;
endmodule