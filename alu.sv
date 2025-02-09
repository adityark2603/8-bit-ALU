`timescale 1ns / 1ps

module and8(
    input [7:0] a, 
    input [7:0] b,
    output [7:0] y
);
    assign y = a & b;  // Bitwise AND
endmodule

module or8(
    input [7:0] a, 
    input [7:0] b,
    output [7:0] y
);
    assign y = a | b;  // Bitwise OR
endmodule

module adder8(
    input Cin,
    input [7:0] A, 
    input [7:0] B,
    output [7:0] S,
    output Cout
);
    assign {Cout, S} = A + B + Cin;  // 8-bit addition with carry
endmodule

module subtractor8(
    input Bin,
    input [7:0] A,
    input [7:0] B,
    output [7:0] Diff,
    output Bout
);
    assign {Bout, Diff} = A - B - Bin;  // 8-bit subtraction with borrow
endmodule  

module slt8( // Set Less Than
    input [7:0] a, 
    input [7:0] b,
    output [7:0] y
);
    assign y = (a < b) ? 8'b0000_0001 : 8'b0000_0000;
endmodule

module mux8(
    input [7:0] d0, d1, d2, d3, d4, d5, d6, d7,
    input [2:0] s,
    output reg [7:0] y
);
    always @ (*) begin
        case (s)
            3'b000: y = d0;   // AND
            3'b001: y = d1;   // OR
            3'b010: y = d2;   // ADD
            3'b011: y = d3;   // SUBTRACT
            3'b100: y = d4;   // Reserved
            3'b101: y = d5;   // Reserved
            3'b110: y = d6;   // Reserved
            3'b111: y = d7;   // SLT
            default: y = 8'b00000000;
        endcase
    end
endmodule

module alu8(
    input [2:0] funSel,
    input [7:0] a, 
    input [7:0] b,
    output zeroFlag, 
    output [7:0] result
);
    wire [7:0] andab, orab, addab, subab, slthb;
    wire Cout, Bout;
    
    and8 and8bit(.a(a), .b(b), .y(andab));
    or8 or8bit(.a(a), .b(b), .y(orab));
    adder8 adder(.Cin(funSel[2]), .A(a), .B(b), .S(addab), .Cout(Cout));
    subtractor8 sub8(.Bin(funSel[2]), .A(a), .B(b), .Diff(subab), .Bout(Bout));
    slt8 slt(.a(a), .b(b), .y(slthb));

    mux8 m8(
        .d0(andab), .d1(orab), .d2(addab), .d3(subab), 
        .d4(8'b00000000), .d5(8'b00000000), .d6(8'b00000000), .d7(slthb),
        .s(funSel), .y(result)
    );
    
    assign zeroFlag = (result == 8'b00000000) ? 1 : 0;
endmodule
