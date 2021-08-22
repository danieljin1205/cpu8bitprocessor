`timescale 1ns / 1ps
module register_block(
    input id_stage,
    input wb_stage,
    input RegWrite,
    
    input [7:0] instruction, // just for printing purposes
    input Rt_or_Rd,
    input Rs,
    
    input [7:0] write_data,
    
    output [7:0] data1,
    output [7:0] data2
    
    );
    reg [7:0] registers [1:0];
    
    reg [7:0] data1_temp, data2_temp;
  
    initial
    begin
        registers[0] = 8'd0;
        registers[1] = 8'd0;
    end

    always @(id_stage)
    begin
        #5
        /* START: PRINT BLOCK*/
        case(instruction[7:5])
            'b011: $display("\tADD t%d t%d t%d\n", instruction[4], instruction[4], instruction[3]);
            'b101: $display("\tSUB t%d t%d t%d\n", instruction[4], instruction[4], instruction[3]);
            'b100: $display("\tADDI t%d t%d %d\n", instruction[4], instruction[3], instruction[2:0]);
            'b000: $display("\tLW t%d %d(t%d)\n", instruction[4], instruction[2:0], instruction[3]);
            'b001: $display("\tSW t%d %d(t%d)\n", instruction[4], instruction[2:0], instruction[3]);
            'b010: $display("\tJUMP %d\n", instruction [4:0]);
        endcase
        /* END: PRINT BLOCK*/
        case(Rt_or_Rd) // if sw, this is what should be entered into data memory
            0: data1_temp = registers[0];        
            1: data1_temp = registers[1];
        endcase
        case(Rs)
            0: data2_temp = registers[0];
            1: data2_temp = registers[1];
        endcase
        $display("Before t0: %d\n", registers[0]);
        $display("Before t1: %d\n", registers[1]);
        
        
    end
    
    always @(wb_stage)
    begin
        if(RegWrite == 1)
        begin
            case(Rt_or_Rd)
                0: registers[0] = write_data;
                1: registers[1] = write_data;
            endcase
            $display("New value t0: %d\n", registers[0]);
            $display("New value t1: %d\n", registers[1]);
        end
    end
    
    assign data1 = data1_temp;
    assign data2 = data2_temp;
endmodule