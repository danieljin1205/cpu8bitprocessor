`timescale 1ns / 1ps
module alu_unit(
    input ex_stage,
    input [2:0] opcode,
    input ALUcontrol,
    input ALUsrc, //0- compute with reg_data1 and reg_data2 // 1- compute with reg_data1 and extended_immediate
    input [7:0] reg_data1,
    input [7:0] reg_data2,
    input [7:0] extended_immediate,
    
    output [7:0] ALUresult
    );
    reg [7:0] ALUresult_temp;

    wire [7:0] secondReg;
    
    initial
    begin
        ALUresult_temp = 0;
    end
    
    always @(ex_stage)
    begin
        #5
        case (ALUsrc)
            0: begin /* compute with reg_data1 and reg_data2*/
                    case (ALUcontrol)
                        0: /* addition */ALUresult_temp = reg_data1 + reg_data2;
                        1: /* subtraction */ALUresult_temp = reg_data1 - reg_data2;
                    endcase
               end
            1: begin /* computer with reg_data1 and extended_immediate: sw, lw, or addi*/
                    case(opcode)
                        'b100: begin /* addi: immediate <operation> reg_data1 */
                                    ALUresult_temp = reg_data1 + extended_immediate; // addi will always add
                               end
                               
                        default: begin /* lw or sw: immediate <operation> reg_data2 */
                                    case (ALUcontrol)
                                        0: /* addition */ALUresult_temp = reg_data2 + extended_immediate;
                                        1: /* subtraction */ALUresult_temp = reg_data2 - extended_immediate;
                                    endcase
                                 end
                    endcase
               end
        endcase
    end
    
    assign ALUresult = ALUresult_temp;
    
endmodule