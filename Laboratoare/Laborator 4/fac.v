module fac (
	input x, y, ci,
	output z, co
);

	assign z = x ^ y ^ ci;
	assign co = (x | y) & (ci & (x ^ y));

endmodule

module fac_tb;

	reg x, y, ci;
	wire z, co;

	fac uut (
		.x(x),
		.y(y),
		.ci(ci),
		.z(z),
		.co(co)
	);
	
	integer k;

	initial begin
	
	$display("Time\tx\ty\tci\tz\tco");
	$monitor("%0t\t%b\t%b\t%b\t%b\t%b", $time, x, y, ci, z, co);
	{x, y, ci} = 0;
	for (k = 1; k < 8; k = k + 1)
		#10 {x, y, ci} = k;
	end

endmodule
