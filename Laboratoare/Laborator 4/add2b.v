module add2b(
	input [1:0] x,
	input [1:0] y,
	input ci,
	output [1:0] o, co
);

	wire new_ci;

	fac uut1 (x[0], y[0], ci, o[0], new_ci);
	fac uut2 (x[1], y[1], new_ci, o[1], co);

endmodule

module fac (
	input x, y, ci,
	output z, co
);

	assign z = x ^ y ^ ci;
	assign co = (x & y) | (ci & (x ^ y));

endmodule

module add2b_tb;

	reg [1:0] x;
	reg [1:0] y;
	reg ci;
	wire [1:0] o;
	wire co;

	integer k;
		
	add2b uut (
		.x(x),
		.y(y),
		.ci(ci),
		.o(o),
		.co(co)
	);

	initial begin
	
	$display("Time\t x  \t y  \tci\t o \tco");
	$monitor("%0t\t%b\t%b\t%b\t%b\t%b", $time, x, y, ci, o, co);
		{x, y, ci} = 0;
		for (k = 1; k < 32; k = k + 1)
			#10 {x, y, ci} = k[4:0];

	end

endmodule
