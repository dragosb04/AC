module d_ff (
	input clk, rst_b, set_b, d,
	output reg q
);

	always @(posedge clk, negedge rst_b, negedge set_b) begin
		if (!rst_b)
			q <= 1'b0;
		else if (!set_b)
			q <= 1'b1;
		else
			q <= d;
	end

endmodule

module lss5b (
	input clk, rst_b,
	output reg [4:0] q
);

	wire [4:0] q;
	d_ff uut1 (
		.clk(clk),
		.rst_b(rst_b),
		.set_b(rst_b),
		.d(q[4]),
		.q(q[0])
	);

	d_ff uut2 (
		.clk(clk),
		.rst_b(rst_b),
		.set_b(rst_b),
		.d(q[0]),
		.q(q[1])
	);

	d_ff uut3 (
		.clk(clk),
		.rst_b(rst_b),
		.set_b(rst_b),
		.d(q[1]),
		.q(q[2])
	);

	d_ff uut1 (
		.clk(clk),
		.rst_b(rst_b),
		.set_b(rst_b),
		.d(q[q[4] | q[2]),
		.q(q[3])
	);

	d_ff uut1 (
		.clk(clk),
		.rst_b(rst_b),
		.set_b(rst_b),
		.d(q[3] ^ q[4]),
		.q(q[4])
	);

endmodule
