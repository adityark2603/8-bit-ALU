`timescale 1ns / 1ps

module alu8_tb;

    reg [2:0] funSel;
    reg [7:0] a, b;
    wire zeroFlag;
    wire [7:0] result;

    alu8 uut (
        .funSel(funSel),
        .a(a),
        .b(b),
        .zeroFlag(zeroFlag),
        .result(result)
    );

    initial begin
        $dumpfile("alu8_tb.vcd");
        $dumpvars(0, alu8_tb);
        
        // Test AND
        a = 8'b11001100; b = 8'b10101010; funSel = 3'b000;
        #10;
        
        // Test OR
        a = 8'b11001100; b = 8'b10101010; funSel = 3'b001;
        #10;
        
        // Test ADD
        a = 8'b00000011; b = 8'b00000001; funSel = 3'b010;
        #10;
        
        // Test SUB
        a = 8'b00000100; b = 8'b00000001; funSel = 3'b011;
        #10;
        
        // Test SLT (Set Less Than)
        a = 8'b00000010; b = 8'b00000100; funSel = 3'b111;
        #10;
        
        // Test Zero Flag (if result is zero)
        a = 8'b00000000; b = 8'b00000000; funSel = 3'b010;
        #10;
        
        // Finish simulation
        $finish;
    end

endmodule
