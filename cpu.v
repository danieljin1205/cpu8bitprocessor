`timescale 1ns / 1ps
module cpu(
    );
    reg clock;
    wire [7:0] program_counter;
    wire startbit;

    wire jump_mux_output;
    wire if_stage;
    wire [7:0] instruction;
    
    wire id_stage;
    
    wire [7:0] after_extended;
    
    wire wb_stage;
    
    wire [7:0] regblockdata1;
    wire [7:0] regblockdata2;
    
    wire ex_stage;
    wire [7:0] ALUresult;
    
    wire sel_RegDest;
    wire sel_ALUsrc;
    wire sel_MemToReg;
    wire sel_RegWrite;
    wire sel_MemRead;
    wire sel_MemWrite;
    wire sel_Branch;
    wire sel_Jump;
    wire sel_ALUcontrol;
    
    wire mem_stage;
    wire [7:0] mem_data;
    
    wire [7:0] mux_write_to_reg_data;
    
    wire [7:0] actual_pc;
    wire [7:0] incremented_pc;
    
    
    program_counter pc(
        .clock(clock),
        .current_pc(program_counter),
        .new_pc(actual_pc), // this is what fetches the memory
        .if_stage(if_stage),
        .id_stage(id_stage),
        .ex_stage(ex_stage),
        .mem_stage(mem_stage),
        .wb_stage(wb_stage),
        .startbit(startbit)
                        ); 
    instruction_memory instr_mem(
        .if_stage(if_stage),
        .program_counter(actual_pc),
        .instruction(instruction)              
                        );   
    register_block regblock(
        .id_stage(id_stage),
        .wb_stage(wb_stage),
        .RegWrite(sel_RegWrite),
        .instruction(instruction), // just for printing purposes
        .Rt_or_Rd(instruction[4]),
        .Rs(instruction[3]),
        .write_data(mux_write_to_reg_data),
        .data1(regblockdata1),
        .data2(regblockdata2)                
                        );          
     control_unit control(
        .id_stage(id_stage),
        .opcode(instruction[7:5]),
        .RegDest(sel_RegDest), // unused
        .ALUsrc(sel_ALUsrc),
        .MemToReg(sel_MemToReg),
        .RegWrite(sel_RegWrite),
        .MemRead(sel_MemRead),
        .MemWrite(sel_MemWrite),
        .Branch(sel_Branch), //unused
        .Jump(sel_Jump),
        .ALUcontrol(sel_ALUcontrol)
                        );
     sign_extend_all sign_extend(
        .id_stage(id_stage),
        .opcode(instruction[7:5]),
        .immediate(instruction[2:0]),
        .jump_addr_short(instruction[4:0]),
        .extended(after_extended)
                        );
     alu_unit alu(
        .ex_stage(ex_stage),
        .opcode(instruction[7:5]),
        .ALUcontrol(sel_ALUcontrol),
        .ALUsrc(sel_ALUsrc),
        .reg_data1(regblockdata1),
        .reg_data2(regblockdata2),
        .extended_immediate(after_extended),
        .ALUresult(ALUresult)
                        );
     memory_block mem(
        .mem_stage(mem_stage),
        .ALUresult_mem_address(ALUresult),
        .write_to_mem_data(regblockdata1),
        .MemRead(sel_MemRead),
        .MemWrite(sel_MemWrite),
        .mem_data(mem_data)  
                        );
     mux_2to1_8bit mux_write_to_register(
        .stage_wait(mem_stage),
        .d0(ALUresult),
        .d1(mem_data),
        .select_bit(sel_MemToReg),
        .data_out(mux_write_to_reg_data)             
                        );
     
     jump_mux jumper(
        .wb_stage(wb_stage),
        .startbit(startbit),
        .pc(actual_pc),
        .jump_address_extended(after_extended),
        .jump_flag(sel_Jump),
        .mux_jump_output(program_counter)
                        );                  
     
     
                       
    initial
    begin
        forever
        begin
            #5 clock = ~clock; // pc file uses clock as input
        end
    end
    initial
    begin
        clock = 0; 
        #5000 $finish;
    end
    
    
endmodule
