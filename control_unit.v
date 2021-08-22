`timescale 1ns / 1ps
module control_unit(
    input id_stage,
    input [2:0] opcode,
    
    output RegDest,
    output ALUsrc,
    output MemToReg,
    output RegWrite,
    output MemRead,
    output MemWrite,
    output Branch,
    output Jump,
    output ALUcontrol // 0 for add, 1 for subtract
    );
    reg RegDest_temp, ALUsrc_temp, MemToReg_temp, RegWrite_temp, MemRead_temp, MemWrite_temp, Branch_temp;
    reg Jump_temp, ALUcontrol_temp;
    
    initial
    begin
        RegDest_temp=0; ALUsrc_temp=0; MemToReg_temp=0; RegWrite_temp=0; MemRead_temp=0; MemWrite_temp=0;
        Branch_temp=0; Jump_temp=0; ALUcontrol_temp=0;
    end
    
    always @(id_stage)
    begin   // RegDest, Branch not used
        //RegDest_temp=RegDest; ALUsrc_temp=ALUsrc; MemToReg_temp=MemToReg; RegWrite_temp=RegWrite; 
        //MemRead_temp=MemRead; MemWrite_temp=MemWrite; Branch_temp=Branch; Jump_temp=Jump; ALUcontrol_temp=ALUcontrol;
        case(opcode)
            3'b000: begin // lw
                        RegDest_temp=0; ALUsrc_temp=1; MemToReg_temp=1; RegWrite_temp=1; MemRead_temp=1; 
                        MemWrite_temp=0; Branch_temp=0; Jump_temp=0; ALUcontrol_temp=0;
                    end
            3'b001: begin // sw
                        RegDest_temp=1'bz; ALUsrc_temp=1; MemToReg_temp=1'bz; RegWrite_temp=0; MemRead_temp=0; 
                        MemWrite_temp=1; Branch_temp=0; Jump_temp=0; ALUcontrol_temp=0;
                    end
            3'b010: begin // jmp
                        RegDest_temp=1'bz; ALUsrc_temp=1'bz; MemToReg_temp=1'bz; RegWrite_temp=0; MemRead_temp=0; 
                        MemWrite_temp=0; Branch_temp=0; Jump_temp=1; ALUcontrol_temp=1'bz;
                    end
            3'b011: begin // add
                        RegDest_temp=1'b1; ALUsrc_temp=0; MemToReg_temp=0; RegWrite_temp=1; MemRead_temp=0; 
                        MemWrite_temp=0; Branch_temp=0; Jump_temp=0; ALUcontrol_temp=0;
                    end 
            3'b100: begin // addi
                        RegDest_temp=0; ALUsrc_temp=1; MemToReg_temp=0; RegWrite_temp=1; MemRead_temp=0; 
                        MemWrite_temp=0; Branch_temp=0; Jump_temp=0; ALUcontrol_temp=0;
                    end
            3'b101: begin // sub
                        RegDest_temp=1'b1; ALUsrc_temp=0; MemToReg_temp=0; RegWrite_temp=1; MemRead_temp=0; 
                        MemWrite_temp=0; Branch_temp=0; Jump_temp=0; ALUcontrol_temp=1;
                    end         
        endcase
    end
    
    assign RegDest = RegDest_temp;
    assign ALUsrc = ALUsrc_temp;
    assign MemToReg = MemToReg_temp;
    assign RegWrite = RegWrite_temp;
    assign MemRead = MemRead_temp;
    assign MemWrite = MemWrite_temp;
    assign Branch = Branch_temp;
    assign Jump = Jump_temp;
    assign ALUcontrol = ALUcontrol_temp;
endmodule