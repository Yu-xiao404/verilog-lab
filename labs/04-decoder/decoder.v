module decoder(
    input  wire [2:0] sel,
    input  wire       en,
    output reg  [7:0] y
);
    always @(*) begin
        if (!en)
            y = 8'b00000000;
        else begin
            case (sel)
                3'd0: y = 8'b00000001;   // sel=0 → 第0位亮
                3'd1: y = 8'b00000010;     // sel=1 → 应该是？
                3'd2: y = 8'b00000100;     // sel=2 → 应该是？
                3'd3: y = 8'b00001000;     // sel=3 → 应该是？
                3'd4: y = 8'b00010000;
                3'd5: y = 8'b00100000;
                3'd6: y = 8'b01000000;
                3'd7: y = 8'b10000000;                
             default: y = 8'b00000000;
            endcase
        end
    end
endmodule
