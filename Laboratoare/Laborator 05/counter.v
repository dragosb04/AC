module counter #(
	parameter w = 8,
	parameter init = {w{1'b0}}
)(
	input clk, rst_b, c_up, clr,
	output reg [w-1:0]q
);

	always @(posedge clk or negedge rst_b) begin
		if (!rst_b)
			q <= init;
		else if (clr)
			q <= init;
		else if (c_up)
			q <= q + 1;
	end

endmodule

module counter_tb;

	localparam CLK_PERIOD = 100;
	localparam CLK_CYCLES = 6;
	localparam RST_PULSE = 5;
	
	reg clk, rst_b, c_up, clr;
	wire[7:0] q; 

	counter uut (.clk(clk), .rst_b(rst_b), .c_up(c_up), .clr(clr), .q(q));
	
	initial begin
		clk = 1'b0;
		repeat (2*CLK_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
	end

	initial begin 
		rst_b = 1'b0;
		#(RST_PULSE) rst_b = 1'b1;
	end

	initial begin

		c_up = 1;
		clr = 0;

		#(2 * CLK_PERIOD) clr = 1;
		#(CLK_PERIOD) clr = 0;
		#(CLK_PERIOD) c_up = 0;
		#(CLK_PERIOD) c_up = 1;
	
		$finish;
	end

endmodule
