`timescale 1ns / 1ps
module program_counter(
    input clock,

    input [7:0] current_pc,
    output [7:0] new_pc,
  
    output if_stage,
    output id_stage,
    output ex_stage,
    output mem_stage,
    output wb_stage,
    
    output startbit
    );
   
    reg [7:0] current_pc_temp;
    reg [7:0] new_pc_temp;
    
    reg if_stage_temp;
    reg id_stage_temp;
    reg ex_stage_temp;
    reg mem_stage_temp;
    reg wb_stage_temp;
    
    reg startbit_temp; // used only for the very beginning
   
    reg [7:0] newstage;
    
    initial
    begin
        current_pc_temp = 0;
        new_pc_temp = 0;
        
        if_stage_temp = 0;
        id_stage_temp = 0;
        ex_stage_temp = 0;
        mem_stage_temp = 0;
        wb_stage_temp = 0;
        
        startbit_temp = 0;
        
        newstage=0;
    end
    
    always @(posedge clock)
    begin 
        startbit_temp = 1;  
        
        newstage = (newstage + 1) % 5;
        case(newstage)
            1: begin
                new_pc_temp = current_pc;
                if_stage_temp = ~if_stage_temp;
                //new_pc_temp = current_pc;
               end
            2: begin
                id_stage_temp = ~id_stage_temp;
               end
            3: begin
                ex_stage_temp = ~ex_stage_temp;
               end
            4: begin
                mem_stage_temp = ~mem_stage_temp;
               end
            0: begin
                wb_stage_temp = ~wb_stage_temp;
               end
        endcase
    end
    
    assign new_pc = new_pc_temp;

    assign if_stage = if_stage_temp;
    assign id_stage = id_stage_temp;
    assign ex_stage = ex_stage_temp;
    assign mem_stage = mem_stage_temp;
    assign wb_stage = wb_stage_temp;
    
    assign startbit = startbit_temp;
    
endmodule
