module rgst (
	input clk, clr, ld,
	input [2:0] d,
	output reg [2:0] q
);

	always @(posedge clk or negedge clr) begin
		if (!clr)
			q <= 3'b000;
		else if (ld)
			q <= d;
		else
			q <= q;
	end
endmodule

module fdivby5 (
	input clk, c_up, clr,
	output fdclk
);

	wire[2:0] q;
	rgst uut (
		.clk (clk),
		.clr (clr | q[2]),
		.ld (c_up),
		.d({q[2] ^ (q[1] & q[0]), q[0] ^ q[1], ~q[0]}),
		.q(q)
	);
	
	assign fdclk = ~(q[2] | q[1] | q[0]);

endmodule

module fdivby5_tb;

	reg clk, c_up, clr, rst_b;
	wire fdclk;
	
	localparam CLK_PERIOD = 100;
	localparam RST_PULSE = 25;
	localparam CLK_CYCLES = 15;
	
	fdivby5 cut (
		.clk(clk),
		.c_up(c_up),
		.clr(clr),
		.fdclk(fdclk)
	);

	initial begin
		clk = 1'b0;
		repeat (CLK_CYCLES * 2) #(CLK_PERIOD / 2) clk = ~clk;
	end
	
	initial begin
		rst_b = 1'b0;
		#(RST_PULSE) rst_b = 1'b1;
	end
	
	initial begin
		clr = 1'b0;
		c_up = 1'b1;
		#(6 * CLK_PERIOD) clr = 1'b1;
		#(CLK_PERIOD) clr = 1'b0;
		#(5 * CLK_PERIOD) clr = 1'b1;
		#(CLK_PERIOD) clr = 1'b0;
	end
endmodule
