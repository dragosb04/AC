module counter #(
    parameter WIDTH = 8,
    parameter INITIAL_VALUE = 8'hFF
)(
    input wire clk,
    input wire rst_b,
    input wire c_up,
    input wire clr,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            q <= INITIAL_VALUE;     
        end else if (clr) begin
            q <= INITIAL_VALUE;     
        end else if (c_up) begin
            q <= q + 1;             
        end
    end

endmodule

module counter_tb;

    parameter WIDTH = 8;
    parameter INITIAL_VALUE = 8'hFF;

    reg clk;
    reg rst_b;
    reg c_up;
    reg clr;
    wire [WIDTH-1:0] q;

    counter #(
        .WIDTH(WIDTH),
        .INITIAL_VALUE(INITIAL_VALUE)
    ) dut (
        .clk(clk),
        .rst_b(rst_b),
        .c_up(c_up),
        .clr(clr),
        .q(q)
    );

    initial begin
        clk = 0;
        forever #50 clk = ~clk; 
    end

    initial begin
		$display("clk rst_b c_up clr | q");
		$monitor("%b    %b    %b    %b  | %b", clk, rst_b, c_up, clr, q);

        rst_b = 1;
        c_up = 0;
        clr = 0;

        #10 rst_b = 0; 
        #5 rst_b = 1;  

        #100;

        clr = 1; 
        #100 clr = 0; 

        #100;

        c_up = 1; 
        #200;     
        c_up = 0; 

        #10 rst_b = 0; 
        #5 rst_b = 1;  

        #100;

        $stop;
    end

endmodule
