module top_module();
    wire [7:0] a = 8'b00001011;
    wire [7:0] b = 8'b00000101;
    reg [7:0] q;
    reg [7:0] r;
    reg ready;

    reg clk = 0;
    always #5 clk = ~clk;  // Create clock with period=10

    reg [2:0] state = 3'b000;
    reg [7:0] rol;

    always @(posedge clk) begin
        if (state == 0) begin
            ready = 0;
            rol = a;
            q = 8'h00;
            r = 8'h00;
        end
        if (ready == 0) begin
            $display("%d:\t%d\t%d", state, q, r);
            q = {q[6:0], 1'b1};
            r = {r[6:0], rol[7]};
            rol = {rol[6:0], 1'b0};
            r = r - b;
            if (r[7] == 1) begin
                $display("rollback");
                r = r + b;
                q[0] = 0;
            end
            if (state == 3'b111) ready = 1;
            else state = state + 1;
        end
    end

    `probe(clk);
    `probe(ready);
    initial begin
        #80 $display("%d %d", q, r);
        $finish;
    end
endmodule
