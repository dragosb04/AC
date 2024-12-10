module d_ff (
	input clk, rst_b, set_b, d,
	output reg q
);
	
	always @(posedge clk or negedge rst_b or negedge set_b) begin
		if (!set_b)
			q <= 1'b1;
		else if (!rst_b)
			q <= 1'b0;
		else
			q <= d;
	end
endmodule

module lfsr5b (
	input clk, rst_b,
	output [4:0] q
);

		d_ff uut1 (.clk(clk), .rst_b(1'b1), .set_b(rst_b), .d(q[4]), .q(q[0]));
		d_ff uut2 (.clk(clk), .rst_b(1'b1), .set_b(rst_b), .d(q[0]), .q(q[1]));
		d_ff uut3 (.clk(clk), .rst_b(1'b1), .set_b(rst_b), .d(q[1] ^ q[4]), .q(q[2]));
		d_ff uut4 (.clk(clk), .rst_b(1'b1), .set_b(rst_b), .d(q[2]), .q(q[3]));	
		d_ff uut5 (.clk(clk), .rst_b(1'b1), .set_b(rst_b), .d(q[3]), .q(q[4]));	

endmodule

module lfsr5b_tb;

	localparam CLK_CYCLES = 35;
	localparam RST_PULSE = 25;
	localparam CLK_PERIOD = 100;
	
	reg clk, rst_b;
	wire [4:0] q;
	
	lfsr5b cut (
		.clk(clk),
		.rst_b(rst_b),
		.q(q)
	);

	initial begin
		clk = 1'b0;
		repeat (CLK_CYCLES*2) #(CLK_PERIOD / 2) clk = ~clk;
	end

	initial begin
		rst_b = 1'b0;
		#(RST_PULSE) rst_b = 1'b1;
	end


endmodule
